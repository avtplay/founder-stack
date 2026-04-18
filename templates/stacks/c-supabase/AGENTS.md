# AGENTS.md — React + Supabase

## Stack
- **Frontend** : React 18 + TypeScript + Vite + TailwindCSS
- **Auth** : Supabase Auth (email/password + OAuth)
- **Base de données** : PostgreSQL via Supabase (SQL, temps réel)
- **Stockage fichiers** : Supabase Storage
- **SDK** : @supabase/supabase-js@2+

## Structure du projet
```
mon-projet/
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── pages/
│   ├── components/
│   ├── hooks/
│   │   ├── useAuth.ts          ← hook auth Supabase
│   │   └── useSupabase.ts      ← hook requêtes DB
│   ├── lib/
│   │   └── supabase.ts         ← initialisation client
│   └── types/
│       └── database.types.ts   ← types générés depuis le schéma
├── supabase/
│   └── migrations/             ← migrations SQL
├── .env.local                  ← clés Supabase (jamais committé)
├── .env.example
├── package.json
└── vite.config.ts
```

## Variables d'environnement requises
```bash
# .env.local
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
```

## Commandes
```bash
pnpm install              # installer les dépendances
pnpm dev                  # démarrer en local → http://localhost:5173
pnpm build                # compiler pour la production

# Supabase CLI (optionnel, pour dev local)
npx supabase init         # initialiser Supabase local
npx supabase start        # démarrer Supabase en local (Docker requis)
npx supabase db push      # appliquer les migrations
```

## Règles pour Claude
- Initialiser le client Supabase une seule fois dans `src/lib/supabase.ts`
- Utiliser Row Level Security (RLS) sur toutes les tables — jamais de table sans RLS activé
- Auth via un contexte React (`AuthContext`) + hook `useAuth`
- Typage fort : générer les types depuis le schéma avec `supabase gen types typescript`
- Préférer des fonctions SQL pour la logique métier complexe (edge functions si besoin)
- Jamais exposer la `service_role` key côté frontend — uniquement `anon` key

## Structure de base de données recommandée
```sql
-- Toujours avoir une table profiles liée à auth.users
create table profiles (
  id uuid references auth.users primary key,
  created_at timestamptz default now(),
  ...
);

-- RLS sur toutes les tables
alter table profiles enable row level security;
create policy "Users can only see their own profile"
  on profiles for all using (auth.uid() = id);
```

## Déploiement
**Frontend → Vercel** (recommandé) :
1. Push sur GitHub
2. Connecte le repo sur vercel.com
3. Ajoute les variables d'environnement dans Vercel

**Base de données → Supabase Cloud** :
- Déjà en ligne si créé sur supabase.com

## Avantages vs Firebase
- SQL complet (joins, agrégations, transactions)
- Open source — exportable, auto-hébergeable
- Row Level Security = sécurité fine dans la DB directement
- Moins de vendor lock-in

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Modifying Row Level Security policies
2. Running DB migrations on non-dev environments
3. Committing and pushing to remote
4. Installing new dependencies
5. Deleting files

## Do NOT
- Mettre les clés Supabase (surtout `service_role`) dans le code
- Créer des tables sans activer RLS
- Utiliser `any` en TypeScript
- Écrire de CSS inline (utiliser Tailwind)
