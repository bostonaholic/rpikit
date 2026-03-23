# Research: Markdownlint Config — Line Length (2026-03-23)

## Problem Statement

Configure markdownlint with an appropriate line length limit for this
repository. This requires understanding the current state of linting config,
what line lengths are actually in use, and what constraints exist from editor
and CI tooling.

## Scope

- Existing markdownlint configuration and CI integration
- Markdown file inventory and categories
- Current line length patterns across all file types
- Editor configuration
- npm/dev dependency landscape

---

## Findings

### 1. Existing Markdownlint Configuration

**No markdownlint config file exists in the repository.**

The following config file locations were checked — all absent:

- `.markdownlint.json`
- `.markdownlint.yaml`
- `.markdownlint-cli2.yaml`
- `.markdownlintrc`
- `package.json` (no file at all — no npm setup)

There is also no `.editorconfig` and no `.vscode/settings.json`.

**Historical note:** A `.markdownlint.json` existed previously with this
config:

```json
{
  "default": true,
  "MD013": false,
  "MD024": { "siblings_only": true },
  "MD033": false,
  "MD041": false,
  "MD060": false
}
```

This was removed in v0.8.0 (2026-03-19) along with the `markdown-validation`
skill, PostToolUse hook, and validation script. The CHANGELOG entry reads:
"markdown linting was too obtrusive during normal workflow."

The previous config set `"MD013": false`, which **disabled line-length
enforcement entirely**.

### 2. CI Integration

CI runs `markdownlint-cli2-action@v19` via GitHub Actions
(`.github/workflows/ci.yml`), with this glob config:

```yaml
globs: |
  **/*.md
  !.beads/**/*.md
```

Because there is no config file, markdownlint-cli2 falls back to its
**built-in defaults**. The markdownlint-cli2 default for MD013 is
`line_length: 80`, but the default markdownlint ruleset has MD013 **disabled**
in many preset contexts. Without a config file, the behavior depends on the
action's bundled defaults — in practice, `markdownlint-cli2-action` uses
markdownlint's default ruleset where MD013 is **enabled at 80 characters**.

This means CI is currently **either failing silently or the repo passes
because MD013 is not enforced by default in cli2**. Given that many files
have lines well over 80 characters and CI is apparently passing, MD013 is
likely not enforced in the current default config.

### 3. Markdown File Inventory

The repository contains markdown files in these categories:

