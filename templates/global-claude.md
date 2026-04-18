# Claude Code — Global Instructions

## founder-stack auto-bootstrap

Trigger phrases (any language):
- "start my project", "démarre mon projet", "start a founder-stack"
- "démarre un founder-stack ici", "bootstrap this folder"
- "here's the link: <url> — start my project"
- Any message giving a founder-stack GitHub URL + asking to start

When triggered, follow this flow:

---

### Step 1 — Find founder-stack

**Check local first (fast path):**
```bash
if [ -d "$HOME/founder-stack/scripts" ]; then
  FOUNDER_STACK="$HOME/founder-stack"
elif [ -d "/tmp/founder-stack/scripts" ]; then
  FOUNDER_STACK="/tmp/founder-stack"
else
  FOUNDER_STACK=""
fi
```

**If not found locally — download it:**

Try git clone first:
```bash
git clone https://github.com/avtplay/founder-stack.git /tmp/founder-stack --depth 1 -q
FOUNDER_STACK="/tmp/founder-stack"
```

If git is not available or clone fails — fallback to zip:
```bash
curl -fsSL https://github.com/avtplay/founder-stack/archive/refs/heads/main.zip \
  -o /tmp/founder-stack.zip \
  && unzip -q /tmp/founder-stack.zip -d /tmp/ \
  && mv /tmp/founder-stack-main /tmp/founder-stack
FOUNDER_STACK="/tmp/founder-stack"
```

---

### Step 2 — Ask the /start questions

Before running the bootstrap, follow the /start command workflow:
- Ask about the project idea
- Ask the stack qualification questions (Q1 → Q6)
- Get confirmation

---

### Step 3 — Bootstrap in the current directory

```bash
bash "$FOUNDER_STACK/scripts/bootstrap-project.sh" --stack <a|b|c-firebase|c-supabase|d> [--git]
```

---

### Step 4 — Clean up (only if downloaded to /tmp)

```bash
[ "$FOUNDER_STACK" = "/tmp/founder-stack" ] && rm -rf /tmp/founder-stack /tmp/founder-stack.zip 2>/dev/null || true
```

---

### Step 5 — Continue

Read the new CLAUDE.md and AGENTS.md just created, then continue the /start flow.

---

## Language

Always respond in the user's language. Detect it from their first message.
