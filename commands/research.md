---
description: Deep codebase exploration before planning or implementation
argument-hint: [topic]
allowed-tools: Read, Glob, Grep, Task, TodoWrite, AskUserQuestion, Write
---

# Research Phase

Conduct thorough codebase research for: **$ARGUMENTS**

## Prerequisites

Load the research-methodology skill for guidance on effective research.

## Process

### 1. Clarify Scope

Before exploring, clarify what needs to be understood:

- State the problem or goal in one sentence
- Identify what is unknown or uncertain
- Use AskUserQuestion to clarify ambiguous requirements

Ask clarifying questions now if the topic "$ARGUMENTS" is vague or could
be interpreted multiple ways.

### 2. Create Research Tracking

Use TodoWrite to track research progress:

- Key questions to answer
- Areas to explore
- Findings to document

### 3. Explore the Codebase

Conduct systematic exploration:

**Map the territory:**

- Identify relevant directories and file organization
- Find entry points and key files
- Note patterns and conventions

**Trace data flow:**

- Follow how data moves through relevant code
- Identify inputs, transformations, and outputs
- Document state changes and side effects

**Find existing patterns:**

- Search for analogous implementations
- Note reusable utilities and helpers
- Document conventions for testing and error handling

**Identify constraints:**

- External dependencies
- Performance requirements
- Security considerations

### 4. Document Findings

Create research document at: `docs/plans/research/$ARGUMENTS.md`

Use this structure:

```markdown
# Research: $ARGUMENTS

## Problem Statement

[One paragraph describing what needs to be understood]

## Key Questions

- [Question 1]
- [Question 2]

## Findings

### Relevant Files

| File              | Purpose     | Key Lines |
| ----------------- | ----------- | --------- |
| path/to/file.ts   | Description | 42-87     |

### Existing Patterns

[Patterns discovered that inform implementation]

### Dependencies

[External and internal dependencies]

### Constraints

[Limitations, requirements, considerations]

## Open Questions

[Questions that remain unanswered]

## Recommendations

[Initial thoughts on approach]
```

### 5. Transition to Planning

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

- [ ] Key questions have answers or are documented as open
- [ ] Relevant files identified with line references
- [ ] Existing patterns documented
- [ ] Constraints understood
- [ ] Research document created at docs/plans/research/
