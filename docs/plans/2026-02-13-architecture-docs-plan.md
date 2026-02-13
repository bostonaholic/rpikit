# Plan: Architecture Documentation (2026-02-13)

## Summary

Create `docs/architecture.md` documenting the rpikit plugin architecture for
people learning about the tool and developers onboarding to the project.
Link it from README.md and CONTRIBUTING.md.

## Stakes Classification

**Level**: Low
**Rationale**: Documentation-only changes to existing files plus one new
markdown file. No code changes, easy to revise, no risk of breaking anything.

## Context

**Research**: `docs/plans/2026-02-13-plugin-architecture-research.md`
**Affected Areas**: `docs/architecture.md` (new), `README.md`, `CONTRIBUTING.md`

## Success Criteria

- [ ] `docs/architecture.md` exists with component model, delegation map,
      and infrastructure overview
- [ ] README.md links to architecture doc
- [ ] CONTRIBUTING.md links to architecture doc
- [ ] All markdown passes markdownlint validation
- [ ] Content is accurate to the current codebase (6 commands, 14 skills,
      7 agents, 1 hook)

## Implementation Steps

### Phase 1: Create Architecture Document

#### Step 1.1: Write docs/architecture.md

- **Files**: `docs/architecture.md` (new)
- **Action**: Create the architecture document with these sections:
  - **Overview** - One paragraph describing the layered component model
  - **Component Types** - Table of the 4 types with location, count, role
  - **Commands** - Table mapping each command to its delegated skill
  - **Skills** - Grouped tables (core RPI, design/review, development
    discipline, workflow support) showing each skill and its purpose
  - **Agents** - Table with name, model, color, purpose for all 7 agents
  - **How Components Connect** - Text diagram showing the delegation flow
    (commands -> skills -> agents) and the core RPI flow with approval gates
  - **Infrastructure** - Brief description of hooks, scripts, linting config
  - **Design Principles** - The key patterns (thin commands, skills own
    methodology, agents are reusable, model selection by task type, human
    approval gates)
- **Verify**: File exists, markdownlint passes, content matches research
  findings
- **Complexity**: Medium

#### Step 1.2: Validate markdown

- **Files**: `docs/architecture.md`
- **Action**: Run markdownlint, fix any errors
- **Verify**: `markdownlint docs/architecture.md` produces no output
- **Complexity**: Small

### Phase 2: Link From Existing Docs

#### Step 2.1: Add link to README.md

- **Files**: `README.md`
- **Action**: Add an "Architecture" entry to an appropriate location (after
  the Skills section, before Inspired By) with a brief sentence and link to
  `docs/architecture.md`
- **Verify**: Link points to correct path, markdownlint passes
- **Complexity**: Small

#### Step 2.2: Add link to CONTRIBUTING.md

- **Files**: `CONTRIBUTING.md`
- **Action**: Add a reference to `docs/architecture.md` in the Component
  Conventions section or as a new "Understanding the Architecture" section
  near the top, directing new contributors to read it before making changes
- **Verify**: Link points to correct path, markdownlint passes
- **Complexity**: Small

## Risks and Mitigations

| Risk                          | Impact | Mitigation                          |
| ----------------------------- | ------ | ----------------------------------- |
| Doc becomes stale over time   | Low    | Keep it high-level; details change, |
|                               |        | patterns are stable                 |
| Duplicating README content    | Low    | Architecture doc covers structure;  |
|                               |        | README covers usage                 |

## Rollback Strategy

Delete `docs/architecture.md` and revert the two link additions. No risk.

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
