---
description: Deep codebase exploration before planning or implementation
argument-hint: [topic]
allowed-tools: Read, Glob, Grep, Task, TodoWrite, AskUserQuestion, Write
---

# Research Phase

Research topic: **$ARGUMENTS**

## STOP - READ THIS FIRST

**YOUR FIRST ACTION MUST BE: Use AskUserQuestion to ask Question 1 below.**

Do NOT:

- Read any files
- Search the codebase
- Use Glob or Grep
- Explore anything
- Make assumptions about what the user wants

You MUST ask clarifying questions FIRST. The topic "$ARGUMENTS" is NOT
enough information to begin research. Even if it seems clear, ASK ANYWAY.

## Phase 1: Interrogation (MANDATORY)

Ask these questions ONE AT A TIME using AskUserQuestion. Wait for each
answer before asking the next question.

### Question 1 - ASK THIS NOW

Use AskUserQuestion immediately with:

- **Header**: "Goal"
- **Question**: "Which best describes what you're trying to accomplish?"
- **Options**:
  - "Build something new" (description: "Add new functionality")
  - "Change existing behavior" (description: "Modify how something works")
  - "Fix something broken" (description: "Resolve a bug or issue")
  - "Understand how it works" (description: "Learn about implementation")

**STOP HERE. Do not continue until the user answers.**

### Question 2 - After Q1 is answered

Based on their Q1 answer, use AskUserQuestion:

If "Build something new":

- **Header**: "Feature"
- **Question**: "What should this new feature do?"
- **Options**: Let user type (no predefined options needed)

If "Change existing behavior":

- **Header**: "Change"
- **Question**: "What should be different from current behavior?"
- **Options**: Let user type

If "Fix something broken":

- **Header**: "Problem"
- **Question**: "What's happening that shouldn't be?"
- **Options**: Let user type

If "Understand how it works":

- **Header**: "Aspect"
- **Question**: "What specific aspect is unclear?"
- **Options**: Let user type

**STOP. Wait for answer.**

### Question 3 - After Q2 is answered

Use AskUserQuestion:

- **Header**: "Scope"
- **Question**: "How big do you expect this change to be?"
- **Options**:
  - "Small" (description: "One file, isolated change")
  - "Medium" (description: "Multiple related files")
  - "Large" (description: "Architectural, touches many areas")
  - "Unknown" (description: "Need to explore to find out")

**STOP. Wait for answer.**

### Question 4 - After Q3 is answered

Use AskUserQuestion with multiSelect: true:

- **Header**: "Constraints"
- **Question**: "Are there constraints I should know about?"
- **multiSelect**: true
- **Options**:
  - "Performance" (description: "Speed/efficiency requirements")
  - "Compatibility" (description: "Must work with existing systems")
  - "Security" (description: "Security considerations apply")
  - "Timeline" (description: "Time pressure exists")

**STOP. Wait for answer.**

### Question 5 - After Q4 is answered

Use AskUserQuestion:

- **Header**: "Context"
- **Question**: "Have you already identified relevant code or tried anything?"
- **Options**:
  - "Yes, I know where to look" (description: "I'll share specific files")
  - "I have some ideas" (description: "I have hunches to share")
  - "No, starting fresh" (description: "No prior investigation")

If they answer "Yes" or "I have some ideas", ask them to share before
proceeding.

**STOP. Wait for answer.**

### Question 6 - After Q5 is answered

Summarize what you learned, then use AskUserQuestion:

```text
Let me confirm I understand:

- Goal: [from Q1]
- Specifics: [from Q2]
- Scope: [from Q3]
- Constraints: [from Q4]
- Prior context: [from Q5]
```

- **Header**: "Confirm"
- **Question**: "Is this understanding accurate?"
- **Options**:
  - "Yes, proceed" (description: "Begin codebase exploration")
  - "Let me clarify" (description: "I need to correct something")

If "Let me clarify", ask what needs adjustment before proceeding.

**STOP. Do not explore code until user confirms "Yes, proceed".**

## Phase 2: Exploration (ONLY after Phase 1 complete)

You may ONLY reach this phase after:

1. All 6 questions have been asked
2. User has confirmed understanding with "Yes, proceed"

If you have not done both, GO BACK TO PHASE 1.

### Now explore the codebase

Use TodoWrite to track exploration based on interrogation answers.

**Map relevant territory:**

- Identify directories related to their stated goal
- Find entry points and key files
- Note patterns and conventions

**Trace relevant data flow:**

- Follow data through areas relevant to their goal
- Identify inputs, transformations, outputs
- Document state changes and side effects

**Find existing patterns:**

- Search for analogous implementations
- Note reusable utilities and helpers
- Document conventions for testing and error handling

**Identify technical constraints:**

- External dependencies
- Performance considerations
- Security implications

### Validate findings with user

After exploring, use AskUserQuestion:

- **Header**: "Validate"
- **Question**: "I found [brief summary]. Does this align with expectations?"
- **Options**:
  - "Yes, looks right" (description: "Proceed to documentation")
  - "Look elsewhere" (description: "I'll redirect you")
  - "Need more detail" (description: "Dig deeper in current area")

## Phase 3: Document Findings

Create research document at: `docs/plans/research/<topic>.md`

```markdown
# Research: <Topic>

## Problem Statement

[Based on interrogation - what the user wants to accomplish]

## User Requirements

- **Goal**: [from Q1]
- **Specifics**: [from Q2]
- **Scope**: [from Q3]
- **Constraints**: [from Q4]
- **Prior context**: [from Q5]

## Findings

### Relevant Files

| File            | Purpose     | Key Lines |
| --------------- | ----------- | --------- |
| path/to/file.ts | Description | 42-87     |

### Existing Patterns

[Patterns discovered that inform implementation]

### Dependencies

[External and internal dependencies]

### Technical Constraints

[Limitations discovered during exploration]

## Open Questions

[Questions that remain unanswered]

## Recommendations

[Initial thoughts on approach]
```

## Phase 4: Transition to Planning

Use AskUserQuestion:

- **Header**: "Next step"
- **Question**: "Research complete. What would you like to do?"
- **Options**:
  - "Create implementation plan" (description: "Proceed to /rpikit:plan")
  - "Continue researching" (description: "Gather more context")
  - "Done for now" (description: "End research phase")

## Checklist

- [ ] Question 1 asked and answered
- [ ] Question 2 asked and answered
- [ ] Question 3 asked and answered
- [ ] Question 4 asked and answered
- [ ] Question 5 asked and answered
- [ ] Question 6 asked and user confirmed
- [ ] Exploration completed
- [ ] Findings validated with user
- [ ] Research document created
