# AGENTS.md — Full Stack (Mode Avancé)

> ⚠️ **Mode avancé** — Cette stack est recommandée uniquement si tu as besoin de logique backend complexe, de contrôle total sur ton infrastructure, ou si tu travailles avec un développeur. Elle demande plus de configuration et de maintenance qu'un projet Firebase/Supabase.

## Stack
- **Frontend** : React + TypeScript + Vite + TailwindCSS + React Query
- **Backend** : Node.js + Fastify
- **DB** : PostgreSQL + Prisma ORM
- **Auth** : JWT (access + refresh tokens)
- **CI/CD** : GitHub Actions
- **AI Orchestration** : Claude Code subagents + LangGraph (flows complexes)

## Project Structure
```
mon-projet/
├── apps/
│   ├── web/           → React frontend (Vite)
│   ├── api/           → Node/Fastify backend
│   └── workers/       → Background jobs / agents
├── packages/
│   ├── types/         → Types TypeScript partagés
│   ├── db/            → Prisma schema + client
│   └── config/        → Config partagée
├── .github/
│   └── workflows/     → CI/CD GitHub Actions
└── .claude/
    ├── agents/        → Sous-agents spécialisés
    └── commands/      → Commandes slash
```

## Commandes
```bash
pnpm install          # installer toutes les dépendances
pnpm dev              # démarrer tous les services
pnpm build            # compiler tout
pnpm test             # lancer tous les tests
pnpm lint             # eslint + tsc --noEmit
pnpm db:migrate       # prisma migrate dev
pnpm db:studio        # prisma studio (interface visuelle DB)
```

## Variables d'environnement requises
```bash
# .env.local
DATABASE_URL=postgresql://devuser:devpass@localhost:5432/devdb
JWT_SECRET=change-me-in-production
JWT_REFRESH_SECRET=change-me-too
NODE_ENV=development
PORT=3000
VITE_API_URL=http://localhost:3000
```

## Sous-agents disponibles
| Agent | Déclencher |
|-------|-----------|
| security-reviewer | auth / paiements / données sensibles |
| db-architect | schéma DB / migrations |
| test-writer | couverture de tests |
| frontend-specialist | composants React complexes |
| mvp-advisor | nouvelle feature / arbitrage produit |

## Règles
- TypeScript strict — pas de `any`
- Tests requis pour toute logique métier (Vitest)
- Commits conventionnels : feat/fix/chore/docs/refactor
- Feature branches depuis `main`, PRs obligatoires
- Variables d'env dans `.env.local` — jamais committées
- Pas de force push sur main

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Running DB migrations on non-dev environments
2. Committing and pushing to remote
3. Modifying auth/security logic
4. Installing new dependencies
5. Deleting files

## Do NOT
- Hard-coder des valeurs de config — utiliser les variables d'env
- Utiliser des class components React
- Utiliser `any` en TypeScript
- Écrire de CSS inline (utiliser Tailwind)
