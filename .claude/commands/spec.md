# /spec — Idea to Buildable Spec

Transforms a business idea (even vague) into a concrete spec, then into a first `/feature` command.

## Usage
```
/spec "je veux créer une app pour réserver des cours de yoga"
/spec "une plateforme où des freelances proposent leurs services"
/spec "un outil qui envoie des rappels automatiques à mes clients"
```

## What happens

### Phase 1 — Clarification (if needed)
The `mvp-advisor` subagent will ask up to 3 questions to understand:
- Who are the users
- What is the core value
- What does "done" look like for v1

**If the idea is clear enough, it skips straight to Phase 2.**

### Phase 2 — MVP Spec
The subagent produces:
- One-sentence description
- The core loop (the 3-5 steps that create value)
- Screens / pages needed for v1
- Data the app needs to remember (plain English)
- What is explicitly cut from v1

**⚠️ CHECKPOINT**: Present spec → await "c'est bon" or "go" before continuing

### Phase 3 — First feature
From the spec, derive the single best first feature to build.
Output a ready-to-use `/feature` command.

**⚠️ CHECKPOINT**: Confirm the first feature before launching `/feature`

## Rules
- Always use the `mvp-advisor` subagent for Phase 1 & 2
- Never start writing code in this command — that's `/feature`'s job
- If the user wants to change the spec after checkpoint 2, restart from Phase 2
- Keep the spec in plain language — the user is non-technical
