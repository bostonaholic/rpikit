# Research: Git Worktrees Skill Comparison (2026-01-13)

## Problem Statement

Compare the rpikit git-worktrees skill with the superpowers using-git-worktrees skill to identify gaps and combine the best elements of both into a superior rpikit version.

## Requirements

- Comprehensive review covering features, documentation, edge cases, and UX
- Identify gaps in rpikit that superpowers handles well
- Identify rpikit strengths to preserve
- Combine best elements into recommendations

## Findings

### Relevant Files

| File | Purpose | Key Lines |
|------|---------|-----------|
| skills/git-worktrees/SKILL.md | rpikit worktree skill | 330 lines |
| skills/implementing-plans/SKILL.md | Worktree integration in implement | 80-131 |
| skills/finishing-work/SKILL.md | Worktree cleanup | 156-171 |
| superpowers using-git-worktrees/SKILL.md | superpowers worktree skill | ~150 lines |
| superpowers finishing-a-development-branch/SKILL.md | superpowers cleanup integration | Step 5 |

### Feature Comparison Matrix

| Feature | rpikit | superpowers | Winner |
|---------|--------|-------------|--------|
| **Directory Selection Priority** | ✓ | ✓ | Tie |
| **Safety Verification** | Describes check | Provides exact bash command | superpowers |
| **Global Worktree Location** | "External location" generic | Specific `~/.config/superpowers/worktrees/` path | superpowers |
| **When to Use/Skip Guidance** | ✓ Detailed | ✗ Missing | rpikit |
| **Multi-language Setup** | Ruby, Node (all managers), Python, Rust, Go | Node, Rust, Python, Go | rpikit |
| **Worktree Management (list/remove/prune)** | ✓ Full section | ✗ Missing | rpikit |
| **External vs Local Pros/Cons** | ✓ Table format | ✗ Missing | rpikit |
| **Cleanup Checklist** | ✓ Pre-removal verification | ✗ Missing | rpikit |
| **Commands Reference** | ✓ Quick reference section | ✗ Missing | rpikit |
| **Quick Reference Table** | ✗ Missing | ✓ Situation → Action table | superpowers |
| **"Never Do These" Section** | Anti-patterns format | ✓ "Red Flags" format | superpowers |
| **Integration Documentation** | Prose in "Integration with RPI Workflow" | ✓ Explicit "Called by" / "Pairs with" | superpowers |
| **Example Workflow** | ✗ Missing | ✓ Actual session example | superpowers |

### Detailed Gap Analysis

#### Gaps in rpikit (from superpowers)

##### Gap 1: Missing actual git check-ignore command

rpikit says:

```text
Check .gitignore for:
- .worktrees/
- worktrees/
```

superpowers provides the actual command:

```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**Impact**: Without the exact command, AI may interpret "check .gitignore" inconsistently.

##### Gap 2: Missing specific global worktree location option

rpikit says:

```text
- External location (e.g., ~/worktrees/project-name/)
```

superpowers says:

```text
- `~/.config/superpowers/worktrees/<project-name>/` (global location)
```

**Impact**: The superpowers path integrates with the broader superpowers ecosystem. rpikit should have its own consistent path, perhaps `~/.config/rpikit/worktrees/<project-name>/`.

##### Gap 3: Missing quick reference decision table

superpowers has:

```markdown
| Situation | Action |
|-----------|--------|
| `.worktrees/` exists | Use it (verify ignored) |
| `worktrees/` exists | Use it (verify ignored) |
| Both exist | Use `.worktrees/` |
| Neither exists | Check CLAUDE.md → Ask user |
| Directory not ignored | Add to .gitignore + commit |
| Tests fail | Report failures + ask |
```

**Impact**: Easy quick-lookup format for common decisions.

##### Gap 4: Missing "Red Flags" section format

superpowers has explicit "Never Do These" list:

```markdown
- Create project-local worktree without verifying it's ignored
- Skip baseline test verification
- Proceed with failing tests without asking
- Assume directory location when ambiguous
- Skip CLAUDE.md check
```

**Impact**: More scannable than prose anti-patterns.

##### Gap 5: Missing explicit integration documentation format

superpowers uses:

```markdown
**Called by:** brainstorming (Phase 4 - REQUIRED) and any skill needing isolated workspace
**Pairs with:** finishing-a-development-branch (REQUIRED for cleanup)
```

**Impact**: Clear understanding of skill relationships without reading other skills.

##### Gap 6: Missing example workflow

superpowers shows actual session flow with user/assistant interaction.

**Impact**: Concrete visualization of expected behavior.

#### Strengths in rpikit (preserve these)

1. **"When to Use / Skip worktrees" section** - Clear guidance superpowers lacks
2. **Ruby/Gemfile support** - Language coverage superpowers misses
3. **npm/yarn/pnpm detection via lockfile** - More sophisticated than superpowers
4. **Worktree Management section** - Full lifecycle commands
5. **External vs Project-Local comparison table** - Helps users choose
6. **Cleanup Checklist** - Pre-removal verification prevents mistakes
7. **Commands Reference** - Quick lookup for git worktree commands

### Integration Comparison

| Integration Point | rpikit | superpowers |
|-------------------|--------|-------------|
| **Implementation phase** | ✓ Step 3 in implementing-plans skill | ✓ Called by executing-plans |
| **Cleanup phase** | ✓ finishing-work handles cleanup | ✓ finishing-a-development-branch handles cleanup |
| **Brainstorming** | ✗ Not integrated | ✓ Phase 4 calls worktrees |

**Gap**: rpikit brainstorming skill does not offer worktree creation. superpowers brainstorming Phase 4 explicitly calls using-git-worktrees.

### External Research

The superpowers plugin is maintained by Jesse Vincent (@obra) and represents a well-established Claude Code plugin with mature patterns. The explicit "Called by" / "Pairs with" format appears to be a deliberate design pattern for skill discoverability.

## Open Questions

1. Should rpikit adopt the `~/.config/rpikit/worktrees/` path convention for global worktrees?
2. Should the brainstorming skill offer worktree creation after design is validated?
3. Should the skill explicitly document what agents/skills call it?

## Recommendations

### Priority 1: Add missing technical precision

1. Add actual `git check-ignore` command for safety verification
2. Add specific global path option: `~/.config/rpikit/worktrees/<project-name>/`

### Priority 2: Add superpowers UX patterns

1. Add "Quick Reference" decision table
2. Convert anti-patterns to "Never Do These" red flags section
3. Add explicit "Integration" section with "Called by" / "Pairs with"
4. Add example workflow section

### Priority 3: Consider integration expansion

1. Consider adding worktree offer to brainstorming skill (after design validation)

### Summary: Changes Needed

| Section | Action |
|---------|--------|
| Safety Verification | Add exact `git check-ignore` command |
| Ask the User | Add `~/.config/rpikit/worktrees/<project-name>/` option |
| New: Quick Reference | Add situation → action decision table |
| Anti-Patterns | Reformat as "Never Do These" red flags |
| New: Integration | Add "Called by" / "Pairs with" documentation |
| New: Example Workflow | Add sample session flow |

### Sections to Preserve (rpikit advantages)

- When to Use / Skip worktrees
- Multi-language setup detection (especially Ruby, lockfile detection)
- Worktree Management section
- External vs Project-Local comparison
- Cleanup Checklist
- Commands Reference
