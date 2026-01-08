---
name: parallel-agents
description: >-
  Concurrent agent dispatch for independent problems. Use when facing multiple
  independent tasks that can be worked on simultaneously. Reduces total time
  by parallelizing work that has no shared state.
---

# Parallel Agents

Dispatch multiple agents concurrently for independent problems.

## Purpose

Sequential investigation of independent problems wastes time. When multiple
issues have different root causes and don't affect each other, dispatching
agents in parallel reduces total resolution time significantly.

## When to Use

Use parallel agents when:

- 3+ test files failing with different root causes
- Multiple subsystems broken independently
- Independent tasks in a plan that don't share state
- Bulk operations across unrelated files

**Do NOT use when:**

- Failures might be related (fixing one might fix others)
- Tasks have sequential dependencies
- Changes could conflict with each other
- Shared state exists between tasks

## Decision Framework

Before parallelizing, ask:

```text
1. Are these problems truly independent?
   - Different files?
   - Different subsystems?
   - No shared data or state?

2. Could fixing one affect another?
   - Shared dependencies?
   - Common configuration?
   - Overlapping code paths?

3. Will changes conflict?
   - Same file modifications?
   - Related API changes?
   - Interconnected tests?
```

If any answer suggests dependency, work sequentially instead.

## The Parallel Process

### Step 1: Identify Independent Problems

Group failures or tasks by independence:

```text
Test failures example:
- auth.test.js: Login validation errors (auth subsystem)
- api.test.js: Endpoint routing issues (api subsystem)
- db.test.js: Connection pool exhaustion (database subsystem)

Assessment: Independent subsystems, can parallelize
```

### Step 2: Create Focused Agent Prompts

Each agent needs a self-contained, focused prompt:

```text
Good prompt structure:
- ONE clear problem to solve
- ALL necessary context included
- SPECIFIC about expected output
- NO dependencies on other agents
```

Example prompts:

```text
Agent 1 - Auth fixes:
"Fix the login validation errors in auth.test.js.
The tests expect [specific behavior].
Current error: [error message].
Do not modify files outside src/auth/."

Agent 2 - API fixes:
"Fix the endpoint routing issues in api.test.js.
Routes should map to [expected handlers].
Current error: [error message].
Do not modify files outside src/api/."

Agent 3 - Database fixes:
"Fix the connection pool exhaustion in db.test.js.
Pool should handle [expected load].
Current error: [error message].
Do not modify files outside src/db/."
```

### Step 3: Dispatch Concurrently

Use Task tool with multiple invocations in a single message:

```text
Task tool invocations (all in one message):
1. Agent for auth fixes
2. Agent for API fixes
3. Agent for database fixes

All agents run concurrently.
```

### Step 4: Review Results

When agents complete:

```text
For each agent result:
1. Read the summary
2. Verify the claimed fix
3. Check for conflicts with other agents
4. Run affected tests
```

### Step 5: Integrate Changes

If no conflicts:

```text
1. Accept all changes
2. Run full test suite
3. Verify no regressions
```

If conflicts exist:

```text
1. Identify conflicting changes
2. Resolve conflicts manually
3. Run full test suite
4. Verify resolution is correct
```

## Agent Prompt Requirements

### Must Have

- **Focused scope**: One problem domain only
- **Self-contained context**: All info agent needs
- **Clear deliverable**: What success looks like
- **Boundary constraints**: What NOT to touch

### Must Avoid

- **Overly broad scope**: "Fix all the tests"
- **Missing context**: Assuming agent knows background
- **Vague deliverable**: "Make it work"
- **No boundaries**: Free rein to change anything

## Example: Multiple Test Failures

Situation: 6 failures across 3 test files

```text
Analysis:
- tests/auth.test.js: 2 failures (login, logout)
- tests/api.test.js: 3 failures (GET, POST, DELETE)
- tests/db.test.js: 1 failure (connection timeout)

Independence check:
- Auth tests: Isolated authentication logic
- API tests: Isolated route handling
- DB tests: Isolated database operations

Decision: Parallelize - no shared dependencies
```

Agent dispatch:

```text
Agent 1: "Fix auth.test.js failures. Login should [spec].
         Logout should [spec]. Error: [message]."

Agent 2: "Fix api.test.js failures. GET should [spec].
         POST should [spec]. DELETE should [spec]. Error: [message]."

Agent 3: "Fix db.test.js failure. Connection should [spec].
         Current timeout at [duration]. Error: [message]."
```

Results:

```text
Agent 1: Fixed login validation, logout token cleanup
Agent 2: Fixed route registration order
Agent 3: Increased pool size and added retry logic

Conflict check: No overlapping files
Integration: All changes accepted
Final tests: All passing
```

## Integration with Implement Phase

Use during implementation when:

- Multiple plan steps are independent
- Test failures span unrelated subsystems
- Bulk changes across independent files

```text
Plan step identifies parallelizable work
→ Verify independence
→ Create focused agent prompts
→ Dispatch concurrently
→ Review and integrate
→ Continue with next plan step
```

## Conflict Resolution

When agents modify overlapping code:

```text
1. Identify the conflict
   - Same file?
   - Same function?
   - Incompatible changes?

2. Determine precedence
   - Which change is more correct?
   - Which aligns with requirements?
   - Which has fewer side effects?

3. Merge carefully
   - Take best of both if compatible
   - Choose one if mutually exclusive
   - Test merged result

4. Verify resolution
   - Run affected tests
   - Check for regressions
   - Document the resolution
```

## Anti-Patterns

### Parallelizing Related Problems

**Wrong**: Dispatch agents for potentially related failures
**Right**: Verify independence before parallelizing

### Overly Broad Agent Prompts

**Wrong**: "Fix all failing tests in this area"
**Right**: "Fix specific failure X with context Y"

### Ignoring Conflicts

**Wrong**: Accept all agent outputs without checking
**Right**: Review for conflicts before integrating

### Too Many Parallel Agents

**Wrong**: Dispatch 10+ agents simultaneously
**Right**: Keep to 3-5 agents for manageability

### No Boundary Constraints

**Wrong**: Let agents modify any file
**Right**: Constrain each agent to relevant files

## Checklist Before Dispatching

- [ ] Problems verified as independent
- [ ] No shared state between tasks
- [ ] Changes won't conflict
- [ ] Each agent prompt is focused
- [ ] Each agent prompt is self-contained
- [ ] Boundaries specified for each agent
- [ ] Expected output is clear

## Checklist After Completion

- [ ] All agent results reviewed
- [ ] Conflicts identified and resolved
- [ ] Full test suite passes
- [ ] No regressions introduced
- [ ] Changes integrated cleanly
