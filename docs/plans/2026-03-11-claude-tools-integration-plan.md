# Plan: Claude Tools Integration (2026-03-11)

## Summary

Update rpikit's skill files to leverage native Claude Code tools — replacing
TodoWrite with TaskCreate/TaskUpdate/TaskList, replacing the git-worktrees
skill delegation with EnterWorktree/ExitWorktree, adding LSP for code
intelligence, adding worktree isolation for implementation agents, standardizing
model selection, and enabling direct WebFetch for simple lookups. All changes
are edits to markdown skill instruction files.

## Stakes Classification

**Level**: Medium
**Rationale**: Changes span 4 skill files and affect the methodology users
experience across all RPI phases. However, all changes are to markdown
instruction files (no compiled code), each layer is independently valuable, and
rollback is a simple git revert.

## Context

**Design**: [docs/plans/2026-03-11-claude-tools-integration-design.md](2026-03-11-claude-tools-integration-design.md)
**Affected Areas**:

- `skills/implementing-plans/SKILL.md` — Layer 1b (Tasks), Layer 1c (Worktree)
- `skills/researching-codebase/SKILL.md` — Layer 2a (LSP), Layer 2d (WebFetch)
- `skills/writing-plans/SKILL.md` — Layer 2d (WebFetch)
- `skills/research-to-implementation/SKILL.md` — Layer 2b (Agent isolation),
  Layer 2c (Model selection)

## Success Criteria

- [ ] All TodoWrite references replaced with TaskCreate/TaskUpdate/TaskList
- [ ] Worktree isolation uses EnterWorktree/ExitWorktree instead of
      rpikit:git-worktrees skill
- [ ] LSP tool added to research skill with graceful fallback
- [ ] Implementation agents use `isolation: "worktree"` in pipeline skill
- [ ] Model parameter explicitly specified when spawning agents
- [ ] Direct WebFetch guidance added for single-page lookups
- [ ] All skill files pass markdown validation
- [ ] Manual end-to-end test of each modified skill

## Implementation Steps

### Phase 1: Implementation Skill — Task Tools (Layer 1b)

#### Step 1.1: Replace TodoWrite with TaskCreate in progress initialization

- **Files**: `skills/implementing-plans/SKILL.md:132-140`
- **Action**: Rewrite section "4. Initialize Progress Tracking" to use
  TaskCreate instead of TodoWrite. Create one task per plan step using
  TaskCreate with status "pending". Include guidance on using task dependencies
  (`addBlockedBy`) when plan steps have sequential requirements.
- **Verify**: Section references TaskCreate, not TodoWrite. Instructions
  include task creation with subject (active-form), status, and optional
  dependencies.
- **Complexity**: Small

#### Step 1.2: Replace TodoWrite with TaskUpdate in step execution

- **Files**: `skills/implementing-plans/SKILL.md:144-159`
- **Action**: In section "5. Execute Steps in Order", replace "Mark
  in\_progress — Update TodoWrite" with "Mark in\_progress — Update task via
  TaskUpdate". Replace "Mark completed — Update TodoWrite immediately" with
  "Mark completed — Update task via TaskUpdate". Maintain the same step
  numbering and flow.
- **Verify**: All step execution references use TaskUpdate, not TodoWrite.
- **Complexity**: Small

#### Step 1.3: Replace TodoWrite in progress documentation section

- **Files**: `skills/implementing-plans/SKILL.md:283-303`
- **Action**: Rewrite "Track Progress Visibly" principle and "TodoWrite Format"
  subsection to reference TaskCreate/TaskUpdate/TaskList. Update the format
  example to show task-based tracking instead of TodoWrite format.
- **Verify**: No remaining references to TodoWrite in the file. The format
  example shows TaskList output style.
- **Complexity**: Small

#### Step 1.4: Replace TodoWrite in researching-codebase skill

