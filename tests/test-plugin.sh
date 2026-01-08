#!/usr/bin/env bash
# Plugin manifest validation tests
# Verifies plugin.json structure and validity

PLUGIN_DIR="$PROJECT_ROOT/.claude-plugin"
PLUGIN_JSON="$PLUGIN_DIR/plugin.json"

# Check if plugin directory exists
if [[ ! -d "$PLUGIN_DIR" ]]; then
    fail "Plugin directory .claude-plugin does not exist"
    return
fi

# Check plugin.json exists
if [[ -f "$PLUGIN_JSON" ]]; then
    pass "plugin.json exists"
else
    fail "plugin.json does not exist"
    return
fi

# Check plugin.json is valid JSON
if command -v jq &> /dev/null; then
    if jq empty "$PLUGIN_JSON" 2>/dev/null; then
        pass "plugin.json is valid JSON"
    else
        fail "plugin.json is not valid JSON"
        return
    fi

    # Check required fields
    if jq -e '.name' "$PLUGIN_JSON" > /dev/null 2>&1; then
        name=$(jq -r '.name' "$PLUGIN_JSON")
        pass "plugin.json has 'name' field: $name"
    else
        fail "plugin.json missing 'name' field"
    fi

    if jq -e '.version' "$PLUGIN_JSON" > /dev/null 2>&1; then
        version=$(jq -r '.version' "$PLUGIN_JSON")
        pass "plugin.json has 'version' field: $version"
    else
        fail "plugin.json missing 'version' field"
    fi

    if jq -e '.description' "$PLUGIN_JSON" > /dev/null 2>&1; then
        pass "plugin.json has 'description' field"
    else
        fail "plugin.json missing 'description' field"
    fi

    # Check that directories referenced exist
    if jq -e '.commands' "$PLUGIN_JSON" > /dev/null 2>&1; then
        commands_path=$(jq -r '.commands' "$PLUGIN_JSON")
        if [[ -d "$PROJECT_ROOT/$commands_path" ]]; then
            pass "Commands directory exists: $commands_path"
        else
            fail "Commands directory does not exist: $commands_path"
        fi
    fi

    if jq -e '.skills' "$PLUGIN_JSON" > /dev/null 2>&1; then
        skills_path=$(jq -r '.skills' "$PLUGIN_JSON")
        if [[ -d "$PROJECT_ROOT/$skills_path" ]]; then
            pass "Skills directory exists: $skills_path"
        else
            fail "Skills directory does not exist: $skills_path"
        fi
    fi

    if jq -e '.agents' "$PLUGIN_JSON" > /dev/null 2>&1; then
        agents_path=$(jq -r '.agents' "$PLUGIN_JSON")
        if [[ -d "$PROJECT_ROOT/$agents_path" ]]; then
            pass "Agents directory exists: $agents_path"
        else
            fail "Agents directory does not exist: $agents_path"
        fi
    fi
else
    skip "jq not installed - skipping JSON validation"
fi

# Check marketplace.json if it exists
MARKETPLACE_JSON="$PLUGIN_DIR/marketplace.json"
if [[ -f "$MARKETPLACE_JSON" ]]; then
    if command -v jq &> /dev/null; then
        if jq empty "$MARKETPLACE_JSON" 2>/dev/null; then
            pass "marketplace.json is valid JSON"
        else
            fail "marketplace.json is not valid JSON"
        fi
    fi
else
    skip "marketplace.json not found (optional)"
fi
