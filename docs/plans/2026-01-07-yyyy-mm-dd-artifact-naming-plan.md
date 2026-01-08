# Plan: YYYY-MM-DD Artifact Naming Convention

## Summary

Update all three rpikit methodology skills to use date-prefixed artifact paths following the superpowers convention. Research documents will use `docs/plans/YYYY-MM-DD-<topic>-research.md` and plan documents will use `docs/plans/YYYY-MM-DD-<topic>-plan.md`.

## Stakes Classification

**Level**: Low
**Rationale**: Changes are isolated to 3 markdown documentation files. No runtime code affected. Easy git rollback.

## Context

**Research**: Conducted in-session (superpowers writing-plans and brainstorming skills)
**Affected Areas**: `skills/research-methodology/`, `skills/plan-methodology/`, `skills/implement-methodology/`

## Success Criteria

- [ ] Research methodology outputs to `docs/plans/YYYY-MM-DD-<topic>-research.md`
- [ ] Plan methodology outputs to `docs/plans/YYYY-MM-DD-<topic>-plan.md`
- [ ] Plan methodology looks up research at date-prefixed path
- [ ] Implement methodology looks up plans at date-prefixed path
- [ ] All path references are consistent across skills

## Implementation Steps

### Phase 1: Update Research Methodology

#### Step 1.1: Update research output path

- **Files**: `skills/research-methodology/SKILL.md:140`
- **Action**: Change `docs/plans/research/<topic>.md` to `docs/plans/YYYY-MM-DD-<topic>-research.md`
- **Verify**: Grep for old path returns no results; new path present
- **Complexity**: Small

#### Step 1.2: Update research document template header

- **Files**: `skills/research-methodology/SKILL.md:142-144`
- **Action**: Update template to reflect new naming in example
- **Verify**: Template shows date-prefixed format
- **Complexity**: Small

### Phase 2: Update Plan Methodology

#### Step 2.1: Update research lookup path

- **Files**: `skills/plan-methodology/SKILL.md:26`
- **Action**: Change `docs/plans/research/$ARGUMENTS.md` to use date-prefixed research path pattern
- **Verify**: Path references new naming convention
- **Complexity**: Small

#### Step 2.2: Update plan output path

- **Files**: `skills/plan-methodology/SKILL.md:164`
- **Action**: Change `docs/plans/$ARGUMENTS.md` to `docs/plans/YYYY-MM-DD-<topic>-plan.md`
- **Verify**: New path present in "Write Plan Document" section
- **Complexity**: Small

#### Step 2.3: Update plan template header

- **Files**: `skills/plan-methodology/SKILL.md:168-169`
- **Action**: Update template structure to show date-prefixed naming
- **Verify**: Template reflects new convention
- **Complexity**: Small

#### Step 2.4: Update approval message paths

- **Files**: `skills/plan-methodology/SKILL.md:233-239`
- **Action**: Update path references in approval request section
- **Verify**: Approval message shows correct path format
- **Complexity**: Small

#### Step 2.5: Update plan iteration lookup path

- **Files**: `skills/plan-methodology/SKILL.md:252`
- **Action**: Update existing plan check path
- **Verify**: Iteration check uses new path format
- **Complexity**: Small

### Phase 3: Update Implement Methodology

#### Step 3.1: Update plan lookup path

- **Files**: `skills/implement-methodology/SKILL.md:26`
- **Action**: Change `docs/plans/$ARGUMENTS.md` to date-prefixed plan path
- **Verify**: Implementation looks for plans at new path
- **Complexity**: Small

#### Step 3.2: Update completion summary path

- **Files**: `skills/implement-methodology/SKILL.md:204`
- **Action**: Update plan document reference in completion summary
- **Verify**: Summary shows correct path format
- **Complexity**: Small

## Risks and Mitigations

| Risk | Impact | Mitigation |
| ---- | ------ | ---------- |
| Existing artifacts orphaned | Low | Old artifacts remain accessible; users can migrate manually |
| Path pattern mismatch | Low | Verify all references updated consistently |

## Rollback Strategy

Git revert the commit. No data migration needed.

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
