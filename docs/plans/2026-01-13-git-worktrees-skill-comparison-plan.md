# Plan: Git Worktrees Skill Improvements (2026-01-13)

## Summary

Enhance the rpikit git-worktrees skill by incorporating the best elements from the superpowers using-git-worktrees skill while preserving rpikit's existing strengths. This includes adding technical precision (exact commands), UX improvements (quick reference tables, example workflow), and better documentation structure (integration docs, red flags format).

## Stakes Classification

**Level**: Medium
**Rationale**:

- Single file modification (skills/git-worktrees/SKILL.md)
- Additive changes that preserve existing functionality
- Easy to verify against research findings
- Easy to rollback if needed
- No breaking changes to existing behavior

## Context

**Research**: [docs/plans/2026-01-13-git-worktrees-skill-comparison-research.md](./2026-01-13-git-worktrees-skill-comparison-research.md)
**Affected Areas**: `skills/git-worktrees/SKILL.md`

## Success Criteria

- [ ] Safety Verification section includes actual `git check-ignore` command
- [ ] `.worktrees/` in project root offered as default/recommended option (still asks user)
- [ ] Quick Reference decision table added
- [ ] Anti-patterns reformatted as "Never Do These" red flags
- [ ] Integration section with "Called by" / "Pairs with" added
- [ ] Example workflow section added
- [ ] All existing rpikit strengths preserved (When to Use, Multi-language, Worktree Management, External vs Local, Cleanup Checklist, Commands Reference)

## Implementation Steps

### Phase 1: Technical Precision (Priority 1)

#### Step 1.1: Add git check-ignore command to Safety Verification

- **Files**: `skills/git-worktrees/SKILL.md:72-96`
- **Action**: Replace prose description with actual verification command
- **Before**:

  ```text
  Check .gitignore for:
  - .worktrees/
  - worktrees/
  ```

- **After**:

  ```bash
  # Verify directory is ignored (returns 0 if ignored)
  git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
  ```

- **Verify**: Section contains executable bash command, not prose description
- **Complexity**: Small

#### Step 1.2: Update default worktree location

- **Files**: `skills/git-worktrees/SKILL.md:59-68`
- **Action**: Update "Ask the User" section to offer `.worktrees/` as the default and recommended option
- **Before**:

  ```text
  - External location (e.g., ~/worktrees/project-name/)
  ```

- **After**:

  ```text
  - .worktrees/ in project root (recommended, must be in .gitignore)
  - External location (e.g., ~/worktrees/project-name/)
  ```

- **Verify**: Still asks user, but `.worktrees/` is first and marked as recommended
- **Complexity**: Small

### Phase 2: UX Improvements (Priority 2)

#### Step 2.1: Add Quick Reference decision table

- **Files**: `skills/git-worktrees/SKILL.md` (new section after "Safety Verification")
- **Action**: Add quick reference table for common situations
- **Content**: Table with columns Situation and Action, covering: existing directories, neither exists, not ignored, tests fail
- **Verify**: New "Quick Reference" section exists with table
- **Complexity**: Small

#### Step 2.2: Reformat Anti-Patterns as "Never Do These"

- **Files**: `skills/git-worktrees/SKILL.md:273-298`
- **Action**: Replace current format with scannable red flags list
- **Before**: Current "Wrong/Right" prose format
- **After**: Bullet list of 8 items covering: unverified ignore, skipping deps, skipping tests, failing tests, ambiguous location, skipping CLAUDE.md, stale worktrees, overuse
- **Verify**: Section renamed to "Never Do These" with bullet list format
- **Complexity**: Small

#### Step 2.3: Add Integration section

- **Files**: `skills/git-worktrees/SKILL.md` (new section, place after "Purpose" or before "When to Use")
- **Action**: Add explicit integration documentation with "Called by" and "Pairs with" subsections
- **Verify**: New "Integration" section exists with Called by / Pairs with
- **Complexity**: Small

#### Step 2.4: Add Example Workflow section

- **Files**: `skills/git-worktrees/SKILL.md` (new section, place near end before Commands Reference)
- **Action**: Add concrete example showing expected session flow with User/Assistant interaction demonstrating: directory check, ignore verification, worktree creation, dependency setup, baseline tests, ready state
- **Verify**: New "Example Workflow" section exists with session example
- **Complexity**: Small

### Phase 3: Verification

#### Step 3.1: Final review

- **Files**: `skills/git-worktrees/SKILL.md`
- **Action**: Read complete file to verify:
  1. All 6 improvements added
  2. All existing strengths preserved
  3. Section order is logical
  4. No duplication or conflicts
- **Verify**: Manual review confirms checklist
- **Complexity**: Small

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Section ordering unclear | Minor confusion | Follow superpowers pattern: Integration early, Example Workflow near end |
| Duplication with existing content | Bloat, confusion | Remove redundant prose when adding structured equivalents |
| Changed behavior expectations | Users confused | Changes are additive/clarifying, not behavioral changes |

## Rollback Strategy

Git revert a single commit - all changes are in one file (`skills/git-worktrees/SKILL.md`). Previous version easily recoverable.

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete (2026-01-14)
