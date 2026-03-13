# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

rpikit is a Claude Code plugin implementing the **Research-Plan-Implement (RPI)** framework. It enforces disciplined software engineering through structured workflows with human approval gates between phases.

## Architecture

See [docs/architecture.md](docs/architecture.md) for the full component model,
delegation map, and design principles.

```text
.claude-plugin/          # Plugin manifest (plugin.json, marketplace.json)
skills/                  # Methodology instructions (auto-register as slash commands)
  ├── research-plan-implement/SKILL.md
  ├── researching-codebase/SKILL.md
  ├── synthesizing-research/SKILL.md
  ├── writing-plans/SKILL.md
  └── implementing-plans/SKILL.md
agents/                  # Autonomous agents for specialized tasks
  ├── file-finder.md     # Locates files using systematic search
  └── web-researcher.md  # Conducts web research with citations
```

**Workflow:** `/rpikit:research-plan-implement` runs the full pipeline, or use individual skills:
`/rpikit:researching-codebase` → (approval) → `/rpikit:writing-plans` → (approval) → `/rpikit:implementing-plans`

## Changelog Rules

CHANGELOG.md tracks **plugin user-facing changes only** — features, skills, agents, commands, and behaviors that ship to users who install rpikit. Never log local development tooling, CI config, or repo-internal conveniences (e.g., local slash commands, dev scripts) as changelog entries.

## Documentation Requirements

**README.md is updated only during release prep — never between releases.** The README is the primary user-facing documentation and must match what marketplace users have installed. After changes that affect user-visible behavior, update CHANGELOG.md's `[Unreleased]` section instead. At release time, batch-update the README to reflect all accumulated changes.

Do NOT document implementation details (specific agents, internal patterns) in README — these change frequently and create maintenance burden.

## Key Patterns

- **Skills are the entry points** - Auto-registered from `skills/<name>/SKILL.md` as slash commands
- **Agents are reusable** - file-finder and web-researcher used across all phases
- **Output artifacts** - Research and plans written to `docs/plans/` in user's project

## Plugin Development Commands

```bash
# Test plugin locally (launches Claude Code with the plugin loaded)
claude --plugin-dir /path/to/rpikit

# Validate plugin structure (run from plugin directory)
claude plugin validate .

# Debug plugin loading issues
claude --plugin-dir /path/to/rpikit --debug

# View installed skills (from within Claude Code session)
/skills
```

**Development workflow:**

1. Make changes to plugin files
2. Restart Claude Code with `--plugin-dir` to reload
3. Test skills via `/rpikit:skill-name`
4. Use `--debug` flag to troubleshoot loading issues

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
