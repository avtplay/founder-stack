# CLAUDE.md

@AGENTS.md

## Claude Code Specifics

### Context Management
- Run `/compact` when context reaches ~70%
- Use subagents for tasks that read many files
- Prefer `rtk <cmd>` over raw shell commands (RTK hook installed)

### Subagent Usage
Say "use a subagent" to delegate isolated tasks:
- Security reviews → security-reviewer agent
- DB work → db-architect agent  
- Tests → test-writer agent
- Frontend → frontend-specialist agent

### Model Selection
- Default: claude-sonnet (speed + cost)
- Complex architecture: `claude --model opus`
- Quick fixes: `claude --model haiku`

### Hooks Active
- **PreToolUse**: RTK rewrite (Bash commands → token-optimized)
- **PostToolUse**: lint + type-check on file edits
- **Stop**: runs `pnpm lint` before session ends
