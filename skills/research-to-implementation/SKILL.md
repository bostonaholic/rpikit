---
name: research-to-implementation
description: End-to-end pipeline that orchestrates the full RPI workflow in a single session using agent teams. Spawns parallel research teammates, synthesizes findings into a plan, and executes implementation — each teammate gets its own context window. Use when implementing a feature or change that requires research, planning, and execution rather than running each phase manually across separate sessions.
---

# Research-to-Implementation Pipeline

Orchestrate the full Research → Plan → Implement workflow in a single
session using an agent team. Each phase runs as a separate teammate with
its own context window, coordinated by the team lead that handles
approval gates and phase transitions.

## Purpose

Running RPI phases across separate sessions loses context and requires
manual bridging. This skill collapses the three phases into one
orchestrated pipeline using agent teams. Each teammate gets maximum
context for its work, with file artifacts on disk as the communication
channel between phases.

## Architecture

The team lead (you) stays thin. It creates an agent team, spawns
teammates for each phase, reads their output artifacts, presents
summaries to the user, and handles approval gates. The lead does NOT
do research, planning, or implementation itself.

```text
TEAM LEAD (main context — stays thin)
  │
  ├── Phase 1: Spawn research teammates (parallel)
  │     ├── Teammate: codebase exploration
  │     ├── Teammate: web research
  │     └── Teammate: synthesis → writes research file
  │     └── Output: docs/plans/YYYY-MM-DD-<topic>-research.md
  │
  ├── [APPROVAL GATE: User confirms research findings]
  │
  ├── Phase 2: Spawn planning teammate
  │     └── Teammate: reads research file, writes plan file
  │     └── Output: docs/plans/YYYY-MM-DD-<topic>-plan.md
  │
  ├── [APPROVAL GATE: User approves plan]
  │
  └── Phase 3: Spawn implementation teammate
        └── Teammate: reads plan file, executes steps
        └── Output: code changes, test results
```

**Key principle**: Teammates communicate through files, not conversation
context. Each teammate reads the artifacts from prior phases and writes
its own artifacts for the next phase.

## Prerequisites

Agent teams require:

- `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` set to `1` in settings
- `teammateMode` set to `"tmux"` for split-pane visibility (recommended)
- tmux installed and available in PATH

## Setting Up the Team

### Step 1: Create the Agent Team

Create a team named after the feature being implemented:

```text
Create an agent team called "rpi-<topic>" to research, plan, and
implement <feature description>. Use tmux split panes so each
teammate is visible.
```

### Step 2: Define the Task List

Create tasks for each phase in the shared task list. Mark dependencies
so phases execute in order:

```text
Tasks:
1. [Research] Explore codebase for <feature area>
2. [Research] Investigate <external API/library/pattern>
3. [Synthesize] Combine research into document (depends on 1, 2)
4. [Plan] Create implementation plan (depends on 3)
5. [Implement] Execute approved plan (depends on 4)
```

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

## Phase 1: Research (Parallel Teammates)

### Step 1: Define Research Questions

Before spawning teammates, break the feature into independent research
questions. Typically 2-3 questions covering:

- **Codebase context**: How does the relevant code work today?
- **External context**: What APIs, libraries, or patterns are involved?
- **Security/performance**: Are there concerns to investigate?

### Step 2: Spawn Research Teammates

Spawn teammates for each research question. Each teammate gets its own
context window and tmux pane.

**Codebase researcher:**

```text
Spawn a teammate called "codebase-researcher" with the prompt:
"Find and analyze files related to [feature area]. Goal: [what will
be implemented].

Explore the codebase and document:
- Core files with their purpose and key lines
- Supporting files and utilities
- Test files and patterns
- Suggested reading order

Write your findings to docs/plans/YYYY-MM-DD-<topic>-codebase.md
when complete."
```

**Web researcher (when external context needed):**

```text
Spawn a teammate called "web-researcher" with the prompt:
"Research [specific question about API, library, pattern, or best
practice].

Provide findings with source citations and confidence assessment.
Write your findings to docs/plans/YYYY-MM-DD-<topic>-external.md
when complete."
```

**Additional teammates (when needed):**

```text
Spawn a teammate called "security-researcher" with the prompt:
"Investigate security and performance implications of [feature].
Write findings to docs/plans/YYYY-MM-DD-<topic>-security.md
when complete."
```

Guidelines:

- Verify questions are truly independent before parallelizing
- Each teammate gets a focused scope with clear deliverable
- Keep to 2-4 teammates for manageability
- Each teammate writes its findings to a separate file

### Step 3: Synthesize Research

After research teammates complete, spawn a synthesis teammate that
combines all findings into one document.

