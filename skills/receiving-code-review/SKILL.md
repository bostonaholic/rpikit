---
name: receiving-code-review
description: >-
  Verification-first approach to code review feedback. Use when receiving
  review comments during the implement phase. Evaluate suggestions rigorously
  before implementing - no performative agreement.
---

# Receiving Code Review

Verify feedback before implementing. No performative agreement.

## Purpose

Code review feedback requires rigorous evaluation, not automatic acceptance.
Reviewers may lack context, make incorrect suggestions, or propose changes
that conflict with project requirements. This skill enforces verification
before implementation.

## The Iron Law

**Evaluate suggestions rigorously before implementing.**

Not all feedback is correct. Not all suggestions improve the code. Your job
is to verify, not to agree performatively.

## Prohibited Responses

Never respond with:

- "You're absolutely right!"
- "Great catch!"
- "Thanks for catching that!"
- "Of course, I should have seen that!"
- Any excessive praise or validation

These are performative, not technical. They waste time and signal you're not
actually evaluating the feedback.

## The Response Pattern

For each piece of feedback, complete these steps:

### Step 1: Read Completely

Read the entire feedback before reacting:

- Full comment, not just the first line
- Any linked context or references
- The specific code being discussed

### Step 2: Restate Requirements

Restate what the reviewer is asking for:

```text
"The feedback requests: [restatement in your own words]"
```

If you can't restate it clearly, you don't understand it.

### Step 3: Verify Against Codebase

Check whether the suggestion is correct for THIS codebase:

```text
Questions to answer:
- Is the reviewer's assumption about the code correct?
- Does this file/function work the way they think?
- Are there constraints they might not know about?
```

### Step 4: Assess Technical Soundness

Evaluate whether the suggestion is technically sound:

```text
Consider:
- Will this change break existing functionality?
- Does it align with project patterns?
- Is the suggested approach better than alternatives?
- What are the trade-offs?
```

### Step 5: Respond Appropriately

**If feedback is valid**: Implement it, then respond factually.

```text
"Fixed. [Brief description of what changed]"
"Implemented. Added null check at line 45."
"Done. Extracted helper function as suggested."
```

**If feedback needs clarification**: Ask specific questions.

```text
"Clarifying question: Does this apply when [specific case]?"
"Can you elaborate on [specific aspect]?"
```

**If feedback is incorrect**: Push back with technical reasoning.

```text
"Pushing back on this suggestion because [reason].
The current implementation handles [specific case] by [explanation].
The suggested change would break [specific behavior]."
```

## When to Push Back

Push back when:

- The suggestion breaks existing functionality
- The reviewer lacks context you have
- The suggestion violates project patterns
- The change conflicts with documented requirements
- The suggestion adds unnecessary complexity (YAGNI)
- The technical premise is incorrect

Push back format:

```text
"I'm pushing back on [specific suggestion] because:

1. [Technical reason]
2. [Evidence from codebase]

The current approach [explanation of why it's correct].

Alternative consideration: [if applicable]"
```

## Handling Ambiguity

When feedback is unclear:

```text
STOP - do not implement anything yet.

Ask for clarification:
"I want to make sure I understand correctly.
Are you suggesting [interpretation A] or [interpretation B]?"
```

**Never guess** at unclear feedback. Implementation based on misunderstanding
wastes time and may create cascading errors.

## Implementation Sequence

When implementing review feedback:

1. **Blocking issues first**
   - Test failures
   - Security vulnerabilities
   - Broken functionality

2. **Simple corrections next**
   - Syntax fixes
   - Import corrections
   - Typo fixes

3. **Complex refactoring last**
   - Architectural changes
   - Large rewrites
   - Pattern changes

**Test after each fix.** Do not batch changes.

## YAGNI Filter

Question suggestions that add unused features:

```text
Reviewer: "We should also handle case X"
Response: "Is case X currently needed? The existing usage only
requires [current scope]. Adding X introduces complexity for
a case we don't have yet (YAGNI).

If X becomes necessary, we can add it then."
```

## Handling External Reviewers

For reviewers outside the immediate team:

Before implementing, verify:

- [ ] The suggestion is technically correct for this codebase
- [ ] Implementation won't break functionality
- [ ] Reviewer's assumptions about the code are accurate
- [ ] Suggestion aligns with project patterns
- [ ] Reviewer has sufficient context

External reviewers may not know:

- Local conventions
- Historical decisions
- Constraints from other systems
- Recent changes not yet visible

## Integration with Implement Phase

This skill activates during code review cycles:

```text
Code review received
→ For each comment:
   → Read completely
   → Restate requirements
   → Verify against codebase
   → Assess technical soundness
   → Respond appropriately
→ Test after each implemented change
→ Request re-review when done
```

## Acknowledgment Format

When feedback is correct, use factual acknowledgments:

```text
Correct: "Fixed. Added validation at line 23."
Correct: "Implemented. Refactored to use existing helper."
Correct: "Done. Tests now cover edge case."

Incorrect: "Great catch! You're absolutely right!"
Incorrect: "Thanks so much for pointing that out!"
Incorrect: "I can't believe I missed that!"
```

Factual, not performative.

## Anti-Patterns

### Automatic Agreement

**Wrong**: Accept all feedback without evaluation
**Right**: Verify each suggestion before implementing

### Performative Responses

**Wrong**: "You're absolutely right!"
**Right**: "Fixed. [what changed]"

### Implementing Unclear Feedback

**Wrong**: Guess at what the reviewer meant
**Right**: Ask for clarification first

### Batching All Changes

**Wrong**: Implement all feedback, then test once
**Right**: Test after each change

### Never Pushing Back

**Wrong**: Implement everything to avoid conflict
**Right**: Push back when technically justified

### Pushing Back Without Reasoning

**Wrong**: "I disagree" (no explanation)
**Right**: "Pushing back because [technical reason]"

## Checklist for Each Feedback Item

- [ ] Read completely (not just first line)
- [ ] Restated in own words
- [ ] Verified against actual codebase
- [ ] Assessed technical soundness
- [ ] Responded factually (not performatively)
- [ ] Tested after implementation (if applicable)
