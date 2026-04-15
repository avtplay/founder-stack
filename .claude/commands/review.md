# /review — Pre-PR Code Review

Runs a structured code review on staged changes or a specific file/directory.

## Usage
```
/review                    # review git diff (staged)
/review src/api/auth/      # review specific directory
/review --security         # focus on security issues
/review --perf             # focus on performance
```

## Review Checklist

Claude will evaluate against:

**Correctness**
- [ ] Logic errors or off-by-one bugs
- [ ] Unhandled error paths
- [ ] Race conditions (async code)
- [ ] Missing null/undefined checks

**Code Quality**
- [ ] DRY violations (duplicated logic)
- [ ] Functions doing more than one thing
- [ ] Misleading variable/function names
- [ ] Dead code

**Security** (always runs, even without --security flag)
- [ ] Input validation present
- [ ] No secrets in code
- [ ] Auth checks on all protected routes

**Performance**
- [ ] N+1 query patterns
- [ ] Missing indexes (flag only)
- [ ] Unnecessary re-renders (React)

**Tests**
- [ ] New code has test coverage
- [ ] Edge cases covered

## Output Format
PASS / NEEDS CHANGES + list of findings by severity.
Critical = must fix. High = should fix. Medium = consider fixing.
