---
name: markdown-validation
description: >-
  Validates markdown files using markdownlint after writing or editing. Invoke
  this skill after creating or modifying any markdown file to ensure consistent
  formatting and zero linting violations.
---

# Markdown Validation

Validate markdown files after writing or editing them.

## Iron Law

**Always run markdownlint after writing markdown. Fix ALL errors before
proceeding.**

This is not optional. This is not negotiable. Markdown files that fail linting
create inconsistency and maintenance burden.

## Workflow

```text
Write/Edit markdown file
        │
        ▼
Run markdownlint on file
        │
        ▼
    ┌───────────┐
    │  Errors?  │
    └───────────┘
        │
   ┌────┴────┐
   │         │
   ▼         ▼
  Yes        No
   │         │
   ▼         ▼
Fix errors  Done
   │
   ▼
Re-run markdownlint
   │
   ▼
(repeat until no errors)
```

## Process

### 1. Run Validation

After writing or editing a markdown file, run:

```bash
markdownlint <file-path>
```

### 2. Interpret Results

**No output**: File passes validation. Proceed.

**Error output**: Fix each error before proceeding.

Common errors:

| Code  | Issue                       | Fix                              |
| ----- | --------------------------- | -------------------------------- |
| MD001 | Heading level increment     | Use sequential heading levels    |
| MD009 | Trailing spaces             | Remove trailing whitespace       |
| MD012 | Multiple blank lines        | Use single blank lines           |
| MD022 | Headings need blank lines   | Add blank line before/after      |
| MD031 | Fenced code needs blanks    | Add blank line before/after      |
| MD032 | Lists need blank lines      | Add blank line before/after list |
| MD034 | Bare URL                    | Use proper link syntax           |
| MD047 | No newline at end of file   | Add final newline                |

### 3. Fix Errors

For each error:

1. Read the error message and line number
2. Navigate to the specific location
3. Apply the fix
4. Re-run validation

**Do not proceed until all errors are fixed.**

### 4. Confirm Success

Only after markdownlint returns no errors:

```text
Markdown validation passed for <file-path>.
```

## Red Flags

These thoughts mean STOP - you are rationalizing:

| Thought                              | Reality                             |
| ------------------------------------ | ----------------------------------- |
| "It's just a small formatting issue" | Small issues compound into chaos    |
| "I'll fix it later"                  | Later never comes. Fix it now.      |
| "The content is correct"             | Correct content with bad format     |
|                                      | is still broken                     |
| "markdownlint is too strict"         | Consistency requires strictness     |
| "This file is temporary"             | All files deserve quality           |
| "I don't have time"                  | Fixing later takes more time        |
| "It's only one warning"              | One warning becomes ten             |

## Integration Points

This skill is invoked by:

- `rpikit:writing-plans` - After writing plan documents
- `rpikit:researching-codebase` - After writing research documents
- `rpikit:brainstorming` - After writing design documents
- PostToolUse hooks - Automatically after Write/Edit on `.md` files

## Requirements

**markdownlint must be installed.** Install via:

```bash
npm install -g markdownlint-cli
```

If markdownlint is not available, warn and proceed:

```text
Warning: markdownlint not installed. Skipping validation.
Consider installing: npm install -g markdownlint-cli
```

## Anti-Patterns

### Skipping Validation

**Wrong**: Writing markdown and moving on without checking
**Right**: Always run markdownlint after every markdown write/edit

### Partial Fixes

**Wrong**: Fixing some errors and ignoring others
**Right**: Fix ALL errors. Zero tolerance.

### Disabling Rules

**Wrong**: Adding disable comments to bypass errors
**Right**: Fix the underlying issue

### Batch Validation

**Wrong**: Writing many files then validating all at once
**Right**: Validate immediately after each file write/edit
