# Plan: Plan Filename Consistency Fix (2026-02-16)

## Summary

Replace `$ARGUMENTS` with `<topic>` in filename patterns across
`writing-plans` and `implementing-plans` skills, aligning them with the
approach already used by `researching-codebase` and `brainstorming`. This
eliminates the double-dash bug when commands are invoked without arguments.

## Stakes Classification

**Level**: Low
**Rationale**: Isolated text changes in skill markdown files. No code logic
affected. Easy rollback via git revert.

## Context

**Research**: `docs/plans/2026-02-16-plan-filename-consistency-research.md`
**Affected Areas**: `skills/writing-plans/SKILL.md`,
`skills/implementing-plans/SKILL.md`

## Success Criteria

- [ ] All four skills use `<topic>` (not `$ARGUMENTS`) in filename patterns
- [ ] `$ARGUMENTS` is preserved for topic description lines (line 13)
- [ ] Search patterns use `<topic>` instead of `$ARGUMENTS`
- [ ] Approval message uses `<topic>` instead of `$ARGUMENTS`
- [ ] Markdown validation passes on both modified files

## Implementation Steps

### Phase 1: Fix writing-plans Skill

#### Step 1.1: Update research lookup pattern

- **Files**: `skills/writing-plans/SKILL.md:26-28`
- **Action**: Change `$ARGUMENTS` to `<topic>` in the research file lookup
  path and search pattern
- **Verify**: Lines 26 and 28 use `<topic>` instead of `$ARGUMENTS`
- **Complexity**: Small

#### Step 1.2: Update plan creation filename

- **Files**: `skills/writing-plans/SKILL.md:166`
- **Action**: Change `docs/plans/YYYY-MM-DD-$ARGUMENTS-plan.md` to
  `docs/plans/YYYY-MM-DD-<topic>-plan.md`
- **Verify**: Line 166 uses `<topic>`
- **Complexity**: Small

#### Step 1.3: Update approval message

- **Files**: `skills/writing-plans/SKILL.md:237`
- **Action**: Change `$ARGUMENTS` to `<topic>` in the approval message
  filename
- **Verify**: Line 237 uses `<topic>`
- **Complexity**: Small

#### Step 1.4: Update plan iteration check

- **Files**: `skills/writing-plans/SKILL.md:256-258`
- **Action**: Change `$ARGUMENTS` to `<topic>` in the existing plan lookup
  path and search pattern
- **Verify**: Lines 256 and 258 use `<topic>`
- **Complexity**: Small

#### Checkpoint: Validate writing-plans

- Run `markdownlint skills/writing-plans/SKILL.md`
- Verify `$ARGUMENTS` appears only on line 13 (topic description)
- Verify `<topic>` appears in all filename patterns

### Phase 2: Fix implementing-plans Skill

#### Step 2.1: Update plan lookup pattern

- **Files**: `skills/implementing-plans/SKILL.md:26-28`
- **Action**: Change `$ARGUMENTS` to `<topic>` in the plan file lookup path
  and search pattern
- **Verify**: Lines 26 and 28 use `<topic>` instead of `$ARGUMENTS`
- **Complexity**: Small

#### Checkpoint: Validate implementing-plans

- Run `markdownlint skills/implementing-plans/SKILL.md`
- Verify `$ARGUMENTS` appears only on line 13 (topic description)
- Verify `<topic>` appears in all filename patterns

### Phase 3: Verify Consistency

#### Step 3.1: Cross-skill audit

- **Files**: All four skill files
- **Action**: Grep for `$ARGUMENTS` across all skills and confirm it only
  appears in topic description lines (line 13), never in filename patterns
- **Verify**: `grep -n '$ARGUMENTS' skills/*/SKILL.md` shows only line 13
  hits for writing-plans and implementing-plans
- **Complexity**: Small

## Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| AI derives different slug than expected | Plan lookup may fail | Slug derivation already works in research/brainstorming skills |
| Existing plans with old naming not found | Implementation skill can't find plan | Search patterns are fuzzy (`*-<topic>-plan.md`); AI adapts |

## Rollback Strategy

`git revert` the commit. Only two markdown files are modified.

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
