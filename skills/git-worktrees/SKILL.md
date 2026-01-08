---
name: git-worktrees
description: >-
  Isolated workspace creation for parallel development work. Use when starting
  feature work that needs isolation from the current workspace. Creates git
  worktrees with proper setup and safety verification.
---

# Git Worktrees

Create isolated workspaces for parallel development without disrupting
current work.

## Purpose

Git worktrees allow multiple branches to be checked out simultaneously in
separate directories. This enables parallel work without stashing, context
switching, or polluting the main workspace. This skill provides structured
worktree creation with safety verification.

## When to Use

Use worktrees when:

- Starting feature work that shouldn't affect main workspace
- Working on multiple features in parallel
- Testing changes in isolation
- Running long processes while continuing other work
- Reviewing PRs without disrupting current work

Skip worktrees when:

- Quick single-file fixes
- Changes that don't need isolation
- The main workspace is already clean

## Directory Selection Priority

When creating worktrees, check these locations in order:

### 1. Check for Existing Worktree Directory

```text
Look for:
- .worktrees/ (hidden, preferred)
- worktrees/ (visible)

If both exist, prefer .worktrees/
```

### 2. Check Project Configuration

```text
Look in CLAUDE.md or project documentation for:
- Stated worktree location preference
- Project-specific conventions
```

### 3. Ask the User

If no preference found:

```text
"Where should worktrees be created?"
- .worktrees/ (project-local, hidden)
- worktrees/ (project-local, visible)
- External location (e.g., ~/worktrees/project-name/)
```

## Safety Verification

**Critical for project-local worktrees:**

Before creating a worktree in `.worktrees/` or `worktrees/`:

```text
MUST verify directory is ignored in git.

Check .gitignore for:
- .worktrees/
- worktrees/
```

**If NOT ignored:**

```text
1. Add to .gitignore
   echo ".worktrees/" >> .gitignore
   (or "worktrees/" depending on choice)

2. Commit the change
   git add .gitignore
   git commit -m "Add worktree directory to .gitignore"

3. Then proceed with worktree creation
```

**Why this matters:** Accidentally committing worktree contents creates
massive, confusing commits with duplicate code.

## Worktree Creation Process

### Step 1: Detect Project Information

```text
Get project name: basename $(git rev-parse --show-toplevel)
Get current branch: git branch --show-current
Get default branch: git symbolic-ref refs/remotes/origin/HEAD
```

### Step 2: Create Worktree

For new feature branch:

```bash
git worktree add <worktree-path> -b <branch-name>
```

For existing branch:

```bash
git worktree add <worktree-path> <existing-branch>
```

From specific base:

```bash
git worktree add <worktree-path> -b <branch-name> origin/main
```

### Step 3: Auto-Detect and Run Setup

Detect project type and run appropriate setup:

```text
If package.json exists:
  npm install (or yarn, pnpm based on lockfile)

If Cargo.toml exists:
  cargo build

If requirements.txt exists:
  pip install -r requirements.txt (in venv if present)

If Gemfile exists:
  bundle install

If go.mod exists:
  go mod download
```

### Step 4: Run Baseline Tests

Verify clean state before starting work:

```bash
# Run project test command
npm test / cargo test / pytest / etc.
```

**If tests fail:**

```text
"Baseline tests fail in the new worktree.

This could mean:
- Missing dependencies
- Environment configuration needed
- Pre-existing failures on the base branch

Options:
- Investigate and fix (recommended)
- Proceed anyway (acknowledge failures exist)
- Abort worktree creation"
```

### Step 5: Report Ready State

```text
"Worktree created and ready:

Location: <worktree-path>
Branch: <branch-name>
Base: <base-branch>
Tests: <pass/fail status>

To work in this worktree:
cd <worktree-path>

To return to main workspace:
cd <main-repo-path>"
```

## Worktree Management

### List Worktrees

```bash
git worktree list
```

### Remove Worktree

```bash
# From main repository
git worktree remove <worktree-path>

# If worktree has changes, force removal
git worktree remove --force <worktree-path>
```

### Prune Stale Worktrees

```bash
# Remove worktrees whose directories no longer exist
git worktree prune
```

## Integration with RPI Workflow

### With Plan Phase

When planning involves isolated implementation:

```text
Plan approved
→ Create worktree for implementation
→ Run setup in worktree
→ Verify baseline tests
→ Begin implementation in isolated environment
```

### With Finishing Work

After implementation in worktree:

```text
Implementation complete
→ Use finishing-work skill
→ If merging locally: cleanup worktree
→ If creating PR: keep worktree for review cycle
→ If discarding: cleanup worktree
```

## External vs Project-Local Worktrees

### Project-Local (in .worktrees/ or worktrees/)

**Pros:**

- Everything in one place
- Easy to find related work
- Cleans up with project deletion

**Cons:**

- Must ensure directory is gitignored
- Uses project disk space

### External (e.g., ~/worktrees/project-name/)

**Pros:**

- No gitignore management needed
- Separate from project structure
- Can survive project directory changes

**Cons:**

- Scattered across filesystem
- May forget to clean up

## Anti-Patterns

### Skipping Ignore Verification

**Wrong**: Create project-local worktree without checking .gitignore
**Right**: Always verify gitignore before creating project-local worktrees

### Skipping Setup

**Wrong**: Start working without running npm install / cargo build / etc.
**Right**: Run appropriate setup for project type

### Not Running Baseline Tests

**Wrong**: Assume worktree is ready without verification
**Right**: Run tests to establish clean baseline

### Forgetting to Clean Up

**Wrong**: Leave stale worktrees indefinitely
**Right**: Remove worktrees after work is merged or abandoned

### Creating Too Many Worktrees

**Wrong**: New worktree for every small change
**Right**: Worktrees for substantial, isolated work

## Cleanup Checklist

Before removing a worktree:

- [ ] Work is merged or intentionally abandoned
- [ ] No uncommitted changes (or explicitly discarded)
- [ ] Branch is deleted (if work was merged)
- [ ] No running processes in the worktree

## Commands Reference

```bash
# Create worktree with new branch
git worktree add <path> -b <new-branch> <base>

# Create worktree with existing branch
git worktree add <path> <existing-branch>

# List all worktrees
git worktree list

# Remove worktree
git worktree remove <path>

# Force remove (with uncommitted changes)
git worktree remove --force <path>

# Prune stale entries
git worktree prune
```
