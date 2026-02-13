# Architecture

rpikit is a Claude Code plugin built on a layered component model. Commands
are user-facing entry points that delegate to skills. Skills contain
methodology instructions and orchestrate agents. Agents are autonomous task
performers. Hooks enforce quality automatically.

## Component Types

| Type     | Location            | Count | Role                         |
| -------- | ------------------- | ----- | ---------------------------- |
| Commands | `commands/*.md`     | 6     | User-facing entry points     |
| Skills   | `skills/*/SKILL.md` | 14    | Methodology instructions     |
| Agents   | `agents/*.md`       | 7     | Autonomous task performers   |
| Hooks    | `hooks/hooks.json`  | 1     | Automated quality enforcement|

## Commands

Commands are thin markdown wrappers with YAML frontmatter. Each immediately
delegates to a skill and does nothing else.

| Command                | Delegates To         | Purpose                            |
| ---------------------- | -------------------- | ---------------------------------- |
| `/rpikit:brainstorm`   | brainstorming        | Explore ideas before research      |
| `/rpikit:research`     | researching-codebase | Deep codebase exploration          |
| `/rpikit:plan`         | writing-plans        | Create implementation plans        |
| `/rpikit:implement`    | implementing-plans   | Execute approved plans             |
| `/rpikit:review-code`  | reviewing-code       | Code quality and design review     |
| `/rpikit:review-security` | security-review   | Security vulnerability review      |

## Skills

Skills are self-contained methodology documents that define how to perform
each activity and which agents to use.

### Core RPI Workflow

| Skill                | Phase     | Agents Used                                               |
| -------------------- | --------- | --------------------------------------------------------- |
| researching-codebase | Research  | file-finder, web-researcher                               |
| writing-plans        | Plan      | file-finder, web-researcher                               |
| implementing-plans   | Implement | file-finder, web-researcher, code-reviewer, security-reviewer |

### Design and Review

| Skill           | Purpose                                |
| --------------- | -------------------------------------- |
| brainstorming   | Collaborative design exploration       |
| reviewing-code  | Code review with Conventional Comments |
| security-review | Security-focused vulnerability analysis|

### Development Discipline

| Skill                          | Purpose                              |
| ------------------------------ | ------------------------------------ |
| test-driven-development        | RED-GREEN-REFACTOR cycle enforcement |
| systematic-debugging           | Root cause investigation before fixes|
| verification-before-completion | Evidence-based completion claims     |

### Workflow Support

| Skill                 | Purpose                                  |
| --------------------- | ---------------------------------------- |
| finishing-work        | Structured completion (merge, PR, push)  |
| receiving-code-review | Verification-first response to feedback  |
| git-worktrees         | Isolated workspaces for parallel work    |
| parallel-agents       | Concurrent dispatch for independent tasks|
| markdown-validation   | Markdownlint enforcement with auto-fix   |

## Agents

Agents are specialized task performers invoked by skills via the Task tool.
Each has a model assignment and color for terminal display.

| Agent             | Model  | Color   | Purpose                               |
| ----------------- | ------ | ------- | ------------------------------------- |
| file-finder       | haiku  | cyan    | Locate relevant files in the codebase |
| web-researcher    | sonnet | magenta | Internet research with citations      |
| code-reviewer     | sonnet | blue    | Quality/design review (soft-gating)   |
| security-reviewer | sonnet | red     | Vulnerability analysis (hard-gating)  |
| test-runner       | haiku  | green   | Test execution and diagnostics        |
| debugger          | sonnet | orange  | Root cause investigation              |
| verifier          | haiku  | yellow  | Verification checks before completion |

Model selection follows a pattern: **haiku** for fast, mechanical tasks
(file search, test running, verification) and **sonnet** for tasks requiring
judgment (research, review, debugging).

## How Components Connect

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

### Core RPI Flow

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

### Review Flow

Reviews can be used at any point, independent of the RPI phases:

```text
/rpikit:review-code     -->  reviewing-code skill --> code-reviewer agent
/rpikit:review-security -->  security-review skill --> security-reviewer agent
```

## Infrastructure

**Hooks**: `hooks/hooks.json` defines a PostToolUse hook that runs
`scripts/validate-markdown.sh` after every Write or Edit operation on
markdown files, enforcing formatting quality automatically.

**Linting**: `.markdownlint.json` defines the markdown linting rules used by
both the hook and the markdown-validation skill.

**CI**: `.github/workflows/ci.yml` provides automated validation on push and
pull requests.

## Design Principles

1. **Commands are always thin** - Frontmatter plus one line delegating to a
   skill. No methodology logic in commands.
2. **Skills own methodology** - All decision logic and instructions live in
   skills, not commands or agents.
3. **Agents are reusable** - file-finder and web-researcher are used across
   multiple skills rather than duplicated.
4. **Model selection by task type** - haiku for mechanical tasks, sonnet for
   judgment tasks.
5. **Output to docs/plans/** - Research and plans are written as dated
   markdown files in the user's project.
6. **Human approval gates** - Users review output between each RPI phase
   before the next phase begins.
