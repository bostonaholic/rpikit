# Research: Markdownlint Config (2026-03-23)

## Problem Statement

Configure markdownlint with an appropriate line length limit for this
repository. The previous configuration explicitly disabled MD013 line-length
enforcement; the linting infrastructure was subsequently removed entirely in
v0.8.0. A new `.markdownlint.json` configuration file must be created from
scratch that balances CI enforcement, authoring practicality, and the actual
line length patterns present in the codebase.

## Requirements

- Must work with the existing `DavidAnson/markdownlint-cli2-action@v19` CI job
  (no local npm setup exists; enforcement is CI-only)
- Must not cause CI failures on content that cannot be wrapped (tables, code
  blocks, URLs)
- Should reflect current community best practices for documentation projects
- Should account for the distinct categories of markdown files in the repo:
  maintained skill/agent files vs. AI-generated artifacts (docs/plans,
  CHANGELOG)

---

## Findings

### Current Configuration State

No markdownlint configuration file exists in the repository. The previous
`.markdownlint.json` was removed in v0.8.0 (2026-03-19) along with the
`markdown-validation` skill. The CHANGELOG records the reason: "markdown
linting was too obtrusive during normal workflow."

The previous config set `"MD013": false`, which disabled line-length
enforcement entirely. The removal was therefore a full infrastructure cleanup,
not just a loosening of rules.

With no config file present, the CI job (`markdownlint-cli2-action@v19`)
falls back to built-in defaults. In practice, `markdownlint-cli2` does **not**
enable MD013 by default (the rule requires explicit configuration to activate),
so the repo currently passes CI without any line-length enforcement. This
should be confirmed before treating it as a hard constraint.

### Codebase Line Length Patterns

The repository contains approximately 59 markdown files across five categories:

| Category | Files | Line Length Behavior |
| -------- | ----- | -------------------- |
| Root docs (README, CHANGELOG, CLAUDE.md, etc.) | 5 | Mixed; CHANGELOG and CLAUDE.md have lines up to 363 chars |
| Architecture docs | 1 | Tables and mermaid diagrams; up to 107 chars |
| Plan artifacts (`docs/plans/`) | ~30 | AI-generated; lines up to 410 chars |
| Skills (`skills/*/SKILL.md`) | 16 | Mostly wrapped at ~80 chars; table rows up to 106 chars |
| Agents (`agents/*.md`) | 7 | Consistently wrapped; max ~79 chars |

Key observations:

- **Skills and agents are well-formatted.** `agents/file-finder.md` (max 79
  chars) and `CONTRIBUTING.md` (max 81 chars) show consistent hard-wrapping
  at 80 columns. Skill files are similarly disciplined in prose sections.
- **CHANGELOG is unwrapped.** Bullet points run 100–260 characters. These are
  AI-generated entries written without line-length discipline.
- **CLAUDE.md is unwrapped.** Project config file with lines up to 363 chars.
  Dense prose paragraphs not manually wrapped.
- **`docs/plans/` artifacts are unwrapped.** AI-generated research and plan
  files with lines up to 410 chars. These are transient artifacts, not
  maintained documentation.
- **Tables cannot be wrapped** regardless of configuration — markdownlint
  MD013 should exempt them (non-default; requires explicit `"tables": false`).
- **Code blocks cannot be arbitrarily wrapped** — mermaid diagram nodes and
  shell commands appear inside fenced blocks with lines up to 95 chars.

### MD013 Rule Mechanics

MD013 defaults (from the markdownlint specification):

| Parameter | Default | Notes |
| --------- | ------- | ----- |
| `line_length` | 80 | Applies to regular prose lines |
| `heading_line_length` | 80 | Applies to heading lines |
| `code_block_line_length` | 80 | Applies inside fenced code blocks |
| `code_blocks` | true | Whether the rule applies to code blocks |
| `tables` | true | Whether the rule applies to table cells |
| `headings` | true | Whether the rule applies to headings |
| `strict` | false | When true, removes the URL/no-whitespace exception |

By default, MD013 does **not** flag lines where there is no whitespace beyond
the limit. This exempts long URLs on their own lines without needing additional
configuration.

### External Best Practices

The community is broadly moving away from strict 80-character enforcement for
documentation projects:

- **Google Markdown Style Guide**: 80 characters
- **flowmark** (modern Markdown formatter): 88 characters (Black-inspired)
- **Common community configs**: 120 characters with code blocks and tables
  excluded
- **Many open source projects**: MD013 disabled entirely

The strongest arguments **for** some limit:

- Diff readability: 300-character prose lines make PR diffs noisy; it is hard
  to see what changed within a line
- Git blame granularity: shorter lines allow line-level blame attribution

The strongest arguments **against** strict enforcement:

- Markdown renderers (GitHub, GitLab, browsers) wrap prose automatically;
  hard line breaks in source have no effect on rendered output
- All major editors in 2026 support soft-wrap natively, removing the
  ergonomic argument for hard-wrapping
- Tables, URLs, mermaid diagrams, and code blocks routinely exceed 80 chars
  with no practical alternative

**Semantic Line Breaks (SemBr)** is the most technically coherent modern
approach: break after sentences and clauses rather than at a fixed column.
This preserves diff readability without arbitrary column enforcement. However,
it requires consistent authoring discipline that AI-generated content does
not provide.

### File Categories and Enforcement Suitability

