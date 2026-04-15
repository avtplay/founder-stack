#!/usr/bin/env bash
# =============================================================
# AI Stack — WSL2 Setup Script
# Run once on a fresh WSL2 Ubuntu environment
# Usage: bash scripts/setup-wsl.sh
# =============================================================

set -euo pipefail

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

info()    { echo -e "${YELLOW}▶ $1${RESET}"; }
success() { echo -e "${GREEN}✓ $1${RESET}"; }
error()   { echo -e "${RED}✗ $1${RESET}"; exit 1; }

echo ""
echo "╔══════════════════════════════════════╗"
echo "║   AI Stack WSL2 Setup               ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── 1. System deps ──────────────────────────────────────────
info "System dependencies"
sudo apt-get update -q
sudo apt-get install -y -q \
  curl git build-essential unzip jq \
  ca-certificates gnupg lsb-release
success "System deps installed"

# ── 2. Node.js 20 via nvm ───────────────────────────────────
info "Node.js 20 (via nvm)"
if ! command -v nvm &>/dev/null && [ ! -d "$HOME/.nvm" ]; then
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
nvm install 20
nvm use 20
nvm alias default 20
success "Node $(node -v) installed"

# ── 3. pnpm ─────────────────────────────────────────────────
info "pnpm"
npm install -g pnpm@9
success "pnpm $(pnpm -v) installed"

# ── 4. Claude Code ──────────────────────────────────────────
info "Claude Code"
npm install -g @anthropic-ai/claude-code
success "Claude Code $(claude --version 2>/dev/null || echo 'installed') ready"

# ── 5. RTK (Rust Token Killer) ──────────────────────────────
info "RTK — Rust Token Killer"
if ! command -v rtk &>/dev/null; then
  # Install via Homebrew (recommended) or cargo
  if command -v brew &>/dev/null; then
    brew install rtk-ai/tap/rtk
  elif command -v cargo &>/dev/null; then
    cargo install --git https://github.com/rtk-ai/rtk
  else
    # Direct binary install
    RTK_VERSION="0.13.1"
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then
      RTK_TARGET="x86_64-unknown-linux-gnu"
    else
      RTK_TARGET="aarch64-unknown-linux-gnu"
    fi
    curl -fsSL "https://github.com/rtk-ai/rtk/releases/download/v${RTK_VERSION}/rtk-${RTK_TARGET}.tar.gz" \
      | tar -xz -C /tmp
    mkdir -p "$HOME/.local/bin"
    mv /tmp/rtk "$HOME/.local/bin/rtk"
    chmod +x "$HOME/.local/bin/rtk"
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
      export PATH="$HOME/.local/bin:$PATH"
    fi
  fi
fi
success "RTK $(rtk --version 2>/dev/null || echo 'installed')"

# ── 6. Init RTK hook for Claude Code ────────────────────────
info "RTK hook → Claude Code"
rtk init -g --auto-patch 2>/dev/null || true
success "RTK hook configured"

# ── 7. SuperClaude Framework ────────────────────────────────
info "SuperClaude Framework"
SUPERCLAUDE_DIR="$HOME/.superclaude"
if [ ! -d "$SUPERCLAUDE_DIR" ]; then
  git clone --depth 1 https://github.com/NomenAK/SuperClaude.git "$SUPERCLAUDE_DIR"
  cd "$SUPERCLAUDE_DIR"
  bash install.sh --force
  cd - > /dev/null
else
  info "SuperClaude already installed, updating..."
  cd "$SUPERCLAUDE_DIR" && git pull && bash install.sh --update --force && cd - > /dev/null
fi
success "SuperClaude installed"

# ── 8. ccusage (token monitoring) ───────────────────────────
info "ccusage (token usage tracker)"
# No install needed — use npx ccusage@latest
# Add convenient alias
if ! grep -q "alias ccusage" "$HOME/.bashrc"; then
  echo "alias ccusage='npx ccusage@latest'" >> "$HOME/.bashrc"
fi
success "ccusage alias added (use: ccusage or ccusage daily)"

# ── 9. Claude Code Usage Monitor ────────────────────────────
info "Claude Code Usage Monitor (real-time)"
if command -v pip3 &>/dev/null; then
  pip3 install claude-monitor --break-system-packages --quiet 2>/dev/null || \
  pip3 install claude-monitor --quiet 2>/dev/null || \
  info "⚠️  Install manually: pip install claude-monitor"
fi
success "Usage monitor ready (use: cmonitor)"

# ── 10. PostgreSQL (local dev) ───────────────────────────────
info "PostgreSQL 16"
if ! command -v psql &>/dev/null; then
  sudo apt-get install -y -q postgresql-16 postgresql-client-16
  sudo service postgresql start
  sudo -u postgres psql -c "CREATE USER devuser WITH PASSWORD 'devpass' CREATEDB;" 2>/dev/null || true
  sudo -u postgres psql -c "CREATE DATABASE devdb OWNER devuser;" 2>/dev/null || true
fi
success "PostgreSQL ready (user: devuser / pass: devpass / db: devdb)"

# ── 11. Git global config ────────────────────────────────────
info "Git configuration"
if [ -z "$(git config --global user.email 2>/dev/null)" ]; then
  echo ""
  read -rp "  Git email: " GIT_EMAIL
  read -rp "  Git name:  " GIT_NAME
  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"
fi
git config --global init.defaultBranch main
git config --global pull.rebase false
success "Git configured"

# ── 12. Copy stack config files ─────────────────────────────
info "Copying stack config files to ~/.claude/"
mkdir -p "$HOME/.claude/agents" "$HOME/.claude/commands"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STACK_DIR="$(dirname "$SCRIPT_DIR")"

# Copy agents and commands if running from the stack repo
if [ -d "$STACK_DIR/.claude" ]; then
  cp -r "$STACK_DIR/.claude/agents/"* "$HOME/.claude/agents/" 2>/dev/null || true
  cp -r "$STACK_DIR/.claude/commands/"* "$HOME/.claude/commands/" 2>/dev/null || true
  success "Global agents & commands copied"
fi

# ── Summary ─────────────────────────────────────────────────
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   ✅ AI Stack ready!                     ║"
echo "╠══════════════════════════════════════════╣"
echo "║  claude          → Claude Code           ║"
echo "║  rtk gain        → token savings stats   ║"
echo "║  ccusage         → usage analytics       ║"
echo "║  cmonitor        → live token monitor    ║"
echo "║  /feature        → scaffold a feature    ║"
echo "║  /handoff        → context dump          ║"
echo "║  /review         → pre-PR review         ║"
echo "║  /sc:implement   → SuperClaude build     ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "  Next: Set ANTHROPIC_API_KEY in ~/.bashrc"
echo "  Then: source ~/.bashrc && claude"
echo ""

# Remind about API key
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  echo -e "${YELLOW}⚠️  Don't forget:${RESET}"
  echo "  echo 'export ANTHROPIC_API_KEY=sk-ant-...' >> ~/.bashrc"
  echo "  source ~/.bashrc"
fi
