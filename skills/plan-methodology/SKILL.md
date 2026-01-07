---
name: plan-methodology
description: >-
  This skill should be used when the user asks to "create a plan",
  "plan the implementation", "design the approach", "break down the task",
  "write an implementation plan", or invokes the rpi:plan command. Provides
  methodology for creating actionable implementation plans with verification
  criteria.
---

# Plan Methodology

## Purpose

Planning transforms research findings into actionable implementation
strategy. A good plan enables disciplined execution by breaking work into
granular tasks with clear verification criteria. Plans serve as contracts
between human and AI, ensuring alignment before code is written.

## Core Principles

### Granular Tasks

Break work into small, verifiable units:

| Task Size | Description                        | Verification             |
| --------- | ---------------------------------- | ------------------------ |
| Small     | Single function or component       | 2-5 minutes to verify    |
| Medium    | Multiple related changes           | 10-15 minutes to verify  |
| Large     | Architectural change               | Should be broken down    |

Prefer small tasks. Large tasks hide complexity and make progress hard
to track.

### Explicit Verification

Every task must have clear success criteria:

- **Testable**: Can be verified by running code or tests
- **Observable**: Changes are visible in output or behavior
- **Specific**: No ambiguity about what "done" means

### Reference Research

Plans build on research findings. Reference the research document and use
discovered patterns, constraints, and file references.

### Human Approval Required

Plans require explicit human approval before implementation begins. Never
proceed to implementation without confirmation.

## Planning Process

### 1. Review Research

Before planning, ensure research is complete:

- Read the research document at `docs/plans/research/<topic>.md`
- Verify key questions are answered
- Note existing patterns to follow
- Understand constraints and dependencies

If research is incomplete, return to research phase.

### 2. Define Success

State what "done" looks like:

- Functional requirements (what it does)
- Non-functional requirements (performance, security)
- Acceptance criteria (how to verify)

### 3. Classify Stakes

Determine implementation risk level:

| Stakes | Characteristics                    | Planning Rigor           |
| ------ | ---------------------------------- | ------------------------ |
| Low    | Isolated, easy rollback            | Brief plan               |
| Medium | Multiple files, moderate impact    | Standard plan            |
| High   | Architectural, hard to rollback    | Detailed plan            |

Stakes classification affects implementation enforcement.

### 4. Break Down Tasks

Decompose work into ordered steps:

1. **Identify phases**: Group related changes
2. **Order by dependency**: What must come first?
3. **Add verification**: How to confirm each step?
4. **Estimate complexity**: Small/Medium/Large per task

Each task should include:

- Clear description of what to do
- Target files (with line references when known)
- Verification criteria
- Complexity estimate

### 5. Identify Risks

Document what could go wrong:

- Breaking changes to existing functionality
- Performance implications
- Security considerations
- Dependencies that might fail

### 6. Request Approval

Present the plan and ask for explicit approval using AskUserQuestion:

> "Plan ready for review. Approve this plan to proceed with implementation?"

Options should include:

- Approve and implement
- Request changes
- Return to research

## Plan Structure

Plans are written to `docs/plans/<name>.md`:

```markdown
# Plan: <Feature/Task Name>

## Summary

[One paragraph describing what will be implemented]

## Stakes Classification

**Level**: Low | Medium | High
**Rationale**: [Why this classification]

## Context

**Research**: [Link to research document if exists]
**Affected Areas**: [Components, services, files]
**Dependencies**: [What this depends on]

## Success Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

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

| Risk     | Impact   | Mitigation        |
| -------- | -------- | ----------------- |
| [Risk 1] | [Impact] | [How to address]  |

## Rollback Strategy

[How to undo changes if needed]

## Status

- [ ] Plan approved
- [ ] Implementation started
- [ ] Implementation complete
- [ ] Verified working
```

## Task Granularity Guidelines

### Good Task Examples

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

### Bad Task Examples

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

## Iteration and Refinement

Plans can be refined before approval:

### Adding Detail

If a task is too vague, expand it:

- Add specific file:line references
- Clarify the exact changes
- Add intermediate verification steps

### Splitting Tasks

If a task is too large:

- Create sub-steps within phases
- Add checkpoint verifications
- Consider making it a separate phase

### Adjusting Order

If dependencies change:

- Reorder steps to respect dependencies
- Add explicit "depends on" notes
- Verify the critical path

## Transition to Implementation

Planning is complete when:

- All tasks have clear verification criteria
- Stakes are classified
- Risks are documented
- Human has approved the plan

After approval, prompt transition:

> "Plan approved. Ready to begin implementation?"

Use AskUserQuestion to confirm. Implementation will reference this plan
document.

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

## Integration with Claude Features

### Use TodoWrite for Plan Tasks

Convert plan steps into todos for execution tracking.

### Use AskUserQuestion for Approval

Present plan summary and request explicit approval before implementation.

### Reference Research Documents

Link to and quote from research findings to justify approach.

### Use EnterPlanMode When Appropriate

For complex plans, Claude's built-in plan mode provides additional
structure.

## Additional Resources

Plan templates and examples will be stored at:

- `${CLAUDE_PLUGIN_ROOT}/docs/plans/` for output location
