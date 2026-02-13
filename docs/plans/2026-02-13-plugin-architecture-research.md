# Research: Plugin Architecture (2026-02-13)

## Problem Statement

Create a high-level onboarding reference that maps the rpikit plugin
architecture: component types (agents, skills, commands), their roles, and
how they connect to form the RPI workflow.

## Requirements

- Bird's-eye view suitable for new contributors
- Cover all component types and their relationships
- Show how the RPI workflow flows through the components
- Keep it high-level, not implementation details

## Findings

### Plugin Identity

| Field       | Value                                                              |
| ----------- | ------------------------------------------------------------------ |
| Name        | rpikit                                                             |
| Version     | 0.4.0                                                              |
| Description | General-purpose software engineering framework (Research-Plan-Implement) |
| Author      | Matthew Boston                                                     |
| License     | MIT                                                                |

### Component Types

The plugin has four component types:

| Type      | Location                  | Count | Role                             |
| --------- | ------------------------- | ----- | -------------------------------- |
| Commands  | `commands/*.md`           | 6     | User-facing entry points         |
| Skills    | `skills/*/SKILL.md`       | 14    | Methodology instructions         |
| Agents    | `agents/*.md`             | 7     | Autonomous task performers       |
| Hooks     | `hooks/hooks.json`        | 1     | Automated quality enforcement    |

### Commands (Entry Points)

Commands are thin markdown wrappers with YAML frontmatter. Each immediately
delegates to a skill. All commands set `disable-model-invocation: true`.

| Command              | Delegates To             | Purpose                              |
| -------------------- | ------------------------ | ------------------------------------ |
| `/rpikit:research`   | researching-codebase     | Deep codebase exploration            |
| `/rpikit:plan`       | writing-plans            | Create implementation plans          |
| `/rpikit:implement`  | implementing-plans       | Execute approved plans               |
| `/rpikit:brainstorm` | brainstorming            | Explore ideas before research        |
| `/rpikit:review-code`    | reviewing-code       | Code quality and design review       |
| `/rpikit:review-security`| security-review       | Security vulnerability review        |

### Skills (Methodology)

Skills are self-contained methodology documents. They define how to perform
each activity and which agents to use.

**Core RPI workflow:**

| Skill                  | Phase     | Agents Used                            |
| ---------------------- | --------- | -------------------------------------- |
| researching-codebase   | Research  | file-finder, web-researcher            |
| writing-plans          | Plan      | file-finder, web-researcher            |
| implementing-plans     | Implement | file-finder, web-researcher, code-reviewer, security-reviewer |

**Design and review:**

| Skill          | Purpose                                     |
| -------------- | ------------------------------------------- |
| brainstorming  | Collaborative design exploration            |
| reviewing-code | Code review with Conventional Comments      |
| security-review| Security-focused vulnerability analysis     |

**Development discipline:**

| Skill                        | Purpose                               |
| ---------------------------- | ------------------------------------- |
| test-driven-development      | RED-GREEN-REFACTOR cycle enforcement  |
| systematic-debugging         | Root cause investigation before fixes |
| verification-before-completion | Evidence-based completion claims     |

**Workflow support:**

| Skill                  | Purpose                                  |
| ---------------------- | ---------------------------------------- |
| finishing-work         | Structured completion (merge, PR, push)  |
| receiving-code-review  | Verification-first response to feedback  |
| git-worktrees          | Isolated workspaces for parallel work    |
| parallel-agents        | Concurrent dispatch for independent tasks|
| markdown-validation    | Markdownlint enforcement with auto-fix   |

### Agents (Autonomous Performers)

Agents are specialized task performers with their own model and color
assignments. Skills invoke them via the Task tool.

