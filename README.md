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
| `/rpikit:research`        | Understand the codebase and gather context     |
| `/rpikit:plan`            | Create an actionable implementation plan       |
| `/rpikit:implement`       | Execute the plan with discipline               |
| `/rpikit:code-review`     | Review changes for quality and maintainability |
| `/rpikit:security-review` | Review changes for security vulnerabilities    |

## Workflow

```text
/rpikit:research ──► /rpikit:plan ──► /rpikit:implement
       │                  │                  │
       └──[approval]──────┴───[approval]─────┘
```

Each phase produces artifacts in `docs/plans/` and requires human approval
before transitioning to the next phase.

## Output Structure

```text
docs/plans/
├── research/
│   └── <topic>.md      # Research findings with file:line references
└── <plan-name>.md      # Implementation plan with tasks and criteria
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

Start with research to understand the codebase:

```bash
/rpikit:research user-authentication
```

Review the research output in `docs/plans/research/`, then create a plan:

```bash
/rpikit:plan user-authentication
```

Review and approve the plan, then implement:

```bash
/rpikit:implement user-authentication
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

The plugin includes methodology skills that are automatically activated:

- **research-methodology** - How to conduct thorough codebase research
- **plan-methodology** - How to create granular, verifiable plans
- **implement-methodology** - How to execute with discipline and verification
- **code-review** - Review changes for quality, design, and maintainability
- **security-review** - Review changes for vulnerabilities and security risks

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
