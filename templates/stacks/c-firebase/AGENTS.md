# AGENTS.md — React + Firebase

## Stack
- **Frontend** : React 18 + TypeScript + Vite + TailwindCSS
- **Auth** : Firebase Authentication (email/password + Google)
- **Base de données** : Cloud Firestore (NoSQL temps réel)
- **Stockage fichiers** : Firebase Storage
- **Hébergement** : Firebase Hosting
- **SDK** : firebase@10+

## Structure du projet
```
mon-projet/
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── pages/
│   ├── components/
│   ├── hooks/
│   │   ├── useAuth.ts        ← hook auth Firebase
│   │   └── useFirestore.ts   ← hook données Firestore
│   ├── lib/
│   │   └── firebase.ts       ← initialisation Firebase
│   └── types/
├── .env.local                ← clés Firebase (jamais committé)
├── .env.example              ← template des variables
├── package.json
└── vite.config.ts
```

## Variables d'environnement requises
```bash
# .env.local
VITE_FIREBASE_API_KEY=
VITE_FIREBASE_AUTH_DOMAIN=
VITE_FIREBASE_PROJECT_ID=
VITE_FIREBASE_STORAGE_BUCKET=
VITE_FIREBASE_MESSAGING_SENDER_ID=
VITE_FIREBASE_APP_ID=
```

## Commandes
```bash
pnpm install          # installer les dépendances
pnpm dev              # démarrer en local → http://localhost:5173
pnpm build            # compiler
firebase deploy       # déployer sur Firebase Hosting
```

## Règles pour Claude
- Toujours initialiser Firebase dans `src/lib/firebase.ts` — ne jamais répliquer l'init ailleurs
- Accès Firestore via hooks custom (`useCollection`, `useDocument`)
- Auth via un contexte React (`AuthContext`) + hook `useAuth`
- Règles de sécurité Firestore : toujours vérifier `request.auth != null` pour les données privées
- TypeScript strict — pas de `any`
- Jamais exposer les clés Firebase dans le code — uniquement via `import.meta.env.VITE_*`

## Structure Firestore recommandée
```
users/{userId}
  → profil utilisateur

<collection>/{docId}
  → ownerId: string (référence vers users)
  → createdAt: timestamp
  → ...données métier
```

## Déploiement
```bash
npm install -g firebase-tools
firebase login
firebase init hosting    # choisir dist/ comme dossier public
pnpm build
firebase deploy
```

## Limites de cette stack
- Vendor lock-in Google (difficile à migrer plus tard)
- Firestore = NoSQL : pas adapté aux requêtes complexes (joins, agrégations)
- Coûts peuvent augmenter avec le trafic (surveiller les quotas)

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Modifying Firestore security rules
2. Committing and pushing to remote
3. Running `firebase deploy` on production
4. Installing new dependencies
5. Deleting files

## Do NOT
- Mettre les clés Firebase dans le code source
- Utiliser `allow read, write: if true` en production (règles de sécurité ouvertes)
- Utiliser `any` en TypeScript
- Écrire de CSS inline (utiliser Tailwind)
