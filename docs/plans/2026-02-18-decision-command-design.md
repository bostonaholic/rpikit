# Design: Decision Command (2026-02-18)

## Problem Statement

Design decisions made during brainstorming and planning are captured in design
docs but lack a standardized, discoverable format for long-term reference. ADRs
provide a proven convention for recording architectural decisions with context,
rationale, and status tracking. rpikit needs its own decision-documenting
command that reads design docs and produces ADR files.

## Chosen Approach

A standalone `documenting-decisions` skill invoked by a thin
`/rpikit:decision` command. The skill contains its own ADR template focused on
capturing decisions already made (not evaluating them). It reads design
documents from `docs/plans/`, accepts additional context via arguments,
auto-detects the next sequential number, and writes ADR files to
`docs/decisions/`.

## Design Details

### New Files

- `commands/decision.md` - thin wrapper delegating to `documenting-decisions`
  skill
- `skills/documenting-decisions/SKILL.md` - methodology and ADR template

### Input Flow

1. User invokes `/rpikit:decision <path-to-design-doc> [additional context]`
2. Skill reads the referenced design doc
3. Skill extracts: problem statement, chosen approach, alternatives considered,
   trade-offs
4. Skill prompts user to confirm/adjust extracted content
5. Skill generates the ADR file

### Output Format

File naming: `docs/decisions/NNNN-kebab-case-title.md`

```markdown
# NNNN. Decision Title

**Date**: YYYY-MM-DD

**Status**: Accepted | Proposed | Deprecated | Superseded by NNNN

## Context

[Problem and background extracted from design doc]

## Decision

[What was decided and why]

## Consequences

[Positive and negative outcomes, trade-offs accepted]

## Alternatives Considered

[Options evaluated and why they were not chosen]
```

### Sequential Numbering

Skill scans `docs/decisions/` for existing files, finds the highest number,
increments by one. Pads to 4 digits (0001, 0002, etc.).

### Status Tracking

Default status is "Accepted". Users can specify a different status via
arguments. Superseded decisions link to the replacing ADR by number.

## Trade-offs Accepted

- **Simpler template than full ADR frameworks** - Intentional. This is for
  recording decisions, not running evaluation workshops. Sections can be added
  later if needed.
- **No reverse linking** - When a decision supersedes another, it does not
  auto-update the old ADR's status. This keeps the tool simple; manual updates
  are infrequent.

## Next Steps

- [ ] Planning phase
- [ ] Implementation
