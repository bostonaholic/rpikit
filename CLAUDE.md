# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

rpikit is a Claude Code plugin implementing the **Research-Plan-Implement (RPI)** framework. It enforces disciplined software engineering through structured workflows with human approval gates between phases.

## Architecture

```text
.claude-plugin/          # Plugin manifest (plugin.json, marketplace.json)
commands/                # Entry points that delegate to skills
  ├── research.md        # /rpikit:research command
  ├── plan.md            # /rpikit:plan command
  └── implement.md       # /rpikit:implement command
skills/                  # Detailed methodology instructions
  ├── researching-codebase/SKILL.md
  ├── writing-plans/SKILL.md
  └── implementing-plans/SKILL.md
agents/                  # Autonomous agents for specialized tasks
  ├── file-finder.md     # Locates files using systematic search
  └── web-researcher.md  # Conducts web research with citations
```

**Workflow:** `/rpikit:research` → (approval) → `/rpikit:plan` → (approval) → `/rpikit:implement`

## Documentation Requirements

**CRITICAL: Always update README.md.** The README is the primary user-facing documentation and MUST stay synchronized with the codebase. After ANY change that affects user-visible behavior, update README.md in the same commit. This includes:

- Commands (adding, removing, renaming)
- Workflow or phase structure
- Output artifact locations or formats
- Installation instructions

Do NOT document implementation details (specific agents, internal patterns) in README - these change frequently and create maintenance burden.

Never leave README.md out of sync. An outdated README misleads users and undermines trust in the project.

## Key Patterns

- **Commands are thin wrappers** - They delegate to skills via `Skill tool invoke: skill-name`
- **Skills contain methodology** - Detailed instructions in `skills/<name>/SKILL.md`
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
3. Test commands via `/rpikit:command-name`
4. Use `--debug` flag to troubleshoot loading issues

## Releasing

When releasing a new version:

1. Update version in `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
2. Move CHANGELOG.md unreleased section to new version with date
3. Commit with message `chore(release): X.Y.Z`
4. Create git tag: `git tag -a vX.Y.Z -m "Release X.Y.Z"`
5. Push with tags: `git push origin main --tags`
6. Create GitHub release: `gh release create vX.Y.Z --title "vX.Y.Z" --notes "..."`

GitHub releases: <https://github.com/bostonaholic/rpikit/releases>

## Component Conventions

**Commands** (in `commands/`):

- Use markdown frontmatter for metadata
- Should be minimal - delegate to skills immediately
- Arguments passed via `$ARGUMENTS` variable

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
