# Research: Markdownlint Enforcement (2026-01-14)

## Problem Statement

Ensure all rpikit components that write markdown files validate them with
markdownlint before considering the task complete. This enforcement should
use both skill/instruction updates AND hook-based automation for
defense-in-depth.

## Requirements

- **Scope**: rpikit plugin only
- **Enforcement**: Dual approach (skill updates + hooks)
- **Configuration**: Use project-specific markdownlint config
- **Portability**: Self-contained - no dependencies on external skills

## Findings

### Relevant Files

| File | Purpose | Key Lines |
| ---- | ------- | --------- |
| `skills/writing-plans/SKILL.md` | Creates plan documents | 166-231 (template) |
| `skills/researching-codebase/SKILL.md` | Creates research documents | 140-186 (template) |
| `skills/brainstorming/SKILL.md` | Creates design documents | 114-140 (template) |
| `.markdownlint.json` | Linting rules | All |
| `.github/workflows/ci.yml` | CI validation | 35-47 |
| `.claude-plugin/plugin.json` | Plugin manifest | All |

### Components That Write Markdown

**Skills (create artifact files):**

1. `writing-plans` - Creates `docs/plans/YYYY-MM-DD-*-plan.md`
2. `researching-codebase` - Creates `docs/plans/YYYY-MM-DD-*-research.md`
3. `brainstorming` - Creates `docs/plans/YYYY-MM-DD-*-design.md`

**Agents (produce markdown output):**

1. `code-reviewer` - Review reports with Conventional Comments
2. `security-reviewer` - Security findings reports
3. `web-researcher` - Research findings with citations
4. `verifier` - Status reports

### Existing Patterns

**Current CI validation:**

- GitHub Actions runs `markdownlint-cli2-action@v19` on `**/*.md`
- Excludes `.beads/**/*.md`
- Validates at PR/push time only (not during authoring)

**Current markdownlint config:**

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

**Reference implementation (external):**

A global `markdown-quality` skill exists with patterns to adapt:

- Run markdownlint after EVERY markdown edit
- Fix ALL errors before proceeding
- No exceptions for "simple" changes

Note: Cannot depend on external skills for portability. rpikit must provide
its own implementation.

### Hook System Capabilities

Claude Code supports PostToolUse hooks for file validation:

**Key features:**

- `matcher: "Write|Edit"` targets file operations
- Exit code 2 blocks Claude until issues are fixed
- Hooks receive JSON with `tool_input.file_path`
- `${CLAUDE_PLUGIN_ROOT}` enables portable paths
- Multiple hooks run in parallel

**Hook placement:**

- `hooks/hooks.json` within plugin directory
- Scripts in `scripts/` directory

### Technical Constraints

**Markdownlint availability:**

- Not guaranteed to be installed in user's environment
- Hook scripts should gracefully degrade if not available
- CI has it installed; local development may not

**File type filtering:**

- Hooks fire for ALL Write/Edit operations
- Must filter to `.md` files only in validation script

## Recommendations

### Approach 1: Skill Updates (Instruction-Based)

Add markdownlint validation requirements to each skill that writes markdown.

#### Option A: Create dedicated rpikit skill (Recommended)

Create `skills/markdown-validation/SKILL.md` containing:

- Iron law: Always run markdownlint after writing markdown
- Workflow diagram showing edit-validate-fix loop
- Common rationalizations to reject
- Clear instructions to fix ALL errors

Then add validation step to each markdown-writing skill:

```markdown
## Validation

After writing the document, invoke `rpikit:markdown-validation` to validate.
```

Benefits:

- Self-contained within rpikit (portable)
- Single source of truth for validation methodology
- Consistent with rpikit's skill-based architecture

#### Option B: Inline validation in each skill

Add explicit validation section directly to each skill:

```markdown
### Final Step: Validate Markdown

Run `markdownlint <file>` and fix ALL errors before presenting to user.
```

Drawbacks:

- Duplicated instructions across skills
- Harder to maintain consistency

**Recommendation:** Option A - create dedicated `rpikit:markdown-validation`
skill for portability and maintainability.

### Approach 2: Hook-Based Automation (Safety Net)

Create PostToolUse hook that validates markdown files after writes:

**`hooks/hooks.json`:**

```json
{
  "description": "Enforce markdown quality on all written files",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/validate-markdown.sh",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

**`scripts/validate-markdown.sh`:**

```bash
#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Skip non-markdown files
[[ "$file_path" =~ \.(md|markdown)$ ]] || exit 0

# Skip if markdownlint not available
command -v markdownlint >/dev/null 2>&1 || {
  echo "Warning: markdownlint not installed, skipping validation"
  exit 0
}

# Run validation
output=$(markdownlint "$file_path" 2>&1) || {
  echo "Markdown validation failed:" >&2
  echo "$output" >&2
  exit 2  # Blocking error
}

echo "Markdown validated: $file_path"
exit 0
```

### Implementation Priority

1. **Create `rpikit:markdown-validation` skill** (foundation)
   - Create `skills/markdown-validation/SKILL.md`
   - Define iron law, workflow, and anti-patterns
   - Self-contained methodology for markdown quality

2. **Update markdown-writing skills** (high impact)
   - Add validation step to `writing-plans`
   - Add validation step to `researching-codebase`
   - Add validation step to `brainstorming`
   - Each invokes `rpikit:markdown-validation` after writing

3. **Hook automation** (safety net)
   - Create `hooks/hooks.json` configuration
   - Create `scripts/validate-markdown.sh` validation script
   - Provides automated enforcement as backup

4. **Agent output** (lower priority)
   - Agent output is typically inline, not file-based
   - Less critical than artifact files

## Open Questions

1. Should the hook require markdownlint or gracefully skip?
   (Recommendation: gracefully skip with warning)

2. Should we add a Stop hook to verify all markdown files pass before
   completing? (Recommendation: yes, for comprehensive enforcement)

3. Should agent-produced markdown be validated separately?
   (Recommendation: no, agent output is transient, not persisted files)
