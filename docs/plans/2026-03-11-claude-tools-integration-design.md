# Design: Claude Tools Integration (2026-03-11)

## Problem Statement

rpikit's skills reference Claude Code tools inconsistently and miss
opportunities to use native tools that provide better UX and capability. For
example, implementation tracks progress with TodoWrite instead of structured
Tasks, and agent spawning doesn't leverage model selection, worktree isolation,
or Teams.

## Chosen Approach

**Layered Integration** — incrementally adopt Claude tools across three
priority layers, each independently valuable and testable.

## Research Findings (2026-03-11)

Three open questions were investigated via deep web research. Key findings:

### EnterPlanMode — Do Not Use in Skills

**Verdict: Remove from design.** Three blockers identified:

1. **Skill tool excluded from plan mode.** When `EnterPlanMode` fires, Claude
   transitions to a Plan subagent with a restricted tool set. The `Skill` tool
   is not available, so the skill's flow is interrupted.
   ([#24072](https://github.com/anthropics/claude-code/issues/24072), closed
   without fix)
2. **ExitPlanMode deadlocks in automated contexts.** `ExitPlanMode`
   unconditionally shows an interactive approval prompt that blocks indefinitely
   in skill-driven workflows.
   ([#30463](https://github.com/anthropics/claude-code/issues/30463), open)
3. **Write constraints are prompt-based, not tool-blocked.** Plan mode tells
   Claude not to write files, but the tools remain available — creating
   ambiguity for skills that need to write plan documents to disk.

rpikit's existing pattern (writing plans to `docs/plans/` directly) is
architecturally superior and avoids all of these conflicts.

### TaskCreate — Safe to Adopt

**Verdict: Proceed.** Tasks are disk-backed at `~/.claude/tasks/` and persist
across skill boundaries within the same session. Key facts:

- Tasks survive context compaction and session resume (`--continue`)
- Cross-skill visibility confirmed: both skills run inline by default, sharing
  the same implicit task list
- `TaskCreate` supersedes `TodoWrite` as of Claude Code v2.1.16
- Tasks support dependencies (`blockedBy`/`blocks`), active-form spinners, and
  structured status tracking
- Known issue: Task tools bypass `PreToolUse`/`PostToolUse` hooks
  ([#20243](https://github.com/anthropics/claude-code/issues/20243))

### Agent Worktree Isolation — Use Cautiously

**Verdict: Limit to implementation agents only.** Each isolated agent gets its
own working directory and branch. Uncommitted files are invisible across
worktrees.

- Research agents must run without isolation (they write shared artifacts to
  `docs/plans/`)
- Implementation agents can use `isolation: "worktree"` but must `git commit`
  before completing, or work is silently destroyed
- Active bugs: `bypassPermissions` ineffective
  ([#29110](https://github.com/anthropics/claude-code/issues/29110)),
  background team members' `pwd` not set correctly
  ([#27749](https://github.com/anthropics/claude-code/issues/27749))

## Layer 1: Phase-Native Tool Mapping (Quick Wins)

### ~~1a. Planning → EnterPlanMode / ExitPlanMode~~ REMOVED

Removed based on research findings. The Skill tool is excluded from plan mode,
ExitPlanMode deadlocks in automated contexts, and rpikit's existing
plan-writing approach is better suited to plugin skills.

### 1b. Implementation → TaskCreate / TaskUpdate / TaskList

**Current**: `implementing-plans/SKILL.md` uses `TodoWrite` for progress
tracking.

**Proposed**: Replace `TodoWrite` with `TaskCreate` / `TaskUpdate` /
`TaskList`. This provides:

- Structured task subjects with active-form spinners ("Implementing auth
  middleware...")
- Task dependencies via `addBlockedBy` / `addBlocks`
- Status tracking (pending → in\_progress → completed)
- Better UI integration — tasks appear in Claude's task panel

**Changes**: Update `implementing-plans/SKILL.md` to use Task tools instead of
TodoWrite. Create tasks from plan steps, mark in\_progress before starting each,
completed when done.

### 1c. Implementation → EnterWorktree / ExitWorktree

**Current**: `implementing-plans/SKILL.md` mentions worktree isolation as an
option and delegates to the `rpikit:git-worktrees` skill.

**Proposed**: Use the native `EnterWorktree` / `ExitWorktree` tools directly
instead of a custom skill. This provides:

- Automatic worktree creation in `.claude/worktrees/`
- Session-aware cleanup on exit
- No custom skill needed for the basic case

**Changes**: Update `implementing-plans/SKILL.md` to invoke `EnterWorktree`
when the user opts for isolation, and `ExitWorktree` (with action: "keep") when
implementation is complete.

**Caution**: Monitor active bugs around worktree isolation before relying on
this in production workflows.

## Layer 2: Agent Improvements

### 2a. Research → LSP for Code Intelligence

**Current**: Research relies on file-finder agent (Glob/Grep/Read) to
understand code structure.

**Proposed**: Add `LSP` tool usage in `researching-codebase/SKILL.md` for:

- `goToDefinition` — trace how functions connect
- `findReferences` — understand usage patterns
- `documentSymbol` — get file structure overview
- `incomingCalls` / `outgoingCalls` — map call hierarchies

**Changes**: Add LSP as a supplementary tool in the research skill. Use it
after file-finder identifies relevant files — LSP provides deeper structural
understanding.

**Constraint**: LSP requires configured language servers. The skill should
gracefully fall back to Grep-based exploration if LSP is unavailable.

### 2b. Agent Spawning → Worktree Isolation (Implementation Only)

**Current**: Agents run in the same working directory as the main session.

**Proposed**: Use `isolation: "worktree"` parameter when spawning
implementation agents that modify source code. Research agents must NOT use
isolation — they write shared artifacts to `docs/plans/` that other agents and
the main session need to read.

**Changes**: Update `research-to-implementation/SKILL.md` to pass
`isolation: "worktree"` only for implementation agents. Research agents
continue running in the main working directory.

**Requirement**: Isolated agents must `git commit` their changes before
completing, or work is silently destroyed during worktree cleanup.

### 2c. Agent Spawning → Explicit Model Selection

**Current**: Agent frontmatter specifies model (haiku for file-finder), but
skills don't always pass the `model` parameter when spawning.

**Proposed**: Standardize model selection in skill instructions:

- `haiku` — file-finder, quick lookups (fast, cheap)
- `sonnet` — research agents, code review (balanced)
- `opus` — complex reasoning, architecture analysis, security review (thorough)

**Changes**: Update skills to explicitly pass `model` parameter when spawning
agents via the Agent tool.

### 2d. Research → Direct WebFetch for Quick Lookups

**Current**: All web research goes through the web-researcher agent.

**Proposed**: Use `WebFetch` directly in skills for simple, targeted lookups
(e.g., checking a library's API docs). Reserve the web-researcher agent for
multi-source research that requires synthesis.

**Changes**: Update `researching-codebase/SKILL.md` and
`writing-plans/SKILL.md` to allow direct `WebFetch` for single-page lookups.

## Layer 3: Polish

### 3a. AskUserQuestion → Preview Fields

**Current**: Approval gates use plain text options.

**Proposed**: Use the `preview` field on AskUserQuestion options to show plan
summaries, code diffs, or approach comparisons side-by-side.

**Changes**: Update skills to include `preview` content when presenting
approaches or plans for approval.

### 3b. Research-to-Implementation → TeamCreate for Large Pipelines

**Current**: `research-to-implementation/SKILL.md` spawns parallel agents but
coordinates them manually.

**Proposed**: For large pipelines, use `TeamCreate` to establish a formal team
with `TaskList` coordination. Agents become teammates that can communicate via
`SendMessage` and track shared work via Tasks.

**Changes**: Add an optional "team mode" to the research-to-implementation
skill for complex, multi-file changes. This is opt-in — simple changes still
use the current lightweight agent spawning.

**Note**: This is the most speculative item. Teams add orchestration overhead
that may not be justified for typical RPI workflows. Evaluate after Layers 1
and 2 are stable.

## Trade-offs Accepted

- **No native plan mode** — rpikit's text-based planning avoids tool exclusion
  and deadlock issues while providing equivalent functionality through
  `docs/plans/` artifacts and AskUserQuestion approval gates.
- **TaskCreate adds UI complexity** — more items in the task panel. Mitigated by
  only creating tasks for plan steps, not sub-steps.
- **LSP availability varies** — not all projects have language servers
  configured. Skills must gracefully degrade.
- **Worktree isolation has active bugs** — limit to implementation agents,
  require explicit commits, monitor upstream fixes.
- **Teams add overhead** — only justified for large, parallel workloads. Kept as
  Layer 3 / opt-in.

## Next Steps

- [ ] Implement Layer 1b (implementation → TaskCreate/TaskUpdate/TaskList)
- [ ] Implement Layer 1c (implementation → EnterWorktree/ExitWorktree)
- [ ] Test Layer 1 end-to-end
- [ ] Implement Layer 2a (research → LSP)
- [ ] Implement Layer 2b (agent isolation for implementation only)
- [ ] Implement Layer 2c (explicit model selection)
- [ ] Implement Layer 2d (direct WebFetch)
- [ ] Evaluate Layer 3 (teams, previews) based on Layer 1-2 experience
