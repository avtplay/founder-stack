# Claude Code — Global Instructions

## founder-stack auto-bootstrap

When the user gives you a founder-stack URL and asks to start or set up a project, follow this flow exactly — even in an empty folder with no other files.

### Step 1 — Download founder-stack

Run the /start questions first (idea, stack choice, git) to know which `--stack` and `--git` flags to use.

Then download founder-stack to a temp location:

```bash
# Try git clone first (faster, cleaner)
if command -v git &>/dev/null; then
  git clone https://github.com/avtplay/founder-stack.git /tmp/founder-stack --depth 1 -q 2>/dev/null \
    && echo "cloned" \
    || echo "clone_failed"
else
  echo "no_git"
fi
```

If git is not available or clone fails → fallback to zip:
```bash
curl -fsSL https://github.com/avtplay/founder-stack/archive/refs/heads/main.zip \
  -o /tmp/founder-stack.zip \
  && unzip -q /tmp/founder-stack.zip -d /tmp/ \
  && mv /tmp/founder-stack-main /tmp/founder-stack
```

### Step 2 — Bootstrap in the current directory

```bash
bash /tmp/founder-stack/scripts/bootstrap-project.sh --stack <a|b|c-firebase|c-supabase|d> [--git]
```

This sets up the AI config (CLAUDE.md, AGENTS.md, .claude/) in the current folder.
It also removes the founder-stack git remote if the folder was previously a clone.

### Step 3 — Clean up

```bash
rm -rf /tmp/founder-stack /tmp/founder-stack.zip 2>/dev/null || true
```

### Step 4 — Continue

The project is now configured. Read the new CLAUDE.md and AGENTS.md that were just created, then continue the /start flow (external service setup if needed, first /feature suggestion).

---

## Language

Always respond in the user's language. Detect it from their first message.
