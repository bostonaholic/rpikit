# External Research: Markdown Line Length Best Practices (2026)

**Date:** 2026-03-23
**Purpose:** Research current best practices for markdown line length limits to inform markdownlint configuration
decisions.

---

## 1. markdownlint MD013 Rule

### Default Settings

The MD013 (`line-length`) rule in DavidAnson/markdownlint defaults to:

- `line_length`: **80** characters
- `heading_line_length`: 80 characters
- `code_block_line_length`: 80 characters
- `code_blocks`: true (rule applies to code blocks)
- `tables`: true (rule applies to tables)
- `headings`: true (rule applies to headings)
- `strict`: false
- `stern`: false

### Configuration Options

All configurable via `.markdownlint.json` or `.markdownlint.yaml`:

| Option | Type | Default | Behavior |
|---|---|---|---|
| `line_length` | int | 80 | Maximum length for regular lines |
| `heading_line_length` | int | 80 | Maximum length for heading lines |
| `code_block_line_length` | int | 80 | Maximum length for lines inside code blocks |
| `code_blocks` | bool | true | Whether the rule applies to code blocks at all |
| `tables` | bool | true | Whether the rule applies to table cells |
| `headings` | bool | true | Whether the rule applies to headings |
| `strict` | bool | false | When true, removes the URL/no-whitespace exception |
| `stern` | bool | false | When true, warns on fixable long lines but allows long lines with no spaces |

### The URL/No-Whitespace Exception

By default, MD013 does **not** flag a line if there is no whitespace beyond the configured limit. This allows long
URLs to appear on their own lines without triggering the rule. Setting `strict: true` removes this exception.

### Disabling the Rule

The most common real-world response to MD013 is to disable it entirely (`"MD013": false`) or set `line_length` to a
large value. The rule's GitHub issue tracker contains a well-known ticket titled "Make MD013 default false" with
significant community support, reflecting widespread friction with the 80-character default.

---

## 2. Common Line Length Choices

### Style Guide Survey

| Organization / Project | Line Length |
|---|---|
| Google Markdown Style Guide | 80 characters |
| Microsoft PowerShell docs | 100 (conceptual), 79 (about_ files) |
| flowmark (modern Markdown formatter) | 88 characters (Black-inspired) |
| Common community configurations | 120 (with code blocks excluded) |
| Many open source projects | MD013 disabled entirely |

### Arguments for 80 Characters

- Historical convention from terminal width (80-column TTY standard).
- Matches typical code line length, providing consistency across file types.
- Forces atomic commits: line-level changes in git diffs are cleaner.
- Side-by-side diff views in narrow terminals remain readable.

### Arguments for 100–120 Characters

