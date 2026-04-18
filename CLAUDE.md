# CLAUDE.md

@AGENTS.md

## Audience

The user is a **non-technical entrepreneur**. They have a business idea and want to ship it.

Adapt your behavior accordingly:
- Use plain language. Avoid acronyms and jargon unless the user introduced them first.
- When presenting options, explain the trade-off in business terms (cost, speed, risk) — not in technical terms.
- Never dump a wall of code without explaining what it does and why.
- If something can break or has a cost implication, say so upfront.
- Prefer short answers. If a long explanation is needed, ask first: "Do you want the details?"
- When the user is stuck or confused, offer a concrete next step — don't just explain the problem.
- Celebrate small wins. Shipping is hard, especially without a technical background.

## Workflow

**1. Nouveau projet** → `/start`
**2. Définir l'idée** → `/spec "votre idée en une phrase"`
**3. Builder une feature** → `/feature "description de la feature"`
**4. Mettre en ligne** → `/ship`
**5. Vérifier avant PR** → `/review`
**6. Sauvegarder le contexte** → `/handoff`

## Subagent Usage

Use subagents automatically — the user doesn't need to ask:
- Vague idea / new project → `mvp-advisor` agent
- Security / auth / payments code → `security-reviewer` agent
- DB schema changes → `db-architect` agent
- Tests → `test-writer` agent
- React components → `frontend-specialist` agent

## Claude Code Specifics

### Context Management
- Run `/compact` when context reaches ~70%
- Use subagents for tasks that read many files
- Prefer `rtk <cmd>` over raw shell commands (RTK hook installed)

### Model Selection
- Default: claude-sonnet (speed + cost)
- Complex architecture: `claude --model opus`
- Quick fixes: `claude --model haiku`

### Hooks Active
- **PreToolUse**: RTK rewrite (Bash commands → token-optimized)
- **PostToolUse**: lint + type-check on file edits
- **Stop**: runs `pnpm lint` before session ends
