---
name: systematic-debugging
description: >-
  Root cause investigation methodology for bugs and failures. Use when
  encountering test failures, unexpected behavior, or errors during research
  or implement phases. Find the cause before attempting fixes.
---

# Systematic Debugging

Find the root cause before attempting fixes. Symptom fixes are failure.

## Purpose

Debugging without methodology wastes time and creates new bugs. Random fixes
address symptoms, not causes. This skill enforces systematic investigation
to find root causes before any fix is attempted.

## The Iron Law

**ALWAYS find root cause before attempting fixes.**

Quick patches mask underlying issues. If you're trying fixes without
understanding why they might work, you're guessing - stop and investigate.

## The Four Phases

Complete each phase in order. Do not skip to implementation.

### Phase 1: Root Cause Investigation

**Understand what's happening before theorizing why.**

1. **Read the error carefully**
   - Full error message, not just the first line
   - Stack trace - where did it originate?
   - Error codes or types

2. **Reproduce consistently**
   - Can you trigger the failure reliably?
   - What are the exact steps?
   - Does it fail the same way every time?

3. **Review recent changes**
   - What changed since it last worked?
   - Check git log for recent commits
   - Any new dependencies or configuration?

4. **Gather diagnostic evidence**
   - Add logging at key points
   - Check system state (memory, disk, network)
   - Inspect input data

5. **Trace backwards**
   - Start from the error
   - Work backwards through the call stack
   - Find where correct behavior diverges

### Phase 2: Pattern Analysis

**Compare against working code.**

1. **Find similar working code**
   - How does a working version do this?
   - What's different about this case?

2. **Compare against references**
   - Documentation examples
   - Library/framework conventions
   - Previous implementations

3. **Identify the difference**
   - What's unique about the failing case?
   - What assumption is being violated?

4. **Understand dependencies**
   - What does this code depend on?
   - Could a dependency have changed?
   - Are versions correct?

### Phase 3: Hypothesis and Testing

**Scientific method for debugging.**

1. **Form a single hypothesis**
   - "The error occurs because X"
   - Be specific and testable
   - Only one hypothesis at a time

2. **Design a test**
   - How would you prove/disprove this hypothesis?
   - What would you expect to see if correct?
   - What would you expect to see if wrong?

3. **Make minimal changes**
   - Change ONE thing to test the hypothesis
   - Don't bundle multiple changes
   - Keep changes reversible

4. **Observe results**
   - Did the change affect the behavior?
   - Does it match your prediction?
   - Record what happened

5. **Iterate or proceed**
   - Hypothesis confirmed: proceed to Phase 4
   - Hypothesis rejected: form new hypothesis, repeat Phase 3

### Phase 4: Implementation

**Fix only after understanding.**

1. **Write a failing test**
   - Capture the bug in a test
   - Test should fail before fix
   - Test should pass after fix

2. **Implement single fix**
   - Address the root cause
   - Not symptoms or side effects
   - Minimal change required

3. **Verify the fix**
   - Original test passes
   - All other tests pass
   - Manual verification if applicable

4. **Check for related issues**
   - Could this bug exist elsewhere?
   - Should you search for similar patterns?

## Red Flags: You're Skipping Investigation

| Thought | Reality |
|---------|---------|
| "Let me try this quick fix" | You don't understand the cause |
| "I'll just restart the service" | Masking the symptom |
| "Maybe if I add a null check here" | Guessing, not debugging |
| "Let me try a few things" | Random changes waste time |
| "This usually fixes it" | Past fixes don't explain current bugs |
| "I don't have time to investigate" | You don't have time NOT to |

## Integration with RPI Workflow

### During Research Phase

When investigating an issue:

1. Use this skill to understand the problem
2. Document root cause in research findings
3. Root cause informs the implementation plan

### During Implement Phase

When a step fails verification:

1. Stop the step (do not proceed)
2. Apply this debugging methodology
3. Find root cause before attempting fixes
4. Update plan if fix requires changes
5. Resume implementation after fix verified

## Escalation: When to Question Architecture

If you've attempted three or more fixes and the problem persists:

**Stop fixing. Question the architecture.**

- Is the design fundamentally flawed?
- Are we fighting the framework?
- Should this be reimplemented differently?

Use AskUserQuestion to discuss architectural concerns before continuing.

## Evidence Gathering Techniques

### Logging

```text
Add temporary logging:
- Entry/exit of functions
- Variable values at key points
- Timestamps for timing issues
- Request/response payloads
```

### Bisection

```text
When did it break?
- git bisect to find breaking commit
- Binary search through code changes
- Narrow down to specific change
```

### Isolation

```text
Simplify to reproduce:
- Remove unrelated code
- Use minimal test case
- Eliminate variables
```

### Comparison

```text
What's different?
- Working vs broken environment
- Working vs broken input
- Working vs broken configuration
```

## Anti-Patterns

### Shotgun Debugging

**Wrong**: Try random changes hoping one works
**Right**: Form hypothesis, test it, iterate

### Fix and Pray

**Wrong**: Apply fix, hope it works, move on
**Right**: Verify fix addresses root cause

### Debugging by Deletion

**Wrong**: Remove code until error goes away
**Right**: Understand why code causes error

### Copy-Paste Fixes

**Wrong**: Find similar fix online, apply blindly
**Right**: Understand why the fix works for your case

### Skipping to Phase 4

**Wrong**: "I think I know the fix, let me just try it"
**Right**: Complete investigation phases first

## Checklist Before Fixing

- [ ] Error message read completely
- [ ] Failure reproduced consistently
- [ ] Recent changes reviewed
- [ ] Diagnostic evidence gathered
- [ ] Root cause identified (not just symptoms)
- [ ] Hypothesis formed and tested
- [ ] Fix addresses root cause
- [ ] Failing test written before fix
