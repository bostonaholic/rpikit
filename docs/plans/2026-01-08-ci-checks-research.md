# Research: CI Checks (2026-01-08)

## Problem Statement

Understand what checks the rpikit plugin runs in CI, to identify opportunities for adding new checks.

## Requirements

- Inventory all current CI checks
- Understand what each check validates
- Identify gaps where additional checks could be valuable

## Findings

### CI Pipeline Structure

The CI runs on GitHub Actions (`.github/workflows/ci.yml`) with **three parallel jobs**:

| Job | Purpose |
|-----|---------|
| `validate` | Plugin structure validation via `claude plugin validate` |
| `test` | Custom test suite validating agents, skills, commands |
| `lint-markdown` | Markdown formatting via markdownlint-cli2 |

### Relevant Files

| File | Purpose | Key Lines |
|------|---------|-----------|
| `.github/workflows/ci.yml` | CI workflow definition | 1-61 |
| `tests/run-tests.sh` | Test runner orchestrating all suites | 69-73 (suite calls) |
| `tests/test-plugin.sh` | Plugin manifest validation | 12-27 |
| `tests/test-agents.sh` | Agent file validation | 22-84 |
| `tests/test-skills.sh` | Skill directory validation | 22-87 |
| `tests/test-commands.sh` | Command file validation | 22-72 |
| `.markdownlint.json` | Markdown lint rules | 1-10 |

### What Each Check Validates

#### 1. Plugin Validation (`validate` job)

Runs `claude plugin validate .` which checks:

- `plugin.json` structure and required fields
- `marketplace.json` validity
- Component references exist

#### 2. Test Suite (`test` job)

**Agent tests** (`test-agents.sh`):

- Frontmatter exists and starts with `---`
- Required fields: `name`, `description`, `model`, `color`
- Model is valid (`haiku`, `sonnet`, `opus`, or `claude-*`)
- Has H1 heading
- Has substantive content (>5 non-empty lines)

**Skill tests** (`test-skills.sh`):

- `SKILL.md` exists in each skill directory
- Frontmatter with `name` and `description` fields
- `name` field matches directory name
- Has H1 heading
- Has substantive content (>10 non-empty lines)
- No unexpected files in skill directory

**Command tests** (`test-commands.sh`):

- Frontmatter with `description` field
- Has `disable-model-invocation: true` (recommended, skip if missing)
- References a `rpikit:` skill
- Has invocation instruction
- Is thin wrapper (<30 lines)

**Plugin tests** (`test-plugin.sh`):

- `claude plugin validate` passes without warnings

#### 3. Markdown Linting (`lint-markdown` job)

Uses markdownlint-cli2 with custom config:

- **Enabled**: All default rules
- **Disabled**: MD013 (line length), MD033 (HTML), MD041 (first line heading), MD060 (code fence language)
- **Modified**: MD024 (duplicate headings) - siblings only

Excludes `.beads/**/*.md` from linting.

### Gaps / Opportunities

| Category | Gap | Potential Check |
|----------|-----|-----------------|
| Scripts | Bash scripts not validated | shellcheck for `tests/*.sh`, `bin/*` |
| Links | Dead links not detected | markdown-link-check or lychee |
| Spelling | Typos not caught | cspell or similar |
| YAML | Frontmatter syntax not validated | yamllint on extracted frontmatter |
| Duplicates | Duplicate agent/skill names | Custom test to check uniqueness |
| Integration | Plugin behavior not tested | Load plugin in Claude Code and verify commands work |

### Technical Constraints

- CI uses Node.js 24 (for Claude Code CLI)
- Tests are bash scripts (not a testing framework)
- No package.json - pure bash/shell tooling
- Plugin is markdown-based (no JavaScript/TypeScript to lint)

## Open Questions

1. Is there value in adding shellcheck given the small number of scripts?
2. Should integration tests exist, or is manual testing sufficient?
3. Are there specific failure modes you've encountered that tests should catch?

## Recommendations

**Low effort, high value:**

1. **shellcheck** - Add validation for bash scripts (catches common errors)
2. **Link checking** - Ensure documentation links aren't broken

**Medium effort:**

1. **Spell checking** - Catch typos in user-facing content
2. **YAML validation** - Validate frontmatter syntax

**Higher effort:**

1. **Integration tests** - Actually load the plugin and verify commands work
