# =============================================================
# bootstrap-project.ps1 — Scaffold a new project with AI config
# Usage: .\scripts\bootstrap-project.ps1 <name> --stack <a|b|c-firebase|c-supabase|d> [--git]
# =============================================================

param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$ProjectName,

    [Parameter(Mandatory=$true)]
    [ValidateSet("a","b","c-firebase","c-supabase","d")]
    [string]$Stack,

    [switch]$Git
)

$ErrorActionPreference = "Stop"

function Info($msg)    { Write-Host "▶ $msg" -ForegroundColor Yellow }
function Success($msg) { Write-Host "✓ $msg" -ForegroundColor Green }
function Err($msg)     { Write-Host "✗ $msg" -ForegroundColor Red; exit 1 }

$StackLabels = @{
    "a"          = "HTML Mockup (Tailwind CDN)"
    "b"          = "React + Vite (local / deployable)"
    "c-firebase" = "React + Firebase (app with accounts)"
    "c-supabase" = "React + Supabase (app with accounts)"
    "d"          = "Full Stack — Advanced Mode"
}

$TargetDir  = Join-Path $env:USERPROFILE "projects\$ProjectName"
$ScriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Path
$StackDir   = Split-Path -Parent $ScriptDir
$TemplateDir = Join-Path $StackDir "templates\stacks"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Bootstrapping: $ProjectName"
Write-Host "║  Stack: $($StackLabels[$Stack])"
Write-Host "║  Git: $($Git.IsPresent)"
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── Create project directory ─────────────────────────────────
New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
Set-Location $TargetDir

# ── Copy AI config ────────────────────────────────────────────
Info "Claude Code configuration"
New-Item -ItemType Directory -Path ".claude\agents"   -Force | Out-Null
New-Item -ItemType Directory -Path ".claude\commands" -Force | Out-Null

Copy-Item "$StackDir\.claude\agents\*"   ".claude\agents\"   -Force
Copy-Item "$StackDir\.claude\commands\*" ".claude\commands\" -Force

# Use Windows-specific settings (no RTK hook, PowerShell lint)
Copy-Item "$StackDir\.claude\settings.windows.json" ".claude\settings.json" -Force

# CLAUDE.md
Copy-Item "$StackDir\CLAUDE.md" "." -Force

# AGENTS.md — stack-specific
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
        Info ".env.example created — fill in your Firebase keys"
    }
    "c-supabase" {
        @"
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=
"@ | Set-Content ".env.example" -Encoding UTF8
        "" | Set-Content ".env.local" -Encoding UTF8
        Info ".env.example created — fill in your Supabase keys"
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

# ── Git (optional) ────────────────────────────────────────────
if ($Git) {
    Info "Initializing Git repository"
    git init -q
    git add .
    git commit -q -m "chore: init $ProjectName (stack: $Stack)"
    Success "Git repository initialized"
}

# ── Done ──────────────────────────────────────────────────────
Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✅ $ProjectName ready!" -ForegroundColor Green
Write-Host "╠══════════════════════════════════════════════════════╣" -ForegroundColor Green
Write-Host "║"
Write-Host "║  cd $TargetDir"
Write-Host "║  claude"
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