| Agent             | Model  | Color   | Purpose                                |
| ----------------- | ------ | ------- | -------------------------------------- |
| file-finder       | haiku  | cyan    | Locate relevant files in the codebase  |
| web-researcher    | sonnet | magenta | Internet research with citations       |
| code-reviewer     | sonnet | blue    | Quality/design review (soft-gating)    |
| security-reviewer | sonnet | red     | Vulnerability analysis (hard-gating)   |
| test-runner       | haiku  | green   | Test execution and diagnostics         |
| debugger          | sonnet | orange  | Root cause investigation               |
| verifier          | haiku  | yellow  | Verification checks before completion  |

**Model selection pattern:** haiku for fast, mechanical tasks (file search,
test running, verification); sonnet for tasks requiring judgment (research,
review, debugging).

### How Components Connect

```text
User
  |
  v
Commands (thin wrappers)
  |
  v
Skills (methodology)
  |
  +---> Agents (autonomous task performers)
  |
  +---> Output artifacts (docs/plans/*.md)
```

**Core RPI flow:**

```text
/rpikit:research  -->  researching-codebase skill
                         |-> file-finder (locate files)
                         |-> web-researcher (external context)
                         |-> writes: docs/plans/YYYY-MM-DD-*-research.md
                         v
                    [user approval gate]
                         v
/rpikit:plan      -->  writing-plans skill
                         |-> file-finder (locate files)
                         |-> web-researcher (external dependencies)
                         |-> writes: docs/plans/YYYY-MM-DD-*-plan.md
                         v
                    [user approval gate]
                         v
/rpikit:implement -->  implementing-plans skill
                         |-> file-finder (locate target files)
                         |-> web-researcher (unfamiliar issues)
                         |-> code-reviewer (quality gate)
                         |-> security-reviewer (security gate)
                         |-> writes: implementation code
```

**Review flow (can be used at any point):**

```text
/rpikit:review-code     -->  reviewing-code skill
                               |-> code-reviewer agent
                               |-> flags security concerns for security-reviewer

/rpikit:review-security -->  security-review skill
                               |-> security-reviewer agent
```

### Infrastructure

**Hooks:** `hooks/hooks.json` defines a PostToolUse hook that runs
`scripts/validate-markdown.sh` after every Write or Edit operation,
enforcing markdown quality automatically.

**CI:** `.github/workflows/ci.yml` provides automated validation.

**Linting:** `.markdownlint.json` defines the markdown linting rules used by
both the hook and the markdown-validation skill.

### Relevant Files

| File                           | Purpose                         | Key Lines |
| ------------------------------ | ------------------------------- | --------- |
| `.claude-plugin/plugin.json`   | Plugin manifest                 | all       |
| `commands/*.md`                | 6 command entry points          | all       |
| `skills/*/SKILL.md`           | 14 skill methodologies          | all       |
| `agents/*.md`                  | 7 agent definitions             | all       |
| `hooks/hooks.json`             | PostToolUse markdown validation | all       |
| `scripts/validate-markdown.sh` | Markdown linting script         | all       |
| `.markdownlint.json`           | Linting configuration           | all       |

### Existing Patterns

1. **Commands are always thin** - frontmatter + one line delegating to a skill
2. **Skills own methodology** - all decision logic lives in skills, not
   commands or agents
3. **Agents are reusable** - file-finder and web-researcher used across
   multiple skills
4. **Model selection by task type** - haiku for mechanical, sonnet for judgment
5. **Output to docs/plans/** - research and plans written as dated markdown
6. **Human approval gates** - user reviews output between each RPI phase

### Dependencies

- Claude Code plugin system (commands, skills, agents, hooks)
- markdownlint (via `scripts/validate-markdown.sh`)
- GitHub CLI (`gh`) for releases

### Technical Constraints

- Commands must set `disable-model-invocation: true` in frontmatter
- Agent model choices limited to `haiku` and `sonnet`
- Hook scripts must complete within 60 second timeout
- Output artifacts go to `docs/plans/` in the user's project (not the plugin)

## Open Questions

None - the architecture is well-documented and consistent.

## Recommendations

This plugin follows a clean, layered architecture. The component
relationships are straightforward: commands delegate to skills, skills
orchestrate agents. The separation of concerns is clear and the naming
conventions are consistent.
