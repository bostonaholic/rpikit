---
name: research-plan-implement
description: >
  End-to-end pipeline that orchestrates the full RPI workflow in a single session using parallel subagents. Spawns
  research subagents, synthesizes findings into a plan, and executes implementation — each subagent gets its own
  context window. Use when implementing a feature or change that requires research, planning, and execution rather
  than running each phase manually across separate sessions.
---

# Research-Plan-Implement Pipeline

Orchestrate the full Research → Plan → Implement workflow in a single session using subagents. Each phase runs as a
separate subagent with its own context window, coordinated by the orchestrator that handles approval gates and phase
transitions.

## Purpose

Running RPI phases across separate sessions loses context and requires manual bridging. This skill collapses the three
phases into one orchestrated pipeline using subagents via the Agent tool. Each subagent gets maximum context for its
work, with file artifacts on disk as the communication channel between phases.

## Architecture

The orchestrator (you) stays thin. It spawns subagents for each phase via the Agent tool, reads their output artifacts,
presents summaries to the user, and handles approval gates. The orchestrator does NOT do research, planning, or
implementation itself.

```text
ORCHESTRATOR (main context — stays thin)
  │
  ├── Phase 1: Spawn research subagents (parallel)
  │     ├── Subagent: codebase exploration
  │     ├── Subagent: web research
  │     └── Subagent: synthesis → writes research file
  │     └── Output: docs/plans/YYYY-MM-DD-<topic>-research.md
  │
  ├── [APPROVAL GATE: User confirms research findings]
  │
  ├── Phase 2: Spawn planning subagent
  │     └── Subagent: reads research file, writes plan file
  │     └── Output: docs/plans/YYYY-MM-DD-<topic>-plan.md
  │
  ├── [APPROVAL GATE: User approves plan]
  │
  └── Phase 3: Spawn implementation subagent
        └── Subagent: reads plan file, executes steps
        └── Output: code changes, test results
```

**Key principle**: Subagents communicate through files, not conversation context. Each subagent reads the artifacts from
prior phases and writes its own artifacts for the next phase.

## When to Use

Use this pipeline when:

- A feature requires understanding unfamiliar code or APIs
- Multiple aspects need investigation before planning
- The full research → plan → implement cycle is needed
- You want to avoid manually bridging sessions between phases

Do NOT use when:

- Requirements are already clear (skip to `rpikit:writing-plans`)
- A plan already exists (skip to `rpikit:implementing-plans`)
- This is a simple bug fix (use `rpikit:systematic-debugging`)
- Only research is needed without implementation

## Phase 1: Research (Parallel Subagents)

### Step 1: Define Research Questions

Before spawning subagents, break the feature into independent research questions. Typically 2-3 questions covering:

- **Codebase context**: How does the relevant code work today?
- **External context**: What APIs, libraries, or patterns are involved?
- **Security/performance**: Are there concerns to investigate?

### Step 2: Spawn Research Subagents

Spawn subagents for each research question using the Agent tool. Each subagent gets its own context window. Use
existing skills to ensure consistent methodology. Launch independent subagents in parallel by including multiple Agent
tool calls in a single message.

**Codebase researcher:**

```text
Spawn a subagent with the Agent tool:
  name: "codebase-researcher"
  model: "sonnet"
  prompt: "Research [feature area] for the goal: [what will be implemented].

1. Invoke the Skill tool with skill: 'rpikit:researching-codebase'
   and args: '[feature area]'
2. Follow the skill's full methodology (interrogation, exploration,
   documentation)
3. Write your findings to docs/plans/YYYY-MM-DD-<topic>-codebase.md"
```

**Web researcher (when external context needed):**

```text
Spawn a subagent with the Agent tool:
  name: "web-researcher"
  model: "sonnet"
  prompt: "Research [specific question about API, library, pattern, or best
practice].

Provide findings with source citations and confidence assessment.
Write your findings to docs/plans/YYYY-MM-DD-<topic>-external.md"
```

**Additional subagents (when needed):**

```text
Spawn a subagent with the Agent tool:
  name: "security-researcher"
  model: "sonnet"
  prompt: "Investigate security and performance implications of [feature].
Write findings to docs/plans/YYYY-MM-DD-<topic>-security.md"
```

> **Note**: Research agents must NOT use `isolation: "worktree"` — they
> write shared artifacts to `docs/plans/` that other agents and the main
> session need to read.

Guidelines:

- Verify questions are truly independent before parallelizing
- Each subagent gets a focused scope with clear deliverable
- Keep to 2-4 subagents for manageability
- Each subagent writes its findings to a separate file

### Step 3: Synthesize Research

After research subagents complete, spawn a synthesis subagent that consolidates all findings using the synthesis skill.

```text
Spawn a subagent with the Agent tool:
  name: "synthesizer"
  model: "sonnet"
  prompt: "Synthesize all research findings for '<topic>'.

1. Invoke the Skill tool with skill: 'rpikit:synthesizing-research'
   and args: '<topic>'
2. Follow the skill's full methodology to consolidate:
   - docs/plans/YYYY-MM-DD-<topic>-codebase.md
   - docs/plans/YYYY-MM-DD-<topic>-external.md
   - [any additional research files]
3. Write the consolidated document to:
   docs/plans/YYYY-MM-DD-<topic>-research.md"
```

### Step 4: Present Summary and Gate

Read the research document and present a brief summary to the user. Include the subagent results table:

