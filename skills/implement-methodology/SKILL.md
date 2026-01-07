---
name: implement-methodology
description: >-
  This skill should be used when the user asks to "implement the plan",
  "execute the plan", "start implementation", "build the feature",
  "make the changes", or invokes the rpi:implement command. Provides
  methodology for disciplined execution with checkpoint validation and
  progress tracking.
---

# Implement Methodology

## Purpose

Implementation executes an approved plan with discipline and verification.
The goal is not just working code, but verified, documented progress that
matches the plan. Implementation follows the plan strictly, verifying each
step before proceeding.

## Core Principles

### Follow the Plan

The plan is the contract. Deviations require explicit approval:

- Execute steps in order
- Use specified files and approaches
- Meet verification criteria before proceeding
- Document any necessary deviations

### Verify Before Claiming Done

Never claim completion without evidence:

- Run the verification for each step
- Confirm tests pass
- Check that changes match expectations
- Document verification results

### Track Progress Visibly

Use TodoWrite to show real-time progress:

- Create todos from plan steps
- Mark in_progress when starting
- Mark completed only after verification
- Update plan document with status

### Checkpoint Validation

After each phase or significant step:

- Review what was done
- Verify it matches the plan
- Confirm no regressions
- Get human confirmation before continuing

## Stakes-Based Enforcement

Implementation enforcement depends on stakes classification:

### High Stakes

**Behavior**: Refuse to implement without approved plan

```text
Cannot proceed. High-stakes changes require an approved plan.

Use rpi:plan to create and approve an implementation plan first.
```

High-stakes characteristics:

- Architectural changes
- Security-sensitive code
- Hard to rollback
- Wide impact across codebase

### Medium Stakes

**Behavior**: Strong warning, require confirmation

```text
Warning: No approved plan found for this implementation.

Medium-stakes changes benefit from planning. Proceed anyway?
- Create a plan first (recommended)
- Proceed with caution
- Cancel
```

Medium-stakes characteristics:

- Multiple file changes
- Moderate impact
- Testable but non-trivial

### Low Stakes

**Behavior**: Proceed with reminder

```text
Note: Consider using rpi:research and rpi:plan for better results.
Proceeding with implementation...
```

Low-stakes characteristics:

- Isolated changes
- Easy rollback
- Minimal impact
- Quick fixes

## Implementation Process

### 1. Verify Prerequisites

Before starting implementation:

- [ ] Plan exists at `docs/plans/<name>.md`
- [ ] Plan is marked approved
- [ ] Research document is available (if referenced)
- [ ] Stakes level is understood
- [ ] Development environment is ready

### 2. Initialize Progress Tracking

Convert plan steps to TodoWrite todos:

```text
Creating todos from plan...
- [ ] Step 1.1: Add validation function
- [ ] Step 1.2: Update API endpoint
- [ ] Step 2.1: Add tests
...
```

### 3. Execute Steps in Order

For each step:

1. **Mark in_progress** in TodoWrite
2. **Read target files** before modifying
3. **Make the change** as specified
4. **Run verification** as defined in plan
5. **Mark completed** only if verification passes
6. **Update plan document** with status

### 4. Checkpoint After Phases

After completing a phase:

- Summarize what was done
- Report verification results
- Ask for confirmation to continue

```text
Phase 1 complete:
- Step 1.1: ✓ Validation function added
- Step 1.2: ✓ API endpoint updated

All verifications passed. Continue to Phase 2?
```

### 5. Handle Failures

When verification fails:

1. **Stop** - do not proceed to next step
2. **Diagnose** - understand why it failed
3. **Fix** - address the issue
4. **Re-verify** - run verification again
5. **Document** - note what happened

If the fix requires plan changes:

```text
Verification failed for Step 1.2.

The planned approach doesn't work because [reason].
Proposed adjustment: [new approach]

Approve this change to the plan?
```

### 6. Complete Implementation

