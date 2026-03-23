# Plan: markdownlint-config (2026-03-23)

## Summary

Create a `.markdownlint.json` configuration that enforces a 120-character line length limit (with tables and code blocks
excluded) across all markdown files in the repository. Rewrap files currently hard-wrapped at 80 characters to use the
new 120-character limit, rewrap unwrapped files (CHANGELOG.md, CLAUDE.md) to 120 characters, rewrap all existing
`docs/plans/` files to comply with the 120-character limit, and verify all files pass markdownlint with the new config.

## Stakes Classification

**Level**: Low
**Rationale**: Configuration and formatting changes only. No functional code is modified. All changes are easily
reviewable in diffs, and rollback is trivial (delete config files, revert rewrapping commits). The CI job already exists
and just needs its config updated.

## Context

**Research**: [docs/plans/2026-03-23-markdownlint-config-research.md](2026-03-23-markdownlint-config-research.md)
**Affected Areas**: Repository root config files, CI workflow, all markdown files including `docs/plans/`

### Key Decisions (from user)

- Line length limit: 120 characters
- Tables and code blocks: excluded from line length enforcement
- `docs/plans/` directory: included in linting (all markdown files must comply)
- `CHANGELOG.md`: reformat to 120 chars (do NOT exclude)
- `CLAUDE.md`: reformat to 120 chars
- Skills and agents: already mostly compliant, minor adjustments needed

## Success Criteria

- [ ] `.markdownlint.json` exists at repository root with MD013 configured for 120-char limit, code blocks and tables
      excluded
- [ ] No `.markdownlintignore` file is created (no files are excluded from linting)
- [ ] All markdown files in the repository have no prose lines exceeding 120 characters
- [ ] All `docs/plans/*.md` files are rewrapped to comply with the 120-char limit
- [ ] Tables and code blocks are left untouched regardless of line length
- [ ] `markdownlint-cli2` passes cleanly against all files with the new config
- [ ] CI workflow lints all markdown files (no `docs/plans/` exclusion)

## Implementation Steps

### Phase 1: Configuration Files

#### Step 1.1: Create `.markdownlint.json`

- **Files**: `.markdownlint.json` (new file)
- **Action**: Create the markdownlint configuration file at repository root with the following content:

  ```json
  {
    "default": true,
    "MD013": {
      "line_length": 120,
      "code_blocks": false,
      "tables": false
    },
    "MD024": { "siblings_only": true },
    "MD033": false,
    "MD041": false
  }
  ```

  Rule rationale (from research):
  - `MD013` with 120-char limit, code blocks and tables excluded per user decision
  - `MD024` siblings_only: allows duplicate headings in different sections (common in changelogs)
  - `MD033` disabled: inline HTML is used in some markdown files and is harmless
  - `MD041` disabled: frontmatter in skills/agents means the first line is not a heading
- **Verify**: File exists and is valid JSON
- **Complexity**: Small

#### Step 1.2: Verify CI workflow globs do not exclude `docs/plans/`

- **Files**: `.github/workflows/ci.yml`
- **Action**: Confirm the markdownlint globs do NOT exclude `docs/plans/`. The current globs should be:

  ```yaml
  globs: |
    **/*.md
    !.beads/**/*.md
  ```

  No changes needed if `docs/plans/` is not already excluded. If it is excluded, remove the exclusion.
- **Verify**: YAML is valid; `docs/plans/` files are included in linting
- **Complexity**: Small

### Phase 2: Rewrap Files Hard-Wrapped at 80 Characters *(parallel steps)*

These files are currently hard-wrapped at approximately 80 characters. Rewrap prose paragraphs to use the 120-character
limit. Tables, code blocks, headings, list items, and URLs must not be modified.

#### Step 2.1: Rewrap `README.md`

- **Files**: `README.md`
- **Current state**: Hard-wrapped at ~80 chars; max line 120 chars (a table row). Prose paragraphs are wrapped at 72-80
  chars.
