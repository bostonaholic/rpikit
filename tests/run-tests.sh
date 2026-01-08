#!/usr/bin/env bash
# Test runner for rpikit plugin validation
# Runs all test suites and reports results

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Use temp files for counters (works across sourced scripts)
PASS_FILE=$(mktemp)
FAIL_FILE=$(mktemp)
SKIP_FILE=$(mktemp)
echo "0" > "$PASS_FILE"
echo "0" > "$FAIL_FILE"
echo "0" > "$SKIP_FILE"

# Cleanup on exit
cleanup() {
    rm -f "$PASS_FILE" "$FAIL_FILE" "$SKIP_FILE"
}
trap cleanup EXIT

# Print test result and increment counter
pass() {
    echo -e "${GREEN}PASS${NC}: $1"
    count=$(<"$PASS_FILE")
    echo $((count + 1)) > "$PASS_FILE"
}

fail() {
    echo -e "${RED}FAIL${NC}: $1"
    count=$(<"$FAIL_FILE")
    echo $((count + 1)) > "$FAIL_FILE"
}

skip() {
    echo -e "${YELLOW}SKIP${NC}: $1"
    count=$(<"$SKIP_FILE")
    echo $((count + 1)) > "$SKIP_FILE"
}

# Run a test suite
run_suite() {
    local suite_name="$1"
    local suite_script="$SCRIPT_DIR/test-${suite_name}.sh"

    echo ""
    echo "=== Running $suite_name tests ==="

    if [[ -f "$suite_script" ]]; then
        # shellcheck source=/dev/null
        source "$suite_script"
    else
        echo "Suite script not found: $suite_script"
    fi
}

echo "rpikit Plugin Test Suite"
echo "========================"
echo "Project root: $PROJECT_ROOT"

# Run all test suites
run_suite "agents"
run_suite "skills"
run_suite "commands"
run_suite "plugin"

# Read final counts
TESTS_PASSED=$(<"$PASS_FILE")
TESTS_FAILED=$(<"$FAIL_FILE")
TESTS_SKIPPED=$(<"$SKIP_FILE")

# Summary
echo ""
echo "=== Test Summary ==="
echo -e "${GREEN}Passed${NC}: $TESTS_PASSED"
echo -e "${RED}Failed${NC}: $TESTS_FAILED"
echo -e "${YELLOW}Skipped${NC}: $TESTS_SKIPPED"

if [[ $TESTS_FAILED -gt 0 ]]; then
    echo ""
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
else
    echo ""
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
