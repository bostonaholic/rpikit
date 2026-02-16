# Research: Plan Filename Consistency (2026-02-16)

## Problem Statement

Plan documents are being named `docs/plans/2026-02-16--plan.md` (double
dash, missing topic slug) while design documents are correctly named like
`docs/plans/2026-02-16-heroku-deployment-design.md`. The goal is to identify
the root cause of this inconsistency and ensure all artifact types produce
correct filenames.

## Requirements

- All artifact filenames should follow `YYYY-MM-DD-<slug>-<type>.md`
- The slug portion must always be populated with a meaningful kebab-case
  topic descriptor
- Naming must be consistent across all four skills that produce artifacts

## Findings

### Relevant Files

| File | Purpose | Key Lines |
| --- | --- | --- |
| `skills/writing-plans/SKILL.md` | Defines plan filename convention | 26, 166, 237, 256-258 |
| `skills/implementing-plans/SKILL.md` | Looks up plan files by name | 26, 28 |
| `skills/researching-codebase/SKILL.md` | Defines research filename convention | 140-142 |
| `skills/brainstorming/SKILL.md` | Defines design filename convention | 114, 208 |
| `commands/plan.md` | Entry point for `/rpikit:plan` | 3 (argument-hint) |
| `commands/research.md` | Entry point for `/rpikit:research` | 3 (argument-hint) |
| `commands/implement.md` | Entry point for `/rpikit:implement` | 3 (argument-hint) |

### Root Cause

The four skills use **two different mechanisms** for the slug portion of
filenames:

| Skill | Pattern | Slug Source |
| --- | --- | --- |
| `researching-codebase` | `YYYY-MM-DD-<topic>-research.md` | `<topic>` (AI-derived) |
| `brainstorming` | `YYYY-MM-DD-<topic>-design.md` | `<topic>` (AI-derived) |
| `writing-plans` | `YYYY-MM-DD-$ARGUMENTS-plan.md` | `$ARGUMENTS` (literal substitution) |
| `implementing-plans` | `YYYY-MM-DD-$ARGUMENTS-plan.md` | `$ARGUMENTS` (literal substitution) |

**`<topic>` (works correctly):** A placeholder the AI interprets from
conversation context. The AI always derives a meaningful kebab-case slug
regardless of how the command was invoked.

**`$ARGUMENTS` (causes the bug):** A literal variable that gets substituted
with whatever the user typed after the command. When empty (user runs
`/rpikit:plan` without args, or passes a file reference like
`@/docs/plans/...`), the pattern becomes `YYYY-MM-DD--plan.md` — producing
the double-dash filename.

### Existing Patterns

The `writing-plans` skill uses `$ARGUMENTS` in six places:

- Line 13: `Create an implementation plan for: **$ARGUMENTS**`
- Line 26: `docs/plans/YYYY-MM-DD-$ARGUMENTS-research.md` (lookup)
- Line 28: `*-$ARGUMENTS-research.md` (search pattern)
- Line 166: `docs/plans/YYYY-MM-DD-$ARGUMENTS-plan.md` (create)
- Line 237: `docs/plans/YYYY-MM-DD-$ARGUMENTS-plan.md` (approval message)
- Line 256-258: `docs/plans/YYYY-MM-DD-$ARGUMENTS-plan.md` (iteration check)

The `implementing-plans` skill uses `$ARGUMENTS` in three places:

- Line 13: `Execute the implementation plan for: **$ARGUMENTS**`
- Line 26: `docs/plans/YYYY-MM-DD-$ARGUMENTS-plan.md` (lookup)
- Line 28: `*-$ARGUMENTS-plan.md` (search pattern)

### Why the Design Doc Worked

The brainstorming skill uses `<topic>` on line 114:

```text
Save final design to `docs/plans/YYYY-MM-DD-<topic>-design.md`
```

The AI interpreted `<topic>` from the conversation context
("heroku deployment" became "heroku-deployment"), producing the correct
filename `2026-02-16-heroku-deployment-design.md`.

### Why the Plan Failed

The writing-plans skill uses `$ARGUMENTS` on line 166:

```text
Create plan at: `docs/plans/YYYY-MM-DD-$ARGUMENTS-plan.md`
```

When `/rpikit:plan` was invoked (likely without arguments or with a file
reference), `$ARGUMENTS` was empty, producing
`2026-02-16--plan.md`.

### Technical Constraints

- `$ARGUMENTS` is a Claude Code plugin variable substituted at skill load
  time, before the AI processes the content
- `<topic>` is a natural language placeholder interpreted by the AI at
  runtime
- The research and brainstorming skills don't use `$ARGUMENTS` in filename
  patterns at all — only for describing the topic on the first line

## Open Questions

1. Should the fix use `<topic>` consistently across all skills, or should
   there be explicit instructions to derive a slug from `$ARGUMENTS`?
2. Should the skills include fallback logic (e.g., "if `$ARGUMENTS` is
   empty, derive the slug from the conversation context")?
3. The `implementing-plans` skill's lookup pattern
   (`*-$ARGUMENTS-plan.md`) also breaks when `$ARGUMENTS` is empty — it
   would search for `*--plan.md`. Should lookup use a different strategy?

## Recommendations

**Replace `$ARGUMENTS` with `<topic>` in filename patterns.** This is the
simplest fix and aligns with how the research and brainstorming skills
already work. The AI derives a kebab-case slug from context regardless of
whether `$ARGUMENTS` is populated.

Specifically, change these lines:

- `skills/writing-plans/SKILL.md:166` — change filename pattern to use
  `<topic>`
- `skills/writing-plans/SKILL.md:237` — change approval message to use
  `<topic>`
- `skills/writing-plans/SKILL.md:256` — change iteration check to use
  `<topic>`
- `skills/implementing-plans/SKILL.md:26` — change lookup pattern to use
  `<topic>`

Keep `$ARGUMENTS` for the topic description lines (line 13 in both skills)
since those correctly describe the task, not the filename.
