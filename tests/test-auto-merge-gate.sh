#!/usr/bin/env bash
# Security checks for native auto-merge. No GitHub calls.

if [[ -z "${PROJECT_ROOT:-}" ]]; then
  PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

if ! declare -F pass >/dev/null; then
  pass() { echo "PASS: $1"; }
  fail() { echo "FAIL: $1"; }
fi

SCRIPT_PATH="${PROJECT_ROOT}/.github/scripts/enable-native-auto-merge.sh"
# shellcheck source=/dev/null
source "$SCRIPT_PATH"

assert_missing() {
  local label="$1" rules="$2" expected="$3" actual status
  actual=$(missing_required_checks "$rules")
  status=$?
  if [[ "$status" -ne 0 ]]; then
    fail "$label (exit ${status})"
    return
  fi
  if [[ "$actual" == "$expected" ]]; then
    pass "$label"
  else
    fail "$label"
    printf 'expected:\n%s\nactual:\n%s\n' "$expected" "$actual"
  fi
}

strict_rules='[{"type":"required_status_checks","parameters":{"strict_required_status_checks_policy":true,"required_status_checks":[{"context":"Test and Validate","integration_id":15368},{"context":"Lint Markdown","integration_id":15368},{"context":"Shellcheck","integration_id":15368}]}}]'
loose_rules='[{"type":"required_status_checks","parameters":{"strict_required_status_checks_policy":false,"required_status_checks":[{"context":"Test and Validate"},{"context":"Lint Markdown"},{"context":"Shellcheck"}]}}]'
assert_missing "strict CI rules satisfy the gate" "$strict_rules" ""
assert_missing "non-strict rules do not satisfy the gate" "$loose_rules" "$(printf '%s\n' "${REQUIRED_CHECKS[@]}")"
assert_missing "empty rules do not satisfy the gate" "[]" "$(printf '%s\n' "${REQUIRED_CHECKS[@]}")"

version_patch='[{"filename":".claude-code-version","status":"modified","patch":"@@ -1 +1 @@\n-2.1.310\n+2.1.316"}]'
if claude_bump_is_version_only "$version_patch" "2.1.316"; then
  pass "version-only Claude CLI diff is accepted"
else
  fail "version-only Claude CLI diff is accepted"
fi
if claude_bump_is_version_only "$version_patch" "9.9.9" \
  || claude_bump_is_version_only '[{"filename":".claude-code-version","status":"modified","patch":"@@ -1 +1 @@\n-2.1.310\n+2.1.316"},{"filename":"ci.yml","status":"modified","patch":"x"}]' "2.1.316" \
  || claude_bump_is_version_only '[{"filename":".github/workflows/update-claude-cli.yml","status":"modified","patch":"@@ -1 +1 @@\n-1\n+2"}]' "2"; then
  fail "non-version diffs are rejected"
else
  pass "non-version diffs are rejected"
fi

if is_dependabot_author "dependabot[bot]" && is_claude_author "github-actions[bot]" \
  && ! is_dependabot_author "github-actions[bot]" && ! is_claude_author "dependabot[bot]" \
  && ! is_dependabot_author "app/dependabot" && ! is_claude_author "app/github-actions"; then
  pass "author checks accept only the REST bot logins"
else
  fail "author checks accept only the REST bot logins"
fi

if grep -q -- "--auto" "$SCRIPT_PATH" && grep -q -- "--squash" "$SCRIPT_PATH" \
  && ! grep -q -- "--admin" "$SCRIPT_PATH" && ! grep -q "/pulls/.*/merge" "$SCRIPT_PATH"; then
  pass "merge command is native auto-merge squash only"
else
  fail "merge command is native auto-merge squash only"
fi

if python3 - "${PROJECT_ROOT}/.github/workflows/ci.yml" "$(printf '%s\n' "${REQUIRED_CHECKS[@]}" | jq -R . | jq -s -c .)" <<'PY'
import json, sys, yaml
names = sorted(job.get("name") for job in yaml.safe_load(open(sys.argv[1]))["jobs"].values())
sys.exit(0 if names == sorted(json.loads(sys.argv[2])) else 1)
PY
then
  pass "required checks match the CI job names"
else
  fail "required checks match the CI job names"
fi

dependabot_workflow="${PROJECT_ROOT}/.github/workflows/dependabot-auto-merge.yml"
claude_workflow="${PROJECT_ROOT}/.github/workflows/update-claude-cli.yml"
if ! grep -q "actions/checkout" "$dependabot_workflow" \
  && grep -q "pull_request_target:" "$dependabot_workflow" \
  && grep -q "dependabot\[bot\]" "$dependabot_workflow" \
  && grep -q "enable-native-auto-merge.sh" "$dependabot_workflow" \
  && grep -q "github.event.pull_request.base.sha" "$dependabot_workflow" \
  && ! grep -q "pull_request.head.ref" "$dependabot_workflow" \
  && grep -q "GATE_MODE: claude-cli" "$claude_workflow" \
  && grep -q "TRUSTED_SHA: \${{ github.sha }}" "$claude_workflow" \
  && grep -q "add-paths: .claude-code-version" "$claude_workflow" \
  && ! grep -q -- "--admin" "$dependabot_workflow" "$claude_workflow"; then
  pass "workflows enable auto-merge from trusted revisions only"
else
  fail "workflows enable auto-merge from trusted revisions only"
fi
