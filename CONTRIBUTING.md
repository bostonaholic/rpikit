# Contributing to rpikit

Thank you for your interest in contributing to rpikit! This document provides guidelines for contributing to the
project.

## Development Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/bostonaholic/rpikit
   cd rpikit
   ```

2. Install dependencies (activates Husky git hooks automatically):

   ```bash
   npm install
   ```

3. Launch Claude Code with the plugin loaded:

   ```bash
   bin/start
   # or: claude --plugin-dir /path/to/rpikit
   ```

4. Validate the plugin structure (from the plugin directory):

   ```bash
   claude plugin validate .
   ```

5. Debug plugin loading issues:

   ```bash
   claude --plugin-dir /path/to/rpikit --debug
   ```

**Git hooks (via Husky):**

- **Pre-commit**: markdownlint, shellcheck (fast checks)
- **Pre-push**: full test suite, plugin validation (full gate)

**Development workflow:**

- Make changes to plugin files
- Restart Claude Code with `--plugin-dir` to reload changes
- Test skills via `/rpikit:skill-name`
- Use `--debug` flag to troubleshoot loading issues

## Understanding the Architecture

Before making changes, read the [Architecture](docs/architecture.md) document. It explains how commands, skills, agents,
and hooks connect and the design principles behind the project.

## Making Changes

### For Non-Trivial Changes

Follow the RPI methodology that this plugin implements:

1. **Research first** - Understand the codebase before making changes
2. **Plan before coding** - Create an implementation plan for significant changes
3. **Implement with discipline** - Follow TDD and quality gates

### Documentation Requirements

**Always update README.md** when making changes that affect:

- Commands (adding, removing, renaming)
- Workflow or phase structure
- Output artifact locations or formats
- Installation instructions

This is a critical requirement per CLAUDE.md.

### Testing

The pre-push hook runs the test suite automatically, but you can run it
manually:

```bash
./tests/run-tests.sh
```

All tests must pass before merging.

## Contribution Guidelines

1. **Clear commit messages** - Explain what the change does and why
2. **Reference related issues** - Link to any related GitHub issues
3. **Keep changes focused** - One logical change per commit
4. **Update CHANGELOG.md** - Add your changes under `[Unreleased]`
5. **Ensure CI passes** - All GitHub Actions checks must pass

## Code Standards

### Commands

- Commands are thin wrappers that delegate to skills
- Use markdown frontmatter for metadata
- Include `disable-model-invocation: true`

### Skills

- Self-contained methodology in `skills/<name>/SKILL.md`
- Include verification criteria and anti-patterns
- Use agents for exploration tasks

### Agents

- Frontmatter defines: name, description, model, color
- Valid models: haiku, sonnet, opus
- Include structured output format specifications

## Component Conventions

Follow existing patterns:

```text
skills/             # Methodology documentation (auto-register as slash commands)
agents/             # Autonomous task executors
```

## Questions?

Open an issue for questions or discussions about contributing.
