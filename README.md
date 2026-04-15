# AI Stack — Full-Stack Agentic Setup

Stack opinioné pour démarrer des projets full-stack avec Claude Code en mode autonome + checkpoints.

## Ce qui est inclus

| Outil | Rôle | Token impact |
|-------|------|-------------|
| **Claude Code** | Agent principal | — |
| **RTK** | Compresse sorties CLI | −89% tokens Bash |
| **SuperClaude** | 30 commandes /sc: + 9 personas | Meilleure qualité |
| **ccusage** | Analytics token usage | Monitoring |
| **cmonitor** | Live token monitor | Alertes quotas |
| **Sous-agents CC** | Contextes isolés spécialisés | Réduit context main |
| **GitHub Actions** | CI + agent review auto | — |

## Installation (WSL2)

```bash
# 1. Cloner ce repo
git clone <repo-url> ~/ai-stack
cd ~/ai-stack

# 2. Lancer le setup (une seule fois)
bash scripts/setup-wsl.sh

# 3. Configurer la clé API
echo 'export ANTHROPIC_API_KEY=sk-ant-...' >> ~/.bashrc
source ~/.bashrc
```

## Démarrer un projet

```bash
bash scripts/bootstrap-project.sh mon-projet
cd ~/projects/mon-projet
pnpm install
claude
```

## Workflow quotidien

```bash
# Démarrer une session
claude

# Dans Claude Code :
/feature "authentification JWT complète"
# → Phase 1: spec + checkpoint
# → Phase 2: implémentation + checkpoint  
# → Phase 3: tests + commit checkpoint

# Revue avant PR
/review

# Avant de vider le contexte
/handoff
/clear
```

## Commandes disponibles

| Commande | Description |
|----------|-------------|
| `/feature <desc>` | Scaffold complet avec 3 checkpoints |
| `/review` | Revue de code pre-PR |
| `/handoff` | Dump contexte avant /clear |
| `/sc:implement` | SuperClaude implementation |
| `/sc:design` | SuperClaude architecture design |
| `/sc:test` | SuperClaude test coverage |
| `/sc:analyze` | SuperClaude code analysis |

## Sous-agents disponibles

| Agent | Se déclenche pour |
|-------|------------------|
| `security-reviewer` | Code auth, paiements, inputs |
| `db-architect` | Schéma, migrations, requêtes |
| `test-writer` | Couverture de tests |
| `frontend-specialist` | Composants React complexes |

Usage : *"Use a subagent to review this auth code for security issues"*

## Monitoring tokens

```bash
# Statistiques d'usage
ccusage               # rapport daily
ccusage monthly       # rapport mensuel
rtk gain              # économies RTK

# Monitoring live (dans un autre terminal)
cmonitor --plan max20 # adapter selon ton plan

# Depuis Claude Code
/context              # décomposition du contexte actuel
/cost                 # coût de la session
```

## Checkpoints automatiques

Les agents s'arrêtent et attendent ta validation avant :
1. Écrire des migrations DB
2. Commit + push
3. Modifier la logique auth/sécurité
4. Installer de nouvelles dépendances
5. Supprimer des fichiers

## Structure type d'un projet bootstrappé

```
mon-projet/
├── AGENTS.md              ← source de vérité (tous outils)
├── CLAUDE.md              ← @AGENTS.md + spécifiques CC
├── .claude/
│   ├── agents/            ← sous-agents spécialisés
│   ├── commands/          ← /feature /review /handoff
│   └── settings.json      ← hooks RTK + permissions
├── .github/
│   └── workflows/ci.yml   ← lint + tests + agent review
├── apps/
│   ├── web/               ← React + TypeScript + Vite
│   └── api/               ← Node.js + Fastify
└── packages/
    ├── types/             ← types partagés
    └── db/                ← Prisma schema + client
```

## Tips

- **Context à 70%** → `/compact` avant que ça dégrade
- **Tâche lourde en lecture** → "use a subagent for this"
- **Plusieurs features en parallèle** → git worktrees + instances CC séparées
- **RTK trop agressif** → `rtk proxy <cmd>` pour la sortie brute