```text
Spawn a teammate called "synthesizer" with the prompt:
"Read all research findings:
- docs/plans/YYYY-MM-DD-<topic>-codebase.md
- docs/plans/YYYY-MM-DD-<topic>-external.md
- [any additional research files]

Write a consolidated research document to:
docs/plans/YYYY-MM-DD-<topic>-research.md

Follow this format:
- Problem statement
- Requirements
- Findings (organized by theme, not by source)
- External research (with source citations)
- Technical constraints
- Open questions
- Recommendations

The document must be self-contained — a reader with no prior context
should understand the full picture from this document alone.

After writing, shut down."
```

### Step 4: Present Summary and Gate

Read the research document and present a brief summary to the user.
Include the teammate results table:

| Teammate | Task | Status | Key Findings |
| -------- | ---- | ------ | ------------ |

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
- "More research needed" — spawn additional teammates
- "Stop here" — clean up team, end with research document

## Phase 2: Plan (Dedicated Teammate)

Spawn a planning teammate that reads the research document and creates
the implementation plan. The teammate gets a fresh context window with
only the research file as input.

```text
Spawn a teammate called "planner" with the prompt:
"You are creating an implementation plan.

1. Read the research document at
   docs/plans/YYYY-MM-DD-<topic>-research.md
2. Invoke the Skill tool with skill: 'rpikit:writing-plans' and
   args: '<topic>'
3. Follow the skill's full methodology to create the plan
4. Write the plan to docs/plans/YYYY-MM-DD-<topic>-plan.md

The plan must reference the research document and be self-contained.
Do NOT ask the user questions — use the research document as your
source of truth for requirements and constraints.

After writing, shut down."
```

Require plan approval for this teammate so the lead can review before
implementation proceeds.

### Present Plan and Gate

When the planning teammate completes, read the plan document and present
a summary to the user:

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
- "Stop here" — clean up team, end with plan document

**Do not skip this approval gate.** The user must explicitly approve
the plan before implementation begins.

## Phase 3: Implement (Dedicated Teammate)

After plan approval, spawn an implementation teammate that reads the
plan and executes it. The teammate gets a fresh context window with
only the plan file as input.

```text
Spawn a teammate called "implementer" with the prompt:
"You are implementing an approved plan.

1. Read the plan at docs/plans/YYYY-MM-DD-<topic>-plan.md
2. Invoke the Skill tool with skill: 'rpikit:implementing-plans' and
   args: '<topic>'
3. Follow the skill's full methodology:
   - Execute steps in order
   - Run verification after each step
   - Track progress
   - Run code review and security review at completion
4. Update the plan document status as you complete steps

The plan has been approved by the user. Execute it as written. If you
encounter issues that require plan changes, document them and message
the lead — do NOT deviate silently.

After completing all steps, shut down."
```

### Report Results

When the implementation teammate completes, present results:

```text
Implementation complete for '<topic>'.

Steps completed: [N/M]
Files changed: [list]
Tests: [pass/fail]
Reviews: [code review status, security review status]
```

If the teammate reported deviations or blockers, present them and ask
the user how to proceed.

### Clean Up the Team

After implementation is complete and results are reported:

```text
Clean up the rpi-<topic> team.
```

This removes the shared team resources. Ensure all teammates have
shut down first.

## Customizing the Pipeline

### Skipping Phases

If partial context already exists:

- **Research exists**: Read the file, skip to Phase 2 (plan)
- **Plan exists**: Read the file, skip to Phase 3 (implement)
- **Only research needed**: Stop after Phase 1

### Adjusting Research Depth

Match research depth to complexity:

| Complexity | Research Teammates | Expected Duration |
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

### Falling Back to Subagents

If agent teams are not available (feature flag disabled, tmux not
installed), fall back to subagents using the Agent tool:

- Replace "Spawn a teammate" with `Agent tool` invocations
- Each agent still gets its own context window
- File artifacts still serve as the communication channel
- The orchestrator pattern remains the same

## Team Lead Rules

The team lead MUST stay thin:

- **Do**: Create team, spawn teammates, read artifacts, present
  summaries, gate approvals, clean up team
- **Do NOT**: Research code, write plans, implement changes, or read
  source files beyond the phase artifacts

This ensures the lead's context remains small, leaving maximum
context for each teammate.

## Anti-Patterns

| Do Not | Instead |
| ------ | ------- |
| Do research/planning/implementation as lead | Delegate each phase to a teammate |
| Pass findings through conversation context | Write to files, read from files |
| Spawn 5+ research teammates | Keep to 2-4 focused teammates |
| Skip approval gates between phases | Always get explicit user approval |
| Combine dependent research questions | Only parallelize independent questions |
| Let the team run unattended too long | Monitor progress, redirect as needed |
| Forget to clean up the team | Always clean up after completion |

## Quality Checklist

Before each phase transition:

- [ ] All teammates for current phase completed and shut down
- [ ] Phase artifact written to `docs/plans/`
- [ ] Teammate results summary table presented
- [ ] User approved before proceeding to next phase
- [ ] Lead context remains thin (no research/planning content)

At pipeline completion:

- [ ] All teammates shut down
- [ ] Team cleaned up
- [ ] All artifacts saved to `docs/plans/`
- [ ] Final results presented to user
