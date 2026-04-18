# Claude Code — Global Instructions

## founder-stack — two triggers

---

## Trigger 1 — INSTALL

Phrases: "install it", "installe-le", "install founder-stack", "set up founder-stack"
+ any message giving a founder-stack GitHub URL with "install" intent

**On Linux / WSL2:**
```bash
# Clone to ~/founder-stack if not already there
if [ ! -d "$HOME/founder-stack" ]; then
  git clone https://github.com/avtplay/founder-stack.git "$HOME/founder-stack" --depth 1 -q \
  || {
    curl -fsSL https://github.com/avtplay/founder-stack/archive/refs/heads/main.zip \
      -o /tmp/founder-stack.zip \
      && unzip -q /tmp/founder-stack.zip -d "$HOME/" \
      && mv "$HOME/founder-stack-main" "$HOME/founder-stack"
  }
fi
bash "$HOME/founder-stack/install.sh"
```

**On Windows (PowerShell):**
```powershell
$dest = Join-Path $env:USERPROFILE "founder-stack"
if (-not (Test-Path $dest)) {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        git clone https://github.com/avtplay/founder-stack.git $dest --depth 1 -q
    } else {
        $zip = Join-Path $env:TEMP "founder-stack.zip"
        Invoke-WebRequest https://github.com/avtplay/founder-stack/archive/refs/heads/main.zip -OutFile $zip
        Expand-Archive $zip -DestinationPath $env:USERPROFILE -Force
        Rename-Item (Join-Path $env:USERPROFILE "founder-stack-main") $dest
    }
}
& "$dest\install.ps1"
```

After install: tell the user to restart their terminal, then run `claude` to authenticate.

---

## Trigger 2 — START PROJECT

Phrases: "start my project", "démarre mon projet", "start a founder-stack", "démarre un founder-stack ici", "bootstrap this folder"

### Step 1 — Find founder-stack

**Linux / WSL2:**
```bash
if [ -d "$HOME/founder-stack/scripts" ]; then
  FOUNDER_STACK="$HOME/founder-stack"
elif [ -d "/tmp/founder-stack/scripts" ]; then
  FOUNDER_STACK="/tmp/founder-stack"
else
  git clone https://github.com/avtplay/founder-stack.git /tmp/founder-stack --depth 1 -q \
  || {
    curl -fsSL https://github.com/avtplay/founder-stack/archive/refs/heads/main.zip \
      -o /tmp/founder-stack.zip \
      && unzip -q /tmp/founder-stack.zip -d /tmp/ \
      && mv /tmp/founder-stack-main /tmp/founder-stack
  }
  FOUNDER_STACK="/tmp/founder-stack"
fi
```

**Windows (PowerShell):**
```powershell
$localPath = Join-Path $env:USERPROFILE "founder-stack"
$tempPath  = Join-Path $env:TEMP "founder-stack"
if (Test-Path "$localPath\scripts") {
    $founderStack = $localPath
} elseif (Test-Path "$tempPath\scripts") {
    $founderStack = $tempPath
} else {
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

### Step 2 — Ask /start questions (idea → stack → git)

### Step 3 — Bootstrap in current directory

**Linux / WSL2:**
```bash
bash "$FOUNDER_STACK/scripts/bootstrap-project.sh" --stack <a|b|c-firebase|c-supabase|d> [--git]
```

**Windows:**
```powershell
& "$founderStack\scripts\bootstrap-project.ps1" -Stack <a|b|c-firebase|c-supabase|d> [-Git]
```

### Step 4 — Clean up temp (if downloaded)

**Linux:** `[ "$FOUNDER_STACK" = "/tmp/founder-stack" ] && rm -rf /tmp/founder-stack /tmp/founder-stack.zip 2>/dev/null || true`

**Windows:** `if ($founderStack -eq $tempPath) { Remove-Item $tempPath -Recurse -Force -ErrorAction SilentlyContinue }`

### Step 5 — Continue

Read the new CLAUDE.md and AGENTS.md, then guide the user to their first `/feature`.

---

## Language

Always respond in the user's language. Detect it from their first message.