| Category | Files | Examples |
| -------- | ----- | ------- |
| Root docs | 5 | `README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `CLAUDE.md`, `AGENTS.md` |
| Architecture | 1 | `docs/architecture.md` |
| Plan artifacts | ~30 | `docs/plans/YYYY-MM-DD-*.md` |
| Skills | 16 | `skills/*/SKILL.md` |
| Agents | 7 | `agents/*.md` |

Total: approximately 59 markdown files (excluding `.beads/` and `.claude/`
worktree copies).

### 4. Current Line Length Patterns

#### Maximum line lengths by file

| File | Max line length | Notes |
| ---- | --------------- | ----- |
| `CHANGELOG.md` | 260 chars | Prose bullet points, no hard wrap |
| `CLAUDE.md` | 363 chars | Dense prose paragraphs |
| `docs/plans/2026-03-23-skill-frontmatter-codebase.md` | 410 chars | Research artifact — dense prose |
| `docs/plans/2026-01-13-git-worktrees-skill-comparison-plan.md` | 358 chars | Plan artifact — prose descriptions |
| `README.md` | 120 chars | Mix of prose and tables |
| `docs/architecture.md` | 107 chars | Tables and mermaid diagrams |
| `skills/researching-codebase/SKILL.md` | 106 chars | Table rows |
| `skills/writing-plans/SKILL.md` | 94 chars | Mostly wrapped prose |
| `CONTRIBUTING.md` | 81 chars | Nearly all within 80 chars |
| `agents/file-finder.md` | 79 chars | Fully within 80 chars |

#### Distribution across sampled files (8 core files)

| Threshold | Lines exceeding |
| --------- | --------------- |
| > 80 chars | 90 lines |
| > 100 chars | 46 lines |
| > 120 chars | 23 lines |

#### What the long lines are

Long lines fall into distinct categories:

**Tables (cannot be wrapped — markdownlint MD013 exempts by default):**

```
| `/rpikit:research-plan-implement`   | End-to-end research, plan, and implement pipeline |
```
Width: 91 chars. Tables in `README.md`, `docs/architecture.md`, and skill
files routinely exceed 80 characters and cannot be hard-wrapped.

**Mermaid diagram nodes (inside fenced code blocks — MD013 exempts):**

```
    brainstorm["/rpikit:brainstorming"] -.->|optional| research["/rpikit:researching-codebase"]
```
Width: 95 chars. These appear in `README.md` and `docs/architecture.md` inside
` ```mermaid ` blocks.

**CHANGELOG bullet points (prose, not wrapped):**

```
- `researching-codebase` skill now uses the LSP tool (`goToDefinition`,
  `findReferences`, `documentSymbol`, `incomingCalls`/`outgoingCalls`) for
  deeper structural understanding...
```
The actual file has this as a single 259-character line. CHANGELOG entries are
consistently unwrapped prose, ranging 100–260 chars per bullet.

**CLAUDE.md and docs/plans prose paragraphs (unwrapped):**

CLAUDE.md contains paragraphs like:
```
**README.md is updated only during release prep — never between releases.**
The README is the primary user-facing documentation and must match what
marketplace users have installed...
```
This is a single 363-character line in the file.

**Skill and agent files:** Most prose in skills is wrapped at approximately
80 characters. `skills/writing-plans/SKILL.md` has a max of 94 chars
(one table row). `agents/file-finder.md` stays within 79 chars throughout.
The researching-codebase skill has 106-char table rows.

#### Hard-wrap evidence

`agents/file-finder.md` (max 79 chars) and `CONTRIBUTING.md` (max 81 chars)
show consistent hard-wrapping. These are the most carefully formatted files.

Skill files are mostly wrapped at 80 chars in prose sections, with occasional
table rows exceeding that limit.

CHANGELOG, CLAUDE.md, and docs/plans artifacts are **not hard-wrapped** —
these appear to be written without line-length discipline, likely because
they are AI-generated outputs.

### 5. Editor Config

No `.editorconfig` file exists. No `.vscode/settings.json` exists. There is
no project-level editor configuration of any kind.

### 6. npm / Dev Dependencies

No `package.json` exists in the repository. Markdownlint is not installed
as a local npm dependency. The only markdownlint integration is the GitHub
Actions CI job using `DavidAnson/markdownlint-cli2-action@v19`.

---

## Summary of Key Constraints

| Constraint | Detail |
| ---------- | ------ |
| No existing config | Must be created from scratch |
| No local markdownlint install | Config will only be validated in CI |
| CI uses markdownlint-cli2-action@v19 | Reads `.markdownlint.json` or `.markdownlint-cli2.yaml` |
| Tables widely used | MD013 must exempt tables (default behavior) |
| Code blocks widely used | MD013 must exempt code blocks (default behavior) |
| CHANGELOG has very long lines | 100–260 char bullet points throughout |
| CLAUDE.md has very long lines | Up to 363 chars; project-level config file |
| docs/plans artifacts unwrapped | AI-generated, lines up to 410 chars |
| Skills and agents are mostly wrapped | Within ~80–106 chars for prose |
| Previous config disabled MD013 | `"MD013": false` — enforcement was explicitly off |

---

## Recommendations Scaffold

The data supports these candidate line length values:

**Option A — Disable MD013 (status quo ante)**
Set `"MD013": false`. Zero violations. No enforcement.

**Option B — Permissive limit (120 chars)**
Prose in skills and agents is already within this range. Would require
reformatting CHANGELOG bullet points and CLAUDE.md/docs/plans paragraphs.
Tables and code blocks are exempt by default.

**Option C — Standard limit (80 chars) with exemptions**
Files already wrapped to 80 (agents, CONTRIBUTING) stay clean.
Would require reformatting nearly all CHANGELOG entries, CLAUDE.md paragraphs,
and many table-adjacent prose lines in README and architecture docs.
Aggressive but achievable for maintained files if docs/plans artifacts are
excluded.

**Key decision points for the plan:**
- Whether `docs/plans/` artifacts should be linted (AI-generated, long lines)
- Whether CHANGELOG entries should be wrapped (impacts readability in editors)
- Whether to exclude CLAUDE.md (project config file, not user-facing)
- Whether to configure `heading_length: false` and `table: false` explicitly
