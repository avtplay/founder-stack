# AGENTS.md — HTML Mockup

## Stack
- **Frontend**: HTML5 + TailwindCSS (via CDN) + vanilla JavaScript
- **No build system** — no installation required
- **Database**: none (hardcoded data or localStorage if needed)

## Project structure
```
my-project/
├── index.html          ← main page
├── pages/              ← additional pages if needed
│   └── *.html
├── assets/
│   ├── images/
│   └── icons/
└── script.js           ← JS logic if needed
```

## Commands
```bash
# Preview: open index.html in Chrome/Firefox
# No pnpm, no npm, no build step

# Deploy in 30 seconds:
# → Go to netlify.com/drop and drag-drop the folder
```

## Rules for Claude
- Always include Tailwind via CDN in `<head>`: `<script src="https://cdn.tailwindcss.com"></script>`
- Use Tailwind classes, no custom CSS unless strictly necessary
- Simple, readable JavaScript — no frameworks, no imports
- Everything must work by opening the HTML file directly (no local server required)
- If the user asks for dynamic data → localStorage first, explain the limits
- Reusable components → JS functions that return HTML strings

## Limits of this stack
- No user accounts (everyone sees the same thing)
- Data lost if cache is cleared (if using localStorage)
- Not suited for more than ~10 pages

## Deployment
**Netlify Drop** (free, 30 seconds):
1. Go to netlify.com/drop
2. Drag and drop the project folder
3. Your site is live with a public URL

## Agent Checkpoints
Agents MUST pause and await confirmation before:
1. Committing and pushing to remote
2. Deleting files

## Do NOT
- Use npm/pnpm/node
- Add external dependencies (except Tailwind CDN)
- Hard-code sensitive data in the source
- Use JS frameworks or class-based patterns
