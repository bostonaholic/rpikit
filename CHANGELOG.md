# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
