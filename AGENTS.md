# AGENTS.md — AI Stack Context

## Stack
- **Frontend**: React + TypeScript + Vite
- **Backend**: Node.js + Fastify (or FastAPI for Python services)
- **DB**: PostgreSQL + Prisma ORM
- **Auth**: JWT (access + refresh tokens)
- **CI/CD**: GitHub Actions
- **AI Orchestration**: Claude Code subagents + LangGraph (complex flows)

## Project Structure
```
/apps/web          → React frontend (Vite)
/apps/api          → Node/Fastify backend
/apps/workers      → Background jobs / agents
/packages/types    → Shared TypeScript types
/packages/db       → Prisma schema + client
/packages/config   → Shared config
.claude/agents/    → CC subagent definitions
.claude/commands/  → Slash commands
```

## Commands
```bash
pnpm install          # install all deps
pnpm dev              # start all services
pnpm build            # build all
pnpm test             # run all tests
pnpm lint             # eslint + tsc --noEmit
pnpm db:migrate       # prisma migrate dev
pnpm db:studio        # prisma studio
```

## Rules
- TypeScript strict mode everywhere — no `any`
- Tests required for all business logic (Vitest)
- Conventional commits: feat/fix/chore/docs/refactor
- Feature branches from `main`, PRs required
- Env vars via `.env.local` never committed
- No force push to main

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Running DB migrations on non-dev environments
2. Committing and pushing to remote
3. Modifying auth/security logic
4. Installing new dependencies
5. Deleting files

## Do NOT
- Hard-code config values — use env vars
- Repeat context already established in session
- Generate verbose explanations unless asked
- Use class components in React