- **Files**: `skills/researching-codebase/SKILL.md:86`
- **Action**: Replace "Use TodoWrite to track exploration based on the
  file-finder report" with "Use TaskCreate to track exploration based on the
  file-finder report. Create one task per file category (core, supporting,
  test, config) and update via TaskUpdate as you examine each."
- **Verify**: No remaining references to TodoWrite in the file.
- **Complexity**: Small

### Phase 2: Implementation Skill — Native Worktree (Layer 1c)

#### Step 2.1: Replace git-worktrees skill with EnterWorktree/ExitWorktree

- **Files**: `skills/implementing-plans/SKILL.md:80-131`
- **Action**: Rewrite section "3. Offer Worktree Isolation" to use
  EnterWorktree/ExitWorktree instead of delegating to rpikit:git-worktrees.
  Keep the same flow: check if already in worktree, offer based on stakes
  level, create worktree if chosen. Replace the bash check (`test -f .git`)
  and skill invocation with EnterWorktree tool call. Replace the note about
  "finishing-work skill handles cleanup" with ExitWorktree guidance (action:
  "keep" to preserve the branch). Add a caution note about active bugs per
  design doc findings.
- **Verify**: Section uses EnterWorktree/ExitWorktree. No reference to
  rpikit:git-worktrees skill. Caution note present about known bugs.
- **Complexity**: Medium

### Phase 3: Research Skill — LSP and WebFetch (Layer 2a, 2d) — parallel with Phase 4

#### Step 3.1: Add LSP tool section to research skill

- **Files**: `skills/researching-codebase/SKILL.md` (insert after line 105,
  within Phase 2: Exploration)
- **Action**: Add a new subsection "### Deepen Understanding with LSP" after
  "Review supporting files." Include guidance on using LSP tool for:
  `goToDefinition`, `findReferences`, `documentSymbol`, `incomingCalls`/
  `outgoingCalls`. Add a fallback note: "If LSP is unavailable (no configured
  language server), skip this step and rely on Grep-based content search."
- **Verify**: New LSP subsection exists in Phase 2. Graceful fallback
  documented. Does not disrupt existing file-finder flow.
- **Complexity**: Small

#### Step 3.2: Add direct WebFetch guidance to research skill

- **Files**: `skills/researching-codebase/SKILL.md:112-131`
- **Action**: In the "Research External Context" subsection, add guidance
  before the web-researcher agent block: "For single-page lookups (e.g.,
  checking a library's API docs or a specific GitHub issue), use WebFetch
  directly instead of spawning a web-researcher agent. Reserve the
  web-researcher for multi-source research requiring synthesis."
- **Verify**: WebFetch guidance present. Web-researcher agent still documented
  for complex research.
- **Complexity**: Small

#### Step 3.3: Add direct WebFetch guidance to planning skill

- **Files**: `skills/writing-plans/SKILL.md:116-124`
- **Action**: In the "Research implementation approaches" subsection, add
  guidance before the web-researcher block: "For quick lookups (checking a
  library's API, reading a specific doc page), use WebFetch directly. Reserve
  the web-researcher agent for multi-source investigation."
- **Verify**: WebFetch guidance present in planning skill. Web-researcher
  still documented for complex research.
- **Complexity**: Small

### Phase 4: Pipeline Skill — Agent Isolation and Model Selection (Layer 2b, 2c), parallel with Phase 3

#### Step 4.1: Add worktree isolation for implementation agent

- **Files**: `skills/research-to-implementation/SKILL.md:222-246`
- **Action**: In Phase 3 (Implement), update the implementation subagent
  spawn block to include `isolation: "worktree"`. Add instruction that the
  subagent must `git commit` all changes before completing, or work will be
  silently destroyed. Add a note that research agents must NOT use isolation
  since they write shared artifacts to `docs/plans/`.
- **Verify**: Implementation agent spawn includes `isolation: "worktree"`.
  Commit requirement documented. Research agents explicitly excluded from
  isolation.
