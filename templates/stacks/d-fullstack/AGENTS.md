# AGENTS.md — Full Stack (Advanced Mode)

> ⚠️ **Advanced mode** — This stack is recommended only if you need complex backend logic, full control over your infrastructure, or if you are working with a developer. It requires more configuration and maintenance than a Firebase/Supabase project.

## Stack
- **Frontend**: React + TypeScript + Vite + TailwindCSS + React Query
- **Backend**: Node.js + Fastify
- **DB**: PostgreSQL + Prisma ORM
- **Auth**: JWT (access + refresh tokens)
- **CI/CD**: GitHub Actions
- **AI Orchestration**: Claude Code subagents + LangGraph (complex flows)

## Project structure
```
my-project/
├── apps/
│   ├── web/           → React frontend (Vite)
│   ├── api/           → Node/Fastify backend
│   └── workers/       → Background jobs / agents
├── packages/
│   ├── types/         → Shared TypeScript types
│   ├── db/            → Prisma schema + client
│   └── config/        → Shared config
├── .github/
│   └── workflows/     → CI/CD GitHub Actions
└── .claude/
    ├── agents/        → Specialized subagents
    └── commands/      → Slash commands
```

## Commands
```bash
pnpm install          # install all dependencies
pnpm dev              # start all services
pnpm build            # build everything
pnpm test             # run all tests
pnpm lint             # eslint + tsc --noEmit
pnpm db:migrate       # prisma migrate dev
pnpm db:studio        # prisma studio (visual DB interface)
```

## Required environment variables
```bash
# .env.local
DATABASE_URL=postgresql://devuser:devpass@localhost:5432/devdb
JWT_SECRET=change-me-in-production
JWT_REFRESH_SECRET=change-me-too
NODE_ENV=development
PORT=3000
VITE_API_URL=http://localhost:3000
```

## Available subagents
| Agent | Trigger |
|-------|---------|
| security-reviewer | auth / payments / sensitive data |
| db-architect | DB schema / migrations |
| test-writer | test coverage |
| frontend-specialist | complex React components |
| mvp-advisor | new feature / product decisions |

## Rules
- TypeScript strict — no `any`
- Tests required for all business logic (Vitest)
- Conventional commits: feat/fix/chore/docs/refactor
- Feature branches from `main`, PRs required
- Env vars in `.env.local` — never committed
- No force push to main

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Running DB migrations on non-dev environments
2. Committing and pushing to remote
3. Modifying auth/security logic
4. Installing new dependencies
5. Deleting files

## Do NOT
- Hard-code config values — use environment variables
- Use React class components
- Use `any` in TypeScript
- Write inline CSS (use Tailwind)
