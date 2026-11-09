#!/usr/bin/env bash
# Enable GitHub native squash auto-merge for one trusted dependency update.
# Callers must execute this file from the default-branch revision. It never
# checks out a pull request and the only merge command is `gh pr merge --auto`.

REQUIRED_CHECKS=(
  "Test and Validate"
  "Lint Markdown"
  "Shellcheck"
)
GITHUB_ACTIONS_APP_ID=15368
GATE_PATHS=(
  ".github/workflows/dependabot-auto-merge.yml"
  ".github/workflows/update-claude-cli.yml"
  ".github/scripts/enable-native-auto-merge.sh"
)

is_dependabot_author() {
  [[ "$1" == "dependabot[bot]" ]]
}

is_claude_author() {
  [[ "$1" == "github-actions[bot]" ]]
}

validate_inputs() {
  local pr_number="$1" head_sha="$2" repo="$3"
  [[ "$pr_number" =~ ^[0-9]+$ ]] || return 1
  [[ "$head_sha" =~ ^[0-9a-f]{40}$ ]] || return 1
  [[ "$repo" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || return 1
}

missing_required_checks() {
  local rules_json="$1" required_json
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

# files_json is one page from the pulls files API. The patch must be the
# one-line semver replacement produced by update-claude-cli.yml.
claude_bump_is_version_only() {
  local files_json="$1" expected="$2" count filename status patch old new
  [[ "$expected" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || return 1
  count=$(jq 'length' <<<"$files_json")
  [[ "$count" == "1" ]] || return 1
  filename=$(jq -r '.[0].filename' <<<"$files_json")
  status=$(jq -r '.[0].status' <<<"$files_json")
  patch=$(jq -r '.[0].patch // ""' <<<"$files_json")
  [[ "$filename" == ".claude-code-version" && "$status" == "modified" ]] || return 1
  patch=${patch%$'\n'}
  [[ "$patch" =~ ^@@\ -1\ \+1\ @@$'\n'-([0-9]+\.[0-9]+\.[0-9]+)$'\n'\+([0-9]+\.[0-9]+\.[0-9]+)$ ]] || return 1
  old="${BASH_REMATCH[1]}"
  new="${BASH_REMATCH[2]}"
  [[ "$new" == "$expected" && "$old" != "$new" ]]
}

refuse() {
  echo "Refusing: $*" >&2
  exit 1
}

main() {
  set -euo pipefail
  : "${GATE_MODE:?}"
  : "${REPO:?}"
  : "${PR_NUMBER:?}"
  : "${EXPECTED_HEAD_SHA:?}"
  : "${GH_TOKEN:?}"
  validate_inputs "$PR_NUMBER" "$EXPECTED_HEAD_SHA" "$REPO" || refuse "pull request coordinates failed validation"
  command -v jq >/dev/null 2>&1 || refuse "jq is required"

  local repo_meta default_branch allow_auto allow_squash
  repo_meta=$(gh api "repos/${REPO}")
  default_branch=$(jq -r '.default_branch' <<<"$repo_meta")
  allow_auto=$(jq -r '.allow_auto_merge' <<<"$repo_meta")
  allow_squash=$(jq -r '.allow_squash_merge' <<<"$repo_meta")

  local pr_json author head_sha head_ref head_repo base_name state draft
  pr_json=$(gh api "repos/${REPO}/pulls/${PR_NUMBER}")
  author=$(jq -r '.user.login' <<<"$pr_json")
  head_sha=$(jq -r '.head.sha' <<<"$pr_json")
  head_ref=$(jq -r '.head.ref' <<<"$pr_json")
  head_repo=$(jq -r '.head.repo.full_name // ""' <<<"$pr_json")
  base_name=$(jq -r '.base.ref' <<<"$pr_json")
  state=$(jq -r '.state' <<<"$pr_json")
  draft=$(jq -r '.draft' <<<"$pr_json")
  [[ "$head_sha" == "$EXPECTED_HEAD_SHA" ]] || refuse "head SHA changed"
  [[ "$head_repo" == "$REPO" && "$base_name" == "$default_branch" && "$state" == "open" && "$draft" == "false" ]] \
    || refuse "pull request is not an open update targeting ${default_branch}"

  local files_json
  files_json=$(gh api "repos/${REPO}/pulls/${PR_NUMBER}/files?per_page=100")
  case "$GATE_MODE" in
    dependabot)
      [[ "${EVENT_NAME:-}" == "pull_request_target" ]] || refuse "dependabot auto-merge must run from pull_request_target"
      is_dependabot_author "$author" || refuse "author is ${author}, not dependabot[bot]"
      local protected="" path
      for path in "${GATE_PATHS[@]}"; do
        if jq -e --arg path "$path" 'any(.[]; .filename == $path)' <<<"$files_json" >/dev/null; then
          protected+="${path}"$'\n'
        fi
      done
      [[ -z "$protected" ]] || refuse "pull request edits the auto-merge gate"
      ;;
    claude-cli)
      [[ "${EVENT_NAME:-}" == "schedule" || "${EVENT_NAME:-}" == "workflow_dispatch" ]] \
        || refuse "Claude CLI auto-merge must run from the update workflow"
      [[ "${WORKFLOW_REF:-}" == "${REPO}/.github/workflows/update-claude-cli.yml@refs/heads/${default_branch}" ]] \
        || refuse "workflow ref is not the trusted update-claude-cli workflow on ${default_branch}"
      is_claude_author "$author" || refuse "author is ${author}, not github-actions[bot]"
      [[ "$head_ref" == "update-claude-cli" ]] || refuse "head branch is ${head_ref}"
      : "${EXPECTED_VERSION:?}"
      claude_bump_is_version_only "$files_json" "$EXPECTED_VERSION" \
        || refuse "diff is not a one-line .claude-code-version bump to ${EXPECTED_VERSION}"
      local raw
      raw=$(gh api -H "Accept: application/vnd.github.raw" \
        "repos/${REPO}/contents/.claude-code-version?ref=${EXPECTED_HEAD_SHA}")
      [[ "$raw" == "$EXPECTED_VERSION" || "$raw" == "${EXPECTED_VERSION}"$'\n' ]] \
        || refuse "version file contents do not match ${EXPECTED_VERSION}"
      ;;
    *)
      refuse "unknown gate mode ${GATE_MODE}"
      ;;
  esac

  local encoded_ref rules missing
  encoded_ref=$(jq -rn --arg ref "$default_branch" '$ref | @uri')
  rules=$(gh api "repos/${REPO}/rules/branches/${encoded_ref}")
  missing=$(missing_required_checks "$rules")
  if [[ -n "$missing" ]]; then
    echo "Refusing: ${default_branch} does not strictly require these CI checks:" >&2
    printf '%s\n' "$missing" >&2
    exit 1
  fi
  [[ "$allow_auto" == "true" ]] || refuse "repository allow_auto_merge is ${allow_auto}"
  [[ "$allow_squash" == "true" ]] || refuse "squash merge is not enabled"

  if [[ "$(jq -r '.auto_merge != null' <<<"$pr_json")" == "true" ]]; then
    echo "Native auto-merge is already enabled for pull request ${PR_NUMBER}"
    exit 0
  fi
  local current_head
  current_head=$(gh api "repos/${REPO}/pulls/${PR_NUMBER}" --jq '.head.sha')
  [[ "$current_head" == "$EXPECTED_HEAD_SHA" ]] || refuse "head SHA changed"
  gh pr merge "$PR_NUMBER" --repo "$REPO" --auto --squash --match-head-commit "$EXPECTED_HEAD_SHA"
  echo "Enabled native squash auto-merge for pull request ${PR_NUMBER} at ${EXPECTED_HEAD_SHA}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
