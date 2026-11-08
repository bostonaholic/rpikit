#!/usr/bin/env bash
# Tests the Dependabot native auto-merge gate without calling GitHub.

if [[ -z "${PROJECT_ROOT:-}" ]]; then
  PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

if ! declare -F pass >/dev/null; then
  pass() { echo "PASS: $1"; }
  fail() { echo "FAIL: $1"; }
fi

SCRIPT_PATH="${PROJECT_ROOT}/.github/scripts/enable-dependabot-auto-merge.sh"
WORKFLOW_PATH="${PROJECT_ROOT}/.github/workflows/dependabot-auto-merge.yml"
DEPENDABOT_PATH="${PROJECT_ROOT}/.github/dependabot.yml"
CI_PATH="${PROJECT_ROOT}/.github/workflows/ci.yml"

# shellcheck source=/dev/null
source "$SCRIPT_PATH"

rules_with_checks() {
  local integration="$1"
  local strict="${2:-true}"
  local integration_json="null"
  if [[ "$integration" != "null" ]]; then
    integration_json="$integration"
  fi
  cat <<EOF
[
  {
    "type": "required_status_checks",
    "parameters": {
      "strict_required_status_checks_policy": ${strict},
      "required_status_checks": [
        {"context": "Test and Validate", "integration_id": ${integration_json}},
        {"context": "Lint Markdown", "integration_id": ${integration_json}},
        {"context": "Shellcheck", "integration_id": ${integration_json}}
      ]
    }
  }
]
EOF
}

assert_missing() {
  local label="$1"
  local rules="$2"
  local expected="$3"
  local actual status
  actual=$(missing_required_checks "$rules")
  status=$?
  if [[ "$status" -ne 0 ]]; then
    fail "$label (rules check exited ${status})"
    return
  fi
  if [[ "$actual" == "$expected" ]]; then
    pass "$label"
  else
    fail "$label"
    echo "expected:"
    printf '%s\n' "$expected"
    echo "actual:"
    printf '%s\n' "$actual"
  fi
}

assert_missing "empty rules require every CI check" "[]" "$(printf '%s\n' "${REQUIRED_CHECKS[@]}")"

all_required=""
assert_missing "GitHub Actions checks satisfy the gate" "$(rules_with_checks "$GITHUB_ACTIONS_APP_ID")" "$all_required"
assert_missing "unpinned checks satisfy the gate" "$(rules_with_checks null)" "$all_required"

assert_missing "a different app id does not satisfy the gate" "$(rules_with_checks 1)" "$(printf '%s\n' "${REQUIRED_CHECKS[@]}")"

split_rules='[
  {"type":"deletion"},
  {"type":"required_status_checks","parameters":{"strict_required_status_checks_policy":true,"required_status_checks":[{"context":"Test and Validate","integration_id":15368},{"context":"Lint Markdown","integration_id":15368}]}},
  {"type":"required_status_checks","parameters":{"strict_required_status_checks_policy":true,"required_status_checks":[{"context":"Shellcheck","integration_id":15368}]}}
]'
assert_missing "checks split across rules satisfy the gate" "$split_rules" "$all_required"

assert_missing "non-strict rules do not satisfy the gate" "$(rules_with_checks "$GITHUB_ACTIONS_APP_ID" false)" "$(printf '%s\n' "${REQUIRED_CHECKS[@]}")"

partial='[{"type":"required_status_checks","parameters":{"strict_required_status_checks_policy":true,"required_status_checks":[{"context":"Lint Markdown"},{"context":"Shellcheck"}]}}]'
assert_missing "a missing CI job keeps auto-merge off" "$partial" "Test and Validate"

if is_dependabot_author "dependabot[bot]"; then
  pass "REST Dependabot login is accepted"
else
  fail "REST Dependabot login is accepted"
fi

if is_dependabot_author "app/dependabot" \
  || is_dependabot_author "github-actions[bot]" \
  || is_dependabot_author "app/github-actions" \
  || is_dependabot_author "dependabot"; then
  fail "rewritten or unrelated bot logins are rejected"
