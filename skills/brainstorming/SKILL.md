---
name: brainstorming
description: >-
  Collaborative design methodology for creative work. Use before research or
  planning when requirements are unclear, multiple approaches exist, or the
  idea needs exploration. Refines ideas through progressive questioning.
---

# Brainstorming

Explore ideas collaboratively before committing to an approach.

## Purpose

Jumping from vague ideas to implementation wastes effort. This skill provides
structured exploration to refine concepts, surface constraints, and evaluate
approaches before committing to research or planning. Good brainstorming
prevents building the wrong thing.

## When to Use

Use brainstorming when:

- Requirements are vague or incomplete
- Multiple valid approaches exist
- The problem space is unfamiliar
- Trade-offs need explicit discussion
- Creative design decisions are required

Skip brainstorming when:

- Requirements are clear and specific
- The approach is obvious
- This is a bug fix with known cause
- This is routine maintenance

## The Three Phases

### Phase 1: Understanding the Idea

**Goal**: Clarify what the user wants to accomplish.

Ask questions one at a time using AskUserQuestion:

1. **What problem are you solving?**
   - The underlying need, not the proposed solution
   - Why does this matter?

2. **Who is this for?**
   - End users, developers, operators?
   - What do they need?

3. **What does success look like?**
   - How will you know it works?
   - What would make this valuable?

4. **What constraints exist?**
   - Technical limitations
   - Time constraints
   - Compatibility requirements

5. **What have you considered?**
   - Initial ideas or preferences
   - Approaches to avoid
   - Prior art to reference

**Prefer multiple-choice questions** when possible. Open-ended is fine for
exploration, but specific choices accelerate understanding.

### Phase 2: Exploring Approaches

**Goal**: Present options with trade-offs.

After understanding the idea, present 2-3 approaches:

```text
## Approach A: [Name]
[2-3 sentences describing the approach]

**Pros**: [Key advantages]
**Cons**: [Key disadvantages]
**Best when**: [Situations where this shines]

## Approach B: [Name]
[2-3 sentences describing the approach]

**Pros**: [Key advantages]
**Cons**: [Key disadvantages]
**Best when**: [Situations where this shines]

## Approach C: [Name] (if applicable)
...

## Recommendation
[Which approach and why, based on stated constraints]
```

Use AskUserQuestion to get user's preference:

- "Approach A (recommended)" - with brief rationale
- "Approach B" - with brief rationale
- "Explore further" - discuss more options
- "None of these" - gather more requirements

### Phase 3: Design Documentation

**Goal**: Document the agreed design.

After selecting an approach, document it:

1. **Present design in sections** (200-300 words each)
2. **Validate each section** before continuing
3. **Adjust based on feedback**
4. **Save final design** to `docs/plans/YYYY-MM-DD-<topic>-design.md`

Design document structure:

```markdown
# Design: <Topic> (YYYY-MM-DD)

## Problem Statement
[What problem this solves]

## Chosen Approach
[Selected approach and rationale]

## Design Details
[Specific design decisions]

## Trade-offs Accepted
[What we're giving up and why it's acceptable]

## Open Questions
[Anything still unresolved]

## Next Steps
- [ ] Research phase (if needed)
- [ ] Planning phase
- [ ] Implementation
```

## Questioning Techniques

### Funnel Questions

Start broad, narrow based on answers:

```text
1. "What are you trying to build?" (broad)
2. "Which users will interact with this?" (narrowing)
3. "What's the most important interaction?" (specific)
```

### Assumption Surfacing

Make implicit assumptions explicit:

```text
"I'm assuming this needs to integrate with the existing auth system.
Is that correct?"
```

### Trade-off Questions

When multiple valid choices exist:

```text
"There's a trade-off here:
- Option A is simpler but less flexible
- Option B is more flexible but more complex

Which matters more for this use case?"
```

### Examples for Clarity

When requirements are vague:

```text
"Can you give me an example of what you'd expect to happen
when a user does X?"
```

## YAGNI Principle

**You Aren't Gonna Need It.**

Ruthlessly apply this during brainstorming:

- Reject features "for later"
- Question every "nice to have"
- Focus on the minimum viable solution
- Complexity can be added later; removing it is hard

```text
User: "We should also add support for X in case we need it"
Response: "Let's focus on the core need first. We can add X
later if it becomes necessary. What's the minimum we need now?"
```

## Transition to Next Phase

After brainstorming, guide to appropriate next step:

**If design is complete and validated:**

```text
"Design documented at docs/plans/YYYY-MM-DD-<topic>-design.md

Ready to proceed?"
- "Start research" → /rpikit:research
- "Create implementation plan" → /rpikit:plan
- "Continue brainstorming" → More exploration
```

**If more investigation needed:**

```text
"The design needs more context about [topic].

Recommend research phase to investigate before planning."
```

## Integration with RPI Workflow

Brainstorming is an optional pre-phase:

```text
[Brainstorming] → Research → Plan → Implement
     ^
     Optional when requirements unclear
```

Brainstorming output (design document) feeds into research or planning.

## Anti-Patterns

### Skipping to Solutions

**Wrong**: "Let's build X using Y framework"
**Right**: "What problem are we solving? Who is it for?"

### Analysis Paralysis

**Wrong**: Endless exploration without converging
**Right**: Time-box exploration, make decisions

### Gold Plating

**Wrong**: Designing every possible feature
**Right**: YAGNI - minimum viable solution first

### Ignoring Constraints

**Wrong**: Designing without considering limitations
**Right**: Surface constraints early, design within them

### Monologue Design

**Wrong**: Presenting complete design without validation
**Right**: Incremental presentation with checkpoints

## Checklist Before Proceeding

- [ ] Problem statement clear
- [ ] Success criteria defined
- [ ] Constraints identified
- [ ] Multiple approaches considered
- [ ] Trade-offs discussed
- [ ] YAGNI applied ruthlessly
- [ ] Design documented (if proceeding to plan)
- [ ] Next phase identified
