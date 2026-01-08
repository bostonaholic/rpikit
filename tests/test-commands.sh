#!/usr/bin/env bash
# Command validation tests
# Verifies command structure and skill delegation

COMMANDS_DIR="$PROJECT_ROOT/commands"

# Check if commands directory exists
if [[ ! -d "$COMMANDS_DIR" ]]; then
    fail "Commands directory does not exist"
    return
fi

# Get list of command files
COMMAND_FILES=$(find "$COMMANDS_DIR" -maxdepth 1 -name "*.md" -type f)

if [[ -z "$COMMAND_FILES" ]]; then
    fail "No command files found in $COMMANDS_DIR"
    return
fi

# Validate each command file
for cmd_file in $COMMAND_FILES; do
    cmd_name=$(basename "$cmd_file" .md)

    # Check frontmatter exists
    if head -1 "$cmd_file" | grep -q "^---$"; then
        pass "$cmd_name: has frontmatter"
    else
        fail "$cmd_name: missing frontmatter"
        continue
    fi

    # Extract frontmatter
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$cmd_file" | sed '1d;$d')

    # Check required field: description
    if echo "$frontmatter" | grep -q "^description:"; then
        pass "$cmd_name: has 'description' field"
    else
        fail "$cmd_name: missing 'description' field in frontmatter"
    fi

    # Check for disable-model-invocation (recommended)
    if echo "$frontmatter" | grep -q "disable-model-invocation:\s*true"; then
        pass "$cmd_name: has 'disable-model-invocation: true'"
    else
        skip "$cmd_name: missing 'disable-model-invocation: true' (recommended)"
    fi

    # Check that command delegates to a skill
    # Commands should reference "rpikit:" skill
    if grep -q "rpikit:" "$cmd_file"; then
        pass "$cmd_name: references rpikit skill"
    else
        fail "$cmd_name: does not reference any rpikit skill"
    fi

    # Check for "Invoke" or "invoke" instruction (delegation pattern)
    if grep -qi "invoke" "$cmd_file"; then
        pass "$cmd_name: has invocation instruction"
    else
        fail "$cmd_name: missing invocation instruction"
    fi

    # Commands should be thin wrappers (not too long)
    total_lines=$(wc -l < "$cmd_file")
    if [[ $total_lines -lt 30 ]]; then
        pass "$cmd_name: is thin wrapper ($total_lines lines)"
    else
        skip "$cmd_name: may be too verbose for a command ($total_lines lines)"
    fi
done
