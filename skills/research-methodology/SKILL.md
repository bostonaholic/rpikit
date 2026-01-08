---
name: research-methodology
description: >-
  This skill should be used when the user asks to "research the codebase",
  "understand how X works", "explore the code", "gather context",
  "investigate the implementation", "analyze the architecture", or invokes
  the rpikit:research command. Provides methodology for thorough interrogation
  and codebase exploration before planning or implementation.
---

# Research Methodology

## Purpose

Research is the foundation of disciplined software engineering. Before
exploring code or planning changes, develop deep understanding of what the
user actually needs through systematic questioning. Only after sufficient
understanding should codebase exploration begin.

## The Iron Law

**Ask questions BEFORE exploring code. One question at a time.**

Do not touch the codebase until the problem is thoroughly understood.
Resist the urge to immediately search for files or read code.

## Core Principles

### Interrogate Before Exploring

The research phase has TWO distinct stages:

1. **Interrogation** - Ask questions to understand intent, scope, constraints
2. **Exploration** - Only after interrogation, examine the codebase

Never skip or rush interrogation. Most failed implementations stem from
misunderstanding the problem, not misunderstanding the code.

### One Question at a Time

Do not overwhelm with multiple questions. Ask a single focused question,
wait for the answer, then ask the next question based on that answer.

**Wrong:**

```text
What is the goal? What constraints exist? What have you tried?
Who are the users? What's the timeline?
```

**Right:**

```text
What problem are you trying to solve?
```

Then based on the answer, ask the next relevant question.

### Multiple Choice Preferred

When possible, offer constrained options rather than open-ended questions.
This makes it easier for users to respond and surfaces your assumptions.

**Wrong:**

```text
What approach should we take?
```

**Right:**

```text
Which best describes your goal?
- Add new functionality to existing feature
- Fix a bug in current behavior
- Refactor without changing behavior
- Improve performance of existing code
```

### Evidence Over Assumptions

During exploration, document findings with file:line references. Every
claim about the codebase should be verifiable.

## Research Process

### Phase 1: Interrogation (REQUIRED)

Before any codebase exploration, conduct systematic questioning.

#### Step 1: Understand the Goal

Ask ONE question to understand what the user wants to achieve:

```text
What outcome are you hoping for?
```

Or offer options:

```text
Which best describes what you're trying to do?
- Build something new
- Change existing behavior
- Fix something broken
- Understand how something works
```

#### Step 2: Clarify the Problem

Based on the goal, ask ONE follow-up question:

- If building new: "What should this feature do?"
- If changing: "What should be different from current behavior?"
- If fixing: "What's happening that shouldn't be?"
- If understanding: "What specific aspect is unclear?"

#### Step 3: Identify Scope

Ask about boundaries:

```text
How big is this change?
- Small: One file, isolated change
- Medium: Multiple files, contained area
- Large: Architectural, wide-reaching impact
```

#### Step 4: Surface Constraints

Ask about limitations:

```text
Are there constraints I should know about?
- Performance requirements
- Compatibility needs
- Security considerations
- Timeline pressure
- Other (please specify)
```

#### Step 5: Check for Prior Work

Ask about existing context:

```text
Have you already tried anything or identified relevant code?
```

#### Step 6: Confirm Understanding

Before exploring, summarize understanding and confirm:

```text
Let me confirm I understand:
- Goal: [summarize]
- Scope: [summarize]
- Constraints: [summarize]

Is this accurate, or should I adjust my understanding?
```

Only proceed to exploration after confirmation.

### Phase 2: Exploration (After Interrogation)

Once the problem is understood, explore the codebase systematically.

#### Map the Territory

- Identify relevant directories and file organization
- Note naming conventions and patterns
- Find entry points (main files, routers, handlers)
- Document the dependency graph for affected areas

#### Trace Data Flow

- Identify inputs (APIs, user actions, events)
- Track transformations and processing steps
- Note where state is stored and modified
- Document outputs and side effects

#### Find Existing Patterns

- Search for analogous features already built
- Note patterns used (factories, repositories, services)
- Identify reusable utilities and helpers
- Document conventions for testing, error handling, logging

#### Identify Technical Constraints

- External dependencies and their versions
- Performance bottlenecks
- Security considerations
- Backward compatibility needs

### Phase 3: Documentation

Produce a research document at `docs/plans/research/<topic>.md`:

```markdown
# Research: <Topic>

## Problem Statement

[One paragraph describing what needs to be understood, based on interrogation]

## User Requirements

- Goal: [from interrogation]
- Scope: [from interrogation]
- Constraints: [from interrogation]

## Key Questions

- [Question 1]
- [Question 2]

## Findings

### Relevant Files

| File                | Purpose    | Key Lines |
| ------------------- | ---------- | --------- |
| src/auth/handler.ts | Auth logic | 42-87     |

### Existing Patterns

[Patterns discovered that should inform implementation]

### Dependencies

[External and internal dependencies]

### Constraints

[Technical limitations discovered]

## Open Questions

[Questions that remain unanswered]

## Recommendations

[Initial thoughts on approach, informed by research]
```

## Interrogation Techniques

### Funnel Questions

Start broad, then narrow based on answers:

1. "What are you trying to accomplish?" (broad)
2. "Which part of that is most important?" (narrowing)
3. "What would success look like for that part?" (specific)

### Assumption Surfacing

Make your assumptions explicit and ask for confirmation:

```text
I'm assuming this needs to work with the existing auth system.
Is that correct?
```

### Trade-off Questions

When multiple approaches exist:

```text
There's a trade-off here:
- Option A: Faster to build, but less flexible
- Option B: More flexible, but more complex

Which matters more for this case?
```

### Clarification Through Examples

When requirements are vague:

```text
Can you give me an example of what you'd expect to happen?
```

## Anti-Patterns to Avoid

### Rushing to Code

**Wrong**: Reading files immediately after receiving the request
**Right**: Asking clarifying questions first, exploring code only after

### Question Dumps

**Wrong**: Asking five questions in one message
**Right**: One question, wait for answer, then next question

### Assuming Understanding

**Wrong**: "I understand, let me look at the code"
**Right**: "Let me confirm I understand: [summary]. Is this accurate?"

### Open-Ended When Options Exist

**Wrong**: "How should we handle this?"
**Right**: "Should we A) do X, B) do Y, or C) something else?"

### Premature Solutioning

**Wrong**: "I'll add a new AuthService class"
**Right**: "The codebase uses repository pattern. Auth is in handler.ts:42-87."

## Transition to Planning

Research is complete when:

- User requirements are documented (from interrogation)
- Relevant files are identified with line references
- Existing patterns are documented
- Constraints are understood (both user and technical)

After completing research, prompt the user:

> "Research complete. Ready to create an implementation plan based on
> these findings?"

Use AskUserQuestion to confirm transition to the planning phase.

## Integration with Claude Features

### Use AskUserQuestion Extensively

This is the primary tool for interrogation. Use it for every question
in Phase 1.

### Use TodoWrite for Progress

Track interrogation questions as todos, marking complete as answered.
Then track exploration tasks.

### Use Glob and Grep for Exploration

Only after interrogation is complete. Document findings with file:line
references.

### Use Task Tool for Deep Exploration

For complex codebases, spawn exploration agents to parallelize research.
But only after interrogation establishes what to look for.
