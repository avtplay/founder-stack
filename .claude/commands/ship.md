# /ship — Deploy to production

Guides the project deployment step by step, based on the stack in use.

## Usage
```
/ship                   # full guided deployment
/ship --check           # pre-deployment checklist only
/ship --domain          # configure a custom domain after deployment
```

---

## Step 1 — Stack detection

Read `AGENTS.md` to identify the project's stack.

| What you find in AGENTS.md | Stack |
|----------------------------|-------|
| "HTML5 + TailwindCSS (CDN)" | A — HTML mockup |
| "React 18 + TypeScript + Vite" without Firebase/Supabase | B — React |
| "Firebase" | C — Firebase |
| "Supabase" | C — Supabase |
| "Node.js + Fastify" | D — Full Stack |

---

## Step 2 — Pre-deployment checklist

Check these points **before** deploying. Block if a critical item fails.

**All stacks:**
- [ ] No API keys, passwords, or secrets in source code (check `.env.local` is not committed)
- [ ] Project displays correctly in local

**Stack B, C, D only:**
- [ ] `pnpm build` passes without errors
- [ ] No TypeScript errors (`pnpm lint`)

**Stack C (Firebase/Supabase):**
- [ ] `.env.local` filled with real keys (not example values)
- [ ] Auth works locally
- [ ] Data displays correctly locally

**Stack D:**
- [ ] DB migrations are up to date
- [ ] Production environment variables are ready

**⚠️ CHECKPOINT**: Present checklist results → wait for "go" before continuing

If any item fails → fix it with the user before continuing. Never deploy a broken project.

---

## Step 3 — Deployment by stack

---

### Stack A — HTML mockup → Netlify Drop

**No account required for a quick deployment.**

1. "Open [netlify.com/drop](https://netlify.com/drop) in your browser"
2. "Drag and drop **the entire project folder** onto the upload zone"
3. "Netlify generates a public URL in 30 seconds — copy it"

✅ That's it. Your site is live.

**If you want a permanent URL (same link every time):**
1. "Create a free account at netlify.com"
2. "In your dashboard → 'Add new site' → 'Deploy manually'"
3. "Drag and drop again — the URL will never change"

---

### Stack B — React + Vite → Vercel

**Prerequisite: a GitHub account with your code pushed to it.**

If the code is not on GitHub yet:
1. "Go to [github.com](https://github.com) → 'New repository'"
2. "Give it the same name as your project, leave everything as default"
3. "Copy the commands shown ('…or push an existing repository') and run them in the terminal"

Vercel deployment:
1. "Go to [vercel.com](https://vercel.com) and sign in with GitHub"
2. "Click 'Add New Project' → select your repo"
3. "Vercel detects Vite automatically — click 'Deploy' without changing anything"
4. "Your site is live at a `*.vercel.app` URL"

**Every time you update the code:**
```bash
git add .
git commit -m "feat: <description>"
git push
```
→ Vercel redeploys automatically.

---

### Stack C — Firebase → Firebase Hosting

**Prerequisite: Firebase CLI installed and Firebase project created.**

Check/install Firebase CLI:
```bash
npm install -g firebase-tools
firebase login
```

If not yet initialized in the project:
```bash
firebase init hosting
# → "Use an existing project" → select your project
# → "What do you want to use as your public directory?" → dist
# → "Configure as a single-page app?" → Yes
# → "Set up automatic builds with GitHub?" → No for now
```

Deploy:
```bash
pnpm build
firebase deploy --only hosting
```

Final URL: `https://<your-project>.web.app`

**⚠️ CHECKPOINT**: Confirm the production URL before deploying

---

### Stack C — Supabase → Vercel + Supabase Cloud

**The backend (Supabase) is already online — only the frontend needs to be deployed.**

If the code is not on GitHub yet → same procedure as Stack B.

Vercel deployment:
1. "Go to [vercel.com](https://vercel.com) → 'Add New Project' → select your repo"
2. "Before clicking Deploy: go to 'Environment Variables'"
3. "Add your two variables:"
   - `VITE_SUPABASE_URL` → your Supabase URL
   - `VITE_SUPABASE_ANON_KEY` → your anon key
4. "Click 'Deploy'"

**⚠️ CHECKPOINT**: Verify env variables are entered correctly before deploying

After deployment:
- "Go to your Vercel URL and test login / sign up"
- "If it doesn't work → check in Supabase that the Vercel domain is allowed: Authentication → URL Configuration → add the Vercel URL to 'Site URL'"

---

### Stack D — Full Stack → Railway

> ⚠️ Advanced mode — this step deploys the frontend, backend, AND database.

**Recommended option: Railway** (free up to ~$5/month of resources)

Prerequisite: code on GitHub.

1. "Go to [railway.app](https://railway.app) and sign in with GitHub"
2. "Click 'New Project' → 'Deploy from GitHub repo'"
3. "Railway detects the monorepo — create 3 services: api, web, postgres"
4. "Configure environment variables for each service:"
   - `api` service: `DATABASE_URL` (provided by Railway automatically), `JWT_SECRET`, `JWT_REFRESH_SECRET`, `NODE_ENV=production`
   - `web` service: `VITE_API_URL` = Railway api service URL
5. "Run migrations: in the Railway terminal of the api service → `pnpm db:migrate`"

**⚠️ CHECKPOINT**: Review each env variable with the user before deploying

After deployment:
- Test the frontend URL
- Test an action that writes to the database
- Check Railway logs if there's an error

---

## Step 4 — Custom domain (if `--domain` or if requested)

**Vercel:**
1. Project → 'Settings' → 'Domains' → add `yourdomain.com`
2. Vercel shows 2 DNS records to copy
3. "Go to your registrar (OVH, Namecheap, etc.) → DNS → add both records"
4. Propagation: 5 minutes to 48h

**Firebase Hosting:**
1. Firebase Console → Hosting → 'Add custom domain'
2. Same principle: copy DNS records to your registrar

**Railway:**
1. Web service → Settings → Networking → 'Add custom domain'
2. Copy the CNAME record to your registrar

---

## Rules

- Never deploy without passing the checklist
- Never put real keys in the code — always use the platform's environment variables
- If the user doesn't have an account on the platform → guide them through creating one before continuing
- Stack D → always confirm the user understands it's more complex to maintain
- If a deployment fails → read the logs, explain the error in plain language, suggest a fix
