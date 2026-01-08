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

Research topic: **$ARGUMENTS**

## Overview

Help turn research requests into thorough codebase understanding through
natural collaborative dialogue.

Start by understanding what the user needs to learn, then ask questions one
at a time to refine the scope. Once you understand what you're researching,
explore the codebase systematically, presenting findings in digestible
sections and validating as you go.

## The Iron Law

**Ask questions BEFORE exploring code.**

Do not touch the codebase until the problem is understood. Resist the urge
to immediately search for files or read code.

## Phase 1: Understanding the Request

**Your first action must be asking a clarifying question.**

Do NOT:

- Read any files
- Search the codebase
- Use Glob or Grep
- Explore anything
- Make assumptions about what the user wants

**Ask questions one at a time using AskUserQuestion:**

- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message
- If a topic needs more exploration, break it into multiple questions

**Focus on understanding:**

- **Purpose**: What are they trying to accomplish? (build, change, fix, learn)
- **Specifics**: What exactly should happen or change?
- **Scope**: How big is this? (one file, multiple files, architectural)
- **Constraints**: Any requirements around performance, compatibility, security?
- **Context**: Have they already looked at anything or have hunches?

**When you believe you understand, confirm:**

Summarize your understanding and ask if it's accurate before proceeding.
If anything needs clarification, ask follow-up questions.

## Phase 2: Exploration

**Only proceed after confirming understanding with the user.**

Use TodoWrite to track exploration based on what you learned.

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

**Present findings incrementally:**

- Share what you find in digestible sections
- Ask if findings align with expectations or if you should look elsewhere
- Be ready to redirect based on feedback

## Phase 3: Document Findings

Create research document at: `docs/plans/research/<topic>.md`

```markdown
# Research: <Topic>

## Problem Statement

[What the user wants to accomplish]

## Requirements

[Key requirements gathered during interrogation]

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

## Phase 4: Transition

Ask what the user wants to do next:

- Create an implementation plan
- Continue researching
- End for now

## Questioning Techniques

**Funnel questions** - Start broad, narrow based on answers:

1. "What are you trying to accomplish?" (broad)
2. "Which part is most important?" (narrowing)
3. "What would success look like?" (specific)

**Assumption surfacing** - Make assumptions explicit:

> I'm assuming this needs to work with the existing auth system. Is that
> correct?

**Trade-off questions** - When multiple approaches exist:

> There's a trade-off: Option A is faster to build but less flexible.
> Option B is more flexible but more complex. Which matters more here?

**Clarification through examples** - When requirements are vague:

> Can you give me an example of what you'd expect to happen?

## Anti-Patterns

| Wrong                                          | Right                                                 |
| ---------------------------------------------- | ----------------------------------------------------- |
| Reading files immediately                      | Ask questions first                                   |
| Multiple questions in one message              | One question, wait, then next                         |
| "I understand, let me look"                    | "Let me confirm: [summary]. Accurate?"                |
| "How should we handle this?"                   | "Should we A) do X, B) do Y, or C) something else?"   |
| "I'll add a new AuthService"                   | "The codebase uses repository pattern. Auth is here." |

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended
- **Confirm before exploring** - Validate understanding first
- **Incremental findings** - Present discoveries in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't fit
