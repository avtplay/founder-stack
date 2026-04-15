# /feature — Full Feature Workflow

Scaffolds a complete feature from spec to PR-ready code with autonomous checkpoints.

## Usage
```
/feature "user authentication with JWT"
/feature "product listing page" --type frontend
/feature "payment webhook handler" --type api
```

## Workflow (Autonomous with Checkpoints)

### Phase 1 — Spec (no code yet)
1. Analyze the request
2. List files to create/modify
3. Define API contract (if applicable)
4. Identify risks or dependencies

**⚠️ CHECKPOINT 1**: Present spec → await "proceed" before writing code

### Phase 2 — Implementation
5. Write types/interfaces first (`/packages/types`)
6. Backend: routes → service layer → DB queries
7. Frontend: components → hooks → API integration
8. Use subagents where appropriate:
   - `security-reviewer` for auth/payment code
   - `db-architect` for schema changes
   - `frontend-specialist` for complex UI

**⚠️ CHECKPOINT 2**: Present diff summary → await "looks good" before tests

### Phase 3 — Tests + Finalize
9. Use `test-writer` subagent for test coverage
10. Run `pnpm test` and `pnpm lint`
11. Generate conventional commit message

**⚠️ CHECKPOINT 3**: Show commit message → await confirmation before `git commit`

## Rules
- Never skip checkpoints even if user seems in a hurry
- If blocked: explain clearly, propose options, wait
