# /start — Démarrer un nouveau projet

Point d'entrée universel. Pose les bonnes questions, choisit la stack adaptée, configure tout.

## Déclencheurs
- "je veux démarrer mon projet"
- "commencer un nouveau projet"
- "je veux créer une app / un site"
- `/start`

---

## Flux complet

### Étape 1 — L'idée

Utilise l'agent `mvp-advisor` pour :
1. Demander une description en 2-3 phrases
2. Produire une spec MVP (core loop, pages, données, ce qu'on coupe)

**⚠️ CHECKPOINT 1** : Présenter la spec → attendre "c'est bon" avant de continuer

---

### Étape 2 — Questions stack (une par une, dans l'ordre)

Pose chaque question séparément. Attends la réponse avant de passer à la suivante.
Arrête-toi dès que tu peux déterminer la stack.

---

**Q1 — Qui va l'utiliser ?**
> "Ton projet, c'est pour toi seul, ou d'autres personnes vont l'utiliser ?"

---

**Q2 — Maquette ou fonctionnel ?**
> "Tu veux juste montrer l'idée (comme une maquette visuelle), ou tu veux que ça fonctionne vraiment ?"

→ Si maquette : **Stack A** déterminée, passer à Q6 (git)

---

**Q3 — Comptes utilisateurs ?** *(seulement si fonctionnel)*
> "Les gens devront-ils créer un compte / se connecter pour utiliser ton app ?"

→ Si non ET usage perso : **Stack B** déterminée, passer à Q6 (git)
→ Si non ET autres utilisateurs : **Stack B** déterminée (déployable), passer à Q6

---

**Q4 — Logique complexe ?** *(seulement si comptes = oui)*
> "Est-ce que ton app doit gérer des choses comme des paiements, des calculs avancés, ou se connecter à d'autres services externes ?"

→ Si non : **Stack C** → poser Q5 (Firebase vs Supabase)
→ Si oui : **Stack D** (mode avancé) → passer à Q6

---

**Q5 — Firebase ou Supabase ?** *(seulement si Stack C)*
> "Pour gérer les comptes et stocker les données, deux options s'offrent à toi :
>
> - **Firebase** (par Google) — très facile à démarrer, tout est géré automatiquement, gratuit jusqu'à un certain usage. Idéal si tu veux aller vite.
> - **Supabase** — similaire à Firebase mais open source (pas dépendant de Google), base de données plus puissante, peut tourner sur ton ordi. Idéal si tu veux plus de contrôle.
>
> Tu as une préférence ? Sinon, je te recommande **Firebase** pour commencer."

---

**Q6 — Git ?** *(toujours poser cette question)*
> "Est-ce que tu connais Git ?
>
> C'est un outil qui sauvegarde l'historique complet de ton code — comme un 'Ctrl+Z' illimité dans le temps, et ça permet de collaborer avec d'autres développeurs plus tard.
>
> Tu veux l'utiliser ?"

Si l'utilisateur ne sait pas ce que c'est : expliquer en 1 phrase supplémentaire et laisser choisir. Ne pas insister si non.

---

### Étape 3 — Récapitulatif

Présente le résumé avant de lancer quoi que ce soit :

```
## Résumé de ton projet

**Nom** : <à demander si pas encore défini>
**Idée** : <spec en une phrase>

**Stack choisie** : <lettre> — <nom>
**Pourquoi** : <1 phrase en langage simple, sans jargon>

**Ce que ça veut dire concrètement** :
- <point 1>
- <point 2>
- <point 3>

**Git** : <oui / non>
```

**⚠️ CHECKPOINT 2** : Attendre confirmation ("c'est bon", "go", "oui") avant de lancer le setup

---

### Étape 4 — Setup

#### Si Stack C (Firebase ou Supabase) : guide externe d'abord

Avant de lancer le script, guide l'utilisateur étape par étape pour créer son projet sur le service choisi. Ne pas lancer le script tant que l'utilisateur n'a pas ses clés/credentials.

**Firebase :**
1. "Va sur [console.firebase.google.com](https://console.firebase.google.com)"
2. "Clique sur 'Créer un projet', donne-lui le même nom que ton projet"
3. "Désactive Google Analytics (pas nécessaire pour l'instant)"
4. "Dans le menu à gauche → 'Authentification' → 'Commencer' → active 'Email/Mot de passe'"
5. "Dans 'Firestore Database' → 'Créer une base de données' → mode test"
6. "Dans les paramètres du projet ⚙️ → 'Ajouter une app web' → copie les clés firebaseConfig"
7. "Donne-moi les clés, je les mets en place"

**Supabase :**
1. "Va sur [supabase.com](https://supabase.com) et crée un compte gratuit"
2. "Clique sur 'New project', donne-lui le même nom que ton projet"
3. "Note bien ton mot de passe de base de données"
4. "Dans 'Project Settings' → 'API' → copie l'URL et la clé 'anon public'"
5. "Donne-moi ces deux valeurs, je les mets en place"

#### Lancement du script

```bash
bash scripts/bootstrap-project.sh <nom-projet> --stack <a|b|c-firebase|c-supabase|d> [--git]
```

#### Après le script

- Indique les prochaines étapes concrètes selon la stack
- Propose de lancer `/spec` si pas encore fait, ou directement `/feature "<première feature>"`

---

## Règles

- Ne jamais sauter les checkpoints
- Ne jamais utiliser de jargon technique sans l'expliquer en même temps
- Si l'utilisateur répond "je ne sais pas" à une question technique → choisir l'option la plus simple et expliquer pourquoi
- Stack D = toujours signaler que c'est le mode avancé, demander confirmation explicite
