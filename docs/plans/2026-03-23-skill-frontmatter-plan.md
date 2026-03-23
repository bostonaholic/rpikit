# Skill Frontmatter Improvement Plan

**Status**: Complete
**Date**: 2026-03-23
**Stakes**: Low

## Overview

Improve YAML frontmatter in SKILL.md files to use concise, behavior-focused
descriptions and add argument-hint and effort fields where appropriate.

## Phase 1: Rewrite skill descriptions

Replace verbose trigger-phrase descriptions with concise behavior-focused text.

### Step 1.1: research-plan-implement

- **File**: `skills/research-plan-implement/SKILL.md`
- **Action**: Replace description with concise text; add `effort: high`
- **New description**: End-to-end Research-Plan-Implement
  pipeline using parallel subagents. Each phase runs in its
  own context window with file artifacts as the communication
  channel between phases.
- **Verify**: YAML parses correctly, no content below `---` changed

### Step 1.2: implementing-plans

- **File**: `skills/implementing-plans/SKILL.md`
- **Action**: Replace description with concise text
- **New description**: Disciplined plan execution with
  checkpoint validation, progress tracking, and verification
  at each step. Follows an approved plan strictly, running
  verification criteria before proceeding.
- **Verify**: YAML parses correctly, no content below `---` changed

### Step 1.3: researching-codebase

- **File**: `skills/researching-codebase/SKILL.md`
- **Action**: Replace description with concise text
- **New description**: Thorough codebase exploration that
  builds understanding through collaborative dialogue.
  Investigates architecture, patterns, and implementation
  details before planning or making changes.
- **Verify**: YAML parses correctly, no content below `---` changed

### Step 1.4: writing-plans

- **File**: `skills/writing-plans/SKILL.md`
- **Action**: Replace description with concise text
- **New description**: Transform research findings into
  actionable implementation plans with granular steps,
  verification criteria, and stakes-based enforcement.
  Plans serve as contracts between human and AI.
- **Verify**: YAML parses correctly, no content below `---` changed

### Step 1.5: synthesizing-research

- **File**: `skills/synthesizing-research/SKILL.md`
- **Action**: Replace description with concise text
- **New description**: Consolidate multiple parallel research
  documents into a single unified report. Produces a
  self-contained document that a reader with no prior context
  can understand completely.
- **Verify**: YAML parses correctly, no content below `---` changed

## Phase 2: Add argument-hint to skills that use $ARGUMENTS

### Step 2.1: researching-codebase

- **File**: `skills/researching-codebase/SKILL.md`
- **Action**: Add `argument-hint: topic or question to research`
- **Verify**: YAML parses correctly

### Step 2.2: writing-plans

- **File**: `skills/writing-plans/SKILL.md`
- **Action**: Add `argument-hint: feature or change to plan`
- **Verify**: YAML parses correctly

### Step 2.3: implementing-plans

- **File**: `skills/implementing-plans/SKILL.md`
- **Action**: Add `argument-hint: feature or change to implement`
- **Verify**: YAML parses correctly

### Step 2.4: synthesizing-research

- **File**: `skills/synthesizing-research/SKILL.md`
- **Action**: Add `argument-hint: topic to synthesize research for`
- **Verify**: YAML parses correctly

### Step 2.5: reviewing-code

- **File**: `skills/reviewing-code/SKILL.md`
- **Action**: Add `argument-hint: scope or focus of the code review`
- **Verify**: YAML parses correctly

### Step 2.6: security-review

- **File**: `skills/security-review/SKILL.md`
- **Action**: Add `argument-hint: scope or focus of the security review`
- **Verify**: YAML parses correctly

### Step 2.7: documenting-decisions

- **File**: `skills/documenting-decisions/SKILL.md`
- **Action**: Add `argument-hint: decision or design document to record`
- **Verify**: YAML parses correctly

## Success Criteria

- All 5 description rewrites applied
- All 7 argument-hint fields added
- effort: high added to research-plan-implement only
- No content below closing `---` modified in any file
- All YAML frontmatter parses correctly
