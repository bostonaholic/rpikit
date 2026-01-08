# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
