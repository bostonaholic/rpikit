#!/usr/bin/env bash
# Plugin manifest validation tests
# Uses claude plugin validate for comprehensive validation

# Check if claude CLI is available
if ! command -v claude &> /dev/null; then
    skip "claude CLI not installed - skipping plugin validation"
    return
fi

# Run claude plugin validate
echo "Running: claude plugin validate $PROJECT_ROOT"
output=$(claude plugin validate "$PROJECT_ROOT" 2>&1)
exit_code=$?

echo "$output"

if [[ $exit_code -eq 0 ]]; then
    # Check if there were warnings
    if echo "$output" | grep -q "warning"; then
        fail "Plugin validation passed with warnings"
    else
        pass "Plugin validation passed"
    fi
else
    fail "Plugin validation failed"
fi
