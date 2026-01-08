# Plan: Worktree Integration in Implement Command (2026-01-08)

## Summary

Add worktree creation offer to the implement-methodology skill. After stakes assessment but before any code changes, the skill will detect if already in a worktree (skip prompt if so) and offer to create one with recommendation strength varying by stakes level. High-stakes work will strongly recommend worktree usage.

## Stakes Classification

**Level**: Medium
**Rationale**: Changes affect one skill file (implement-methodology), with clear verification through manual testing. Moderate impact on workflow but easy to rollback by reverting the skill file.

## Context

**Research**: [2026-01-08-worktree-implement-integration-research.md](2026-01-08-worktree-implement-integration-research.md)
**Affected Areas**: `skills/implement-methodology/SKILL.md`

## Success Criteria

- [ ] Implement skill detects if currently running in a worktree
- [ ] If not in worktree, prompts user with stakes-appropriate recommendation
- [ ] High stakes: "Recommended" label on worktree option
- [ ] Medium stakes: Neutral option
- [ ] Low stakes: Brief mention, no strong recommendation
- [ ] If user chooses worktree, skill invokes git-worktrees skill
- [ ] After worktree creation, implementation continues in new directory
- [ ] Finishing-work skill already handles cleanup (no changes needed)

## Implementation Steps

### Phase 1: Add Worktree Detection and Offer

#### Step 1.1: Add new section header after Step 2

- **Files**: `skills/implement-methodology/SKILL.md:77-79`
- **Action**: Insert new `### 2.5 Offer Worktree Isolation` section after stakes-based enforcement (before Step 3)
- **Verify**: New section exists between Step 2 and Step 3
- **Complexity**: Small

#### Step 1.2: Add worktree detection instructions

- **Files**: `skills/implement-methodology/SKILL.md` (new section)
- **Action**: Add instructions to check if currently in a worktree using `git rev-parse --show-toplevel` compared to main repo, or check `git worktree list`
- **Verify**: Section includes detection method
- **Complexity**: Small

#### Step 1.3: Add conditional prompt logic

- **Files**: `skills/implement-methodology/SKILL.md` (new section)
- **Action**: Add AskUserQuestion prompt that varies by stakes:
  - High stakes: "Use worktree (Recommended)" as first option
  - Medium stakes: "Use worktree" as neutral option
  - Low stakes: "Use worktree" with brief mention only
  Include "Continue in current directory" as alternative
- **Verify**: Three different prompt variants documented for each stakes level
- **Complexity**: Small

#### Step 1.4: Add worktree skill invocation

- **Files**: `skills/implement-methodology/SKILL.md` (new section)
- **Action**: Add instructions to invoke git-worktrees skill if user chooses worktree option, then continue implementation in new worktree directory
- **Verify**: Skill invocation syntax present
- **Complexity**: Small

### Phase 2: Renumber Subsequent Steps

#### Step 2.1: Update step numbers

- **Files**: `skills/implement-methodology/SKILL.md:80-367`
- **Action**: Renumber Step 3 → Step 4, Step 4 → Step 5, etc. through end of file
- **Verify**: All step numbers sequential (1, 2, 2.5, 3, 4, 5, 6, 7) or renumber 2.5 to 3 and shift all
- **Complexity**: Small

### Phase 3: Verify Integration

#### Step 3.1: Manual verification

- **Files**: N/A
- **Action**: Read through updated skill to verify logical flow from stakes assessment → worktree offer → progress tracking
- **Verify**: Flow is coherent and matches intended behavior
- **Complexity**: Small

#### Step 3.2: Verify finishing-work compatibility

- **Files**: `skills/finishing-work/SKILL.md:156-171`
- **Action**: Confirm existing worktree cleanup instructions work with new flow (no changes expected)
- **Verify**: No conflicts between new implementation and existing cleanup
- **Complexity**: Small

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Breaks existing implement workflow | High | Test manually before committing |
| Worktree detection unreliable | Medium | Use simple git commands, test edge cases |
| User confusion about worktree prompt | Low | Clear option labels with descriptions |

## Rollback Strategy

Revert `skills/implement-methodology/SKILL.md` to previous version using `git checkout HEAD~1 -- skills/implement-methodology/SKILL.md`.

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
