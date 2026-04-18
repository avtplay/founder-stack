# =============================================================
# setup-windows.ps1 — AI Stack setup for Windows (native)
# Run once in PowerShell as Administrator
# Usage: Set-ExecutionPolicy Bypass -Scope Process; .\scripts\setup-windows.ps1
# =============================================================

$ErrorActionPreference = "Stop"

function Info($msg)    { Write-Host "▶ $msg" -ForegroundColor Yellow }
function Success($msg) { Write-Host "✓ $msg" -ForegroundColor Green }
function Warn($msg)    { Write-Host "⚠ $msg" -ForegroundColor DarkYellow }
function Err($msg)     { Write-Host "✗ $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "╔══════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   founder-stack — Windows Setup          ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Warn "Running on Windows — RTK and SuperClaude are not available."
Warn "All AI agents and commands work normally. Token compression is disabled."
Write-Host ""

# ── 1. winget check ─────────────────────────────────────────
Info "Checking winget..."
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Err "winget not found. Install 'App Installer' from the Microsoft Store, then re-run this script."
}
Success "winget available"

# ── 2. Git ───────────────────────────────────────────────────
Info "Git"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    winget install --id Git.Git -e --source winget --silent
    # Refresh PATH
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
}
Success "Git $(git --version)"

# ── 3. Node.js 20 ───────────────────────────────────────────
Info "Node.js 20"
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    winget install --id OpenJS.NodeJS.LTS -e --source winget --silent
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
} else {
    $nodeVersion = node --version
    if ($nodeVersion -notmatch "^v2[0-9]") {
        Warn "Node $nodeVersion detected — v20+ recommended. Install manually from nodejs.org if needed."
    }
}
Success "Node $(node --version)"

# ── 4. pnpm ──────────────────────────────────────────────────
Info "pnpm"
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
    npm install -g pnpm@9
}
Success "pnpm $(pnpm --version)"

# ── 5. Claude Code ───────────────────────────────────────────
Info "Claude Code"
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    npm install -g @anthropic-ai/claude-code
}
Success "Claude Code installed"

# ── 6. ccusage (token monitoring) ────────────────────────────
Info "ccusage (token usage tracker)"
# No install needed — use npx ccusage@latest
$profileFile = $PROFILE
if (-not (Test-Path $profileFile)) { New-Item -ItemType File -Path $profileFile -Force | Out-Null }
if (-not (Select-String -Path $profileFile -Pattern "ccusage" -Quiet)) {
    Add-Content -Path $profileFile -Value "`nfunction ccusage { npx ccusage@latest @args }"
}
Success "ccusage alias added (use: ccusage or ccusage daily)"

# ── 7. PostgreSQL ─────────────────────────────────────────────
Info "PostgreSQL 16"
if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
    winget install --id PostgreSQL.PostgreSQL.16 -e --source winget --silent
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
    Write-Host ""
    Warn "PostgreSQL installed. You need to complete setup manually:"
    Write-Host "  1. Open pgAdmin or psql as postgres user"
    Write-Host "  2. Run: CREATE USER devuser WITH PASSWORD 'devpass' CREATEDB;"
    Write-Host "  3. Run: CREATE DATABASE devdb OWNER devuser;"
    Write-Host ""
} else {
    Success "PostgreSQL already installed"
}

# ── 8. Git global config ──────────────────────────────────────
Info "Git configuration"
$gitEmail = git config --global user.email 2>$null
$gitName  = git config --global user.name  2>$null
if (-not $gitEmail) {
    $gitEmail = Read-Host "  Git email"
    $gitName  = Read-Host "  Git name"
    git config --global user.email $gitEmail
    git config --global user.name  $gitName
}
git config --global init.defaultBranch main
git config --global pull.rebase false
Success "Git configured"

# ── 9. Copy stack config files to %USERPROFILE%\.claude\ ─────
Info "Copying stack config to $env:USERPROFILE\.claude\"
$claudeDir = Join-Path $env:USERPROFILE ".claude"
New-Item -ItemType Directory -Path "$claudeDir\agents"   -Force | Out-Null
New-Item -ItemType Directory -Path "$claudeDir\commands" -Force | Out-Null

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$stackDir  = Split-Path -Parent $scriptDir

if (Test-Path "$stackDir\.claude") {
    Copy-Item "$stackDir\.claude\agents\*"   "$claudeDir\agents\"   -Force
    Copy-Item "$stackDir\.claude\commands\*" "$claudeDir\commands\" -Force
    Success "Global agents & commands copied"
}

# ── Summary ──────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✅ founder-stack ready on Windows!              ║" -ForegroundColor Green
Write-Host "╠══════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║                                                  ║"
Write-Host "║  claude          → Claude Code                   ║"
Write-Host "║  ccusage         → usage analytics               ║"
Write-Host "║  /start          → start a new project           ║"
Write-Host "║  /feature        → build a feature               ║"
Write-Host "║  /ship           → deploy                        ║"
Write-Host "║                                                  ║"
Write-Host "║  ⚠  Not available on Windows:                   ║"
Write-Host "║     RTK (token compression)                      ║"
Write-Host "║     SuperClaude (/sc: commands)                  ║"
Write-Host "║                                                  ║"
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Restart PowerShell to apply PATH changes"
Write-Host "  2. Run: claude auth login"
Write-Host "  3. Run: .\scripts\bootstrap-project.ps1 my-project --stack b --git"
Write-Host ""
