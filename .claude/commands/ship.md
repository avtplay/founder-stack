# /ship — Mettre en ligne

Déploie le projet en production, étape par étape, selon la stack utilisée.

## Usage
```
/ship                   # déploiement complet guidé
/ship --check           # vérification pré-déploiement uniquement
/ship --domain          # configurer un nom de domaine après déploiement
```

---

## Étape 1 — Détection de la stack

Lis `AGENTS.md` pour identifier la stack du projet.

| Ce que tu trouves dans AGENTS.md | Stack |
|----------------------------------|-------|
| "HTML5 + TailwindCSS (CDN)" | A — Maquette |
| "React 18 + TypeScript + Vite" sans Firebase/Supabase | B — React |
| "Firebase" | C — Firebase |
| "Supabase" | C — Supabase |
| "Node.js + Fastify" | D — Full Stack |

---

## Étape 2 — Checklist pré-déploiement

Vérifie ces points **avant** de déployer. Bloque si un point critique échoue.

**Pour toutes les stacks :**
- [ ] Aucune clé API, mot de passe ou secret dans le code source (grep `.env.local`, pas dans les fichiers committés)
- [ ] Le projet s'affiche correctement en local

**Stack B, C, D uniquement :**
- [ ] `pnpm build` passe sans erreur
- [ ] Pas d'erreurs TypeScript (`pnpm lint`)

**Stack C (Firebase/Supabase) :**
- [ ] `.env.local` rempli avec de vraies clés (pas les valeurs d'exemple)
- [ ] L'auth fonctionne en local
- [ ] Les données s'affichent en local

**Stack D :**
- [ ] Les migrations DB sont à jour
- [ ] Les variables d'environnement de production sont prêtes

**⚠️ CHECKPOINT** : Présenter le résultat de la checklist → attendre "go" avant de continuer

Si un point échoue → corriger avec l'utilisateur avant de continuer. Ne jamais déployer un projet cassé.

---

## Étape 3 — Déploiement par stack

---

### Stack A — Maquette HTML → Netlify Drop

**Aucun compte requis pour un déploiement rapide.**

1. "Ouvre [netlify.com/drop](https://netlify.com/drop) dans ton navigateur"
2. "Glisse-dépose **le dossier entier** de ton projet sur la zone indiquée"
3. "Netlify génère une URL publique en 30 secondes — copie-la"

✅ C'est tout. Ton site est en ligne.

**Si tu veux une URL permanente (garde le même lien) :**
1. "Crée un compte gratuit sur netlify.com"
2. "Dans ton tableau de bord → 'Add new site' → 'Deploy manually'"
3. "Glisse-dépose à nouveau — l'URL ne changera plus"

---

### Stack B — React + Vite → Vercel

**Prérequis : un compte GitHub avec le code dedans.**

Si le code n'est pas encore sur GitHub :
1. "Va sur [github.com](https://github.com) → 'New repository'"
2. "Donne-lui le même nom que ton projet, laisse tout par défaut"
3. "Copie les commandes affichées ('…or push an existing repository') et exécute-les dans le terminal"

Déploiement Vercel :
1. "Va sur [vercel.com](https://vercel.com) et connecte-toi avec GitHub"
2. "Clique sur 'Add New Project' → sélectionne ton repo"
3. "Vercel détecte Vite automatiquement — clique 'Deploy' sans rien changer"
4. "Ton site est en ligne sur une URL `*.vercel.app`"

**À chaque fois que tu modifies le code :**
```bash
git add .
git commit -m "feat: <description>"
git push
```
→ Vercel redéploie automatiquement.

---

### Stack C — Firebase → Firebase Hosting

**Prérequis : Firebase CLI installé et projet Firebase créé.**

Vérifier/installer Firebase CLI :
```bash
npm install -g firebase-tools
firebase login
```

Si pas encore initialisé dans le projet :
```bash
firebase init hosting
# → "Use an existing project" → sélectionner ton projet
# → "What do you want to use as your public directory?" → dist
# → "Configure as a single-page app?" → Yes
# → "Set up automatic builds with GitHub?" → Non pour l'instant
```

Déployer :
```bash
pnpm build
firebase deploy --only hosting
```

L'URL finale sera `https://<ton-projet>.web.app`

**⚠️ CHECKPOINT** : Confirmer l'URL de production avant de déployer

---

### Stack C — Supabase → Vercel + Supabase Cloud

**Le backend (Supabase) est déjà en ligne — seul le frontend doit être déployé.**

Si le code n'est pas encore sur GitHub → même procédure que Stack B.

Déploiement Vercel :
1. "Va sur [vercel.com](https://vercel.com) → 'Add New Project' → sélectionne ton repo"
2. "Avant de cliquer Deploy : va dans 'Environment Variables'"
3. "Ajoute tes deux variables :"
   - `VITE_SUPABASE_URL` → ton URL Supabase
   - `VITE_SUPABASE_ANON_KEY` → ta clé anon
4. "Clique 'Deploy'"

**⚠️ CHECKPOINT** : Vérifier que les variables d'env sont bien saisies avant de déployer

Après déploiement :
- "Va sur ton URL Vercel et teste la connexion / l'inscription"
- "Si ça ne fonctionne pas → vérifie dans Supabase que le domaine Vercel est autorisé : Authentication → URL Configuration → ajoute l'URL Vercel dans 'Site URL'"

---

### Stack D — Full Stack → Railway

> ⚠️ Mode avancé — cette étape déploie le frontend ET le backend ET la base de données.

**Option recommandée : Railway** (gratuit jusqu'à 5$/mois de ressources)

Prérequis : code sur GitHub.

1. "Va sur [railway.app](https://railway.app) et connecte-toi avec GitHub"
2. "Clique 'New Project' → 'Deploy from GitHub repo'"
3. "Railway détecte le monorepo — crée 3 services : api, web, postgres"
4. "Configure les variables d'environnement pour chaque service :"
   - Service `api` : `DATABASE_URL` (fournie par Railway automatiquement), `JWT_SECRET`, `JWT_REFRESH_SECRET`, `NODE_ENV=production`
   - Service `web` : `VITE_API_URL` = URL du service api Railway
5. "Lance les migrations : dans le terminal Railway du service api → `pnpm db:migrate`"

**⚠️ CHECKPOINT** : Vérifier chaque variable d'env avec l'utilisateur avant de déployer

Après déploiement :
- Tester l'URL du frontend
- Tester une action qui écrit en base de données
- Vérifier les logs Railway si erreur

---

## Étape 4 — Domaine personnalisé (si `--domain` ou si demandé)

**Vercel :**
1. Dans le projet Vercel → 'Settings' → 'Domains' → ajouter `mondomaine.com`
2. Vercel affiche 2 enregistrements DNS à copier
3. "Va chez ton registrar (OVH, Namecheap, etc.) → DNS → ajoute les deux enregistrements"
4. Propagation : 5 minutes à 48h

**Firebase Hosting :**
1. Console Firebase → Hosting → 'Add custom domain'
2. Même principe : copier les enregistrements DNS

**Railway :**
1. Service web → Settings → Networking → 'Add custom domain'
2. Copier l'enregistrement CNAME chez ton registrar

---

## Règles

- Ne jamais déployer sans avoir passé la checklist
- Ne jamais mettre de vraies clés dans le code — toujours via les variables d'environnement de la plateforme
- Si l'utilisateur n'a pas de compte sur la plateforme → le guider pour en créer un avant de continuer
- Stack D → toujours confirmer que l'utilisateur comprend que c'est plus complexe à maintenir
- Si un déploiement échoue → lire les logs, expliquer l'erreur en langage simple, proposer une correction
