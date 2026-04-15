#!/usr/bin/env bash
# =============================================================
# bootstrap-project.sh — Scaffold a new full-stack project
# Usage: bash scripts/bootstrap-project.sh my-app
# =============================================================

set -euo pipefail

PROJECT_NAME="${1:-my-app}"
TARGET_DIR="$HOME/projects/$PROJECT_NAME"

YELLOW='\033[1;33m'; GREEN='\033[0;32m'; RESET='\033[0m'
info()    { echo -e "${YELLOW}▶ $1${RESET}"; }
success() { echo -e "${GREEN}✓ $1${RESET}"; }

echo ""
echo "Bootstrapping: $PROJECT_NAME → $TARGET_DIR"
echo ""

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# ── pnpm workspace monorepo ──────────────────────────────────
info "pnpm workspace"
cat > pnpm-workspace.yaml << 'EOF'
packages:
  - 'apps/*'
  - 'packages/*'
EOF

cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "private": true,
  "scripts": {
    "dev": "concurrently \"pnpm --filter api dev\" \"pnpm --filter web dev\"",
    "build": "pnpm -r build",
    "test": "pnpm -r test",
    "lint": "pnpm -r lint",
    "db:migrate": "pnpm --filter @$PROJECT_NAME/db migrate",
    "db:studio": "pnpm --filter @$PROJECT_NAME/db studio"
  },
  "devDependencies": {
    "concurrently": "^8.2.2",
    "typescript": "^5.4.5"
  }
}
EOF
success "pnpm workspace ready"

# ── Copy AI config ───────────────────────────────────────────
info "AI stack config"
STACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

# AGENTS.md + CLAUDE.md
cp "$STACK_DIR/AGENTS.md" .
cp "$STACK_DIR/CLAUDE.md" .

# Update project name in AGENTS.md
sed -i "s/my-project/$PROJECT_NAME/g" AGENTS.md 2>/dev/null || true

# .claude/ config
mkdir -p .claude/{agents,commands}
cp -r "$STACK_DIR/.claude/agents/"* .claude/agents/
cp -r "$STACK_DIR/.claude/commands/"* .claude/commands/
cp "$STACK_DIR/.claude/settings.json" .claude/settings.json
success "Claude Code config copied"

# ── GitHub Actions ───────────────────────────────────────────
info "GitHub Actions"
mkdir -p .github/workflows
cp "$STACK_DIR/.github/workflows/ci.yml" .github/workflows/ci.yml
success "CI workflow ready"

# ── .gitignore ───────────────────────────────────────────────
cat > .gitignore << 'EOF'
node_modules/
dist/
.env
.env.local
.env.*.local
*.log
.DS_Store
.turbo/
coverage/
.nyc_output/
prisma/migrations/dev/
EOF

# ── .env.example ────────────────────────────────────────────
cat > .env.example << 'EOF'
# Database
DATABASE_URL=postgresql://devuser:devpass@localhost:5432/devdb

# Auth
JWT_SECRET=change-me-in-production
JWT_REFRESH_SECRET=change-me-too

# App
NODE_ENV=development
PORT=3000
VITE_API_URL=http://localhost:3000
EOF

cp .env.example .env.local
success ".env files ready"

# ── git init ────────────────────────────────────────────────
info "Git repository"
git init -q
git add .
git commit -q -m "chore: initial ai-stack scaffold"
success "Git repo initialized"

# ── Done ────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║  ✅ $PROJECT_NAME ready!                    "
echo "╠══════════════════════════════════════════════╣"
echo "║                                              ║"
echo "║  cd ~/projects/$PROJECT_NAME               "
echo "║  pnpm install                               ║"
echo "║  claude   (then: /feature \"first feature\") ║"
echo "║                                              ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
