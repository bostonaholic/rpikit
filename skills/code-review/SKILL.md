---
name: code-review
description: >-
  Code review methodology for evaluating implementation changes. Use when
  reviewing code changes for quality, design, correctness, and maintainability.
  Focuses on changes made during implementation using Conventional Comments
  for clear, actionable feedback.
---

# Code Review Methodology

Deep code reviews that protect architecture, catch correctness issues, and
provide mentoring-quality feedback using Conventional Comments.

## Purpose

This skill provides methodology for reviewing code changes introduced during
implementation. Unlike full codebase audits, this focuses on the delta - what
was added or modified - to catch quality issues before they're committed.

## Review Workflow

Follow this order - don't jump to nits.

### 1. Understand Context

- What problem is this solving?
- Is there a linked ticket/design doc?
- Read the implementation plan if available

### 2. Scan High Level

- Files/directories touched
- New public APIs or endpoints
- New dependencies
- Migrations and data changes
- **Size check:** 200-400 lines optimal, >1000 recommend splitting

### 3. Evaluate Correctness

- Does it solve the described problem?
- Edge cases and error conditions handled?
- Assumptions explicit?
- Race conditions considered?

### 4. Evaluate Design

- Aligns with existing architecture?
- New pattern where existing one would work?
- Local change or architecture decision in disguise?

**Pattern Recognition:**

| Smell | Pattern to Suggest |
|-------|-------------------|
| Long method | Compose Method |
| Type-based conditionals | Replace Conditional with Polymorphism |
| Duplicate algorithm structure | Form Template Method |
| Scattered null checks | Introduce Null Object |
| Type field drives behavior | Replace Type Code with State/Strategy |

Always name patterns explicitly.

**SOLID Quick Check:**

| Principle | Red Flag |
|-----------|----------|
| SRP | Class has multiple unrelated responsibilities |
| OCP | Must modify existing code to add behavior |
| LSP | Subclass changes expected behavior |
| ISP | Fat interface forces unused dependencies |
| DIP | High-level depends on low-level details |

### 5. Evaluate Tests

- Tests for critical paths and edge cases?
- Tests read like specifications?
- Stable, isolated, fast?

**Red Flags:**

- Testing private methods instead of behavior
- Heavy mocking of own components (indicates mixed concerns)
- Tests slower than necessary
- Missing edge case coverage

### 6. Evaluate Security (Lightweight)

Note obvious security concerns for security-reviewer to examine in depth:

- User input crossing trust boundaries?
- Authorization and privacy concerns?
- Secrets handling?

Defer detailed security analysis to the security-reviewer agent.

### 7. Evaluate Operability

- Logging, metrics, traces where needed?
- Clear error messages?
- Impact on alerts and SLOs?
- Failure modes understood?

### 8. Evaluate Maintainability

- Can a mid-level engineer understand this?
- Coupling and cohesion appropriate?
- Naming, structure, comments carry weight?
- Future changes considered?

### 9. Provide Feedback

- Use Conventional Comments syntax
- Classify blocking vs non-blocking
- Explain **why** each point matters
- Include at least one praise per review
- End with clear verdict

## Conventional Comments

```text
<label> [decorations]: <subject>
[discussion]
```

### Labels

| Label | Use For |
|-------|---------|
| `praise:` | Highlight positives (aim for 1+ per review) |
| `nitpick:` | Trivial preferences (non-blocking) |
| `suggestion:` | Propose improvement with what and why |
| `issue:` | Concrete problem (pair with suggestion) |
| `todo:` | Small necessary changes |
| `question:` | Need clarification |
| `thought:` | Non-blocking future ideas |
| `chore:` | Process tasks before acceptance |

### Decorations

- `(blocking)` - Must resolve before merge
- `(non-blocking)` - Helpful but not required
- `(security)`, `(performance)`, `(tests)`, `(readability)`, `(maintainability)`

### Examples

```text
[src/validation.ts:34]
**praise**: Clean extraction of validation logic improves readability.
```

```text
[api/users.py:127]
**issue (blocking)**: Missing null check before accessing user.email.
Add guard clause or use optional chaining.
```

```text
[handlers/payment.js:89-105]
**suggestion (non-blocking, readability)**: Nested conditionals hard to scan.
Consider early returns to flatten. Classic Compose Method pattern (Fowler).
```

```text
[core/processor.go:234]
**question**: Is this on the hot path? If so, consider allocation cost in loop.
```

## Principle-Based Review

Apply first principles and attribute by name for shared vocabulary:

```text
**issue (blocking, design)**: This mutates shared state. Following Rich Hickey's
immutability principle, return new value from pure function instead.
```

```text
**suggestion (non-blocking)**: Following Ousterhout's principle, pull this
complexity into the implementation. Simplify the interface.
```

```text
**issue (blocking)**: Subclass overrides parent method but changes expected behavior.
This violates Liskov Substitution - callers can't safely substitute implementations.
```

**Principles to apply:**

- **Rich Hickey**: Simple, immutable data structures; pure functions
- **John Carmack**: Direct implementation; avoid unnecessary abstraction
- **Joe Armstrong**: Isolate failures; rigorous error handling
- **Barbara Liskov**: Respect interface contracts; substitutability
- **John Ousterhout**: Deep modules with simple interfaces
- **Donald Knuth**: Readability and maintainability above cleverness

## Change Size Guidelines

| Lines | Action |
|-------|--------|
| < 200 | Full detailed review of every line |
| 200-400 | Full detailed review (optimal size) |
| 400-1000 | Focus on critical paths, security boundaries, architecture; suggest splitting |
| > 1000 | Architectural review only; strong recommendation to split |

For large changes:

```text
**suggestion (blocking)**: This change (1,450 lines) exceeds reviewable size.
Please split per atomic change principle (200-400 lines optimal).
Providing architectural review only until split.
```

## Report Format

```text
## Code Review: $ARGUMENTS

### Summary
[Brief overview of changes reviewed and overall assessment]

### Findings

[File location first, then Conventional Comment]

[file:line]
**<label> (<decorations>)**: <subject>
<discussion>

### Verdict
[APPROVE / APPROVE WITH NITS / REQUEST CHANGES]

### Rationale
[Brief explanation of verdict decision]
```

## Verdict Criteria

**APPROVE** - No blocking issues, code is ready

- Implementation may proceed to security review
- Note any minor items for awareness

**APPROVE WITH NITS** - Only non-blocking suggestions

- Implementation may proceed
- Suggestions are improvements, not blockers
- Author may address at their discretion

**REQUEST CHANGES** - Blocking issues present

- Should address issues before proceeding
- Provide specific remediation for each blocking issue
- User may choose to proceed anyway (soft gate)

## Integration with Implementation

When called from implementation phase:

1. Review all changes made during implementation
2. Reference the plan to understand intended behavior
3. Focus on quality implications of the changes
4. Report findings clearly with actionable recommendations
5. Soft-gate completion if blocking issues found (user can override)
6. Security concerns flagged here will be examined by security-reviewer next
