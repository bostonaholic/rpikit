# Contributing to rpikit

Thank you for your interest in contributing to rpikit! This document provides
guidelines for contributing to the project.

## Development Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/bostonaholic/rpikit
   cd rpikit
   ```

2. Test the plugin locally from any project:

   ```bash
   /plugin add /path/to/rpikit
   ```

3. Verify the plugin structure:

   ```bash
   /plugin validate rpikit
   ```

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

Run the test suite before submitting changes:

```bash
./tests/run-tests.sh
```

All tests must pass before merging.

## Pull Request Guidelines

1. **Clear description** - Explain what the change does and why
2. **Reference related issues** - Link to any related GitHub issues
3. **Keep changes focused** - One logical change per PR
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
commands/           # Entry points (thin wrappers)
skills/             # Methodology documentation
agents/             # Autonomous task executors
```

## Questions?

Open an issue for questions or discussions about contributing.
