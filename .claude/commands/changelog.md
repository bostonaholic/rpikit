---
description: Update CHANGELOG.md with user-facing changes since last update
---

Update the project's CHANGELOG.md with relevant user-facing changes since it was last updated.

## Procedure

### 1. Find the baseline

Read `CHANGELOG.md` and identify the most recent **versioned** release heading (e.g., `## [0.5.1] - 2026-02-27`). Extract the version tag (e.g., `v0.5.1`).

### 2. Gather commits since baseline

Run:

```bash
git log --oneline <tag>..HEAD
```

If the tag doesn't exist as a git tag, fall back to finding the commit whose message contains the version string (e.g., `chore(release): 0.5.1`) and use that commit hash instead.

### 3. Analyze each commit for user-facing impact

For every commit, read the diff (`git show --stat <hash>` and `git show <hash>` as needed) and classify it:

- **User-facing** — changes to commands, skills, agents, plugin manifest, workflow behavior, or documentation that affects how users interact with the plugin.
- **Internal-only** — CI config, test-only changes, refactors with no behavior change, changelog-only updates, release bookkeeping.

**Skip internal-only commits.** Only user-facing changes belong in the changelog.

Also skip any commit that is already represented in the existing `[Unreleased]` section.

### 4. Write changelog entries

Group changes under the appropriate [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) categories:

- **Added** — new features, commands, skills, agents
- **Changed** — modifications to existing behavior
- **Deprecated** — soon-to-be-removed features
- **Removed** — removed features
- **Fixed** — bug fixes
- **Security** — vulnerability fixes

Only include categories that have entries. Place entries under the `## [Unreleased]` heading in `CHANGELOG.md`, preserving any existing unreleased entries that are still accurate.

Each entry should be a concise, user-oriented description of **what changed and why it matters**, not a restatement of the commit message. Reference skill/command/agent names with backticks.

### 5. Report

If there are no user-facing changes to add, say so and do not modify the file.

If changes were added, show the user what was written to the `[Unreleased]` section.
