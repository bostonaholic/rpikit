# Design: README Release-Gating (2026-03-13)

## Problem Statement

The README on `main` is the primary page GitHub visitors see. Most visitors are
plugin users who installed via the marketplace, which serves the latest tagged
release. When the README tracks `main` ahead of the release, users see
documentation for features or changes they don't have yet, eroding trust.

## Chosen Approach

**README tracks releases, not `main`.** Between releases, user-facing changes
are documented only in the CHANGELOG's `[Unreleased]` section. At release time,
the README is batch-updated to reflect all accumulated changes.

This was chosen over two alternatives:

- **README tracks `main`** — standard open-source convention, but prioritizes
  contributors over users. Most rpikit GitHub visitors are users.
- **README tracks `main` + version badge** — adds signposting but still shows
  users documentation for features they can't use yet.

## Design Details

### Rule Change in CLAUDE.md

Replace the "Documentation Requirements" section:

**Before:**

> CRITICAL: Always update README.md. After ANY change that affects user-visible
> behavior, update README.md in the same commit.

**After:**

> README.md is updated only during release prep — never between releases. After
> changes that affect user-visible behavior, update CHANGELOG.md's `[Unreleased]`
> section instead. At release time, batch-update the README to reflect all
> accumulated changes.

### Release Process Update

Add a step before the existing release steps:

> 1. Update README.md to reflect all changes listed in `[Unreleased]`

This becomes the first step because the README commit should be part of the
release commit (or immediately precede it), ensuring the tagged release has an
accurate README.

### CHANGELOG as Bridge

The `[Unreleased]` section already exists and tracks user-facing changes. No
process change needed here. At release time, reviewing `[Unreleased]` entries
provides a complete list of what the README needs to cover.

## Trade-offs Accepted

- **Developer confusion on `main`**: A developer reading the README on `main`
  may see docs that don't match the current code. Developers are expected to
  check the CHANGELOG or the code itself. This is acceptable because the primary
  README audience is end-users, not contributors.
- **Batch update burden**: Updating the README at release time requires reviewing
  all unreleased changes at once. This is mitigated by the CHANGELOG serving as a
  checklist and by releases happening frequently enough that changes don't
  accumulate excessively.

## Open Questions

None — the design is straightforward and builds on existing CHANGELOG practices.

## Next Steps

- [ ] Update CLAUDE.md "Documentation Requirements" section with new rule
- [ ] Update CLAUDE.md "Releasing" section to include README update step
