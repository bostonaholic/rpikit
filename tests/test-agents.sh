#!/usr/bin/env bash
# Agent validation tests
# Verifies agent markdown structure and required fields

AGENTS_DIR="$PROJECT_ROOT/agents"

# Check if agents directory exists
if [[ ! -d "$AGENTS_DIR" ]]; then
    fail "Agents directory does not exist"
    return
fi

# Get list of agent files
AGENT_FILES=$(find "$AGENTS_DIR" -maxdepth 1 -name "*.md" -type f)

if [[ -z "$AGENT_FILES" ]]; then
    fail "No agent files found in $AGENTS_DIR"
    return
fi

# Validate each agent file
for agent_file in $AGENT_FILES; do
    agent_name=$(basename "$agent_file" .md)

    # Check frontmatter exists (starts with ---)
    if head -1 "$agent_file" | grep -q "^---$"; then
        pass "$agent_name: has frontmatter"
    else
        fail "$agent_name: missing frontmatter (must start with ---)"
        continue
    fi

    # Extract frontmatter (between first two ---)
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$agent_file" | sed '1d;$d')

    # Check required field: name
    if echo "$frontmatter" | grep -q "^name:"; then
        pass "$agent_name: has 'name' field"
    else
        fail "$agent_name: missing 'name' field in frontmatter"
    fi

    # Check required field: description
    if echo "$frontmatter" | grep -q "^description:"; then
        pass "$agent_name: has 'description' field"
    else
        fail "$agent_name: missing 'description' field in frontmatter"
    fi

    # Check required field: model
    if echo "$frontmatter" | grep -q "^model:"; then
        model_value=$(echo "$frontmatter" | grep "^model:" | sed 's/model:\s*//' | xargs)
        # Valid models: haiku, sonnet, opus (or claude-*)
        if echo "$model_value" | grep -qE "^(haiku|sonnet|opus|claude-)"; then
            pass "$agent_name: has valid 'model' ($model_value)"
        else
            fail "$agent_name: invalid model value '$model_value' (expected haiku, sonnet, opus, or claude-*)"
        fi
    else
        fail "$agent_name: missing 'model' field in frontmatter"
    fi

    # Check required field: color
    if echo "$frontmatter" | grep -q "^color:"; then
        pass "$agent_name: has 'color' field"
    else
        fail "$agent_name: missing 'color' field in frontmatter"
    fi

    # Check that file has content after frontmatter
    content_lines=$(sed -n '/^---$/,/^---$/d; p' "$agent_file" | grep -vc "^$")
    if [[ $content_lines -gt 5 ]]; then
        pass "$agent_name: has substantive content ($content_lines non-empty lines)"
    else
        fail "$agent_name: insufficient content after frontmatter ($content_lines lines)"
    fi

    # Check for H1 heading (# Title)
    if grep -q "^# " "$agent_file"; then
        pass "$agent_name: has H1 heading"
    else
        fail "$agent_name: missing H1 heading"
    fi
done