| Agent | Task | Status | Key Findings |
| ----- | ---- | ------ | ------------ |

```text
Research complete for '<topic>'.

Key findings:
- [Finding 1]
- [Finding 2]
- [Finding 3]

Research document: docs/plans/YYYY-MM-DD-<topic>-research.md
```

Use AskUserQuestion:

- "Create plan" — proceed to Phase 2
- "More research needed" — spawn additional subagents
- "Stop here" — end with research document

## Phase 2: Plan (Dedicated Subagent)

Spawn a planning subagent that reads the research document and creates the implementation plan. The subagent gets a
fresh context window with only the research file as input.

```text
Spawn a subagent with the Agent tool:
  name: "planner"
  model: "opus"
  prompt: "You are creating an implementation plan.

1. Read the research document at
   docs/plans/YYYY-MM-DD-<topic>-research.md
2. Invoke the Skill tool with skill: 'rpikit:writing-plans' and
   args: '<topic>'
3. Follow the skill's full methodology to create the plan
4. Write the plan to docs/plans/YYYY-MM-DD-<topic>-plan.md

The plan must reference the research document and be self-contained.
Do NOT ask the user questions — use the research document as your
source of truth for requirements and constraints."
```

### Present Plan and Gate

When the planning subagent completes, read the plan document and present a summary to the user:

```text
Plan created for '<topic>'.

Stakes: [level]
Phases: [count]
Steps: [count]

Plan document: docs/plans/YYYY-MM-DD-<topic>-plan.md
```

Use AskUserQuestion:

- "Approve and implement" — proceed to Phase 3
- "Request changes" — describe what to modify, spawn new planner
- "Stop here" — end with plan document

**Do not skip this approval gate.** The user must explicitly approve the plan before implementation begins.

## Phase 3: Implement (Dedicated Subagent)

After plan approval, spawn an implementation subagent that reads the plan and executes it. The subagent gets a fresh
context window with only the plan file as input.

```text
Spawn a subagent with the Agent tool:
  name: "implementer"
  model: "opus"
  isolation: "worktree"
  prompt: "You are implementing an approved plan.

NOTE: You are running in an isolated worktree (isolation: worktree).
The implementing-plans skill will detect this via 'test -f .git' and
skip the worktree offer — this is expected behavior.

1. Read the plan at docs/plans/YYYY-MM-DD-<topic>-plan.md
2. Invoke the Skill tool with skill: 'rpikit:implementing-plans' and
   args: '<topic>'
3. Follow the skill's full methodology:
   - Execute steps in order
   - Run verification after each step
   - Track progress
   - Run code review and security review at completion
4. Update the plan document status as you complete steps
5. CRITICAL: git commit ALL changes before completing — uncommitted
   work in an isolated worktree is silently destroyed on cleanup

The plan has been approved by the user. Execute it as written. If you
encounter issues that require plan changes, document them and return
the issue — do NOT deviate silently."
```

### Report Results

When the implementation subagent completes, present results:

```text
Implementation complete for '<topic>'.

Steps completed: [N/M]
Files changed: [list]
Tests: [pass/fail]
Reviews: [code review status, security review status]
```

If the subagent reported deviations or blockers, present them and ask the user how to proceed.

## Customizing the Pipeline

### Skipping Phases

If partial context already exists:

- **Research exists**: Read the file, skip to Phase 2 (plan)
- **Plan exists**: Read the file, skip to Phase 3 (implement)
- **Only research needed**: Stop after Phase 1

### Adjusting Research Depth

Match research depth to complexity:

| Complexity | Research Subagents | Expected Duration |
| ---------- | ------------------ | ----------------- |
| Simple     | 1 (codebase)       | Quick             |
| Moderate   | 2 (code + web)     | Medium            |
| Complex    | 3-4 (multiple)     | Thorough          |

### Adding Brainstorming

If requirements are unclear, prepend brainstorming:

```text
Skill tool with skill: "rpikit:brainstorming"
```

Then resume the pipeline at Phase 1 with clarified requirements.

## Orchestrator Rules

The orchestrator MUST stay thin:

- **Do**: Spawn subagents, read artifacts, present summaries, gate approvals
- **Do NOT**: Research code, write plans, implement changes, or read source files beyond the phase artifacts

This ensures the orchestrator's context remains small, leaving maximum context for each subagent.

## Model Selection

Use explicit `model` parameters when spawning subagents:

| Model    | Use For                                | Rationale             |
| -------- | -------------------------------------- | --------------------- |
| `haiku`  | file-finder, quick lookups             | Fast, cost-effective  |
| `sonnet` | research agents, synthesis, code review | Balanced capability  |
| `opus`   | planning, implementation, architecture | Deep reasoning needed |

## Anti-Patterns

| Do Not | Instead |
| ------ | ------- |
| Do research/planning/implementation as orchestrator | Delegate each phase to a subagent |
| Pass findings through conversation context | Write to files, read from files |
| Spawn 5+ research subagents | Keep to 2-4 focused subagents |
| Skip approval gates between phases | Always get explicit user approval |
| Combine dependent research questions | Only parallelize independent questions |

## Quality Checklist

Before each phase transition:

- [ ] All subagents for current phase completed
- [ ] Phase artifact written to `docs/plans/`
- [ ] Subagent results summary table presented
- [ ] User approved before proceeding to next phase
- [ ] Orchestrator context remains thin (no research/planning content)

At pipeline completion:

- [ ] All artifacts saved to `docs/plans/`
- [ ] Final results presented to user
