---
name: verification-before-completion
description: >-
  Evidence-before-claims discipline for implementation completion. Use before
  claiming any work is complete, fixed, or passing. Run verification commands
  and confirm output before making success claims.
---

# Verification Before Completion

Evidence before claims, always. No completion claims without fresh verification.

## Purpose

Claiming work is done without verification breaks trust and wastes time. This
skill enforces running verification commands and confirming output before any
success claim. "It should work" is not verification.

## The Iron Law

**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.**

Every claim must be backed by evidence you just observed. Not evidence from
earlier. Not evidence you expect. Evidence you just saw.

## The Five-Step Gate

Before any completion claim, complete these steps:

### Step 1: Identify

What command proves your claim?

```text
Claim: "Tests pass"
Command: npm test (or project's test command)

Claim: "Build succeeds"
Command: npm run build (or project's build command)

Claim: "Lint is clean"
Command: npm run lint (or project's lint command)

Claim: "Bug is fixed"
Command: The reproduction steps that previously failed
```

### Step 2: Run

Execute the command freshly. Not from cache. Not from memory.

```text
Run the command NOW.
Wait for it to complete.
Do not proceed until finished.
```

### Step 3: Read

Read the COMPLETE output.

```text
- Exit code (0 = success)
- All output lines, not just the last one
- Any warnings (not just errors)
- Summary statistics if provided
```

### Step 4: Verify

Confirm the output supports your claim.

```text
Claim: "Tests pass"
Verify: Exit code 0, "X tests passed", no failures

Claim: "Build succeeds"
Verify: Exit code 0, output files created, no errors

Claim: "Bug is fixed"
Verify: Previous failure no longer occurs
```

### Step 5: Claim

Only NOW make your completion claim.

```text
"Tests pass" - after seeing test output showing success
"Build succeeds" - after seeing build complete without errors
"Implementation complete" - after all verifications pass
```

## Common Failure Modes

### Tests

```text
What to run: Project test command
What to verify:
- Exit code 0
- All tests pass (not just "some tests ran")
- No skipped tests (unless intentional)
- No test warnings
```

### Linting

```text
What to run: Project lint command
What to verify:
- Exit code 0
- No errors
- No new warnings (compare to baseline)
```

### Builds

```text
What to run: Project build command
What to verify:
- Exit code 0
- Output artifacts created
- No compilation errors
- No type errors
```

### Bug Fixes

```text
What to run: Steps that reproduced the bug
What to verify:
- Bug no longer occurs
- Related functionality still works
- Regression test added and passes
```

### Delegated Work

```text
What to run: Independent verification of agent's claim
What to verify:
- Agent's claimed output exists
- Output is correct (not just present)
- No silent failures masked
```

## Rationalization Red Flags

| Thought | Reality |
|---------|---------|
| "It should pass" | Run it and see |
| "I'm confident it works" | Confidence isn't evidence |
| "I already ran it earlier" | Run it again, freshly |
| "The change was small" | Small changes can break things |
| "I'll verify later" | Verify now or don't claim |
| "The agent said it passed" | Verify agent's claims independently |
| "It worked on my machine" | Run it in the target environment |
| "I'm tired of running tests" | Fatigue doesn't excuse skipping verification |

## Integration with Implement Phase

This skill serves as the final gate before completion claims:

```text
Plan step complete? → Run step verification → Claim step done
Phase complete? → Run phase verification → Claim phase done
Implementation complete? → Run all verifications → Claim done
```

**Never mark a step complete without verification evidence.**

### Before Commits

```text
Run before committing:
1. All tests pass
2. Lint is clean
3. Build succeeds
4. Type check passes (if applicable)
```

### Before PRs

```text
Run before creating PR:
1. All verifications from "Before Commits"
2. Branch is up to date with base
3. No merge conflicts
4. CI would pass (simulate locally if possible)
```

### Before Claiming "Fixed"

```text
Run before claiming bug is fixed:
1. Reproduction steps no longer trigger bug
2. Regression test added and passes
3. Related functionality still works
4. All other tests still pass
```

## Verification Commands by Project Type

### Node.js / JavaScript

```text
Tests: npm test
Lint: npm run lint
Build: npm run build
Types: npm run typecheck (or tsc --noEmit)
```

### Python

```text
Tests: pytest
Lint: ruff check . or flake8
Types: mypy .
Format: ruff format --check . or black --check .
```

### Ruby

```text
Tests: bundle exec rspec
Lint: bundle exec rubocop
```

### Go

```text
Tests: go test ./...
Lint: golangci-lint run
Build: go build ./...
```

### Rust

```text
Tests: cargo test
Lint: cargo clippy
Build: cargo build
Format: cargo fmt --check
```

## Anti-Patterns

### Partial Verification

**Wrong**: Run only the test file you changed
**Right**: Run full test suite to catch regressions

### Cached Results

**Wrong**: Trust previous run results
**Right**: Run fresh each time before claiming

### Skipping on Confidence

**Wrong**: "I know this works, no need to verify"
**Right**: Verify anyway, confidence isn't evidence

### Trusting Agent Claims

**Wrong**: Agent said tests pass, so they pass
**Right**: Run tests yourself to verify

### Rushing at End

**Wrong**: Skip verification because you're almost done
**Right**: Final verification is most important

## Checklist Before Completion

- [ ] Identified verification command for the claim
- [ ] Ran command freshly (not cached)
- [ ] Read complete output
- [ ] Exit code confirms success
- [ ] Output matches expectations
- [ ] No warnings or errors ignored
- [ ] Evidence supports the specific claim being made
