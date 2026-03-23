# Agent Instructions

This file provides guidance to AI coding assistants when working with code in this repository.

## Project Overview

rpikit is a Claude Code plugin implementing the **Research-Plan-Implement (RPI)** framework. It enforces disciplined
software engineering through structured workflows with human approval gates between phases.

## Architecture

See [docs/architecture.md](docs/architecture.md) for the full component model,
delegation map, and design principles.

```text
.claude-plugin/          # Plugin manifest (plugin.json, marketplace.json)
skills/                  # Methodology instructions (auto-register as slash commands)
  ├── research-plan-implement/SKILL.md   # Full RPI pipeline orchestrator
  ├── researching-codebase/SKILL.md      # Codebase exploration and understanding
  ├── synthesizing-research/SKILL.md     # Consolidate parallel research findings
  ├── writing-plans/SKILL.md             # Transform research into implementation plans
  ├── implementing-plans/SKILL.md        # Disciplined plan execution
  ├── brainstorming/SKILL.md             # Collaborative design before research
  ├── finishing-work/SKILL.md            # Completion workflow (merge, PR, cleanup)
  ├── git-worktrees/SKILL.md             # Isolated workspace creation
  ├── parallel-agents/SKILL.md           # Concurrent agent dispatch
  ├── receiving-code-review/SKILL.md     # Evaluate review feedback rigorously
  ├── reviewing-code/SKILL.md            # Code quality review methodology
  ├── security-review/SKILL.md           # Security vulnerability review
  ├── systematic-debugging/SKILL.md      # Root cause investigation
  ├── test-driven-development/SKILL.md   # RED-GREEN-REFACTOR discipline
  ├── verification-before-completion/SKILL.md  # Evidence-before-claims enforcement
  └── documenting-decisions/SKILL.md     # Record decisions as ADRs
agents/                  # Autonomous agents for specialized tasks
  ├── file-finder.md       # Locates files using systematic search
  ├── web-researcher.md    # Conducts web research with citations
  ├── code-reviewer.md     # Reviews implementation changes for quality
  ├── security-reviewer.md # Reviews changes for vulnerabilities
  ├── debugger.md          # Investigates errors to find root cause
  ├── test-runner.md       # Executes tests in isolated worktree
  └── verifier.md          # Runs verification checks before completion
```

**Workflow:** `/rpikit:research-plan-implement` runs the full pipeline, or use individual skills:
`/rpikit:researching-codebase` → (approval) → `/rpikit:writing-plans` → (approval) →
`/rpikit:implementing-plans`

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

## Key Patterns

- **Skills are the entry points** - Auto-registered from `skills/<name>/SKILL.md` as slash commands
- **Agents are reusable** - specialized agents used across phases (file-finder, web-researcher, code-reviewer,
  security-reviewer, debugger, test-runner, verifier)
- **Output artifacts** - Research and plans written to `docs/plans/` in user's project

## Plugin Development Commands

```bash
# Install dependencies and activate git hooks (required after clone)
npm install

# Test plugin locally (launches Claude Code with the plugin loaded)
bin/start
# or: claude --plugin-dir /path/to/rpikit

# Validate plugin structure (run from plugin directory)
claude plugin validate .

# Debug plugin loading issues
claude --plugin-dir /path/to/rpikit --debug

# View installed skills (from within Claude Code session)
/skills
```

**Git hooks (via Husky, activated by `npm install`):**

- **Pre-commit**: markdownlint, shellcheck (fast checks)
- **Pre-push**: full test suite, plugin validation (full gate)

**Development workflow:**

1. Run `npm install` after cloning (one-time, activates hooks)
2. Make changes to plugin files
3. Restart Claude Code with `bin/start` to reload
4. Test skills via `/rpikit:skill-name`
5. Use `--debug` flag to troubleshoot loading issues

## Releasing

When releasing a new version:

1. Update README.md to reflect all changes listed in CHANGELOG.md `[Unreleased]`
2. Update version in `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
3. Move CHANGELOG.md unreleased section to new version with date
4. Commit with message `chore(release): X.Y.Z`
5. Create git tag: `git tag -a vX.Y.Z -m "Release X.Y.Z"`
6. Push with tags: `git push origin main --tags`
7. Create GitHub release: `gh release create vX.Y.Z --title "vX.Y.Z" --notes "..."`

GitHub releases: <https://github.com/bostonaholic/rpikit/releases>

## Component Conventions

**Skills** (in `skills/<name>/SKILL.md`):

- Self-contained methodology documentation
- Use agents (file-finder, web-researcher) for exploration
- Include verification criteria and anti-patterns

**Agents** (in `agents/`):

- Frontmatter defines: name, description, model (haiku/sonnet), color
- Include structured output format specifications
- Document search strategies and failure handling

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
