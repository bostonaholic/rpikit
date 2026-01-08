# rpikit

A plugin implementing the **Research-Plan-Implement (RPI)** framework for
disciplined software engineering.

## Philosophy

> Understand before acting. Plan before coding. Implement with discipline.

This plugin enforces a structured workflow that prevents premature
implementation and ensures human oversight at critical decision points.

## Commands

| Command      | Purpose                                         |
| ------------ | ----------------------------------------------- |
| `/research`  | Deep codebase exploration and context gathering |
| `/plan`      | Create actionable implementation strategy       |
| `/implement` | Execute plan with checkpoint validation         |

## Workflow

```text
/research ──[approval]──► /plan ──[approval]──► /implement
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

## Skills

The plugin includes methodology skills that are automatically activated:

- **research-methodology** - How to conduct thorough codebase research
- **plan-methodology** - How to create granular, verifiable plans
- **implement-methodology** - How to execute with discipline and verification

## Inspired By

- [superpowers](https://github.com/obra/superpowers) - Composable skills
- [BMAD Method](https://github.com/bmad-code-org/BMAD-METHOD) - Scale-adaptive
  planning
- [SuperClaude Framework][superclaude] - Behavioral modes and deep research
- [RPI Framework](https://github.com/acampb/claude-rpi-framework) - RPI
  structure
- [HumanLayer](https://github.com/humanlayer/humanlayer) - Human-in-the-loop
  approval patterns

[superclaude]: https://github.com/SuperClaude-Org/SuperClaude_Framework

## License

MIT