- **Action**: Rewrap prose paragraphs to fill up to 120 characters. Do not touch tables, code blocks, mermaid diagrams,
  or list items that are already under 120 chars as a single line.
- **Verify**: `max line length <= 120` for all prose lines; tables/code blocks unchanged; content unchanged
- **Complexity**: Small

#### Step 2.2: Rewrap `CONTRIBUTING.md`

- **Files**: `CONTRIBUTING.md`
- **Current state**: Hard-wrapped at ~80 chars; max line 81 chars. Already nearly compliant.
- **Action**: Rewrap any prose paragraphs to fill up to 120 characters. Most content is short lists and code blocks
  that will not change.
- **Verify**: `max line length <= 120` for all prose lines; content unchanged
- **Complexity**: Small

#### Step 2.3: Rewrap `docs/architecture.md`

- **Files**: `docs/architecture.md`
- **Current state**: Hard-wrapped at ~80 chars; max line 107 chars (table row). Tables excluded from enforcement.
- **Action**: Rewrap prose paragraphs to fill up to 120 characters. Do not touch tables or mermaid code blocks.
- **Verify**: `max line length <= 120` for prose lines; tables/code blocks unchanged
- **Complexity**: Small

#### Step 2.4: Rewrap agent files

- **Files**: `agents/code-reviewer.md`, `agents/debugger.md`, `agents/file-finder.md`,
  `agents/security-reviewer.md`, `agents/test-runner.md`, `agents/verifier.md`, `agents/web-researcher.md`
- **Current state**: Wrapped at 79-82 chars. `test-runner.md` (99 chars) and `verifier.md` (100 chars) have some
  longer lines from table rows or structured output.
- **Action**: Rewrap prose paragraphs to fill up to 120 characters. Leave frontmatter, tables, and structured output
  format specifications untouched.
- **Verify**: All prose lines <= 120 chars; frontmatter and structured sections unchanged
- **Complexity**: Small

#### Step 2.5: Rewrap skill files wrapped at ~80 chars

- **Files**: All `skills/*/SKILL.md` files currently wrapped at ~80 chars:
  - `brainstorming`, `finishing-work`, `parallel-agents`, `receiving-code-review`, `security-review`,
    `synthesizing-research`, `systematic-debugging`, `verification-before-completion` (all max <= 80)
  - `test-driven-development` (max 84), `researching-codebase` (max 106), `reviewing-code` (max 92),
    `git-worktrees` (max 94), `implementing-plans` (max 94), `writing-plans` (max 94)
- **Current state**: Prose is hard-wrapped at approximately 80 characters. Some have table rows or code examples
  reaching 80-106 chars.
- **Action**: Rewrap prose paragraphs to fill up to 120 characters. Leave frontmatter, tables, code blocks, and
  structured examples untouched.
- **Verify**: All prose lines <= 120 chars; tables/code blocks unchanged; methodology content unchanged
- **Complexity**: Medium (14 files, but each is a straightforward rewrap)

### Phase 3: Rewrap Unwrapped Files *(parallel with Phase 2)*

These files have no consistent wrapping and contain lines far exceeding 120 characters.

#### Step 3.1: Rewrap `CHANGELOG.md`

- **Files**: `CHANGELOG.md`
- **Current state**: 18 lines exceed 120 chars; max line 260 chars. Bullet-point entries are unwrapped single lines.
- **Action**: Rewrap long bullet-point entries to 120 characters. Preserve the Keep a Changelog format: headings,
  version sections, and list structure must remain intact. Each bullet's continuation lines should be indented to align
  with the text after the `- ` prefix (2-space indent).<!-- markdownlint-disable-line MD038 -->
- **Verify**: No lines exceed 120 chars; changelog format and content unchanged; version sections intact
- **Complexity**: Small

#### Step 3.2: Rewrap `CLAUDE.md`

