# AGENTS.md — React App (locale / déployable)

## Stack
- **Frontend** : React 18 + TypeScript + Vite + TailwindCSS
- **State** : useState / useReducer (local), Zustand (global si besoin)
- **Données** : localStorage (persistance légère) ou JSON statique
- **Pas de backend** — tout tourne côté navigateur

## Structure du projet
```
mon-projet/
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── pages/          ← une page = un dossier
│   ├── components/     ← composants réutilisables
│   ├── hooks/          ← logique réutilisable
│   └── lib/            ← utilitaires
├── public/
├── index.html
├── package.json
└── vite.config.ts
```

## Commandes
```bash
pnpm install      # installer les dépendances (première fois)
pnpm dev          # démarrer en local → http://localhost:5173
pnpm build        # compiler pour la production
pnpm preview      # prévisualiser la version compilée
```

## Règles pour Claude
- TypeScript strict — pas de `any`
- Composants fonctionnels uniquement (pas de class components)
- TailwindCSS pour les styles — pas de CSS inline ni de fichiers .css séparés
- Si besoin de routing → React Router v6
- Si besoin de formulaires → React Hook Form
- Données persistantes → localStorage avec un hook custom `useLocalStorage`

## Déploiement
**Vercel** (gratuit) :
1. `pnpm build` → dossier `dist/` généré
2. Va sur vercel.com → "Import project" → connecte ton repo GitHub
3. Vercel déploie automatiquement à chaque push

**Alternative Netlify** :
1. `pnpm build`
2. Glisse `dist/` sur netlify.com/drop

## Limites de cette stack
- Pas de comptes utilisateurs natifs
- Données stockées dans le navigateur (perdues si autre appareil)
- Pas adapté si plusieurs utilisateurs doivent partager des données

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Committing and pushing to remote
2. Installing new dependencies
3. Deleting files

## Do NOT
- Utiliser `any` en TypeScript
- Écrire de CSS inline (utiliser Tailwind)
- Utiliser des class components React
- Hard-coder des valeurs de config — utiliser des variables d'environnement
