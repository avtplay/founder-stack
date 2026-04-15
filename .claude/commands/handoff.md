# /handoff — Context Dump

Generates a handoff summary before clearing context. Run this before `/clear` to preserve key decisions.

## Usage
```
/handoff
/handoff --focus "auth feature"
```

## Instructions for Claude

Generate a structured handoff document covering:

1. **Current task** — What was being worked on
2. **Decisions made** — Architecture choices + rationale (not just what, but why)
3. **Files modified** — List with one-line description of changes
4. **Next steps** — Ordered list of what needs to happen next
5. **Blockers / open questions** — Anything unresolved
6. **Commands to run** — Any pending migrations, installs, or scripts

Keep it under 300 words. Optimize for "new Claude session can pick this up immediately."

After generating, ask: "Save to docs/handoff-<date>.md?"
