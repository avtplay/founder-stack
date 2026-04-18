# =============================================================
# bootstrap-project.ps1 — Set up AI config in the current directory
# Usage (from inside your project folder):
#   .\path\to\founder-stack\scripts\bootstrap-project.ps1 --Stack <a|b|c-firebase|c-supabase|d> [-Git]
#
# Optional: override project name (defaults to current folder name)
#   .\bootstrap-project.ps1 my-app -Stack b -Git
# =============================================================

param(
    [Parameter(Position=0)]
    [string]$ProjectName = "",

    [Parameter(Mandatory=$true)]
    [ValidateSet("a","b","c-firebase","c-supabase","d")]
    [string]$Stack,

    [switch]$Git
)

$ErrorActionPreference = "Stop"

function Info($msg)    { Write-Host "▶ $msg" -ForegroundColor Yellow }
function Success($msg) { Write-Host "✓ $msg" -ForegroundColor Green }
function Err($msg)     { Write-Host "✗ $msg" -ForegroundColor Red; exit 1 }

# Default project name = current folder name
if (-not $ProjectName) { $ProjectName = Split-Path -Leaf (Get-Location) }

$StackLabels = @{
    "a"          = "HTML Mockup (Tailwind CDN)"
    "b"          = "React + Vite (local / deployable)"
    "c-firebase" = "React + Firebase (app with accounts)"
    "c-supabase" = "React + Supabase (app with accounts)"
    "d"          = "Full Stack — Advanced Mode"
}

$TargetDir   = (Get-Location).Path
$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$StackDir    = Split-Path -Parent $ScriptDir
$TemplateDir = Join-Path $StackDir "templates\stacks"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Project : $ProjectName"
Write-Host "║  Stack   : $($StackLabels[$Stack])"
Write-Host "║  Target  : $TargetDir"
Write-Host "║  Git     : $($Git.IsPresent)"
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── Copy AI config ────────────────────────────────────────────
Info "Claude Code configuration"
New-Item -ItemType Directory -Path ".claude\agents"   -Force | Out-Null
New-Item -ItemType Directory -Path ".claude\commands" -Force | Out-Null

Copy-Item "$StackDir\.claude\agents\*"   ".claude\agents\"   -Force
Copy-Item "$StackDir\.claude\commands\*" ".claude\commands\" -Force
Copy-Item "$StackDir\.claude\settings.windows.json" ".claude\settings.json" -Force
Copy-Item "$StackDir\CLAUDE.md" "." -Force

$agentsSource = switch ($Stack) {
    "a"          { Join-Path $TemplateDir "a-maquette\AGENTS.md" }
    "b"          { Join-Path $TemplateDir "b-react\AGENTS.md" }
    "c-firebase" { Join-Path $TemplateDir "c-firebase\AGENTS.md" }
    "c-supabase" { Join-Path $TemplateDir "c-supabase\AGENTS.md" }
    "d"          { Join-Path $TemplateDir "d-fullstack\AGENTS.md" }
}
Copy-Item $agentsSource "AGENTS.md" -Force
Success "Claude Code config ready"

# ── .gitignore ────────────────────────────────────────────────
@"
node_modules/
dist/
.env
.env.local
.env.*.local
*.log
.DS_Store
Thumbs.db
.turbo/
coverage/
.firebase/
"@ | Set-Content ".gitignore" -Encoding UTF8

# ── .env.example ──────────────────────────────────────────────
switch ($Stack) {
    "c-firebase" {
        @"
VITE_FIREBASE_API_KEY=
VITE_FIREBASE_AUTH_DOMAIN=
VITE_FIREBASE_PROJECT_ID=
VITE_FIREBASE_STORAGE_BUCKET=
VITE_FIREBASE_MESSAGING_SENDER_ID=
VITE_FIREBASE_APP_ID=
"@ | Set-Content ".env.example" -Encoding UTF8
        "" | Set-Content ".env.local" -Encoding UTF8
    }
    "c-supabase" {
        @"
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=
"@ | Set-Content ".env.example" -Encoding UTF8
        "" | Set-Content ".env.local" -Encoding UTF8
    }
    "d" {
        @"
DATABASE_URL=postgresql://devuser:devpass@localhost:5432/devdb
JWT_SECRET=change-me-in-production
JWT_REFRESH_SECRET=change-me-too
NODE_ENV=development
PORT=3000
VITE_API_URL=http://localhost:3000
"@ | Set-Content ".env.example" -Encoding UTF8
        Copy-Item ".env.example" ".env.local"
    }
}
Success ".env configured"

# ── Git ───────────────────────────────────────────────────────
if ($Git) {
    Info "Git setup"
    # If folder is a clone of founder-stack → clean slate
    if (Test-Path ".git") {
        $remoteUrl = git remote get-url origin 2>$null
        if ($remoteUrl -match "founder-stack") {
            Info "Detected founder-stack remote — resetting git history"
            Remove-Item -Recurse -Force ".git"
        }
    }
    git init -q
    git add .
    git commit -q -m "chore: init $ProjectName (stack: $Stack)"
    Success "Git initialized with clean history"
} elseif (Test-Path ".git") {
    $remoteUrl = git remote get-url origin 2>$null
    if ($remoteUrl -match "founder-stack") {
        git remote remove origin 2>$null
        Info "Removed founder-stack remote"
    }
}

# ── Done ──────────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✅ $ProjectName is ready!" -ForegroundColor Green
Write-Host "╠══════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║"
Write-Host "║  You are already in the project folder."
Write-Host "║  Open Claude Code and tell it what you want to build."
Write-Host "║"

switch ($Stack) {
    "a" {
        Write-Host "║  → Open index.html in Chrome to preview"
        Write-Host "║  → Tell Claude: /feature `"<what you want>`""
    }
    "b" {
        Write-Host "║  → pnpm install && pnpm dev"
        Write-Host "║  → Tell Claude: /feature `"<what you want>`""
    }
    { $_ -in "c-firebase","c-supabase" } {
        Write-Host "║  → Fill in .env.local with your keys"
        Write-Host "║  → pnpm install && pnpm dev"
        Write-Host "║  → Tell Claude: /feature `"<what you want>`""
    }
    "d" {
        Write-Host "║  → pnpm install"
        Write-Host "║  → Tell Claude: /feature `"<what you want>`""
        Write-Host "║  ⚠  Advanced mode — make sure PostgreSQL is running"
    }
}

Write-Host "║"
Write-Host "╚══════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
