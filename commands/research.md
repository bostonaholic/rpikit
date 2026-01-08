---
description: Deep codebase exploration before planning or implementation
argument-hint: [topic]
allowed-tools: Read, Glob, Grep, Task, TodoWrite, AskUserQuestion, Write
---

# Research Phase

Research topic: **$ARGUMENTS**

## The Iron Law

**DO NOT explore the codebase yet.**

First, conduct interrogation to understand what the user actually needs.
Ask questions ONE AT A TIME. Only explore code after sufficient understanding.

## Phase 1: Interrogation (REQUIRED)

Before touching any code, ask clarifying questions. Use AskUserQuestion for
each question below. Ask ONE question, wait for the answer, then proceed.

### Question 1: Understand the Goal

Start with this question using AskUserQuestion:

**Question**: "Which best describes what you're trying to accomplish with
'$ARGUMENTS'?"

**Options**:

- "Build something new" - Add new functionality
- "Change existing behavior" - Modify how something works
- "Fix something broken" - Resolve a bug or issue
- "Understand how it works" - Learn about implementation

### Question 2: Clarify Specifics

Based on their answer, ask ONE follow-up:

- If "Build something new": "What should this new feature do?"
- If "Change existing behavior": "What should be different from now?"
- If "Fix something broken": "What's happening that shouldn't be?"
- If "Understand how it works": "What specific aspect is unclear?"

### Question 3: Scope the Work

Ask about size using AskUserQuestion:

**Question**: "How big do you expect this change to be?"

**Options**:

- "Small" - One file, isolated change
- "Medium" - Multiple related files
- "Large" - Architectural, touches many areas
- "Unknown" - Need to explore to find out

### Question 4: Surface Constraints

Ask about limitations using AskUserQuestion:

**Question**: "Are there constraints I should know about?"

**Options** (allow multiple selection):

- "Performance requirements"
- "Compatibility/backward compatibility"
- "Security considerations"
- "Timeline pressure"
- "No specific constraints"

### Question 5: Prior Context

Ask about existing knowledge:

**Question**: "Have you already identified relevant code or tried anything?"

**Options**:

- "Yes, I know where to look" - Ask them to share
- "I have some ideas" - Ask them to elaborate
- "No, starting fresh" - Proceed to exploration

### Question 6: Confirm Understanding

Before exploring, summarize what you've learned:

```text
Let me confirm I understand:

- Goal: [their goal from Q1/Q2]
- Scope: [their scope from Q3]
- Constraints: [their constraints from Q4]
- Prior context: [their context from Q5]

Is this accurate?
```

Use AskUserQuestion with options:

- "Yes, that's right" - Proceed to exploration
- "Let me clarify" - Ask what needs adjustment

**DO NOT proceed to Phase 2 until they confirm understanding.**

## Phase 2: Exploration (After Interrogation Only)

Only after completing Phase 1 interrogation, explore the codebase.

### Create Research Tracking

Use TodoWrite to track exploration progress based on what you learned:

- Questions to answer (from interrogation)
- Areas to explore (based on their context)
- Findings to document

### Explore Systematically

Based on what you learned in interrogation:

**Map relevant territory:**

- Identify directories related to their goal
- Find entry points and key files
- Note patterns and conventions

**Trace relevant data flow:**

- Follow data through areas they mentioned
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

### Validate Findings

After exploring, check back with the user:

```text
I found [summary of key findings]. Does this align with what you expected,
or should I look elsewhere?
```

## Phase 3: Document Findings

Create research document at: `docs/plans/research/$ARGUMENTS.md`

Include both interrogation results AND exploration findings:

```markdown
# Research: $ARGUMENTS

## Problem Statement

[Based on interrogation - what the user wants to accomplish]

## User Requirements

- **Goal**: [from interrogation]
- **Scope**: [from interrogation]
- **Constraints**: [from interrogation]
- **Prior context**: [from interrogation]

## Key Questions

- [Questions that guided exploration]

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

After documenting findings, ask:

"Research complete for '$ARGUMENTS'. Findings documented at
docs/plans/research/$ARGUMENTS.md.

Ready to create an implementation plan based on this research?"

Use AskUserQuestion with options:

- "Yes, create a plan" - Proceed to invoke rpikit:plan
- "Continue researching" - Gather more context
- "Done for now" - End research phase

If user chooses to create a plan, guide them to use `/rpikit:plan $ARGUMENTS`
or invoke the Skill tool with skill "rpikit:plan".

## Quality Checklist

Before completing research:

- [ ] Interrogation completed (all 6 questions asked)
- [ ] User confirmed understanding before exploration
- [ ] Key questions answered or documented as open
- [ ] Relevant files identified with line references
- [ ] Existing patterns documented
- [ ] Constraints understood (user AND technical)
- [ ] Research document created at docs/plans/research/
