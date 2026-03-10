---
name: writing-plans
description: >-
  This skill should be used when the user asks to "create a plan",
  "plan the implementation", "design the approach", "break down the task",
  "write an implementation plan", or invokes the rpikit:plan command. Provides
  methodology for creating actionable implementation plans with verification
  criteria.
---

# Planning Phase

Create an implementation plan for: **$ARGUMENTS**

## Purpose

Planning transforms research findings into actionable implementation
strategy. A good plan enables disciplined execution by breaking work into
granular tasks with clear verification criteria. Plans serve as contracts
between human and AI, ensuring alignment before code is written.

## Process

### 1. Check for Research

Look for existing research at: `docs/plans/YYYY-MM-DD-<topic>-research.md`

(Search for files matching `*-<topic>-research.md` pattern)

If research exists:

- Read and reference the research findings
- Build the plan on documented context
- Link to research in plan document

If no research exists:

- Ask if research should be conducted first
- For high-stakes tasks, recommend research first
- For low-stakes tasks, use the **file-finder** agent to locate relevant files:

```text
Task tool with subagent_type: "file-finder"
Prompt: "Find files related to [task]. Goal: [what will be implemented]"
```

### 2. Define Success Criteria

Before planning tasks, establish what "done" looks like:

- Functional requirements (what it does)
- Non-functional requirements (performance, security)
- Acceptance criteria (how to verify)

Use AskUserQuestion to clarify requirements if needed.

### 3. Classify Stakes

Determine implementation risk level:

| Stakes     | Characteristics                              | Planning Rigor |
| ---------- | -------------------------------------------- | -------------- |
| **Low**    | Isolated change, easy rollback, low impact   | Brief plan     |
| **Medium** | Multiple files, moderate impact, testable    | Standard plan  |
| **High**   | Architectural, hard to rollback, wide impact | Detailed plan  |

Document the classification and rationale in the plan.

### 4. Break Down Tasks

Decompose work into granular, verifiable steps.

**Identify target files:**

Use file paths from research document, or if unavailable, use the
**file-finder** agent to locate files for each task area:

```text
Task tool with subagent_type: "file-finder"
Prompt: "Find files for [specific task]. Looking for [what to modify]"
```

**For each task include:**

- **Description**: Clear statement of what to do
- **Files**: Target files with line references when known
- **Action**: Specific changes to make
- **Verify**: How to confirm the step is complete
- **Complexity**: Small / Medium / Large

Prefer small tasks (2-5 minute verification time).

Group related tasks into phases with checkpoint verifications.

**Identify parallel step groups (when applicable):**

When a plan contains steps that are genuinely independent, mark them as
a parallel group so the implementer can execute them concurrently. Steps
are independent when they:

- Create new files that don't import from each other
- Modify separate modules with no shared interfaces
- Add tests for different, unrelated functionality

Steps are NOT independent when:

- Step B imports or calls code created in Step A
- Both steps modify the same file
- Step B's tests exercise code from Step A

Only mark groups as parallel when independence is clear. When in doubt,
keep steps sequential — incorrect parallelization causes merge conflicts
and integration failures. Plans with fewer than 4 steps rarely benefit
from parallelization.

**Research implementation approaches (when needed):**

If the plan involves unfamiliar libraries, APIs, or patterns, use the
**web-researcher** agent to inform task design:

```text
Task tool with subagent_type: "web-researcher"
Prompt: "[specific question about implementation approach, library usage, or best practice]"
```

**Plan test cases for each task:**

Every task that changes code must enumerate its test cases upfront. This
ensures implementation follows TDD discipline — tests are written before
production code, not as an afterthought.

For each code-changing task, list:

- **Automated tests** (unit, integration): Specific inputs, expected outputs,
  and edge cases. These become the RED step during implementation.
- **Manual verification** (UI, CLI, deploy): Steps a human performs to confirm
  behavior. Use when automated testing is impractical.

