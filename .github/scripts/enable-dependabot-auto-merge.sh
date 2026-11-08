#!/usr/bin/env bash
# Enable GitHub native auto-merge for one Dependabot pull request.
#
# This file is trusted only when it is read from the base branch. The workflow
# must fetch this script by the base SHA and must not check out the pull
# request head. The script never merges by itself: `gh pr merge --auto` asks
# GitHub to merge later, after repository rules are satisfied.

# These names are the ci.yml job names. All of them must be required before
# native auto-merge is enabled, because GitHub only waits for required checks.
REQUIRED_CHECKS=(
  "Test and Validate"
  "Lint Markdown"
  "Shellcheck"
)
GITHUB_ACTIONS_APP_ID=15368
GATE_PATHS=(
  ".github/workflows/dependabot-auto-merge.yml"
  ".github/scripts/enable-dependabot-auto-merge.sh"
)

# REST pull-request user.login. gh's JSON author field rewrites this to app/<name>.
is_dependabot_author() {
  [[ "$1" == "dependabot[bot]" ]]
}

validate_inputs() {
  local pr_number="$1"
  local head_sha="$2"
  local base_ref="$3"
  local repo="$4"

  [[ "$pr_number" =~ ^[0-9]+$ ]] || return 1
  [[ "$head_sha" =~ ^[0-9a-f]{40}$ ]] || return 1
  [[ "$base_ref" =~ ^[A-Za-z0-9._/-]+$ ]] || return 1
  [[ "$repo" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || return 1
  return 0
}

# Print required CI contexts that are absent from active branch rules.
# A context counts only when a strict required_status_checks rule lists it
# and its integration is unset or GitHub Actions. Empty output means the
# branch rules require every CI job and require the branch to be up to date.
missing_required_checks() {
  local rules_json="$1"
  local required_json

  required_json=$(printf '%s\n' "${REQUIRED_CHECKS[@]}" | jq -R . | jq -s -c .)
  jq -r \
    --argjson required "$required_json" \
    --argjson app_id "$GITHUB_ACTIONS_APP_ID" '
      def accepted:
        [
          .[]
          | select(.type == "required_status_checks")
          | select(.parameters.strict_required_status_checks_policy == true)
          | .parameters.required_status_checks[]?
          | select((.integration_id == null) or (.integration_id == $app_id))
          | .context
        ];
      (accepted) as $contexts
      | $required[]
      | . as $need
      | select(($contexts | index($need)) == null)
    ' <<<"$rules_json"
}

main() {
  set -euo pipefail

  : "${REPO:?REPO is required}"
  : "${PR_NUMBER:?PR_NUMBER is required}"
  : "${BASE_REF:?BASE_REF is required}"
  : "${EXPECTED_HEAD_SHA:?EXPECTED_HEAD_SHA is required}"
  : "${GH_TOKEN:?GH_TOKEN is required}"

  if ! validate_inputs "$PR_NUMBER" "$EXPECTED_HEAD_SHA" "$BASE_REF" "$REPO"; then
    echo "Refusing: pull request coordinates failed validation" >&2
    exit 1
  fi
  if ! command -v jq >/dev/null 2>&1; then
    echo "Refusing: jq is required to read branch rules" >&2
    exit 1
  fi

  local repo_meta default_branch allow_auto allow_squash
  repo_meta=$(gh api "repos/${REPO}")
  default_branch=$(jq -r '.default_branch' <<<"$repo_meta")
  allow_auto=$(jq -r '.allow_auto_merge' <<<"$repo_meta")
  allow_squash=$(jq -r '.allow_squash_merge' <<<"$repo_meta")

  if [[ "$BASE_REF" != "$default_branch" ]]; then
    echo "Refusing: base ${BASE_REF} is not the default branch ${default_branch}" >&2
    exit 1
  fi

  # REST user.login is the webhook identity ("dependabot[bot]"). gh pr view
  # rewrites bot logins to "app/...", so this check uses the pulls API.
  local pr_json author head_sha head_repo base_name state draft
  pr_json=$(gh api "repos/${REPO}/pulls/${PR_NUMBER}")
  author=$(jq -r '.user.login' <<<"$pr_json")
  head_sha=$(jq -r '.head.sha' <<<"$pr_json")
  head_repo=$(jq -r '.head.repo.full_name // ""' <<<"$pr_json")
  base_name=$(jq -r '.base.ref' <<<"$pr_json")
  state=$(jq -r '.state' <<<"$pr_json")
  draft=$(jq -r '.draft' <<<"$pr_json")

  if ! is_dependabot_author "$author"; then
    echo "Refusing: author is ${author}, not dependabot[bot]" >&2
    exit 1
  fi
  if [[ "$head_repo" != "$REPO" || "$base_name" != "$BASE_REF" || "$state" != "open" || "$draft" != "false" ]]; then
    echo "Refusing: pull request is not an open, same-repository Dependabot update targeting ${BASE_REF}" >&2
    exit 1
  fi
  if [[ "$head_sha" != "$EXPECTED_HEAD_SHA" ]]; then
    echo "Refusing: head SHA changed before auto-merge was enabled" >&2
    exit 1
  fi

  local filenames protected_hit
  filenames=$(gh api --paginate "repos/${REPO}/pulls/${PR_NUMBER}/files" --jq '.[].filename')
  protected_hit=$(
    printf '%s\n' "$filenames" \
      | grep -Fx -e "${GATE_PATHS[0]}" -e "${GATE_PATHS[1]}" || true
  )
  if [[ -n "$protected_hit" ]]; then
    echo "Refusing: pull request edits the auto-merge gate" >&2
    printf '%s\n' "$protected_hit" >&2
    exit 1
  fi

  local encoded_ref rules missing strict
  encoded_ref=$(jq -rn --arg ref "$BASE_REF" '$ref | @uri')
  rules=$(gh api "repos/${REPO}/rules/branches/${encoded_ref}")
  missing=$(missing_required_checks "$rules")
  if [[ -n "$missing" ]]; then
    echo "Refusing to enable auto-merge. ${BASE_REF} does not strictly require these CI checks:" >&2
    printf '%s\n' "$missing" >&2
    echo "Native auto-merge stays off until a branch ruleset or protection rule requires them." >&2
    exit 1
  fi
  strict=$(
    jq -r '
      [
        .[]
        | select(.type == "required_status_checks")
        | .parameters.strict_required_status_checks_policy
      ] | any
    ' <<<"$rules"
  )
  echo "Required CI checks are present. strict_required_status_checks_policy=${strict}"

  if [[ "$allow_auto" != "true" ]]; then
    echo "Refusing: repository allow_auto_merge is ${allow_auto}" >&2
    exit 1
  fi
  if [[ "$allow_squash" != "true" ]]; then
    echo "Refusing: squash merge is not enabled (allow_squash_merge=${allow_squash})" >&2
    exit 1
  fi

  local already
  already=$(jq -r '.auto_merge != null' <<<"$pr_json")
  if [[ "$already" == "true" ]]; then
    echo "Native auto-merge is already enabled for pull request ${PR_NUMBER}"
    exit 0
  fi

  local current_head
  current_head=$(gh api "repos/${REPO}/pulls/${PR_NUMBER}" --jq '.head.sha')
  if [[ "$current_head" != "$EXPECTED_HEAD_SHA" ]]; then
    echo "Refusing: head SHA changed before auto-merge was enabled" >&2
    exit 1
  fi

  gh pr merge "$PR_NUMBER" \
    --repo "$REPO" \
    --auto \
    --squash \
    --match-head-commit "$EXPECTED_HEAD_SHA"
  echo "Enabled native squash auto-merge for pull request ${PR_NUMBER} at ${EXPECTED_HEAD_SHA}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