- Most development happens on wide monitors (1080p–4K) where 80 columns is artificially narrow.
- Reduces unnecessary line breaks in prose that interrupt semantic flow.
- Matches broader industry drift (Python's Black uses 88, many style guides use 100–120).
- Long URLs, badge markdown, and reference links routinely exceed 80 characters without meaningful alternatives.

### Arguments for No Hard Limit (Soft-Wrap)

- Markdown renderers (GitHub, GitLab, VS Code preview, browsers) wrap text automatically; hard breaks in source have
  **no effect on rendered output**.
- Hard line breaks in paragraphs can render incorrectly in some Markdown flavors (GitHub once converted single
  newlines to `<br>` elements).
- Accessibility guidance increasingly recommends soft wrapping so that assistive technologies and responsive layouts
  control reflow.
- Modern editors (VS Code, Neovim, Helix) support soft-wrap natively, making fixed-column wrapping an editor concern
  rather than a source concern.

---

## 3. Modern Context Analysis

### GitHub and GitLab Rendering

Both platforms wrap prose automatically. A hard-wrapped paragraph renders identically to a soft-wrapped one in the
final HTML. There is **no rendering benefit** to enforcing a hard line limit in prose blocks. Hard breaks only matter
structurally if you intentionally use two spaces or `\` at line end for a `<br>`, or a blank line for a paragraph
break.

The GitHub community has open discussions about `pre-wrap` behavior and word wrapping in diff views. The conclusion is
that rendered markdown ignores hard wraps in paragraphs, making 80-column enforcement a source-code convention only.

### Diff Readability in PRs

This is the strongest practical argument **for** some line length limit. When a single sentence spans 300 characters
in one line and is edited, the entire line appears changed in the diff, making it hard to identify what changed.

However, **semantic line breaks** (see below) address this concern more precisely than arbitrary column limits.

GitHub's diff view on the web does offer word-wrap toggling. The community feature request for word-wrapping in diff
views has significant upvotes, indicating the tooling is moving toward accommodating long lines rather than requiring
authors to hard-wrap.

### Editor Soft-Wrap Capabilities (2026)

All major editors in 2026 support soft-wrap for Markdown:

- **VS Code**: `"editor.wordWrap": "on"` (or per-language override for Markdown)
- **Neovim/Vim**: `set wrap` with `linebreak`
- **Helix**: `:set soft-wrap.enable true`
- **JetBrains IDEs**: built-in soft-wrap toggle

Soft-wrap eliminates the ergonomic argument for hard wrapping. The argument "long lines are hard to read in an editor"
is resolved at the editor level, not the source level.

### Accessibility Considerations

Accessibility research cites an optimal line length of **40-100 characters** for rendered text. However, this applies
to the **rendered output** in a browser, not the Markdown source. Because renderers control reflow, the source line
length is irrelevant to end-user accessibility. What matters is that hard line breaks not be inserted inside semantic
units (sentences, phrases), as these can confuse screen readers if they accidentally create blank lines or `<br>`
elements.

### Prose vs. Code Blocks

There is broad consensus that **code blocks are different**:

- Code inside fenced blocks cannot be arbitrarily wrapped — it will break syntax.
- Shell commands, URLs, configuration examples, and import paths all have natural lengths.
- The standard practice is to set `code_block_line_length` higher (e.g., 120 or 200) or to set `code_blocks: false`
  entirely.

Prose paragraphs and headings are the primary area of debate.

---

## 4. Emerging Consensus and Recommendation

### Semantic Line Breaks (SemBr)

The most technically coherent modern approach is **Semantic Line Breaks** (sembr.org). The specification (updated
through 2025) recommends:

- Break after sentences (period, `!`, `?`).
- Break after independent clauses (comma, semicolon, colon, em dash).
- Break after dependent clauses when it clarifies structure.

This approach decouples line length from semantic intent. Each line contains "one unit of thought." The result:

- Git diffs show exactly which sentence changed.
- Source is readable without a column limit enforcing arbitrary breaks mid-sentence.
- Works with any renderer (GitHub, GitLab, static site generators).

The SemBr community blog post (January 2025) describes this as a feature of Markdown, not a bug, and argues it is the
most git-friendly authoring style for prose.

### What Popular Tooling Is Converging On

- **flowmark** (modern Markdown formatter, Python): defaults to 88 columns, explicitly citing Black's success with the
  "90-ish" compromise.
- **markdownlint community**: significant push to make MD013 `false` by default; many maintainers recommend disabling
  it for prose-heavy docs.
- **Scott Lowe's 2024 markdownlint guide**: recommends disabling MD013 in favor of editor soft-wrap.
- **DSC Community style guidelines**: recommend a limit but acknowledge that tables, URLs, and code blocks must be
  excluded.

### Summary Recommendation

For a **documentation or plugin project** (not a code repository):

| Context | Recommendation |
|---|---|
| Prose paragraphs | No hard limit, or adopt Semantic Line Breaks |
| Headings | No hard limit (headings are already concise by convention) |
| Code blocks | Exempt from line length entirely (`code_blocks: false`) |
| Tables | Exempt from line length entirely (`tables: false`) |
| URLs / badges | Exempt by default via the no-whitespace exception |

If a numeric limit is required (e.g., for CI enforcement consistency), **120 characters** is the emerging pragmatic
choice: wide enough to avoid constant friction with prose and URLs, narrow enough to catch truly pathological long
lines.

The strongest argument **against** disabling MD013 entirely is diff readability: very long prose lines create noisy
diffs. Semantic line breaks solve this more precisely, but require authoring discipline. A relaxed limit (120+) with
`code_blocks: false` and `tables: false` is a reasonable middle ground for teams not ready to adopt SemBr fully.

---

## Sources

- [DavidAnson/markdownlint — doc/md013.md](https://github.com/DavidAnson/markdownlint/blob/main/doc/md013.md)
- [markdownlint/markdownlint — RULES.md](https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md)
- [Make MD013 default false · Issue #179](https://github.com/markdownlint/markdownlint/issues/179)
- [Restricting line length (MD013) pointless · Issue #114](https://github.com/markdownlint/markdownlint/issues/114)
- [Google Markdown Style Guide](https://google.github.io/styleguide/docguide/style.html)
- [Microsoft PowerShell Markdown best practices][ps-markdown]
- [Semantic Line Breaks specification — sembr.org](https://sembr.org)
- [Semantic line breaks are a feature of Markdown, not a bug (Jan 2025)][sembr-blog]
- [Semantic Line Breaks Debate — BigGo News (Sep 2025)][sembr-debate]
- [flowmark — Modern Markdown formatter with smart line wrapping](https://github.com/jlevy/flowmark)
- [Hard vs. Soft Line Wrap — Martin Ueding](https://martin-ueding.de/posts/hard-vs-soft-line-wrap/)
- [4 + 1 wrapping styles for Markdown prose and code comments — Matias Kinnunen][wrapping-styles]
- [Remove hard line breaks from READMEs — Marijke Luttekes (Dec 2024)][remove-hardbreaks]
- [Linting your Markdown Files — Scott Lowe (Mar 2024)][linting-md]
- [Word wrapping in GitHub diff views — community discussion](https://github.com/orgs/community/discussions/45559)
- [Exploring Guidelines for Line Length in Markdown — MDN discussion #655][mdn-discussion]
- [Wrapping Code Comments — matklad (Feb 2026)](https://matklad.github.io/2026/02/21/wrapping-code-comments.html)
- [GitLab: To Wrap or Not to Wrap (2016, still cited)](https://about.gitlab.com/blog/2016/10/11/wrapping-text/)
- [PyMarkdown Rule MD013 documentation](https://pymarkdown.readthedocs.io/en/latest/plugins/rule_md013/)

[ps-markdown]: https://learn.microsoft.com/en-us/powershell/scripting/community/contributing/general-markdown?view=powershell-7.5
[sembr-blog]: https://writingslowly.com/2025/01/13/semantic-line-breaks-are-a.html
[sembr-debate]: https://biggo.com/news/202509110723_Semantic_Line_Breaks_Debate
[wrapping-styles]: https://mtsknn.fi/blog/4-1-wrapping-styles-for-markdown-prose-and-code-comments/
[remove-hardbreaks]: https://marijkeluttekes.dev/blog/articles/2024/12/05/remove-hard-line-breaks-from-readmes/
[linting-md]: https://blog.scottlowe.org/2024/03/01/linting-your-markdown-files/
[mdn-discussion]: https://github.com/orgs/mdn/discussions/655
