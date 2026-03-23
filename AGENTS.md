# Agent Instructions

This file provides guidance to AI coding assistants when working with code in this repository.

## Project Overview

rpikit is a Claude Code plugin implementing the **Research-Plan-Implement (RPI)** framework. It enforces disciplined
software engineering through structured workflows with human approval gates between phases.

## Architecture & Components

See [docs/architecture.md](docs/architecture.md) for the full component model, skill/agent tables, delegation map,
and design principles.

**Workflow:** `/rpikit:research-plan-implement` runs the full pipeline, or use individual skills:
`/rpikit:researching-codebase` → (approval) → `/rpikit:writing-plans` → (approval) →
`/rpikit:implementing-plans`

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for setup commands, git hooks, development workflow, component conventions,
and releasing.

## Git Workflow

- **No pull requests.** Commits go directly to main locally.
- **No merge commits.** Always use squash or rebase to keep history linear.
  When integrating a worktree branch, decide: squash if the branch has
  messy/WIP commits, rebase if each commit is clean and meaningful.
- Branches may be created when using worktrees for isolation during development,
  but the end result is a squash or rebase onto main — never a merge commit.
- This facilitates agentic workflows that validate their own changes without
  requiring full code reviews.

## Changelog Rules

CHANGELOG.md tracks **plugin user-facing changes only** — features, skills, agents, commands, and behaviors that ship
to users who install rpikit. Never log local development tooling, CI config, or repo-internal conveniences (e.g., local
slash commands, dev scripts) as changelog entries.

## Documentation Requirements

**README.md is updated only during release prep — never between releases.** The README is the primary user-facing
documentation and must match what marketplace users have installed. After changes that affect user-visible behavior,
update CHANGELOG.md's `[Unreleased]` section instead. At release time, batch-update the README to reflect all
accumulated changes.

Do NOT document implementation details (specific agents, internal patterns) in README — these change frequently and
create maintenance burden.

## Stakes Classification

The framework uses stakes-based enforcement:

- **Low stakes**: Quick fixes, documentation, formatting
- **Medium stakes**: New functions, refactors, bug fixes
- **High stakes**: Architecture changes, security, data migrations

Higher stakes require more thorough planning and explicit approval.

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:ca08a54f -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

## Session Completion

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:

   ```bash
   git pull --rebase
   bd dolt push
   git push
   git status  # MUST show "up to date with origin"
   ```

5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**

- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
<!-- END BEADS INTEGRATION -->
