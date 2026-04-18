# AGENTS.md — React + Firebase

## Stack
- **Frontend**: React 18 + TypeScript + Vite + TailwindCSS
- **Auth**: Firebase Authentication (email/password + Google)
- **Database**: Cloud Firestore (NoSQL real-time)
- **File storage**: Firebase Storage
- **Hosting**: Firebase Hosting
- **SDK**: firebase@10+

## Project structure
```
my-project/
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── pages/
│   ├── components/
│   ├── hooks/
│   │   ├── useAuth.ts        ← Firebase auth hook
│   │   └── useFirestore.ts   ← Firestore data hook
│   ├── lib/
│   │   └── firebase.ts       ← Firebase initialization
│   └── types/
├── .env.local                ← Firebase keys (never committed)
├── .env.example              ← variable template
├── package.json
└── vite.config.ts
```

## Required environment variables
```bash
# .env.local
VITE_FIREBASE_API_KEY=
VITE_FIREBASE_AUTH_DOMAIN=
VITE_FIREBASE_PROJECT_ID=
VITE_FIREBASE_STORAGE_BUCKET=
VITE_FIREBASE_MESSAGING_SENDER_ID=
VITE_FIREBASE_APP_ID=
```

## Commands
```bash
pnpm install          # install dependencies
pnpm dev              # start locally → http://localhost:5173
pnpm build            # compile
firebase deploy       # deploy to Firebase Hosting
```

## Rules for Claude
- Always initialize Firebase in `src/lib/firebase.ts` — never duplicate the init elsewhere
- Access Firestore via custom hooks (`useCollection`, `useDocument`)
- Auth via a React context (`AuthContext`) + `useAuth` hook
- Firestore security rules: always check `request.auth != null` for private data
- TypeScript strict — no `any`
- Never expose Firebase keys in code — only via `import.meta.env.VITE_*`

## Recommended Firestore structure
```
users/{userId}
  → user profile

<collection>/{docId}
  → ownerId: string (reference to users)
  → createdAt: timestamp
  → ...business data
```

## Deployment
```bash
npm install -g firebase-tools
firebase login
firebase init hosting    # choose dist/ as public folder
pnpm build
firebase deploy
```

## Limits of this stack
- Google vendor lock-in (hard to migrate later)
- Firestore = NoSQL: not suited for complex queries (joins, aggregations)
- Costs can increase with traffic (monitor quotas)

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Modifying Firestore security rules
2. Committing and pushing to remote
3. Running `firebase deploy` on production
4. Installing new dependencies
5. Deleting files

## Do NOT
- Put Firebase keys in source code
- Use `allow read, write: if true` in production (open security rules)
- Use `any` in TypeScript
- Write inline CSS (use Tailwind)
