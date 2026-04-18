#!/usr/bin/env bash
# =============================================================
# bootstrap-project.sh — Scaffold a new project with AI config
# Usage: bash scripts/bootstrap-project.sh <nom> --stack <a|b|c-firebase|c-supabase|d> [--git]
# =============================================================

set -euo pipefail

YELLOW='\033[1;33m'; GREEN='\033[0;32m'; RED='\033[0;31m'; RESET='\033[0m'
info()    { echo -e "${YELLOW}▶ $1${RESET}"; }
success() { echo -e "${GREEN}✓ $1${RESET}"; }
error()   { echo -e "${RED}✗ $1${RESET}"; exit 1; }

# ── Parse arguments ─────────────────────────────────────────
PROJECT_NAME="${1:-}"
STACK=""
USE_GIT=false

if [ -z "$PROJECT_NAME" ]; then
  error "Nom du projet manquant. Usage: bash bootstrap-project.sh <nom> --stack <a|b|c-firebase|c-supabase|d> [--git]"
fi

shift
while [[ $# -gt 0 ]]; do
  case "$1" in
    --stack) STACK="$2"; shift 2 ;;
    --git)   USE_GIT=true; shift ;;
    *) error "Argument inconnu: $1" ;;
  esac
done

if [ -z "$STACK" ]; then
  error "Stack manquante. Usage: --stack <a|b|c-firebase|c-supabase|d>"
fi

VALID_STACKS=("a" "b" "c-firebase" "c-supabase" "d")
VALID=false
for s in "${VALID_STACKS[@]}"; do
  [[ "$STACK" == "$s" ]] && VALID=true && break
done
$VALID || error "Stack invalide: '$STACK'. Valeurs acceptées: a, b, c-firebase, c-supabase, d"

# ── Setup ────────────────────────────────────────────────────
TARGET_DIR="$HOME/projects/$PROJECT_NAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STACK_DIR="$(dirname "$SCRIPT_DIR")"

# Stack name for display
case "$STACK" in
  a)          STACK_LABEL="Maquette HTML + Tailwind" ;;
  b)          STACK_LABEL="React + Vite (app locale/déployable)" ;;
  c-firebase) STACK_LABEL="React + Firebase (app avec comptes)" ;;
  c-supabase) STACK_LABEL="React + Supabase (app avec comptes)" ;;
  d)          STACK_LABEL="Full Stack — Mode Avancé" ;;
esac

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║  Bootstrapping: $PROJECT_NAME"
echo "║  Stack: $STACK_LABEL"
echo "║  Git: $USE_GIT"
echo "╚══════════════════════════════════════════════╝"
echo ""

mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# ── Copy AI config ───────────────────────────────────────────
info "Configuration Claude Code"
mkdir -p .claude/{agents,commands}

# Copy agents and commands
cp -r "$STACK_DIR/.claude/agents/"* .claude/agents/
cp -r "$STACK_DIR/.claude/commands/"* .claude/commands/
cp "$STACK_DIR/.claude/settings.json" .claude/settings.json

# CLAUDE.md (same for all stacks — audience + workflow)
cp "$STACK_DIR/CLAUDE.md" .

# AGENTS.md — stack-specific
TEMPLATE_DIR="$STACK_DIR/templates/stacks"
case "$STACK" in
  a)          cp "$TEMPLATE_DIR/a-maquette/AGENTS.md" . ;;
  b)          cp "$TEMPLATE_DIR/b-react/AGENTS.md" . ;;
  c-firebase) cp "$TEMPLATE_DIR/c-firebase/AGENTS.md" . ;;
  c-supabase) cp "$TEMPLATE_DIR/c-supabase/AGENTS.md" . ;;
  d)          cp "$TEMPLATE_DIR/d-fullstack/AGENTS.md" . ;;
esac

success "Claude Code config prête"

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
.firebase/
EOF

# ── .env.example (si applicable) ────────────────────────────
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
    info ".env.example créé — remplis avec tes clés Firebase"
    ;;
  c-supabase)
    cat > .env.example << 'EOF'
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=
EOF
    touch .env.local
    info ".env.example créé — remplis avec tes clés Supabase"
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

success ".env configuré"

# ── Git (optionnel) ──────────────────────────────────────────
if $USE_GIT; then
  info "Initialisation Git"
  git init -q
  git add .
  git commit -q -m "chore: init projet $PROJECT_NAME (stack: $STACK)"
  success "Dépôt Git initialisé"
fi

# ── Done ─────────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║  ✅ $PROJECT_NAME prêt !"
echo "╠══════════════════════════════════════════════════════╣"
echo "║"
echo "║  cd ~/projects/$PROJECT_NAME"
echo "║  claude"
echo "║"

case "$STACK" in
  a)
    echo "║  → Ouvre index.html dans Chrome pour prévisualiser"
    echo "║  → Dis à Claude : /feature \"<ce que tu veux\""
    ;;
  b)
    echo "║  → pnpm install && pnpm dev"
    echo "║  → Dis à Claude : /feature \"<ce que tu veux>\""
    ;;
  c-firebase|c-supabase)
    echo "║  → Remplis .env.local avec tes clés"
    echo "║  → pnpm install && pnpm dev"
    echo "║  → Dis à Claude : /feature \"<ce que tu veux>\""
    ;;
  d)
    echo "║  → pnpm install"
    echo "║  → Dis à Claude : /feature \"<ce que tu veux>\""
    echo "║  ⚠️  Mode avancé — assure-toi que PostgreSQL tourne"
    ;;
esac

echo "║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