| File Category | Suitable for Enforcement? | Notes |
| ------------- | ------------------------- | ----- |
| `skills/*/SKILL.md` | Yes | Already well-wrapped; designed for human authoring |
| `agents/*.md` | Yes | Fully within 80 chars; high quality |
| `README.md`, `CONTRIBUTING.md` | Yes | Already near-compliant |
| `docs/architecture.md` | Yes, with table/code exemptions | Tables and mermaid nodes exceed 80 |
| `CHANGELOG.md` | Problematic | Unwrapped; AI-generated; reformatting is disruptive |
| `CLAUDE.md` | Problematic | Project config; unwrapped prose up to 363 chars |
| `docs/plans/` | Problematic | AI-generated artifacts; lines up to 410 chars; transient |

---

## External Research

**MD013 community friction** is well-documented. Issue #179 ("Make MD013
default false") in the markdownlint repository has significant community
support. Scott Lowe's 2024 linting guide recommends disabling MD013 in favor
of editor soft-wrap. These are consistent signals that 80-char enforcement is
widely considered unworkable for documentation-heavy projects.
[Source: DavidAnson/markdownlint doc/md013.md; markdownlint issue #179;
Scott Lowe blog 2024]

**Diff readability** is the strongest remaining argument for a limit.
GitHub's diff view offers word-wrap toggling, and community requests for
native word-wrapping in diffs have significant traction — tooling is moving
toward accommodating long lines rather than requiring authors to hard-wrap.
[Source: GitHub community discussions #45559]

**Semantic Line Breaks** (sembr.org, specification updated through 2025) is
the approach best aligned with git-native workflows: break at sentence and
clause boundaries rather than at a column limit. The January 2025 blog post
"Semantic line breaks are a feature of Markdown, not a bug" is the canonical
modern argument for this approach.
[Source: sembr.org; writingslowly.com Jan 2025]

**120 characters** is the emerging pragmatic middle-ground for teams that want
some enforcement: wide enough to avoid constant friction with prose, URLs, and
tables; narrow enough to catch truly pathological lines. flowmark's 88-column
default reflects a similar compromise.
[Source: flowmark GitHub; common community configurations]

---

## Technical Constraints

1. **No local markdownlint install.** Configuration is only validated in CI
   via `DavidAnson/markdownlint-cli2-action@v19`. Changes to the config file
   are not testable locally without installing the tool separately.

2. **CI glob excludes `.beads/`** but lints everything else including
   `docs/plans/`, `CHANGELOG.md`, and `CLAUDE.md`.

3. **Table rows cannot be shortened.** Markdown table syntax requires cell
   content on a single line. Any limit applied to tables will generate
   violations that cannot be fixed without restructuring content.

4. **Mermaid diagram content is inside code blocks.** If `code_blocks` is set
   to `true` (the default), mermaid nodes will trigger violations that cannot
   be shortened without renaming skills.

5. **`docs/plans/` artifacts are AI-generated.** Retrofitting line wrapping
   would require manual editing of transient research documents with no
   user-facing value.

---

## Open Questions

1. **Does CI currently pass?** The assumption is that MD013 is not enabled by
   default in `markdownlint-cli2`, but this should be verified before assuming
   the current repo state is clean.

2. **Should `docs/plans/` be excluded from linting?** These are transient
   AI-generated artifacts. Adding them to the CI exclusion glob (alongside
   `.beads/`) would allow any limit to be applied to maintained files only.

3. **Should `CHANGELOG.md` be excluded or reformatted?** CHANGELOG entries
   are AI-generated and consistently unwrapped. Excluding it is the low-effort
   path; reformatting is disruptive and likely to regress with each new entry.

4. **Is CLAUDE.md in scope?** It is a project config file that users read but
   don't typically edit. Its long lines are a consequence of AI generation.

5. **Is the goal enforcement or documentation?** If the config exists purely
   to document conventions (with known exclusions), Option A (disable MD013)
   is sufficient. If CI enforcement is the goal, exclusions must be designed
   carefully.

---

## Recommendations

### Preferred: Permissive Limit with Targeted Exclusions

Create `.markdownlint.json` with:

- `"MD013"` configured with `line_length: 120`, `code_blocks: false`,
  `tables: false`
- Exclude `docs/plans/` from the CI glob (AI-generated artifacts with no
  value from enforcement)
- Either exclude `CHANGELOG.md` from the CI glob, or accept that CHANGELOG
  entries will need to be wrapped going forward

This provides:

- Enforcement on the files where it matters: skills, agents, README,
  architecture docs
- No violations for tables or code blocks (which cannot be wrapped)
- A meaningful (not trivial) limit that catches pathological long lines
- A clean migration path: skill and agent files already comply; README and
  architecture docs need minor cleanup

### Alternative: Disable MD013

Set `"MD013": false`. This restores the previous behavior exactly. Zero
violations. No enforcement. Appropriate if the sole goal is to re-establish
a config file for other MD rules while avoiding line-length friction.

### Not Recommended: 80-Character Strict Enforcement

Would require reformatting CHANGELOG, CLAUDE.md, all docs/plans artifacts,
and several README/architecture table rows. High effort, high regression risk
from AI-generated content, no rendering benefit for end users.

### Configuration Template (Preferred Option)

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

And update `.github/workflows/ci.yml` globs to exclude AI-generated artifacts:

```yaml
globs: |
  **/*.md
  !.beads/**/*.md
  !docs/plans/**/*.md
```

---

## Sources

| Document | Researcher | Focus Area |
| -------- | ---------- | ---------- |
| `docs/plans/2026-03-23-markdownlint-config-codebase.md` | file-finder agent | Existing config state, CI setup, file inventory, line length measurements |
| `docs/plans/2026-03-23-markdownlint-config-external.md` | web-researcher agent | MD013 rule mechanics, industry best practices, community consensus, SemBr |
