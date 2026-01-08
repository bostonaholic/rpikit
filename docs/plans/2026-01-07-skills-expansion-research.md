# Research: Skills Expansion for RPI Workflow (2026-01-07)

## Problem Statement

Identify skill gaps in the rpikit plugin by comparing against the superpowers
plugin, then recommend additions that strengthen the Research-Plan-Implement
workflow and provide general-purpose development capabilities.

## Requirements

- Fill gaps across all three RPI phases (research, plan, implement)
- Include both RPI-specific and general-purpose skills
- Skills should integrate naturally with existing workflow
- Avoid duplicating functionality already present

## Findings

### Current rpikit Skills (5)

| Skill | Phase | Purpose |
|-------|-------|---------|
| `research-methodology` | Research | Gather understanding through interrogation, then explore codebase |
| `plan-methodology` | Plan | Create actionable plans with verification criteria |
| `implement-methodology` | Implement | Execute with checkpoints, progress tracking, reviews |
| `code-review` | Implement | Review changes using Conventional Comments |
| `security-review` | Implement | Security-focused review of implementation changes |

### Superpowers Skills Analyzed (14)

| Skill | Maps to Phase | Purpose |
|-------|---------------|---------|
| `brainstorming` | Pre-Research | Collaborative design before creative work |
| `systematic-debugging` | Research/Implement | Root cause investigation before fixes |
| `writing-plans` | Plan | Detailed plans with exact code examples |
| `using-git-worktrees` | Plan | Isolated workspaces for implementation |
| `test-driven-development` | Implement | Red-green-refactor discipline |
| `verification-before-completion` | Implement | Evidence before claims |
| `executing-plans` | Implement | Batch execution with checkpoints |
| `subagent-driven-development` | Implement | Fresh subagent per task with review |
| `dispatching-parallel-agents` | Implement | Concurrent independent work |
| `finishing-a-development-branch` | Implement | Merge/PR/cleanup workflow |
| `requesting-code-review` | Implement | Systematic review requests |
| `receiving-code-review` | Implement | Handle feedback with rigor |
| `using-superpowers` | Meta | Find and invoke skills |
| `writing-skills` | Meta | Create new skills |

### Existing Patterns in rpikit

