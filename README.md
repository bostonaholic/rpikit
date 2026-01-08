# rpikit

A plugin implementing the **Research-Plan-Implement (RPI)** framework for
disciplined software engineering.

## Philosophy

> Understand before acting. Plan before coding. Implement with discipline.

This plugin enforces a structured workflow that prevents premature
implementation and ensures human oversight at critical decision points.

## Commands

| Command                   | Purpose                                        |
| ------------------------- | ---------------------------------------------- |
| `/rpikit:brainstorm`      | Explore ideas when requirements are unclear    |
| `/rpikit:research`        | Understand the codebase and gather context     |
| `/rpikit:plan`            | Create an actionable implementation plan       |
| `/rpikit:implement`       | Execute the plan with discipline               |
| `/rpikit:code-review`     | Review changes for quality and maintainability |
| `/rpikit:security-review` | Review changes for security vulnerabilities    |

## Workflow

```text
/rpikit:brainstorm ──► /rpikit:research ──► /rpikit:plan ──► /rpikit:implement
         │                    │                  │                  │
     (optional)               └──[approval]──────┴───[approval]─────┘
```

Each phase produces artifacts in `docs/plans/` and requires human approval
before transitioning to the next phase.

### When to Use Brainstorming

**Brainstorming** (optional) is for creative/design work when requirements are
unclear:

- "Add user authentication" → What kind? OAuth? JWT? Sessions?
- "Improve performance" → Which areas? What trade-offs are acceptable?

**Research** is for investigative work when requirements are clear:

- "Where is authentication implemented?" → Finds files, traces flow
- "How does the existing caching work?" → Documents patterns

Skip brainstorming and start with research when you know what to build but
need to understand the codebase first.

## Output Structure

```text
docs/plans/
├── YYYY-MM-DD-<topic>-research.md   # Research findings with file:line references
└── YYYY-MM-DD-<topic>-plan.md       # Implementation plan with tasks and criteria
```

## Installation

### Step 1: Add the marketplace

```bash
/plugin marketplace add bostonaholic/rpikit
```

### Step 2: Install the plugin

```bash
/plugin install rpikit
```

## Usage Examples

### Basic Workflow

Start with research to understand the codebase before building:

```bash
/rpikit:research I want to add OAuth login - what auth patterns exist?
```

Review the research output in `docs/plans/`, then create a plan from it:

```bash
/rpikit:plan docs/plans/2025-01-07-oauth-login-research.md
```

Review and approve the plan, then implement from it:

```bash
/rpikit:implement docs/plans/2025-01-07-oauth-login-plan.md
```

### Ad-hoc Code Review

Review current changes for quality issues:

```bash
/rpikit:code-review
```

Review for security vulnerabilities:

```bash
/rpikit:security-review
```

### Stakes-Based Planning

The framework adapts to change complexity:

- **Low stakes** (docs, formatting): Minimal planning, quick execution
- **Medium stakes** (new features, refactors): Full RPI workflow
- **High stakes** (architecture, security): Thorough research and detailed planning

## Skills

The plugin includes methodology skills that guide disciplined development:

### Core RPI Workflow

- **research-methodology** - Thorough codebase research through interrogation
- **plan-methodology** - Granular, verifiable implementation plans
- **implement-methodology** - Disciplined execution with checkpoint verification
- **code-review** - Quality review using Conventional Comments
- **security-review** - Security-focused review for vulnerabilities

### Development Discipline

- **test-driven-development** - RED-GREEN-REFACTOR cycle enforcement
- **systematic-debugging** - Root cause investigation before fixes
- **verification-before-completion** - Evidence before claims

### Workflow Support

- **brainstorming** - Collaborative design before research/planning
- **finishing-work** - Structured completion (merge, PR, cleanup)
- **receiving-code-review** - Verification-first response to feedback

### Advanced Patterns

- **git-worktrees** - Isolated workspaces for parallel work
- **parallel-agents** - Concurrent dispatch for independent tasks

## Inspired By

- [superpowers](https://github.com/obra/superpowers) - Composable skills
- [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) - Scale-adaptive
  planning
- [SuperClaude Framework](https://github.com/SuperClaude-Org/SuperClaude_Framework) - Behavioral modes and deep research
- [RPI Framework](https://github.com/acampb/claude-rpi-framework) - RPI
  structure
- [HumanLayer](https://github.com/humanlayer/humanlayer) - Human-in-the-loop
  approval patterns

## License

MIT
