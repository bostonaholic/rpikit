# Plan: Skills Expansion (2026-01-07)

## Summary

Add 8 new skills to the rpikit plugin to fill identified workflow gaps: test-driven-development, systematic-debugging, verification-before-completion, finishing-work, brainstorming, receiving-code-review, git-worktrees, and parallel-agents. Skills will follow existing conventions and integrate with the RPI workflow phases.

## Stakes Classification

**Level**: Medium
**Rationale**: Multiple new files but additive-only changes. No modification to existing skills. Easy rollback by deleting skill directories. Testable via skill invocation.

## Context

**Research**: [2026-01-07-skills-expansion-research.md](./2026-01-07-skills-expansion-research.md)
**Affected Areas**: `skills/` directory (8 new subdirectories)

## Success Criteria

- [ ] All 8 skills created with YAML frontmatter and methodology content
- [ ] Skills follow existing naming and structure conventions
- [ ] Each skill has clear purpose, process steps, and anti-patterns
- [ ] Skills integrate naturally with RPI workflow phases
- [ ] Skills can be invoked via Skill tool

## Implementation Steps

### Phase 1: Core Discipline Skills

#### Step 1.1: Create test-driven-development skill directory

- **Files**: `skills/test-driven-development/`
- **Action**: Create directory structure
- **Verify**: Directory exists
- **Complexity**: Small

#### Step 1.2: Write test-driven-development SKILL.md

- **Files**: `skills/test-driven-development/SKILL.md`
- **Action**: Create skill with:
  - YAML frontmatter (name, description)
  - Purpose section explaining TDD discipline
  - RED-GREEN-REFACTOR cycle methodology
  - Mandatory verification at each phase
  - Common rationalizations to reject
  - Anti-patterns section
  - Integration with implement phase
- **Verify**: File parses correctly, frontmatter valid
- **Complexity**: Medium

#### Step 1.3: Create systematic-debugging skill directory

- **Files**: `skills/systematic-debugging/`
- **Action**: Create directory structure
- **Verify**: Directory exists
- **Complexity**: Small

#### Step 1.4: Write systematic-debugging SKILL.md

- **Files**: `skills/systematic-debugging/SKILL.md`
- **Action**: Create skill with:
  - YAML frontmatter (name, description)
  - Purpose section explaining root cause focus
  - Four-phase methodology (investigate, analyze, hypothesize, implement)
  - Evidence gathering techniques
  - Red flags for skipping investigation
  - Anti-patterns section
  - Integration with research and implement phases
- **Verify**: File parses correctly, frontmatter valid
- **Complexity**: Medium

**Phase 1 Checkpoint**: Core discipline skills complete

---

### Phase 2: Completion Quality Skills

#### Step 2.1: Create verification-before-completion skill directory

- **Files**: `skills/verification-before-completion/`
- **Action**: Create directory structure
- **Verify**: Directory exists
- **Complexity**: Small

#### Step 2.2: Write verification-before-completion SKILL.md

- **Files**: `skills/verification-before-completion/SKILL.md`
- **Action**: Create skill with:
  - YAML frontmatter (name, description)
  - Purpose: evidence before claims
  - Five-step gate (identify, run, read, verify, claim)
  - Common failure modes (tests, lints, builds)
  - Rationalization red flags
  - Anti-patterns section
  - Integration as final gate in implement phase
- **Verify**: File parses correctly, frontmatter valid
- **Complexity**: Medium

#### Step 2.3: Create finishing-work skill directory

- **Files**: `skills/finishing-work/`
- **Action**: Create directory structure
- **Verify**: Directory exists
- **Complexity**: Small

#### Step 2.4: Write finishing-work SKILL.md

- **Files**: `skills/finishing-work/SKILL.md`
- **Action**: Create skill with:
  - YAML frontmatter (name, description)
  - Purpose: structured completion workflow
  - Test verification requirement
  - Four options (merge, PR, defer, discard)
  - Cleanup procedures
  - Anti-patterns section
  - Integration as final step of implement phase
- **Verify**: File parses correctly, frontmatter valid
- **Complexity**: Medium

**Phase 2 Checkpoint**: Completion quality skills complete

---

### Phase 3: Creative Workflow Skills

#### Step 3.1: Create brainstorming skill directory