When all steps are done:

- [ ] All todos marked complete
- [ ] All verifications passed
- [ ] Plan document updated with completion status
- [ ] Summary provided to user

## Verification Techniques

### Code Verification

For code changes, verify by:

- **Syntax check**: Code compiles/parses without errors
- **Type check**: TypeScript/type annotations pass
- **Lint check**: No new linting errors
- **Unit tests**: Related tests pass

### Behavior Verification

For functionality, verify by:

- **Manual test**: Exercise the feature
- **Integration test**: Run relevant integration tests
- **API test**: Hit endpoints and verify responses
- **UI check**: Visual verification if applicable

### Regression Verification

Ensure no breakage:

- **Full test suite**: Run all tests
- **Build**: Project builds successfully
- **Smoke test**: Core functionality works

## Progress Documentation

### TodoWrite Updates

Maintain real-time progress:

```text
[completed] Step 1.1: Add validation function
[in_progress] Step 1.2: Update API endpoint
[pending] Step 2.1: Add tests
```

### Plan Document Updates

Update the plan file as implementation progresses:

```markdown
## Implementation Steps

### Phase 1: Core Changes

#### Step 1.1: Add validation function

- **Status**: ✓ Complete
- **Verified**: Unit tests pass
- **Notes**: Used existing regex pattern

#### Step 1.2: Update API endpoint

- **Status**: In Progress
```

## Test-Driven Implementation

When plan includes tests, follow TDD:

### Red-Green-Refactor

1. **Red**: Write failing test first
2. **Green**: Write minimal code to pass
3. **Refactor**: Improve without breaking tests

### Test-First Benefits

- Verification criteria are executable
- Progress is measurable
- Regressions caught immediately
- Design emerges from usage

## Error Handling

### Compilation Errors

```text
Step failed: Compilation error in src/utils/validation.ts

Error: Property 'email' does not exist on type 'User'

Diagnosing...
```

Fix the error before marking step complete.

### Test Failures

```text
Step verification failed: 2 tests failing

FAIL src/utils/validation.test.ts
  ✗ validates email format
  ✗ rejects invalid email

Investigating failures...
```

Do not proceed until tests pass.

### Unexpected Behavior

```text
Step verification unclear: API returns 200 but response body unexpected

Expected: { success: true, user: {...} }
Actual: { success: true }

Investigating discrepancy...
```

Verify against plan requirements.

## Transition to Completion

Implementation is complete when:

- All plan steps marked done
- All verifications passed
- Plan document updated
- No pending todos

Final summary:

```text
Implementation complete.

Summary:
- 8 steps completed
- All verifications passed
- Files changed: 5
- Tests added: 3

Plan: docs/plans/add-email-validation.md (marked complete)
```

## Anti-Patterns to Avoid

### Skipping Verification

**Wrong**: Marking done without running verification
**Right**: Always run verification, document results

### Proceeding After Failure

**Wrong**: Moving to next step when current step failed
**Right**: Stop, diagnose, fix, re-verify

### Deviating Silently

**Wrong**: Changing approach without updating plan
**Right**: Request approval for plan changes

### Batch Completion

**Wrong**: Marking multiple steps done at once
**Right**: Mark complete immediately after each verification

### Ignoring Stakes

**Wrong**: Rushing high-stakes changes
**Right**: Respect enforcement based on stakes level

## Integration with Claude Features

### Use TodoWrite Extensively

Convert every plan step to a todo. Update status in real-time.

### Use AskUserQuestion for Checkpoints

After phases, confirm with user before continuing.

### Use Read Before Edit

Always read files before modifying them.

### Use Bash for Verification

Run tests, builds, and checks via Bash tool.

### Reference Plan Document

Keep the plan document open and update it throughout.

## Additional Resources

Implementation progress tracked in:

- `docs/plans/<name>.md` - Plan document with status updates
- TodoWrite - Real-time progress visibility
