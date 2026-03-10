# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.0] - 2026-03-10

### Added

- `/rpikit:rpi` command for end-to-end research, plan, and implement pipeline in a single session using parallel subagents
- `research-to-implementation` skill that orchestrates parallel research subagents, synthesis, planning, and implementation with approval gates between phases
- `synthesizing-research` skill for consolidating parallel research findings into a single unified report

### Changed

- `writing-plans` skill now supports marking independent steps/phases as parallel groups for concurrent execution
- Updated mocking guidance in `test-driven-development` and `reviewing-code` skills to adopt "never mock what you can use for real" philosophy, replacing boundary-based mocking advice with a preference for real implementations over mocks
- `markdown-validation` skill now documents project-level markdownlint configuration files and respects the host project's rules when validating

### Fixed

- `/rpikit:research`, `/rpikit:plan`, and `/rpikit:implement` commands now reliably load full skill methodology instead of letting the agent skip the Skill tool call and improvise from the short description alone

## [0.5.1] - 2026-02-27

### Changed

- Enhanced `writing-plans` skill with TDD test planning guidance:
  - New "Plan test cases" subsection requiring test case enumeration for every code-changing task
  - Task examples updated to show RED/GREEN step pairs with specific inputs and expected outputs
  - New bad example showing test-and-implementation combined anti-pattern
  - Quality checklist now requires test cases and test-first step ordering
  - Plan document template includes "Test Strategy" section with automated and manual test tables

## [0.5.0] - 2026-02-23

### Added

- `/rpikit:decision` command for recording architectural decisions as ADRs
- `documenting-decisions` skill with ADR template, sequential numbering, and
  status tracking

## [0.4.2] - 2026-02-17

### Changed

- Enhanced `git-worktrees` skill with technical precision and UX improvements:
  - Added `git check-ignore` verification commands for safety checks
  - Added Quick Reference decision table for common situations
  - Added Integration section documenting skill relationships
  - Added Example Workflow showing expected session flow
  - Reformatted Anti-Patterns as scannable "Never Do These" list
  - Updated default location to recommend `.worktrees/` in project root

### Fixed

- Plugin `hooks.json` now uses correct schema format expected by Claude Code (object with `hooks` wrapper and matcher strings instead of root-level array)
- Removed stray character from plan document heading

## [0.4.1] - 2026-02-16

### Added

- New `markdown-validation` skill for validating markdown files using markdownlint
- PostToolUse hook that automatically validates `.md` files after Write/Edit operations
- Markdown validation sections added to `writing-plans`, `researching-codebase`, and `brainstorming` skills

### Fixed

- Plan and implementation artifact filenames no longer produce double-dash names (e.g., `2026-02-16--plan.md`) when commands are invoked without arguments. Filename patterns now use AI-derived `<topic>` slugs, consistent with research and brainstorming skills.

## [0.4.0] - 2026-01-13

### Changed

- Renamed core RPI skills for clarity:
  - `research-methodology` → `researching-codebase`
  - `plan-methodology` → `writing-plans`
  - `implement-methodology` → `implementing-plans`
- Renamed review commands for consistency:
  - `/rpikit:code-review` → `/rpikit:review-code`
  - `/rpikit:security-review` → `/rpikit:review-security`

### Added

- Implement command now offers worktree isolation before making changes
  - Detects if already in a worktree (skips prompt if so)
  - Stakes-based recommendation: high stakes strongly recommends, medium offers, low gives brief tip
  - Integrates with existing `git-worktrees` skill for creation and `finishing-work` skill for cleanup

### Fixed

- `/rpikit:code-review` command now works correctly (renamed internal skill to `reviewing-code` to avoid naming collision with command)

## [0.3.0] - 2026-01-07

### Added

- `/rpikit:brainstorm` command for creative exploration before research/planning
- 8 new methodology skills:
  - `test-driven-development` - RED-GREEN-REFACTOR cycle enforcement
  - `systematic-debugging` - Root cause investigation before fixes
  - `verification-before-completion` - Evidence before claims
  - `brainstorming` - Collaborative design before research/planning
  - `finishing-work` - Structured completion (merge, PR, cleanup)
  - `receiving-code-review` - Verification-first response to feedback
  - `git-worktrees` - Isolated workspaces for parallel work
  - `parallel-agents` - Concurrent dispatch for independent tasks
- 3 new autonomous agents:
  - `test-runner` - Execute tests with RED/GREEN status for TDD workflow
  - `verifier` - Comprehensive verification checks before completion claims
  - `debugger` - Systematic error investigation with hypothesis-driven analysis

### Changed

- Updated README with brainstorming vs research guidance in workflow section

## [0.2.0] - 2026-01-07

### Added

- Standalone `/rpikit:code-review` command for ad-hoc quality reviews
- Standalone `/rpikit:security-review` command for ad-hoc security reviews
- Automated test suite for plugin validation (agents, skills, commands, plugin structure)
- CI/CD pipeline with GitHub Actions for validation, testing, and linting
- Expanded .gitignore for development artifacts

## [0.1.0] - 2026-01-07

### Added

- Initial release of rpikit plugin
- Research-Plan-Implement (RPI) workflow commands:
  - `/rpikit:research` - Deep codebase exploration
  - `/rpikit:plan` - Implementation planning with stakes classification
  - `/rpikit:implement` - Disciplined execution with verification
- Methodology skills:
  - `research-methodology` - Systematic codebase investigation
  - `plan-methodology` - Granular, verifiable planning
  - `implement-methodology` - TDD and quality gates
  - `code-review` - Conventional Comments feedback
  - `security-review` - OWASP-based security analysis
- Autonomous agents:
  - `file-finder` - Intelligent file location
  - `web-researcher` - Web research with citations
  - `code-reviewer` - Quality review with soft gating
  - `security-reviewer` - Security review with hard gating
- Output artifacts in `docs/plans/` directory
- Human approval gates between workflow phases