- **Files**: `CLAUDE.md`
- **Current state**: 5 lines exceed 120 chars; max line 363 chars. Dense prose paragraphs with no wrapping.
- **Action**: Rewrap prose paragraphs to 120 characters. Preserve code blocks, tables, and structured sections
  (architecture diagram, file listing). Leave the backtick-fenced code block content untouched.
- **Verify**: No lines exceed 120 chars; code blocks and structured content unchanged
- **Complexity**: Small

### Phase 4: Rewrap `docs/plans/` Files

All existing files in `docs/plans/` must be reformatted to comply with the 120-character line length limit.

#### Step 4.1: Rewrap all `docs/plans/*.md` files

- **Files**: All 28 markdown files in `docs/plans/`:
  - `2026-01-07-agents-expansion-plan.md`
  - `2026-01-07-skills-expansion-plan.md`
  - `2026-01-07-skills-expansion-research.md`
  - `2026-01-07-yyyy-mm-dd-artifact-naming-plan.md`
  - `2026-01-08-ci-checks-research.md`
  - `2026-01-08-ci-improvements-plan.md`
  - `2026-01-08-worktree-implement-integration-plan.md`
  - `2026-01-08-worktree-implement-integration-research.md`
  - `2026-01-13-git-worktrees-skill-comparison-plan.md`
  - `2026-01-13-git-worktrees-skill-comparison-research.md`
  - `2026-01-14-markdownlint-enforcement-plan.md`
  - `2026-01-14-markdownlint-enforcement-research.md`
  - `2026-02-13-architecture-docs-plan.md`
  - `2026-02-13-plugin-architecture-research.md`
  - `2026-02-16-plan-filename-consistency-plan.md`
  - `2026-02-16-plan-filename-consistency-research.md`
  - `2026-02-18-decision-command-design.md`
  - `2026-02-18-decision-command-plan.md`
  - `2026-03-11-claude-tools-integration-design.md`
  - `2026-03-11-claude-tools-integration-plan.md`
  - `2026-03-13-readme-release-gating-design.md`
  - `2026-03-23-skill-frontmatter-codebase.md`
  - `2026-03-23-skill-frontmatter-external.md`
  - `2026-03-23-skill-frontmatter-plan.md`
  - `2026-03-23-markdownlint-config-codebase.md`
  - `2026-03-23-markdownlint-config-external.md`
  - `2026-03-23-markdownlint-config-research.md`
  - `2026-03-23-markdownlint-config-plan.md` (this plan itself)
- **Current state**: Many files have lines exceeding 120 characters (some up to 400+ chars). These are a mix of
  research notes, design documents, and implementation plans with varying formatting.
- **Action**: Rewrap all prose paragraphs and bullet-point entries to 120 characters. Leave tables, code blocks,
  headings, and URLs untouched. For long URLs that exceed 120 characters on their own, leave them as-is (these are
  excluded by markdownlint when they contain no spaces to break on). Preserve the structure and content of each
  document.
- **Verify**: All prose lines <= 120 chars in every `docs/plans/` file; tables/code blocks unchanged; document
  content and structure preserved
- **Complexity**: Large (28 files, many with extensive content and long lines requiring careful rewrapping)

### Phase 5: Fix Skill Files Exceeding 120 Characters

#### Step 5.1: Fix `skills/documenting-decisions/SKILL.md`

- **Files**: `skills/documenting-decisions/SKILL.md`
- **Current state**: Max 128 chars. One line exceeds 120: a diagram/flow line using arrow characters.
- **Action**: Wrap or reformat the offending line. If it is inside a code block, it is already excluded from
  enforcement and no change is needed. Inspect and determine whether the line is prose or code block content.
- **Verify**: No prose lines exceed 120 chars
- **Complexity**: Small

#### Step 5.2: Fix `skills/research-plan-implement/SKILL.md`

