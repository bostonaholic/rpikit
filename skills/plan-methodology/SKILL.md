---
name: plan-methodology
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

Look for existing research at: `docs/plans/research/$ARGUMENTS.md`

If research exists:

- Read and reference the research findings
- Build the plan on documented context
- Link to research in plan document

If no research exists:

- Ask if research should be conducted first
- For low-stakes tasks, proceed with inline exploration
- For high-stakes tasks, recommend research first

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

Decompose work into granular, verifiable steps:

For each task include:

- **Description**: Clear statement of what to do
- **Files**: Target files with line references when known
- **Action**: Specific changes to make
- **Verify**: How to confirm the step is complete
- **Complexity**: Small / Medium / Large

Prefer small tasks (2-5 minute verification time).

Group related tasks into phases with checkpoint verifications.

#### Good Task Examples

```markdown
#### Step 1.1: Add validation function

- **Files**: `src/utils/validation.ts`
- **Action**: Create validateEmail() using regex from validatePhone()
- **Verify**: Unit test passes for valid/invalid emails
- **Complexity**: Small
```

```markdown
#### Step 2.3: Update API endpoint

- **Files**: `src/routes/users.ts:45-60`
- **Action**: Add email field to user creation endpoint
- **Verify**: POST /users with email returns 201
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

### 5. Document Risks

Identify what could go wrong:

- Breaking changes to existing functionality
- Performance implications
- Security considerations
- Dependencies that might fail

Include rollback strategy for high-stakes changes.

### 6. Write Plan Document

Create plan at: `docs/plans/$ARGUMENTS.md`

Use this structure:

```markdown
# Plan: $ARGUMENTS

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

### Phase 2: [Phase Name]

[Continue pattern...]

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

"Plan created for '$ARGUMENTS' at docs/plans/$ARGUMENTS.md.

**Summary**: [brief description]
**Stakes**: [level]
**Steps**: [count] steps in [count] phases

Ready to approve and begin implementation?"

Use AskUserQuestion with options:

- "Approve and implement" - Mark approved, proceed to rpikit:implement
- "Request changes" - Specify what to modify
- "Return to research" - Gather more context first

If approved, guide user to use `/rpikit:implement $ARGUMENTS` or invoke the
Skill tool with skill "rpikit:implement-methodology".

## Plan Iteration

If a plan already exists at `docs/plans/$ARGUMENTS.md`:

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
- [ ] Stakes level is documented with rationale
- [ ] Tasks are granular (prefer small complexity)
- [ ] Risks are identified with mitigations
- [ ] Rollback strategy documented for high stakes
- [ ] Plan document created at docs/plans/
