#!/usr/bin/env bash
# =============================================================
# bootstrap-project.sh — Set up AI config in the current directory
# Usage (from inside your project folder):
#   bash ~/founder-stack/scripts/bootstrap-project.sh --stack <a|b|c-firebase|c-supabase|d> [--git]
#
# Optional: override project name (defaults to current folder name)
#   bash ~/founder-stack/scripts/bootstrap-project.sh my-app --stack b --git
# =============================================================

set -euo pipefail

YELLOW='\033[1;33m'; GREEN='\033[0;32m'; RED='\033[0;31m'; RESET='\033[0m'
info()    { echo -e "${YELLOW}▶ $1${RESET}"; }
success() { echo -e "${GREEN}✓ $1${RESET}"; }
error()   { echo -e "${RED}✗ $1${RESET}"; exit 1; }

# ── Parse arguments ──────────────────────────────────────────
PROJECT_NAME=""
STACK=""
USE_GIT=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --stack) STACK="$2"; shift 2 ;;
    --git)   USE_GIT=true; shift ;;
    --*)     error "Unknown argument: $1" ;;
    *)       PROJECT_NAME="$1"; shift ;;
  esac
done

# Default project name = current folder name
if [ -z "$PROJECT_NAME" ]; then
  PROJECT_NAME="$(basename "$PWD")"
fi

if [ -z "$STACK" ]; then
  error "Missing --stack. Usage: --stack <a|b|c-firebase|c-supabase|d>"
fi

VALID_STACKS=("a" "b" "c-firebase" "c-supabase" "d")
VALID=false
for s in "${VALID_STACKS[@]}"; do
  [[ "$STACK" == "$s" ]] && VALID=true && break
done
$VALID || error "Invalid stack: '$STACK'. Valid values: a, b, c-firebase, c-supabase, d"

# ── Paths ─────────────────────────────────────────────────────
TARGET_DIR="$PWD"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STACK_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$STACK_DIR/templates/stacks"

case "$STACK" in
  a)          STACK_LABEL="HTML Mockup (Tailwind CDN)" ;;
  b)          STACK_LABEL="React + Vite (local / deployable)" ;;
  c-firebase) STACK_LABEL="React + Firebase (app with accounts)" ;;
  c-supabase) STACK_LABEL="React + Supabase (app with accounts)" ;;
  d)          STACK_LABEL="Full Stack — Advanced Mode" ;;
esac

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║  Project : $PROJECT_NAME"
echo "║  Stack   : $STACK_LABEL"
echo "║  Target  : $TARGET_DIR"
echo "║  Git     : $USE_GIT"
echo "╚══════════════════════════════════════════════╝"
echo ""

# ── Copy AI config ────────────────────────────────────────────
info "Claude Code configuration"
mkdir -p .claude/{agents,commands}

cp -r "$STACK_DIR/.claude/agents/"*   .claude/agents/
cp -r "$STACK_DIR/.claude/commands/"* .claude/commands/
cp    "$STACK_DIR/.claude/settings.json" .claude/settings.json
cp    "$STACK_DIR/CLAUDE.md" .

case "$STACK" in
  a)          cp "$TEMPLATE_DIR/a-maquette/AGENTS.md" . ;;
  b)          cp "$TEMPLATE_DIR/b-react/AGENTS.md" . ;;
  c-firebase) cp "$TEMPLATE_DIR/c-firebase/AGENTS.md" . ;;
  c-supabase) cp "$TEMPLATE_DIR/c-supabase/AGENTS.md" . ;;
  d)          cp "$TEMPLATE_DIR/d-fullstack/AGENTS.md" . ;;
esac

success "Claude Code config ready"

# ── .gitignore ────────────────────────────────────────────────
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
.firebase/
EOF

# ── .env.example ──────────────────────────────────────────────
case "$STACK" in
  c-firebase)
    cat > .env.example << 'EOF'
VITE_FIREBASE_API_KEY=
VITE_FIREBASE_AUTH_DOMAIN=
VITE_FIREBASE_PROJECT_ID=
VITE_FIREBASE_STORAGE_BUCKET=
VITE_FIREBASE_MESSAGING_SENDER_ID=
VITE_FIREBASE_APP_ID=
EOF
    touch .env.local
    ;;
  c-supabase)
    cat > .env.example << 'EOF'
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=
EOF
    touch .env.local
    ;;
  d)
    cat > .env.example << 'EOF'
DATABASE_URL=postgresql://devuser:devpass@localhost:5432/devdb
JWT_SECRET=change-me-in-production
JWT_REFRESH_SECRET=change-me-too
NODE_ENV=development
PORT=3000
VITE_API_URL=http://localhost:3000
EOF
    cp .env.example .env.local
    ;;
esac

success ".env configured"

# ── Git ───────────────────────────────────────────────────────
if $USE_GIT; then
  info "Git setup"
  # If the folder is a clone of founder-stack → clean slate
  if [ -d ".git" ]; then
    REMOTE_URL="$(git remote get-url origin 2>/dev/null || echo '')"
    if echo "$REMOTE_URL" | grep -q "founder-stack"; then
      info "Detected founder-stack remote — resetting git history"
      rm -rf .git
    fi
  fi
  git init -q
  git add .
  git commit -q -m "chore: init $PROJECT_NAME (stack: $STACK)"
  success "Git initialized with clean history"
elif [ -d ".git" ]; then
  # Not using git but folder is a founder-stack clone → remove remote
  REMOTE_URL="$(git remote get-url origin 2>/dev/null || echo '')"
  if echo "$REMOTE_URL" | grep -q "founder-stack"; then
    git remote remove origin 2>/dev/null || true
    info "Removed founder-stack remote"
  fi
fi

# ── Done ──────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ $PROJECT_NAME is ready!"
echo "╠══════════════════════════════════════════════════════╣"
echo "║"
echo "║  You are already in the project folder."
echo "║  Open Claude Code and tell it what you want to build."
echo "║"

case "$STACK" in
  a)
    echo "║  → Open index.html in Chrome to preview"
    echo "║  → Tell Claude: /feature \"<what you want>\""
    ;;
  b)
    echo "║  → pnpm install && pnpm dev"
    echo "║  → Tell Claude: /feature \"<what you want>\""
    ;;
  c-firebase|c-supabase)
    echo "║  → Fill in .env.local with your keys"
    echo "║  → pnpm install && pnpm dev"
    echo "║  → Tell Claude: /feature \"<what you want>\""
    ;;
  d)
    echo "║  → pnpm install"
    echo "║  → Tell Claude: /feature \"<what you want>\""
    echo "║  ⚠  Advanced mode — make sure PostgreSQL is running"
    ;;
esac

echo "║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