Structure task steps so the test is the first sub-step and production code
follows. This maps directly to the Red-Green-Refactor cycle enforced by the
`rpikit:test-driven-development` skill during implementation.

> **Boundary**: Plans enumerate *what* to test (cases, inputs, expected
> outputs). The TDD skill covers *how* to execute (Red-Green-Refactor cycle,
> test structure, assertion patterns).

Include edge cases and boundary conditions:

- Empty/null inputs
- Boundary values (0, max, off-by-one)
- Error paths (invalid input, network failure, permission denied)
- Concurrency or ordering concerns when relevant

#### Good Task Examples

```markdown
#### Step 1.1: Test email validation (RED)

- **Files**: `src/utils/__tests__/validation.test.ts`
- **Action**: Write failing tests for validateEmail()
- **Test cases**:
  - `"user@example.com"` → valid
  - `"user@sub.example.com"` → valid
  - `""` → invalid (empty string)
  - `"no-at-sign"` → invalid (missing @)
  - `"user@"` → invalid (missing domain)
- **Verify**: Tests exist and fail (no implementation yet)
- **Complexity**: Small

#### Step 1.2: Implement email validation (GREEN)

- **Files**: `src/utils/validation.ts`
- **Action**: Create validateEmail() using regex pattern from validatePhone()
- **Verify**: All tests from Step 1.1 pass
- **Complexity**: Small
```

```markdown
#### Step 2.1: Test user creation endpoint (RED)

- **Files**: `src/routes/__tests__/users.test.ts`
- **Action**: Write failing integration tests for email in user creation
- **Test cases**:
  - POST /users with valid email → 201, email in response body
  - POST /users with invalid email → 400, error message
  - POST /users without email → 400 (if required) or 201 (if optional)
- **Verify**: Tests exist and fail
- **Complexity**: Small

#### Step 2.2: Update API endpoint (GREEN)

- **Files**: `src/routes/users.ts:45-60`
- **Action**: Add email field to user creation endpoint with validation
- **Verify**: All tests from Step 2.1 pass
- **Complexity**: Small
```

```markdown
#### Step 3.1: Verify dashboard renders new widget

- **Files**: N/A (manual verification)
- **Action**: Manual verification of dashboard widget
- **Manual test cases**:
  - Load dashboard → widget appears in correct position
  - Resize browser to mobile width → widget reflows correctly
  - Click widget action button → expected modal opens
- **Verify**: All manual checks pass in browser
- **Complexity**: Small
```

#### Bad Task Examples

```markdown
#### Step 1: Implement feature

- **Action**: Add the new feature
- **Complexity**: Large
```

**Problem**: Too vague, no verification, no file references

```markdown
#### Step 1: Refactor authentication system

- **Action**: Update all auth code to use new pattern
- **Complexity**: Large
```

**Problem**: Too large, should be broken into multiple phases

```markdown
#### Step 1: Add validation function

- **Files**: `src/utils/validation.ts`
- **Action**: Create validateEmail() with unit tests
- **Verify**: Tests pass
- **Complexity**: Small
```

**Problem**: No test cases enumerated, test and implementation combined into
one step. Without explicit test cases, the implementer writes tests after the
code — losing TDD discipline

### 5. Document Risks

Identify what could go wrong:

- Breaking changes to existing functionality
- Performance implications
- Security considerations
- Dependencies that might fail

For external dependencies or security concerns, use the **web-researcher**
agent to investigate known issues:

```text
Task tool with subagent_type: "web-researcher"
Prompt: "Known issues, security vulnerabilities, or breaking changes in [library/API version]"
```

Include rollback strategy for high-stakes changes.

### 6. Write Plan Document

Create plan at: `docs/plans/YYYY-MM-DD-<topic>-plan.md`

