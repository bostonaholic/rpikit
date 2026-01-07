---
name: research-methodology
description: >-
  This skill should be used when the user asks to "research the codebase",
  "understand how X works", "explore the code", "gather context",
  "investigate the implementation", "analyze the architecture", or invokes
  the rpi:research command. Provides methodology for thorough codebase
  exploration before planning or implementation.
---

# Research Methodology

## Purpose

Research is the foundation of disciplined software engineering. Before
planning or implementing changes, develop deep understanding of the existing
codebase, patterns, and constraints. This methodology ensures thorough
exploration that produces actionable insights.

## Core Principles

### Understand Before Acting

Never propose changes to code without first reading and understanding it.
Resist the urge to jump to solutions. The goal of research is context,
not answers.

### Evidence Over Assumptions

Document findings with file:line references. Every claim about the codebase
should be verifiable. Avoid assumptions about how code works—verify through
exploration.

### Scope Appropriately

Match research depth to task complexity:

| Task Type           | Research Depth      | Time Investment |
| ------------------- | ------------------- | --------------- |
| Bug fix             | Focused             | Quick           |
| Feature addition    | Moderate            | Medium          |
| Architectural       | Deep                | Thorough        |

## Research Process

### 1. Clarify the Problem

Before exploring code, establish what needs to be understood:

- State the problem or goal in one sentence
- Identify what is unknown or uncertain
- List specific questions that research should answer
- Use AskUserQuestion to clarify ambiguous requirements

### 2. Map the Territory

Begin with broad exploration to understand structure:

- Identify relevant directories and file organization
- Note naming conventions and patterns
- Find entry points (main files, routers, handlers)
- Document the dependency graph for affected areas

### 3. Trace Data Flow

Follow how data moves through the system:

- Identify inputs (APIs, user actions, events)
- Track transformations and processing steps
- Note where state is stored and modified
- Document outputs and side effects

### 4. Find Existing Patterns

Locate implementations similar to the planned work:

- Search for analogous features already built
- Note patterns used (factories, repositories, services)
- Identify reusable utilities and helpers
- Document conventions for testing, error handling, logging

### 5. Identify Constraints

Discover limitations and requirements:

- External dependencies and their versions
- Performance requirements or bottlenecks
- Security considerations
- Backward compatibility needs

### 6. Document Findings

Produce a research document that enables planning:

- Problem statement with context
- Relevant files with line references
- Existing patterns to follow
- Dependencies and constraints
- Open questions requiring clarification

## Research Techniques

### File Discovery

Use Glob for structural exploration:

```text
**/*.ts          # Find all TypeScript files
**/test/**       # Locate test directories
**/*Controller*  # Find controller files
```

### Code Search

Use Grep with file:line precision:

```text
Search for: function handleAuth
Found: src/auth/handler.ts:42
```

Always record line numbers for later reference.

### Pattern Recognition

When finding existing implementations:

1. Search for similar feature names
2. Look for consistent architectural patterns
3. Note how tests are structured
4. Identify common utilities used

### Dependency Mapping

Track relationships between components:

- Import/export relationships
- Service dependencies
- Database table relationships
- API contract dependencies

## Output Format

Research produces a document at `docs/plans/research/<topic>.md`:

```markdown
# Research: <Topic>

## Problem Statement

[One paragraph describing what needs to be understood]

## Key Questions

- [Question 1]
- [Question 2]

## Findings

### Relevant Files

| File                  | Purpose    | Key Lines |
| --------------------- | ---------- | --------- |
| src/auth/handler.ts   | Auth logic | 42-87     |

### Existing Patterns

[Patterns discovered that should inform implementation]

### Dependencies

[External and internal dependencies]

### Constraints

[Limitations, requirements, considerations]

## Open Questions

[Questions that remain unanswered]

## Recommendations

[Initial thoughts on approach, informed by research]
```

## Transition to Planning

Research is complete when:

- All key questions have answers (or are documented as open)
- Relevant files are identified with line references
- Existing patterns are documented
- Constraints are understood

After completing research, prompt the user:

> "Research complete. Ready to create an implementation plan based on
> these findings?"

Use AskUserQuestion to confirm transition to the planning phase.

## Anti-Patterns to Avoid

### Premature Solutioning

**Wrong**: "I'll add a new AuthService class"
**Right**: "The codebase uses repository pattern. Auth is in handler.ts:42-87."

### Shallow Exploration

**Wrong**: Finding one file and assuming understanding
**Right**: Tracing the full data flow and finding all related components

### Undocumented Findings

**Wrong**: Exploring code mentally without recording
**Right**: Creating research document with file:line references

### Scope Creep

**Wrong**: Researching the entire codebase for a bug fix
**Right**: Matching research depth to task complexity

## Integration with Claude Features

### Use Glob for File Discovery

Prefer Glob over manual directory listing for pattern-based file discovery.

### Use Grep with Precision

Always capture line numbers. Use output_mode: "content" with line context
for understanding.

### Use Task Tool for Deep Exploration

For complex codebases, spawn exploration agents to parallelize research.

### Use TodoWrite for Progress

Track research questions as todos, marking complete as answers are found.

### Use AskUserQuestion for Clarification

When research reveals ambiguity, ask specific questions before proceeding.

## Additional Resources

For research document templates and examples, see:

- `${CLAUDE_PLUGIN_ROOT}/docs/plans/research/` for output location