else
  pass "rewritten or unrelated bot logins are rejected"
fi

if validate_inputs 19 "3284a63cf7b40f035e2d3c7772231971b7cea0d4" "main" "bostonaholic/rpikit"; then
  pass "valid pull request coordinates pass"
else
  fail "valid pull request coordinates pass"
fi

if validate_inputs 19 "3284a63" "main" "bostonaholic/rpikit"; then
  fail "short SHA is rejected"
else
  pass "short SHA is rejected"
fi

if validate_inputs "19;rm" "3284a63cf7b40f035e2d3c7772231971b7cea0d4" "main" "bostonaholic/rpikit"; then
  fail "non-numeric pull request number is rejected"
else
  pass "non-numeric pull request number is rejected"
fi

if validate_inputs 19 "3284a63cf7b40f035e2d3c7772231971b7cea0d4" "main;touch /tmp/x" "bostonaholic/rpikit"; then
  fail "base ref injection is rejected"
else
  pass "base ref injection is rejected"
fi

merge_lines=$(grep -n "gh pr merge" "$SCRIPT_PATH" || true)
if [[ -n "$merge_lines" && "$merge_lines" != *"--admin"* ]] \
  && grep -q -- "--auto" "$SCRIPT_PATH" \
  && grep -q -- "--squash" "$SCRIPT_PATH" \
  && ! grep -q "/pulls/.*/merge" "$SCRIPT_PATH" \
  && ! grep -q -- "--admin" "$SCRIPT_PATH"; then
  pass "merge command is native auto-merge squash only"
else
  fail "merge command is native auto-merge squash only"
  printf '%s\n' "$merge_lines"
fi

if ! grep -q "actions/checkout" "$WORKFLOW_PATH" \
  && ! grep -q "pull_request.head.ref" "$WORKFLOW_PATH" \
  && ! grep -q "ref: \${{ github.event.pull_request.head" "$WORKFLOW_PATH" \
  && grep -q "pull_request_target:" "$WORKFLOW_PATH" \
  && grep -q "dependabot\[bot\]" "$WORKFLOW_PATH" \
  && grep -q "contents: write" "$WORKFLOW_PATH" \
  && grep -q "pull-requests: write" "$WORKFLOW_PATH" \
  && grep -q "github.event.pull_request.base.sha" "$WORKFLOW_PATH" \
  && ! grep -q -- "--admin" "$WORKFLOW_PATH" \
  && ! grep -q "fetch-metadata" "$WORKFLOW_PATH"; then
  pass "workflow enables auto-merge only from trusted base code"
else
  fail "workflow enables auto-merge only from trusted base code"
fi

required_json=$(printf '%s\n' "${REQUIRED_CHECKS[@]}" | jq -R . | jq -s -c .)
if python3 - "$CI_PATH" "$required_json" <<'PY'
import json
import sys
import yaml

data = yaml.safe_load(open(sys.argv[1]))
names = sorted(job.get("name") for job in data["jobs"].values())
expected = sorted(json.loads(sys.argv[2]))
sys.exit(0 if names == expected else 1)
PY
then
  pass "required checks match the CI job names"
else
  fail "required checks match the CI job names"
fi

if python3 - "$DEPENDABOT_PATH" <<'PY'
import sys
import yaml

data = yaml.safe_load(open(sys.argv[1]))
text = open(sys.argv[1]).read()
updates = data.get("updates") or []
ecosystems = sorted(item.get("package-ecosystem") for item in updates)
forbidden = ("semver-major", "semver-minor", "version-update:semver-patch")
has_ignore = any(isinstance(item, dict) and "ignore" in item for item in updates)
has_strategy = any(isinstance(item, dict) and "versioning-strategy" in item for item in updates)
ok = (
    data.get("version") == 2
    and ecosystems == ["github-actions", "npm"]
    and not has_ignore
    and not has_strategy
    and not any(word in text for word in forbidden)
)
sys.exit(0 if ok else 1)
PY
then
  pass "Dependabot config does not limit updates to patches"
else
  fail "Dependabot config does not limit updates to patches"
fi
