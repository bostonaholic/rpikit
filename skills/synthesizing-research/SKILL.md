---
name: synthesizing-research
description: Consolidate multiple parallel research documents into a single unified report. Produces a self-contained document that a reader with no prior context can understand completely.
argument-hint: topic to synthesize research for
---

# Research Synthesis

Consolidate research for: **$ARGUMENTS**

## Purpose

When research is conducted in parallel — multiple agents exploring different aspects of a problem — each produces a
separate findings file. This skill combines those files into one self-contained document that a reader with no prior
context can understand completely.

## Process

### 1. Locate Research Files

Search for research files related to the topic:

```text
Glob pattern: docs/plans/*-<topic>-*.md
Exclude: *-plan.md, *-research.md (the consolidated output)
```

If no files are found, ask the user to specify the file paths.

### 2. Read All Source Files

Read each research file completely. Note:

- Key findings from each source
- Overlapping or contradictory information
- Gaps — topics mentioned but not investigated
- Confidence levels stated by each researcher

### 3. Organize by Theme

Restructure findings by theme, NOT by source. Multiple researchers may have found related information — group it
together rather than presenting each researcher's output sequentially.

Themes to look for:

- Architecture and design patterns
- Data flow and state management
- External dependencies and APIs
- Security and performance considerations
- Testing patterns and coverage
- Gaps and open questions

### 4. Write Consolidated Document

Create the synthesis at: `docs/plans/YYYY-MM-DD-<topic>-research.md`

(Use today's date in YYYY-MM-DD format)

```markdown
# Research: <Topic> (YYYY-MM-DD)

## Problem Statement

[What is being investigated and why]

## Requirements

[Key requirements gathered from research]

## Findings

### [Theme 1]

[Findings organized by theme, not by source document]

### [Theme 2]

[Continue for each theme...]

## External Research

[Findings from web research with source citations and confidence
assessments]

## Technical Constraints

[Limitations, dependencies, and compatibility concerns]

## Open Questions

[Questions that remain unanswered across all research]

## Recommendations

[Synthesis of all findings into actionable recommendations]

## Sources

| Document | Researcher | Focus Area |
| -------- | ---------- | ---------- |
| [path]   | [agent]    | [scope]    |
```

### 5. Validate and Present

After writing the document:

1. Present a summary of key findings to the user
2. Note any contradictions or gaps found during synthesis

## Quality Criteria

A good synthesis document:

- Is self-contained — no prior context required to understand it
- Organizes by theme, not by source
- Resolves contradictions between sources (or flags them explicitly)
- Preserves source citations for external research
- Identifies gaps where more research may be needed
- Provides actionable recommendations

## Anti-Patterns

| Do Not | Instead |
| ------ | ------- |
| Copy-paste each researcher's output sequentially | Reorganize by theme |
| Drop source citations from web research | Preserve all citations |
| Silently resolve contradictions | Flag them explicitly |
| Include raw notes or exploration logs | Distill into findings |
| Assume all findings are equally confident | Note confidence levels |
