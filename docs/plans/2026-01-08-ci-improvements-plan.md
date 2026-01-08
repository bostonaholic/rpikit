# Plan: CI Improvements (2026-01-08)

## Summary

Add five new CI checks to improve code quality and catch issues early: shellcheck for bash scripts, link validation for markdown, spell checking for user-facing content, YAML frontmatter validation, and integration tests to verify plugin behavior.

## Stakes Classification

**Level**: Medium
**Rationale**: Adds new CI jobs and test scripts across multiple files. Changes are additive (not modifying existing behavior), easily testable, and straightforward to rollback by reverting commits.

## Context

**Research**: [docs/plans/2026-01-08-ci-checks-research.md](2026-01-08-ci-checks-research.md)
**Affected Areas**: `.github/workflows/ci.yml`, `tests/` directory, config files

## Success Criteria

- [ ] All bash scripts pass shellcheck with no errors
- [ ] All markdown links are valid (no 404s)
- [ ] No spelling errors in user-facing content
- [ ] All YAML frontmatter is syntactically valid
- [ ] Integration test verifies plugin loads and commands are recognized
- [ ] CI runs all new checks on PRs

## Implementation Steps

### Phase 1: Shellcheck (Low Effort)

#### Step 1.1: Add shellcheck job to CI workflow

- **Files**: `.github/workflows/ci.yml`
- **Action**: Add new `shellcheck` job using `ludeeus/action-shellcheck@master`
- **Verify**: Job appears in CI workflow, runs on PR
- **Complexity**: Small

#### Step 1.2: Fix any shellcheck violations in existing scripts

- **Files**: `tests/*.sh`, `bin/start`
- **Action**: Run shellcheck locally, fix any reported issues
- **Verify**: `shellcheck tests/*.sh bin/start` reports no errors
- **Complexity**: Small

### Phase 2: Link Checking (Low Effort)

#### Step 2.1: Add link-check job to CI workflow

- **Files**: `.github/workflows/ci.yml`
- **Action**: Add new `link-check` job using `lychee-action` or `markdown-link-check`
- **Verify**: Job appears in CI workflow, runs on PR
- **Complexity**: Small

#### Step 2.2: Create link check configuration

- **Files**: `.lycheerc.toml` or `.markdown-link-check.json` (new file)
- **Action**: Configure to exclude external URLs that may rate-limit CI, set timeout
- **Verify**: Config file exists, link checker uses it
- **Complexity**: Small

#### Step 2.3: Fix any broken links

- **Files**: Various `.md` files
- **Action**: Run link checker locally, fix any broken links found
- **Verify**: Link checker reports no broken links
- **Complexity**: Small

### Phase 3: Spell Checking (Medium Effort)

#### Step 3.1: Add spell-check job to CI workflow

- **Files**: `.github/workflows/ci.yml`
- **Action**: Add new `spell-check` job using `streetsidesoftware/cspell-action`
- **Verify**: Job appears in CI workflow, runs on PR
- **Complexity**: Small

#### Step 3.2: Create cspell configuration

- **Files**: `cspell.json` (new file)
- **Action**: Configure cspell with custom dictionary for project-specific terms (rpikit, frontmatter, subagent, etc.)
- **Verify**: Config file exists, cspell uses it
- **Complexity**: Small

#### Step 3.3: Fix spelling errors and populate dictionary

- **Files**: Various `.md` files, `cspell.json`
- **Action**: Run cspell locally, fix real typos, add valid terms to dictionary
- **Verify**: `npx cspell "**/*.md"` reports no errors
- **Complexity**: Medium (may require multiple iterations)

### Phase 4: YAML Frontmatter Validation (Medium Effort)

#### Step 4.1: Create frontmatter validation test script

- **Files**: `tests/test-frontmatter.sh` (new file)
- **Action**: Create bash script that extracts YAML frontmatter from all `.md` files and validates syntax using `yq` or similar
- **Verify**: Script runs without errors on valid files, catches invalid YAML
- **Complexity**: Medium

#### Step 4.2: Add frontmatter test to test runner

- **Files**: `tests/run-tests.sh`
- **Action**: Add `run_suite "frontmatter"` to test runner
- **Verify**: Frontmatter tests run as part of test suite
- **Complexity**: Small

### Phase 5: Integration Tests (Higher Effort)

#### Step 5.1: Create integration test script

- **Files**: `tests/test-integration.sh` (new file)
- **Action**: Create script that:
  1. Runs `claude --plugin-dir . --print-commands` to verify commands load
  2. Checks expected commands appear in output (research, plan, implement, etc.)
- **Verify**: Script passes when plugin is valid, fails on broken plugin
- **Complexity**: Medium

#### Step 5.2: Add integration test to test runner

- **Files**: `tests/run-tests.sh`
- **Action**: Add `run_suite "integration"` to test runner
- **Verify**: Integration tests run as part of test suite
- **Complexity**: Small

#### Step 5.3: Verify integration test works in CI

- **Files**: `.github/workflows/ci.yml` (may need adjustments)
- **Action**: Ensure Claude Code CLI is available for integration tests, verify test passes in CI environment
- **Verify**: CI runs integration tests successfully
- **Complexity**: Small

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| External link checker hits rate limits | CI flakiness | Configure timeouts, exclude known rate-limited domains |
| Spell checker flags too many false positives | Noisy CI, ignored warnings | Build comprehensive custom dictionary upfront |
| Integration test depends on Claude CLI behavior | Test may break on CLI updates | Keep test minimal, check only command presence |
| YAML validation tool not available in CI | Job fails | Use widely available tool (yq) or pure bash |

## Rollback Strategy

Each phase is independent. If a check causes problems:

1. Remove the job from `.github/workflows/ci.yml`
2. Optionally keep config files for future re-enablement

## Status

- [x] Plan approved
- [ ] Phase 1: Shellcheck complete
- [ ] Phase 2: Link checking complete
- [ ] Phase 3: Spell checking complete
- [ ] Phase 4: YAML validation complete
- [ ] Phase 5: Integration tests complete
- [ ] Implementation complete