- **Files**: `skills/brainstorming/`
- **Action**: Create directory structure
- **Verify**: Directory exists
- **Complexity**: Small

#### Step 3.2: Write brainstorming SKILL.md

- **Files**: `skills/brainstorming/SKILL.md`
- **Action**: Create skill with:
  - YAML frontmatter (name, description)
  - Purpose: idea exploration before research/planning
  - Three-phase approach (understand, explore, document)
  - Progressive questioning methodology
  - Trade-off presentation format
  - Design documentation output
  - Anti-patterns section
  - Handoff to research or plan phases
- **Verify**: File parses correctly, frontmatter valid
- **Complexity**: Medium

**Phase 3 Checkpoint**: Creative workflow skill complete

---

### Phase 4: Advanced Pattern Skills

#### Step 4.1: Create receiving-code-review skill directory

- **Files**: `skills/receiving-code-review/`
- **Action**: Create directory structure
- **Verify**: Directory exists
- **Complexity**: Small

#### Step 4.2: Write receiving-code-review SKILL.md

- **Files**: `skills/receiving-code-review/SKILL.md`
- **Action**: Create skill with:
  - YAML frontmatter (name, description)
  - Purpose: verification-first response to feedback
  - Five-step response pattern
  - When to push back with reasoning
  - Implementation sequence (blocking, simple, complex)
  - Prohibited performative responses
  - Anti-patterns section
  - Integration with implement phase review cycles
- **Verify**: File parses correctly, frontmatter valid
- **Complexity**: Medium

#### Step 4.3: Create git-worktrees skill directory

- **Files**: `skills/git-worktrees/`
- **Action**: Create directory structure
- **Verify**: Directory exists
- **Complexity**: Small

#### Step 4.4: Write git-worktrees SKILL.md

- **Files**: `skills/git-worktrees/SKILL.md`
- **Action**: Create skill with:
  - YAML frontmatter (name, description)
  - Purpose: isolated workspaces for parallel work
  - Directory selection priority
  - Safety verification (.gitignore)
  - Setup automation detection
  - Cleanup procedures
  - Anti-patterns section
  - Integration with plan phase
- **Verify**: File parses correctly, frontmatter valid
- **Complexity**: Medium

#### Step 4.5: Create parallel-agents skill directory

- **Files**: `skills/parallel-agents/`
- **Action**: Create directory structure
- **Verify**: Directory exists
- **Complexity**: Small

#### Step 4.6: Write parallel-agents SKILL.md

- **Files**: `skills/parallel-agents/SKILL.md`
- **Action**: Create skill with:
  - YAML frontmatter (name, description)
  - Purpose: concurrent independent work
  - Decision framework (when to parallelize)
  - Agent prompt structure (focused, self-contained)
  - Result integration approach
  - Conflict resolution
  - Anti-patterns section
  - Integration with implement phase for multi-file work
- **Verify**: File parses correctly, frontmatter valid
- **Complexity**: Medium

**Phase 4 Checkpoint**: Advanced pattern skills complete

---

### Phase 5: Validation

#### Step 5.1: Verify all skills load

- **Files**: All 8 skill directories
- **Action**: Invoke each skill via Skill tool to confirm loading
- **Verify**: No errors on skill invocation
- **Complexity**: Small

#### Step 5.2: Review skill consistency

- **Files**: All 8 SKILL.md files
- **Action**: Check naming conventions, frontmatter format, section structure
- **Verify**: All skills follow consistent patterns
- **Complexity**: Small

**Phase 5 Checkpoint**: All skills validated

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Skill content too verbose | Cluttered methodology | Keep focused, reference superpowers as baseline |
| Inconsistent structure | Confusing UX | Use existing skills as templates |
| Missing integration points | Skills feel disconnected | Document workflow integration in each skill |
| Scope creep | Plan grows unbounded | Stick to identified 8 skills only |

## Rollback Strategy

Delete skill directories:
```bash
rm -rf skills/test-driven-development
rm -rf skills/systematic-debugging
rm -rf skills/verification-before-completion
rm -rf skills/finishing-work
rm -rf skills/brainstorming
rm -rf skills/receiving-code-review
rm -rf skills/git-worktrees
rm -rf skills/parallel-agents
```

No other files are modified, so rollback is complete deletion.

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
