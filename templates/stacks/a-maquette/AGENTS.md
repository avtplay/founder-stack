# AGENTS.md — Maquette HTML

## Stack
- **Frontend** : HTML5 + TailwindCSS (via CDN) + JavaScript vanilla
- **Pas de build system** — aucune installation nécessaire
- **Base de données** : aucune (données en dur ou localStorage si besoin)

## Structure du projet
```
mon-projet/
├── index.html          ← page principale
├── pages/              ← autres pages si besoin
│   └── *.html
├── assets/
│   ├── images/
│   └── icons/
└── script.js           ← logique JS si nécessaire
```

## Commandes
```bash
# Prévisualiser : ouvrir index.html dans Chrome/Firefox
# Pas de pnpm, pas de npm, pas de build

# Déployer en 30 secondes :
# → Va sur netlify.com/drop et glisse-dépose le dossier
```

## Règles pour Claude
- Toujours inclure Tailwind via CDN dans le `<head>` : `<script src="https://cdn.tailwindcss.com"></script>`
- Utiliser des classes Tailwind, pas de CSS custom sauf si vraiment nécessaire
- JavaScript simple et lisible — pas de frameworks, pas d'imports
- Tout doit fonctionner en ouvrant le fichier HTML directement (pas de serveur local requis)
- Si l'utilisateur demande de la donnée dynamique → localStorage d'abord, expliquer les limites
- Composants réutilisables → fonctions JS qui retournent du HTML (pas de Web Components)

## Limites de cette stack
- Pas de comptes utilisateurs (tout le monde voit la même chose)
- Données perdues si on vide le cache (si localStorage)
- Pas adapté à plus de ~10 pages

## Déploiement
**Netlify Drop** (gratuit, 30 secondes) :
1. Va sur netlify.com/drop
2. Glisse-dépose le dossier du projet
3. Ton site est en ligne avec une URL publique

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Committing and pushing to remote
2. Deleting files

## Do NOT
- Utiliser npm/pnpm/node
- Ajouter des dépendances externes (sauf Tailwind CDN)
- Hard-coder des données sensibles
- Utiliser des class components ou frameworks JS
