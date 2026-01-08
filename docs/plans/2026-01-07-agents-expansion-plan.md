# Plan: Agents Expansion (2026-01-07)

## Summary

Add 3 new agents to support the recently added skills: test-runner (supports TDD), verifier (supports verification-before-completion), and debugger (supports systematic-debugging). Each agent will follow existing patterns with YAML frontmatter, clear mission, structured methodology, and defined output formats.

## Stakes Classification

**Level**: Medium
**Rationale**: Additive-only changes to agents/ directory. No modification to existing agents or skills. Easy rollback by deleting agent files. Testable via Task tool invocation.

## Context

**Research**: Based on analysis from skills expansion work and existing agent patterns
**Affected Areas**: `agents/` directory (3 new files)

## Success Criteria

- [ ] All 3 agents created with proper YAML frontmatter (name, description, model, color)
- [ ] Agents follow established patterns from file-finder and code-reviewer
- [ ] Each agent has clear mission, methodology, output format, and edge case handling
- [ ] Agents integrate with corresponding skills (TDD, verification, debugging)
- [ ] Agents can be invoked via Task tool with subagent_type

## Implementation Steps

### Phase 1: Test Runner Agent

#### Step 1.1: Create test-runner agent file

- **Files**: `agents/test-runner.md`
- **Action**: Create agent with:
  - YAML frontmatter (name: test-runner, model: haiku, color: green)
  - Description: Run tests and report results for TDD workflow
  - Mission: Support RED-GREEN-REFACTOR cycle with clear test status reporting
  - Methodology:
    1. Detect project test framework (npm test, cargo test, pytest, etc.)
    2. Run tests with appropriate flags for output
    3. Parse results (pass/fail counts, failed test names)
    4. Report structured results with clear RED/GREEN status
  - Output format: Test report with status, counts, failures
  - Edge cases: No tests found, framework detection failure, flaky tests
  - Integration with test-driven-development skill
- **Verify**: File parses correctly, frontmatter valid, methodology clear
- **Complexity**: Medium

**Phase 1 Checkpoint**: Test runner agent complete

---

### Phase 2: Verifier Agent

#### Step 2.1: Create verifier agent file

- **Files**: `agents/verifier.md`
- **Action**: Create agent with:
  - YAML frontmatter (name: verifier, model: haiku, color: yellow)
  - Description: Run comprehensive verification checks before completion claims
  - Mission: Enforce "evidence before claims" by running all verification checks
  - Methodology:
    1. Identify all verification commands (tests, lint, typecheck, build)
    2. Run each check and capture output
    3. Parse results for pass/fail status
    4. Produce comprehensive verification report
  - Output format: Verification report with all check statuses
  - Edge cases: Missing tools, partial passes, long-running checks
  - Integration with verification-before-completion skill
- **Verify**: File parses correctly, frontmatter valid, methodology clear
- **Complexity**: Medium

**Phase 2 Checkpoint**: Verifier agent complete

---

### Phase 3: Debugger Agent

#### Step 3.1: Create debugger agent file

- **Files**: `agents/debugger.md`
- **Action**: Create agent with:
  - YAML frontmatter (name: debugger, model: sonnet, color: red)
  - Description: Investigate errors systematically to find root cause
  - Mission: Support systematic debugging by gathering evidence before fixes
  - Methodology:
    1. Investigate: Gather error context (logs, stack traces, state)
    2. Analyze: Identify patterns and anomalies in evidence
    3. Hypothesize: Form testable theories about root cause
    4. Report: Present findings with confidence levels
  - Output format: Debug report with evidence, analysis, hypotheses
  - Edge cases: Intermittent errors, missing logs, multiple potential causes
  - Integration with systematic-debugging skill
- **Verify**: File parses correctly, frontmatter valid, methodology clear
- **Complexity**: Medium

**Phase 3 Checkpoint**: Debugger agent complete

---

### Phase 4: Integration and Validation

#### Step 4.1: Update README with new agents

- **Files**: `README.md`
- **Action**: Document the three new agents in appropriate section
- **Verify**: README accurately reflects available agents
- **Complexity**: Small

#### Step 4.2: Verify all agents load

- **Files**: All 3 agent files
- **Action**: Confirm Task tool recognizes each agent type
- **Verify**: No errors when referencing agents
- **Complexity**: Small

#### Step 4.3: Run markdownlint on new files

- **Files**: `agents/test-runner.md`, `agents/verifier.md`, `agents/debugger.md`
- **Action**: Ensure all files pass markdownlint
- **Verify**: `npx markdownlint agents/*.md` returns no errors
- **Complexity**: Small

**Phase 4 Checkpoint**: All agents validated and documented

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Agent model selection wrong | Performance/cost issues | Use haiku for simple tasks, sonnet for complex analysis |
| Inconsistent with existing agents | Confusing UX | Use file-finder and code-reviewer as templates |
| Framework detection fails | Agent can't run tests | Include manual override and fallback strategies |
| Output format unclear | Users confused by results | Follow structured report patterns from existing agents |

## Rollback Strategy

Delete agent files:

```bash
rm agents/test-runner.md
rm agents/verifier.md
rm agents/debugger.md
```

Revert README changes if needed. No other files modified.

## Status

- [x] Plan approved
- [x] Implementation started
- [x] Implementation complete
