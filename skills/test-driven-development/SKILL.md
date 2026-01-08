---
name: test-driven-development
description: >-
  Rigorous TDD methodology enforcing RED-GREEN-REFACTOR discipline. Use when
  implementing features or fixing bugs during the implement phase. Tests must
  be written before production code - no exceptions.
---

# Test-Driven Development

Write tests first, then implementation. No production code without a failing
test.

## Purpose

TDD ensures code correctness through disciplined test-first development. Tests
written after implementation prove nothing - they pass immediately, providing
no evidence the code works correctly. This skill enforces the RED-GREEN-REFACTOR
cycle as a non-negotiable practice.

## The Iron Law

**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.**

If you write code before the test, you must delete it and start over. The test
drives the implementation, not the other way around.

## The Cycle

### RED: Write a Failing Test

Write ONE minimal test that demonstrates the required behavior:

1. Test the public interface, not internals
2. Use real code, not mocks (unless crossing boundaries)
3. Name the test to describe the behavior
4. Run the test - it MUST fail

**Mandatory verification:**

```text
Run the test. Confirm it fails for the RIGHT reason:
- Missing function/method (expected)
- Wrong return value (expected)
- NOT: Syntax error
- NOT: Import error
- NOT: Test framework misconfiguration
```

If the test passes immediately, you've written it wrong or the feature already
exists. Investigate before proceeding.

### GREEN: Write Minimal Code

Write the SIMPLEST code that makes the test pass:

1. No extra features
2. No premature optimization
3. No "while I'm here" additions
4. Just enough to satisfy the test

**Mandatory verification:**

```text
Run the test. Confirm:
- The new test passes
- All other tests still pass
- No new warnings or errors
```

### REFACTOR: Improve Without Breaking

Improve code quality while keeping tests green:

1. Remove duplication
2. Improve names
3. Extract helpers
4. Simplify logic

**After each change:**

```text
Run all tests. They must still pass.
If any test fails, revert the refactor.
```

## Cycle Example

```text
Requirement: Function that validates email addresses

RED:
  Write test: expect(isValidEmail("user@example.com")).toBe(true)
  Run test: FAIL - isValidEmail is not defined
  Correct failure reason: function doesn't exist yet

GREEN:
  Write: function isValidEmail(email) { return true; }
  Run test: PASS
  All tests pass

RED:
  Write test: expect(isValidEmail("invalid")).toBe(false)
  Run test: FAIL - Expected false, got true
  Correct failure reason: no validation logic yet

GREEN:
  Write: function isValidEmail(email) { return email.includes("@"); }
  Run test: PASS
  All tests pass

REFACTOR:
  Extract regex pattern to constant
  Run tests: PASS
  Continue improving...
```

## Common Rationalizations (Reject All)

| Rationalization | Reality |
|-----------------|---------|
| "I'll write tests after" | Tests written after pass immediately, proving nothing |
| "This is too simple to test" | Simple things become complex. Test it. |
| "I know this works" | Prove it with a test |
| "Testing slows me down" | Debugging untested code takes longer |
| "I'll just try it manually" | Manual testing isn't repeatable or systematic |
| "The code is obvious" | Make it obviously correct with a test |
| "I already wrote the code" | Delete it. Start with the test. |

## Integration with Implement Phase

When executing plan steps that involve code:

1. **Before coding**: Write failing test for the behavior
2. **Verify RED**: Test fails for the right reason
3. **Write code**: Minimal implementation
4. **Verify GREEN**: Test passes, no regressions
5. **Refactor**: Improve while green
6. **Mark complete**: Only after tests pass

If a plan step doesn't mention tests, add them anyway. TDD is not optional.

## Test Quality Guidelines

### Good Tests

- Describe behavior, not implementation
- Fail for one reason only
- Run fast (milliseconds)
- Don't depend on external state
- Read like specifications

### Bad Tests

- Test private methods directly
- Require specific execution order
- Mock everything (indicates bad design)
- Pass without verifying anything meaningful
- Break when refactoring internals

## Edge Cases and Boundaries

Test these explicitly:

- Empty inputs
- Null/undefined values
- Boundary values (0, -1, MAX_INT)
- Invalid inputs
- Error conditions
- Concurrent access (if applicable)

## Anti-Patterns

### Writing Code First

**Wrong**: Write feature, then write tests to cover it
**Right**: Write test, watch it fail, then write feature

### Testing After the Fact

**Wrong**: "I'll add tests in a follow-up PR"
**Right**: Tests are part of the implementation, not separate

### Skipping RED Verification

**Wrong**: Assume test will fail, write code immediately
**Right**: Run test, observe failure, understand why

### Over-Mocking

**Wrong**: Mock every dependency to "isolate" the unit
**Right**: Mock only at boundaries (external services, databases)

### Testing Implementation Details

**Wrong**: Test that internal method X calls internal method Y
**Right**: Test that public interface produces correct results

## Verification Checklist

Before marking a step complete:

- [ ] Test was written BEFORE production code
- [ ] Test failed for the correct reason (not syntax/import errors)
- [ ] Implementation is minimal (no extra features)
- [ ] All tests pass (new and existing)
- [ ] Code was refactored while green
- [ ] No untested production code was added
