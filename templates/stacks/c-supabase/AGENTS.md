# AGENTS.md — React + Supabase

## Stack
- **Frontend**: React 18 + TypeScript + Vite + TailwindCSS
- **Auth**: Supabase Auth (email/password + OAuth)
- **Database**: PostgreSQL via Supabase (SQL, real-time)
- **File storage**: Supabase Storage
- **SDK**: @supabase/supabase-js@2+

## Project structure
```
my-project/
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── pages/
│   ├── components/
│   ├── hooks/
│   │   ├── useAuth.ts          ← Supabase auth hook
│   │   └── useSupabase.ts      ← DB query hook
│   ├── lib/
│   │   └── supabase.ts         ← client initialization
│   └── types/
│       └── database.types.ts   ← types generated from schema
├── supabase/
│   └── migrations/             ← SQL migrations
├── .env.local                  ← Supabase keys (never committed)
├── .env.example
├── package.json
└── vite.config.ts
```

## Required environment variables
```bash
# .env.local
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...
```

## Commands
```bash
pnpm install              # install dependencies
pnpm dev                  # start locally → http://localhost:5173
pnpm build                # compile for production

# Supabase CLI (optional, for local dev)
npx supabase init         # initialize local Supabase
npx supabase start        # start Supabase locally (requires Docker)
npx supabase db push      # apply migrations
```

## Rules for Claude
- Initialize the Supabase client once only in `src/lib/supabase.ts`
- Use Row Level Security (RLS) on all tables — never create a table without enabling RLS
- Auth via a React context (`AuthContext`) + `useAuth` hook
- Strong typing: generate types from schema with `supabase gen types typescript`
- Prefer SQL functions for complex business logic (edge functions if needed)
- Never expose the `service_role` key on the frontend — only use the `anon` key

## Recommended database structure
```sql
-- Always have a profiles table linked to auth.users
create table profiles (
  id uuid references auth.users primary key,
  created_at timestamptz default now(),
  ...
);

-- RLS on all tables
alter table profiles enable row level security;
create policy "Users can only see their own profile"
  on profiles for all using (auth.uid() = id);
```

## Deployment
**Frontend → Vercel** (recommended):
1. Push to GitHub
2. Connect the repo on vercel.com
3. Add environment variables in Vercel

**Database → Supabase Cloud**:
- Already online if created on supabase.com

## Advantages over Firebase
- Full SQL (joins, aggregations, transactions)
- Open source — exportable, self-hostable
- Row Level Security = fine-grained security directly in the DB
- Less vendor lock-in

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Modifying Row Level Security policies
2. Running DB migrations on non-dev environments
3. Committing and pushing to remote
4. Installing new dependencies
5. Deleting files

## Do NOT
- Put Supabase keys (especially `service_role`) in source code
- Create tables without enabling RLS
- Use `any` in TypeScript
- Write inline CSS (use Tailwind)
