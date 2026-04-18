# AGENTS.md — React App (local / deployable)

## Stack
- **Frontend**: React 18 + TypeScript + Vite + TailwindCSS
- **State**: useState / useReducer (local), Zustand (global if needed)
- **Persistence**: localStorage via `useLocalStorage` hook (single device)
- **No backend** — everything runs in the browser

> ⚠️ Data stored in localStorage is only accessible on the device where it was saved.
> If users need to access data from multiple devices or share data between users → upgrade to Stack C (Firebase or Supabase).

## Project structure
```
my-project/
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── pages/          ← one folder per page
│   ├── components/     ← reusable components
│   ├── hooks/
│   │   └── useLocalStorage.ts  ← always create this hook first
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

## useLocalStorage hook (always create this first)
```typescript
import { useState } from 'react'

export function useLocalStorage<T>(key: string, initialValue: T) {
  const [value, setValue] = useState<T>(() => {
    try {
      const item = localStorage.getItem(key)
      return item ? JSON.parse(item) : initialValue
    } catch {
      return initialValue
    }
  })

  const setStoredValue = (newValue: T) => {
    setValue(newValue)
    localStorage.setItem(key, JSON.stringify(newValue))
  }

  return [value, setStoredValue] as const
}
```

## Rules for Claude
- TypeScript strict — no `any`
- Functional components only (no class components)
- TailwindCSS for styles — no inline styles or separate .css files
- Routing if needed → React Router v6
- Forms if needed → React Hook Form
- All persistent data goes through `useLocalStorage` — never call `localStorage` directly
- When the user asks for data that needs to be shared between users → suggest upgrading to Stack C

## Deployment
**Vercel** (free, automatic):
1. Push code to GitHub
2. Go to vercel.com → "Import project" → connect your repo
3. Vercel deploys automatically on every push — no configuration needed

**Netlify alternative**:
1. `pnpm build`
2. Drag `dist/` onto netlify.com/drop

## Limits of this stack
- Data only on the current device (localStorage)
- No user accounts
- Not suitable if multiple users need to share data → use Stack C

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Committing and pushing to remote
2. Installing new dependencies
3. Deleting files

## Do NOT
- Use `any` in TypeScript
- Write inline CSS (use Tailwind)
- Use React class components
- Call `localStorage` directly — use the `useLocalStorage` hook
- Hard-code config values — use environment variables
