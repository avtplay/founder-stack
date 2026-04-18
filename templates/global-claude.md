# Claude Code — Global Instructions

## founder-stack auto-bootstrap

Trigger phrases (any language):
- "start my project", "démarre mon projet", "start a founder-stack"
- "démarre un founder-stack ici", "bootstrap this folder"
- "here's the link: <url> — start my project"
- Any message giving a founder-stack GitHub URL + asking to start

When triggered, detect the OS first, then follow the matching flow.

---

## On Linux / WSL2

### Step 1 — Find founder-stack

```bash
if [ -d "$HOME/founder-stack/scripts" ]; then
  FOUNDER_STACK="$HOME/founder-stack"
elif [ -d "/tmp/founder-stack/scripts" ]; then
  FOUNDER_STACK="/tmp/founder-stack"
else
  # Download it
  if command -v git &>/dev/null; then
    git clone https://github.com/avtplay/founder-stack.git /tmp/founder-stack --depth 1 -q
  else
    curl -fsSL https://github.com/avtplay/founder-stack/archive/refs/heads/main.zip \
      -o /tmp/founder-stack.zip \
      && unzip -q /tmp/founder-stack.zip -d /tmp/ \
      && mv /tmp/founder-stack-main /tmp/founder-stack
  fi
  FOUNDER_STACK="/tmp/founder-stack"
fi
```

### Step 2 — Ask /start questions (idea + stack choice + git)

### Step 3 — Bootstrap in current directory

```bash
bash "$FOUNDER_STACK/scripts/bootstrap-project.sh" --stack <a|b|c-firebase|c-supabase|d> [--git]
```

### Step 4 — Clean up (only if downloaded)

```bash
[ "$FOUNDER_STACK" = "/tmp/founder-stack" ] && rm -rf /tmp/founder-stack /tmp/founder-stack.zip 2>/dev/null || true
```

---

## On Windows (native PowerShell)

### Step 1 — Find founder-stack

```powershell
$founderStack = $null
$localPath = Join-Path $env:USERPROFILE "founder-stack"
$tempPath   = Join-Path $env:TEMP "founder-stack"

if (Test-Path "$localPath\scripts") {
    $founderStack = $localPath
} elseif (Test-Path "$tempPath\scripts") {
    $founderStack = $tempPath
} else {
    # Download it
    if (Get-Command git -ErrorAction SilentlyContinue) {
        git clone https://github.com/avtplay/founder-stack.git $tempPath --depth 1 -q
    } else {
        $zip = Join-Path $env:TEMP "founder-stack.zip"
        Invoke-WebRequest https://github.com/avtplay/founder-stack/archive/refs/heads/main.zip -OutFile $zip
        Expand-Archive $zip -DestinationPath $env:TEMP -Force
        Rename-Item (Join-Path $env:TEMP "founder-stack-main") $tempPath
    }
    $founderStack = $tempPath
}
```

### Step 2 — Ask /start questions (idea + stack choice + git)

### Step 3 — Bootstrap in current directory

```powershell
& "$founderStack\scripts\bootstrap-project.ps1" -Stack <a|b|c-firebase|c-supabase|d> [-Git]
```

### Step 4 — Clean up (only if downloaded)

```powershell
if ($founderStack -eq $tempPath) {
    Remove-Item $tempPath -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item (Join-Path $env:TEMP "founder-stack.zip") -Force -ErrorAction SilentlyContinue
}
```

---

## Step 5 — Continue (both OS)

Read the new CLAUDE.md and AGENTS.md just created, then continue the /start flow.

---

## Language

Always respond in the user's language. Detect it from their first message.
