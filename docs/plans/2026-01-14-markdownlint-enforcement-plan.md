# Plan: Markdownlint Enforcement (2026-01-14)

## Summary

Implement dual-layer markdownlint enforcement for all rpikit components that
write markdown files. This includes creating a self-contained
`rpikit:markdown-validation` skill, updating existing markdown-writing skills
to invoke validation, and adding PostToolUse hooks as an automated safety net.

## Stakes Classification

**Level**: Medium
**Rationale**: Multiple files affected (4 skills + hooks), changes workflow
behavior, but easily testable and reversible. No architectural changes.

## Context

**Research**: `docs/plans/2026-01-14-markdownlint-enforcement-research.md`
**Affected Areas**:

- `skills/markdown-validation/` (new)
- `skills/writing-plans/SKILL.md`
- `skills/researching-codebase/SKILL.md`
- `skills/brainstorming/SKILL.md`
- `hooks/hooks.json` (new)
- `scripts/validate-markdown.sh` (new)

## Success Criteria

- [ ] New `rpikit:markdown-validation` skill exists and is self-contained
- [ ] `writing-plans` skill invokes validation after writing plan documents
- [ ] `researching-codebase` skill invokes validation after writing research
- [ ] `brainstorming` skill invokes validation after writing design documents
- [ ] PostToolUse hook validates `.md` files after Write/Edit operations
- [ ] All plugin markdown files pass `markdownlint`
- [ ] Plugin remains portable (no external skill dependencies)

## Implementation Steps

### Phase 1: Create Markdown Validation Skill

#### Step 1.1: Create skill directory and file

- **Files**: `skills/markdown-validation/SKILL.md` (new)
- **Action**: Create new skill with:
  - YAML frontmatter (name, description)
  - Iron law: Always run markdownlint after writing markdown
  - Workflow diagram showing edit-validate-fix loop
  - Red flags / rationalizations table
  - Clear instructions to fix ALL errors before proceeding
- **Verify**: File exists and passes `markdownlint`
- **Complexity**: Medium

### Phase 2: Update Markdown-Writing Skills

#### Step 2.1: Update writing-plans skill

- **Files**: `skills/writing-plans/SKILL.md:299-309`
- **Action**: Add validation section after "Quality Checklist" that invokes
  `rpikit:markdown-validation` skill after writing plan document
- **Verify**: Skill file passes `markdownlint`
- **Complexity**: Small

#### Step 2.2: Update researching-codebase skill

- **Files**: `skills/researching-codebase/SKILL.md:228-235`
- **Action**: Add validation section after "Key Principles" that invokes
  `rpikit:markdown-validation` skill after writing research document
- **Verify**: Skill file passes `markdownlint`
- **Complexity**: Small

#### Step 2.3: Update brainstorming skill

- **Files**: `skills/brainstorming/SKILL.md:263-273`
- **Action**: Add validation section after "Checklist Before Proceeding" that
  invokes `rpikit:markdown-validation` skill after writing design document
- **Verify**: Skill file passes `markdownlint`
- **Complexity**: Small

### Phase 3: Create Hook Automation

#### Step 3.1: Create hooks configuration

- **Files**: `hooks/hooks.json` (new)
- **Action**: Create PostToolUse hook configuration with:
  - Matcher for `Write|Edit` tools
  - Command hook calling validation script
  - 60 second timeout
- **Verify**: Valid JSON, follows Claude Code hook schema
- **Complexity**: Small

#### Step 3.2: Create validation script

- **Files**: `scripts/validate-markdown.sh` (new)
- **Action**: Create bash script that:
  - Reads JSON input from stdin
  - Extracts file path from `tool_input.file_path`
  - Skips non-markdown files (exit 0)
  - Gracefully skips if markdownlint not installed (warning + exit 0)
  - Runs markdownlint and exits 2 on failure (blocking)
  - Outputs success message on pass
- **Verify**: Script is executable, passes shellcheck
- **Complexity**: Small

### Phase 4: Validation

#### Step 4.1: Validate all plugin markdown files

- **Files**: All `*.md` files in plugin
- **Action**: Run `markdownlint **/*.md` and fix any failures
- **Verify**: Zero markdownlint errors
- **Complexity**: Small

#### Step 4.2: Test hook locally

- **Files**: Hook and script from Phase 3
- **Action**: Test script with sample JSON input simulating Write tool
- **Verify**: Script correctly validates markdown, skips non-markdown
- **Complexity**: Small

## Risks and Mitigations

| Risk | Impact | Mitigation |
| ---- | ------ | ---------- |
| markdownlint not installed in user env | Hook fails silently | Graceful degradation with warning message |
| Hook blocks on valid markdown | Frustrating UX | Test thoroughly before release |
| Skill invocation overhead | Slower workflows | Keep validation skill focused and fast |
| Breaking existing skill structure | Confusing users | Preserve existing sections, add at end |

## Rollback Strategy

1. Remove validation sections from skills (revert edits)
2. Delete `skills/markdown-validation/` directory
3. Delete `hooks/hooks.json` and `scripts/validate-markdown.sh`
4. No database or state changes to undo

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