- **Complexity**: Small

#### Step 4.2: Add explicit model selection to agent spawns

- **Files**: `skills/research-to-implementation/SKILL.md:88-121`
- **Action**: Update the Phase 1 research subagent spawn blocks to include
  explicit `model` parameter. Add `model: "sonnet"` to codebase-researcher
  and web-researcher. Add `model: "sonnet"` to security-researcher. Add
  `model: "sonnet"` to synthesis subagent (line 136-148). Add `model: "opus"`
  to planning subagent (Phase 2, line 183-196). Add `model: "opus"` to
  implementation subagent (Phase 3, line 229-246). Add a reference table
  documenting the model selection rationale:
  - `haiku` — file-finder, quick lookups
  - `sonnet` — research agents, code review
  - `opus` — planning, implementation, architecture
- **Verify**: All Agent tool spawn blocks include explicit `model` parameter.
  Model selection rationale table present.
- **Complexity**: Medium

### Phase 5: Validation and Documentation

#### Step 5.1: Validate all modified skill files

- **Files**: All 4 modified skill files
- **Action**: Run markdown validation on each modified file using the
  rpikit:markdown-validation skill. Fix any linting errors.
- **Verify**: All files pass markdown validation with zero errors.
- **Complexity**: Small

#### Step 5.2: Update design document next steps

- **Files**: `docs/plans/2026-03-11-claude-tools-integration-design.md:219-228`
- **Action**: Mark completed items in the Next Steps checklist: Layer 1b, 1c,
  2a, 2b, 2c, 2d. Leave Layer 3 items unchecked.
- **Verify**: Completed items marked with `[x]`. Layer 3 items remain `[ ]`.
- **Complexity**: Small

## Test Strategy

### Manual Verification

This project consists entirely of markdown skill instruction files with no
compiled code or automated test infrastructure. All verification is manual.

- [ ] **Layer 1b**: Run `/rpikit:implement` on a test plan and verify tasks
      appear in Claude's task panel (not TodoWrite). Confirm TaskCreate,
      TaskUpdate, and TaskList are used for progress tracking.
- [ ] **Layer 1c**: Run `/rpikit:implement` and choose worktree isolation.
      Verify EnterWorktree creates the worktree and implementation proceeds
      in the isolated directory.
- [ ] **Layer 2a**: Run `/rpikit:research` on a codebase with a configured
      language server. Verify LSP tool is attempted after file-finder. Verify
      graceful fallback when no language server is available.
- [ ] **Layer 2b**: Run `/rpikit:rpi` full pipeline and verify the
      implementation subagent is spawned with `isolation: "worktree"` while
      research subagents run in the main directory.
- [ ] **Layer 2c**: Run `/rpikit:rpi` and verify agent spawn calls include
      explicit `model` parameters matching the rationale table.
- [ ] **Layer 2d**: Run `/rpikit:research` with a question involving a single
      external doc page. Verify WebFetch is used directly instead of spawning
      a web-researcher agent.

## Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| TaskCreate/TaskUpdate unavailable in older Claude Code versions | Tasks not tracked, skill flow breaks | Design doc confirms TaskCreate available since v2.1.16. Add fallback note in skill. |
| EnterWorktree active bugs cause data loss | Implementation work lost if worktree cleanup is premature | Require explicit `git commit` before ExitWorktree. Add caution note per design doc. |
| LSP not available in target project | Research phase skips structural analysis | Graceful fallback to Grep-based search documented in skill. |
| Model parameter ignored or unavailable | Agent runs on default model instead of specified | No functional impact — model is a preference, not a requirement. Agent still works. |

## Rollback Strategy

All changes are to markdown skill instruction files tracked in git. Rollback
is `git revert <commit>`. Each phase can be reverted independently if changes
are committed per-phase.

## Status

- [x] Plan approved
- [x] Implementation started
- [ ] Implementation complete
