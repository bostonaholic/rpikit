# Research: Worktree Integration in Implement Command (2026-01-08)

## Problem Statement

Determine if the rpikit:implement command/skill offers worktree creation before making code changes, and if not, add this capability.

## Requirements

- Check if implement workflow uses worktrees or offers them
- If missing, add worktree integration so users are asked before changes begin

## Findings

### Answer to Research Question

**No, the implement command does NOT use worktrees or ask about creating them.**

The implement methodology skill makes no mention of worktrees. It proceeds directly to modifying files after plan verification.

### Relevant Files

| File | Purpose | Key Lines |
|------|---------|-----------|
| skills/implement-methodology/SKILL.md | Implementation workflow | All 367 lines - no worktree mention |
| skills/git-worktrees/SKILL.md | Standalone worktree skill | 219-243 (conceptual RPI integration) |
| skills/finishing-work/SKILL.md | Work completion workflow | 145-171 (worktree cleanup) |

### Current State

1. **implement-methodology**: Focuses on plan verification, stakes enforcement, progress tracking, step execution with verification, and code/security review. Worktrees are not part of this workflow.

2. **git-worktrees**: Exists as an independent skill. Lines 219-243 describe "Integration with RPI Workflow" conceptually but this is documentation about intended usage, not actual integration code.

3. **finishing-work**: Has worktree cleanup procedures (lines 156-171) that handle cleanup "if work was done in a worktree" - but this assumes worktree was created manually beforehand.

### Existing Patterns

The git-worktrees skill already describes the intended integration pattern:

```text
Plan approved
→ Create worktree for implementation
→ Run setup in worktree
→ Verify baseline tests
→ Begin implementation in isolated environment
```

This pattern exists in documentation but is not implemented in the actual workflow.

### Gap Analysis

The implement-methodology skill should offer worktree creation after stakes assessment (around line 77-79) but before any code changes begin. This is where the workflow transitions from "verify plan exists" to "execute steps in order."

### Technical Constraints

- Worktree creation requires user decision (not all work needs isolation)
- Must work with stakes-based enforcement (higher stakes = stronger worktree recommendation)
- Must integrate with finishing-work skill's cleanup procedures
- Should detect existing worktrees to avoid duplicates

## Open Questions

1. Should worktree creation be mandatory for high-stakes changes?
2. Should the prompt vary based on stakes level (recommend vs merely offer)?
3. Should the implement skill detect if already running in a worktree and skip the prompt?

## Recommendations

Add worktree integration to implement-methodology skill at the point between plan verification (step 2) and progress tracking initialization (step 3):

1. After stakes-based enforcement, check if currently in a worktree
2. If not in a worktree, offer to create one
3. Adjust recommendation strength based on stakes level:
   - High stakes: "Recommended" - worktrees reduce risk
   - Medium stakes: Neutral option
   - Low stakes: Brief mention, no strong recommendation
4. If user chooses worktree, invoke git-worktrees skill
5. After worktree setup, continue with progress tracking in the new directory