**Strengths:**
- Strong interrogation-first approach in research phase
- Stakes-based enforcement in plan/implement phases
- Integrated code review and security review in implement phase
- Agents (file-finder, web-researcher) reused across phases
- Clear artifact output (docs/plans/*.md)

**Gaps identified:**
- No explicit TDD methodology (mentioned briefly, not enforced)
- No debugging methodology for investigating failures
- No explicit verification discipline (implicit in implement)
- No completion/finishing workflow after implementation
- No brainstorming skill for creative/design work
- No skill for responding to code review feedback
- No isolation strategy (git worktrees)
- No parallel agent dispatch guidance

### Dependencies

**Internal:**
- New skills should integrate with existing agents (file-finder, web-researcher)
- New skills should follow existing artifact conventions (docs/plans/)
- New skills should respect stakes-based enforcement

**External:**
- Superpowers plugin as reference implementation
- Claude Code skill/agent architecture

### Technical Constraints

- Skills must be self-contained markdown files in `skills/<name>/SKILL.md`
- Skills invoked via Skill tool, not direct file reads
- Commands remain thin wrappers delegating to skills
- Must integrate with existing implement-methodology checkpoint system

## Gap Analysis

### Priority 1: HIGH - Significant workflow gaps

#### 1.1 Test-Driven Development

**Gap:** rpikit's implement-methodology mentions TDD briefly ("follow TDD:
Red-Green-Refactor") but provides no methodology. Superpowers has rigorous
enforcement including:
- Non-negotiable "no production code without failing test first"
- Mandatory verification at RED and GREEN phases
- Explicit rejection of common rationalizations

**Impact:** Without TDD discipline, implementation quality suffers. Tests
written after code prove nothing about correctness.

**Recommendation:** Create `test-driven-development` skill with strict
RED-GREEN-REFACTOR enforcement, integrated into implement phase.

#### 1.2 Systematic Debugging

**Gap:** No debugging methodology exists. When tests fail or bugs appear,
there's no structured approach to investigation.

**Impact:** Without root cause analysis, fixes are often symptoms-only,
creating new bugs and wasting time.

**Recommendation:** Create `systematic-debugging` skill covering:
- Root cause investigation before fixes
- Hypothesis formation and testing
- Pattern analysis against working code
- Integration with both research (investigating issues) and implement (fixing
  failures) phases

### Priority 2: MEDIUM - Valuable enhancements

#### 2.1 Verification Before Completion

**Gap:** rpikit's implement-methodology has verification built into steps, but
no explicit "evidence before claims" discipline. Easy to skip or shortcut.

**Impact:** False completion claims lead to broken builds, failed deployments,
and lost trust.

**Recommendation:** Create `verification-before-completion` skill that:
- Makes verification non-negotiable before any completion claim
- Lists common failure modes (tests, lints, builds)
- Identifies rationalization red flags
- Integrates as final gate in implement phase

#### 2.2 Finishing Work

**Gap:** No explicit completion workflow after implementation. Once code review
and security review pass, what happens? Merge? PR? Cleanup?

**Impact:** Implementations left in limbo, branches accumulate, cleanup
forgotten.

**Recommendation:** Create `finishing-work` skill covering:
- Test verification before any completion action
- Structured options: merge locally, create PR, defer, discard
- Cleanup procedures (branch deletion, worktree removal)
- Integration as final step of implement phase

#### 2.3 Brainstorming

**Gap:** Research phase is investigation-focused (understanding existing code).
No skill for creative/design work when requirements are unclear or multiple
approaches exist.

**Impact:** Jumps from vague idea to planning without proper design exploration.

**Recommendation:** Create `brainstorming` skill covering:
- Idea refinement through progressive questioning
- Exploring multiple approaches with trade-offs
- Design documentation before planning
- Natural handoff to research or plan phases

### Priority 3: LOW - Nice-to-have improvements

#### 3.1 Receiving Code Review

**Gap:** rpikit has code-review for giving feedback. No skill for receiving
and responding to feedback appropriately.

**Impact:** Performative agreement ("You're absolutely right!") instead of
rigorous evaluation. Bad suggestions implemented without pushback.

**Recommendation:** Create `receiving-code-review` skill with:
- Verification-first approach to feedback
- When to push back with technical reasoning
- Implementation sequence (blocking first, simple next, complex last)
- Integration with implement phase review cycles

#### 3.2 Git Worktrees

**Gap:** No isolation strategy for parallel work or protecting main workspace.

**Impact:** Feature work can pollute main workspace, context switching is
disruptive.

**Recommendation:** Create `git-worktrees` skill covering:
- Directory selection (project-local vs external)
- Safety verification (.gitignore)
- Setup automation (npm install, etc.)
- Integration with plan phase for isolated execution

#### 3.3 Parallel Agents

**Gap:** No guidance on dispatching multiple agents concurrently for
independent problems.

**Impact:** Sequential investigation of independent failures wastes time.

**Recommendation:** Create `parallel-agents` skill covering:
- Decision framework (when to parallelize)
- Agent prompt structure (focused, self-contained)
- Result integration and conflict resolution
- Integration with implement phase for multi-file failures

## Open Questions

1. **Skill naming convention:** Should new skills follow superpowers naming
   (e.g., `test-driven-development`) or shorter names (e.g., `tdd`)?

2. **Command exposure:** Should high-priority skills (TDD, debugging) get
   their own commands, or remain skill-only invocations?

3. **Implement integration:** How tightly should new skills integrate with
   implement-methodology? Call explicitly vs. automatic invocation?

4. **Stakes enforcement:** Should TDD and verification be mandatory for all
   stakes levels, or only medium/high?

## Recommendations

### Immediate additions (Priority 1)

1. **`test-driven-development`** - Rigorous RED-GREEN-REFACTOR methodology
2. **`systematic-debugging`** - Root cause investigation before fixes

### Near-term additions (Priority 2)

3. **`verification-before-completion`** - Evidence before claims
4. **`finishing-work`** - Completion workflow with merge/PR options
5. **`brainstorming`** - Creative design before research/planning

### Future additions (Priority 3)

6. **`receiving-code-review`** - Handle feedback with rigor
7. **`git-worktrees`** - Isolated workspaces
8. **`parallel-agents`** - Concurrent agent dispatch

### Suggested implementation order

```text
Phase 1: Core discipline
  1. test-driven-development
  2. systematic-debugging

Phase 2: Completion quality
  3. verification-before-completion
  4. finishing-work

Phase 3: Creative workflow
  5. brainstorming

Phase 4: Advanced patterns
  6. receiving-code-review
  7. git-worktrees
  8. parallel-agents
```

### Integration approach

New skills should:
- Follow existing `skills/<name>/SKILL.md` structure
- Use existing agents (file-finder, web-researcher) where appropriate
- Respect stakes-based enforcement model
- Document integration points with existing methodology skills
- Include anti-patterns and verification criteria

## References

- Superpowers plugin: https://github.com/obra/superpowers/tree/main/skills
- rpikit plugin structure: `.claude-plugin/`, `commands/`, `skills/`, `agents/`
