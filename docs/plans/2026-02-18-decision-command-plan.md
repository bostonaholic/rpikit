# Plan: Decision Command (2026-02-18)

## Summary

Add a `/rpikit:decision` command that reads design documents and generates
sequentially numbered Architecture Decision Records (ADRs) in
`docs/decisions/`. The command follows existing rpikit patterns: a thin command
wrapper delegating to a `documenting-decisions` skill.

## Stakes Classification

**Level**: Low
**Rationale**: Adding new files only. No modifications to existing commands,
skills, or agents. Follows established patterns exactly. Easy to remove if
unwanted.

## Context

**Design**: [Decision Command Design](2026-02-18-decision-command-design.md)
**Affected Areas**: `commands/`, `skills/`, `docs/architecture.md`, `README.md`

## Success Criteria

- [ ] `/rpikit:decision` command is invocable and delegates to skill
- [ ] Skill reads a design doc and generates an ADR in `docs/decisions/`
- [ ] ADR files use sequential 4-digit numbering (0001, 0002, etc.)
- [ ] ADR includes Status field (Accepted, Proposed, Deprecated, Superseded)
- [ ] Architecture docs and README updated to reflect new command
- [ ] All markdown files pass markdownlint

## Implementation Steps

### Phase 1: Create Command and Skill

#### Step 1.1: Create the command file

- **Files**: `commands/decision.md` (new)
- **Action**: Create thin command wrapper with frontmatter matching existing
  pattern (description, argument-hint, disable-model-invocation). Delegate to
  `rpikit:documenting-decisions` skill.
- **Verify**: File exists, frontmatter matches pattern from `brainstorm.md`
- **Complexity**: Small

#### Step 1.2: Create the skill directory and SKILL.md

- **Files**: `skills/documenting-decisions/SKILL.md` (new)
- **Action**: Create skill with frontmatter (name, description) and methodology
  content. Include: purpose, input handling (read design doc + args), sequential
  numbering logic, ADR template, status tracking, user confirmation flow,
  markdown validation step, and anti-patterns.
- **Verify**: File exists, frontmatter matches pattern from `brainstorming`
  skill
- **Complexity**: Medium

### Phase 2: Update Documentation

#### Step 2.1: Update architecture docs

- **Files**: `docs/architecture.md`
- **Action**: Add `/rpikit:decision` to the Commands table (delegates to
  `documenting-decisions`). Add `documenting-decisions` skill to the "Design
  and Review" skills table. Update the component count in the Component Types
  table. Add `docs/decisions/` to the output artifacts flow.
- **Verify**: Tables are accurate, markdown passes lint
- **Complexity**: Small

#### Step 2.2: Update README

- **Files**: `README.md`
- **Action**: Add `/rpikit:decision` to the Commands table. Add
  `documenting-decisions` to the Skills listing under "Core RPI Workflow" or a
  new section. Add `docs/decisions/` to the Output Structure section. Add usage
  example showing the decision command workflow.
- **Verify**: README accurately reflects new command, markdown passes lint
- **Complexity**: Small

## Risks and Mitigations

| Risk | Impact | Mitigation |
| ---- | ------ | ---------- |
| Skill instructions unclear | Users generate inconsistent ADRs | Follow brainstorming skill as quality reference |
| Sequential numbering edge cases | Wrong number if directory empty | Skill defaults to 0001 when no existing files |

## Rollback Strategy

Delete `commands/decision.md` and `skills/documenting-decisions/` directory.
Revert changes to `docs/architecture.md` and `README.md`.

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
