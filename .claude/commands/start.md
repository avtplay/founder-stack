# /start — Start a new project

Universal entry point. Asks the right questions, picks the right stack, sets everything up.

## Triggers
- "I want to start my project"
- "start a new project"
- "I want to build an app / a website"
- "je veux démarrer mon projet" / "commencer un projet"
- `/start`

---

## Full flow

### Step 0 — Download founder-stack (if not already present)

If the user gives you a founder-stack URL in an empty folder, download it before doing anything else.

**Try git clone first:**
```bash
git clone https://github.com/avtplay/founder-stack.git /tmp/founder-stack --depth 1 -q
```

**If git is not available or clone fails — fallback to zip:**
```bash
curl -fsSL https://github.com/avtplay/founder-stack/archive/refs/heads/main.zip \
  -o /tmp/founder-stack.zip \
  && unzip -q /tmp/founder-stack.zip -d /tmp/ \
  && mv /tmp/founder-stack-main /tmp/founder-stack
```

Founder-stack is now at `/tmp/founder-stack/`. Continue with Step 1.

---

### Step 1 — The idea

Use the `mvp-advisor` agent to:
1. Ask for a 2-3 sentence description of the project
2. Produce an MVP spec (core loop, pages, data, what to cut)

**⚠️ CHECKPOINT 1**: Present the spec → wait for confirmation before continuing

---

### Step 2 — Stack questions (one at a time, in order)

Ask each question separately. Wait for the answer before moving to the next.
Stop as soon as you can determine the stack.

---

**Q1 — Who will use it?**
> "Is this project just for you, or will other people use it?"

---

**Q2 — Prototype or real product?**
> "Do you want to show the idea visually (like a mockup), or do you want it to actually work?"

→ If mockup: **Stack A** decided, skip to Q6 (git)

---

**Q3 — User accounts?** *(only if real product)*
> "Will people need to create an account / log in to use your app?"

→ If no: **Stack B** decided, skip to Q6

---

**Q4 — Complex logic?** *(only if accounts = yes)*
> "Does your app need to handle things like payments, advanced calculations, or connect to other external services?"

→ If no: **Stack C** → ask Q5 (Firebase vs Supabase)
→ If yes: **Stack D** (advanced mode) → skip to Q6

---

**Q5 — Firebase or Supabase?** *(only if Stack C)*
> "To manage accounts and store data, you have two options:
>
> - **Firebase** (by Google) — very easy to get started, everything managed automatically, free up to a certain usage. Best if you want to move fast.
> - **Supabase** — similar to Firebase but open source (not tied to Google), more powerful database, can run locally. Best if you want more control.
>
> Do you have a preference? If not, I recommend **Firebase** to start."

---

**Q6 — Git?** *(always ask)*
> "Do you know what Git is?
>
> It's a tool that saves the full history of your code — like unlimited Ctrl+Z over time, and it lets you collaborate with other developers later.
>
> Do you want to use it?"

If the user doesn't know what Git is: give one extra sentence of explanation and let them choose. Don't insist if no.

---

### Step 3 — Summary

Present this before running anything:

```
## Your project summary

**Name**: <ask if not yet defined>
**Idea**: <spec in one sentence>

**Chosen stack**: <letter> — <name>
**Why**: <1 sentence in plain language, no jargon>

**What this means in practice**:
- <point 1>
- <point 2>
- <point 3>

**Git**: <yes / no>
```

**⚠️ CHECKPOINT 2**: Wait for confirmation ("ok", "go", "yes", "looks good") before running setup

---

### Step 4 — Setup

#### If Stack C (Firebase or Supabase): external guide first

Before running the script, guide the user step by step to create their project on the chosen service. Do not run the script until the user has their credentials.

**Firebase:**
1. "Go to [console.firebase.google.com](https://console.firebase.google.com)"
2. "Click 'Create a project', give it the same name as your project"
3. "Disable Google Analytics (not needed for now)"
4. "In the left menu → 'Authentication' → 'Get started' → enable 'Email/Password'"
5. "In 'Firestore Database' → 'Create database' → test mode"
6. "In project settings ⚙️ → 'Add app' → Web → copy the firebaseConfig keys"
7. "Give me the keys and I'll set them up"

**Supabase:**
1. "Go to [supabase.com](https://supabase.com) and create a free account"
2. "Click 'New project', give it the same name as your project"
3. "Save your database password somewhere safe"
4. "In 'Project Settings' → 'API' → copy the URL and the 'anon public' key"
5. "Give me those two values and I'll set them up"

#### Run the script

```bash
bash /tmp/founder-stack/scripts/bootstrap-project.sh --stack <a|b|c-firebase|c-supabase|d> [--git]
```

The script sets up the AI config in the current directory.
It automatically removes the founder-stack git remote if the folder was a clone.

#### Clean up temp files

```bash
rm -rf /tmp/founder-stack /tmp/founder-stack.zip 2>/dev/null || true
```

#### After the script

- The user is already in their project folder — no `cd` needed
- Read the new CLAUDE.md and AGENTS.md that were just created
- Give concrete next steps based on the stack
- Suggest `/feature "<first feature>"` to start building

---

## Rules

- Never skip checkpoints
- Never use technical jargon without explaining it in the same sentence
- If the user answers "I don't know" to a technical question → pick the simplest option and explain why
- Stack D = always flag as advanced mode, require explicit confirmation
- **Always respond in the user's language** — detect it from their first message and use it throughout