- **Files**: `skills/research-plan-implement/SKILL.md`
- **Current state**: Max 410 chars. The `description` frontmatter field is a single long line.
- **Action**: Wrap the description frontmatter value using YAML folded scalar (`>`) syntax to keep it under 120 chars
  per line. Check for any other prose lines exceeding 120 chars and wrap them.
- **Verify**: No prose lines exceed 120 chars; frontmatter remains valid YAML; skill loads correctly
- **Complexity**: Small

### Phase 6: Verification

#### Step 6.1: Run markdownlint locally (if available) or verify with line-length check

- **Files**: All `*.md` files in the repository
- **Action**: Verify compliance using one of:
  1. `npx markdownlint-cli2 "**/*.md" "!.beads/**/*.md"` (if npx available)
  2. Shell check (single line):

     ```bash
     for f in $(find . -name '*.md' -not -path './.beads/*'); do awk -v f="$f" 'length > 120 && !/^\|/ && !/^```/ && !/^    / {print f ":" NR ": " length " chars"}' "$f"; done
     ```

  The shell check is an approximation (it excludes table rows starting with `|` and indented code blocks but cannot
  detect fenced code block interiors). The authoritative check is markdownlint in CI.
- **Verify**: Zero violations reported
- **Complexity**: Small

#### Step 6.2: Push and verify CI passes

- **Files**: `.github/workflows/ci.yml`
- **Action**: Push the changes and verify the `lint-markdown` CI job passes. If it fails, inspect the failure output
  and fix any remaining violations.
- **Verify**: CI `lint-markdown` job shows green checkmark
- **Complexity**: Small

## Test Strategy

### Automated Tests

This change has no unit or integration tests — it is a configuration and formatting change. Verification is performed
by the markdownlint CI job itself.

| Test Case | Type | Input | Expected Output |
| --------- | ---- | ----- | --------------- |
| markdownlint passes all files | CI | All `*.md` except `.beads/` | Zero violations |
| `docs/plans/` files pass linting | CI | All `docs/plans/*.md` files | Zero violations |
| Tables exceeding 120 chars are not flagged | CI | `docs/architecture.md` table rows | Zero violations |
| Code blocks exceeding 120 chars are not flagged | CI | Mermaid diagrams, shell examples | Zero violations |

### Manual Verification

- [ ] Spot-check that rewrapped files render identically on GitHub (no visual diff in rendered markdown)
- [ ] Verify `CHANGELOG.md` changelog format is preserved (version headers, bullet structure)
- [ ] Verify skill frontmatter with folded scalars (`>`) still loads correctly via `claude --plugin-dir`
- [ ] Verify `docs/plans/` files render correctly after rewrapping

## Risks and Mitigations

| Risk | Impact | Mitigation |
| ---- | ------ | ---------- |
| Rewrapping changes content meaning | Low — prose rewrapping is whitespace-only | Review diffs carefully; ensure no words are added/removed |
| YAML folded scalar in skill frontmatter breaks plugin loading | Medium — skill becomes unavailable | Test with `claude --plugin-dir` before pushing; the repo already uses `>` in other frontmatter (per CHANGELOG v0.6.1) |
| markdownlint flags violations we did not anticipate | Low — easy to fix | Run local check before pushing; fix any remaining violations |
| Future CHANGELOG entries regress to unwrapped lines | Low — ongoing maintenance | Document 120-char convention; AI-generated entries will need wrapping discipline |
| `docs/plans/` rewrapping is time-consuming | Low — formatting only | Can be done in parallel; no functional risk |
| Long URLs in `docs/plans/` research files cannot be broken | Low — markdownlint handles gracefully | URLs without breakable spaces are typically not flagged by MD013 |

## Rollback Strategy

Delete `.markdownlint.json` and revert any rewrapping commits. The previous state (no config file, no MD013
enforcement) is the implicit fallback. This is a single `git revert` of the implementation commit(s).

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