(Use today's date in YYYY-MM-DD format)

Use this structure:

```markdown
# Plan: $ARGUMENTS (YYYY-MM-DD)

## Summary

[One paragraph describing what will be implemented]

## Stakes Classification

**Level**: Low | Medium | High
**Rationale**: [Why this classification]

## Context

**Research**: [Link to research document if exists]
**Affected Areas**: [Components, services, files]

## Success Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Implementation Steps

### Phase 1: [Phase Name]

#### Step 1.1: [Task Description]

- **Files**: `path/to/file.ts:lines`
- **Action**: [What to do]
- **Verify**: [How to confirm done]
- **Complexity**: Small

#### Step 1.2: [Task Description]

- **Files**: `path/to/file.ts:lines`
- **Action**: [What to do]
- **Verify**: [How to confirm done]
- **Complexity**: Small

### Phase 2: [Phase Name] *(parallel with Phase 3)*

[When phases or steps are independent, mark them with
*(parallel with Phase N)* so the implementer can execute
them concurrently. Omit this annotation for sequential phases.]

[Continue pattern...]

## Test Strategy

### Automated Tests

| Test Case                    | Type        | Input       | Expected Output |
| ---------------------------- | ----------- | ----------- | --------------- |
| [Descriptive test name]      | Unit        | [Input]     | [Output]        |
| [Descriptive test name]      | Integration | [Input]     | [Output]        |

### Manual Verification

- [ ] [Manual check description and steps]
- [ ] [Manual check description and steps]

## Risks and Mitigations

| Risk   | Impact   | Mitigation       |
| ------ | -------- | ---------------- |
| [Risk] | [Impact] | [How to address] |

## Rollback Strategy

[How to undo changes if needed]

## Status

- [ ] Plan approved
- [ ] Implementation started
- [ ] Implementation complete
```

### 7. Request Approval

Present plan summary and request explicit approval:

"Plan created for '$ARGUMENTS' at `docs/plans/YYYY-MM-DD-<topic>-plan.md`.

**Summary**: [brief description]
**Stakes**: [level]
**Steps**: [count] steps in [count] phases

Ready to approve and begin implementation?"

Use AskUserQuestion with options:

- "Approve and implement" - Mark approved, proceed to rpikit:implement
- "Request changes" - Specify what to modify
- "Return to research" - Gather more context first

If approved, invoke the Skill tool with skill "rpikit:implementing-plans"
to begin implementation.

## Plan Iteration

If a plan already exists at `docs/plans/YYYY-MM-DD-<topic>-plan.md`:

(Search for files matching `*-<topic>-plan.md` pattern)

1. Read the existing plan
2. Ask user's intent:
   - "Refine this plan" - Update existing plan
   - "Start fresh" - Create new plan
   - "View plan" - Display current plan

When refining:

- Preserve approved status if already approved
- Document changes made
- Re-request approval for significant changes

## Anti-Patterns to Avoid

### Vague Tasks

**Wrong**: "Update the code"
**Right**: "Add error handling to fetchUser() in src/api/users.ts:23-45"

### Missing Verification

**Wrong**: Tasks without success criteria
**Right**: Every task has "Verify:" with specific check

### Skipping Approval

**Wrong**: Proceeding to implementation without confirmation
**Right**: Explicit AskUserQuestion approval gate

### Over-Planning

**Wrong**: Spending hours planning a 10-minute fix
**Right**: Match planning rigor to stakes level

### Under-Planning

**Wrong**: "We'll figure it out as we go"
**Right**: Sufficient detail to enable disciplined execution

## Quality Checklist

Before requesting approval:

- [ ] All tasks have clear verification criteria
- [ ] Test cases enumerated for each code change (automated and manual)
- [ ] Test steps precede implementation steps (RED before GREEN)
- [ ] Stakes level is documented with rationale
- [ ] Tasks are granular (prefer small complexity)
- [ ] Risks are identified with mitigations
- [ ] Rollback strategy documented for high stakes
- [ ] Plan document created at docs/plans/

## Markdown Validation

After writing the plan document, validate markdown formatting:

Invoke Skill tool with skill: "rpikit:markdown-validation"

Fix all errors before requesting approval. Plans with linting errors indicate
lack of attention to detail.
