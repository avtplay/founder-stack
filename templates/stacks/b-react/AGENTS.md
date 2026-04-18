# AGENTS.md — React App (local / deployable)

## Stack
- **Frontend**: React 18 + TypeScript + Vite + TailwindCSS
- **State**: useState / useReducer (local), Zustand (global if needed)
- **Data**: localStorage (lightweight persistence) or static JSON
- **No backend** — everything runs in the browser

## Project structure
```
my-project/
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── pages/          ← one folder per page
│   ├── components/     ← reusable components
│   ├── hooks/          ← reusable logic
│   └── lib/            ← utilities
├── public/
├── index.html
├── package.json
└── vite.config.ts
```

## Commands
```bash
pnpm install      # install dependencies (first time)
pnpm dev          # start locally → http://localhost:5173
pnpm build        # compile for production
pnpm preview      # preview the compiled version
```

## Rules for Claude
- TypeScript strict — no `any`
- Functional components only (no class components)
- TailwindCSS for styles — no inline styles or separate .css files
- Routing if needed → React Router v6
- Forms if needed → React Hook Form
- Persistent data → localStorage with a custom `useLocalStorage` hook

## Deployment
**Vercel** (free):
1. `pnpm build` → `dist/` folder generated
2. Go to vercel.com → "Import project" → connect your GitHub repo
3. Vercel deploys automatically on every push

**Netlify alternative**:
1. `pnpm build`
2. Drag `dist/` onto netlify.com/drop

## Limits of this stack
- No native user accounts
- Data stored in the browser (lost on another device)
- Not suitable if multiple users need to share data

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Committing and pushing to remote
2. Installing new dependencies
3. Deleting files

## Do NOT
- Use `any` in TypeScript
- Write inline CSS (use Tailwind)
- Use React class components
- Hard-code config values — use environment variables
