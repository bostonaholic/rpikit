#!/usr/bin/env bash
# Frontmatter YAML validation tests
# Validates YAML syntax in markdown frontmatter

# Determine YAML validator
validate_yaml() {
    local yaml_content="$1"
    if command -v yq &> /dev/null; then
        echo "$yaml_content" | yq '.' > /dev/null 2>&1
    elif python3 -c "import yaml" 2>/dev/null; then
        echo "$yaml_content" | python3 -c "import sys, yaml; yaml.safe_load(sys.stdin)" 2>/dev/null
    elif python -c "import yaml" 2>/dev/null; then
        echo "$yaml_content" | python -c "import sys, yaml; yaml.safe_load(sys.stdin)" 2>/dev/null
    else
        # No validator available, assume valid
        return 0
    fi
}

# Check if any validator is available
if ! command -v yq &> /dev/null && ! python3 -c "import yaml" 2>/dev/null && ! python -c "import yaml" 2>/dev/null; then
    skip "No YAML validator available (need yq or Python with PyYAML)"
else
    # Find and validate all markdown files with frontmatter
    file_count=0

    for file in "$PROJECT_ROOT"/agents/*.md \
                "$PROJECT_ROOT"/commands/*.md \
                "$PROJECT_ROOT"/skills/*/SKILL.md; do
        [[ -f "$file" ]] || continue

        relative_path="${file#"$PROJECT_ROOT"/}"

        # Check if file starts with ---
        if ! head -1 "$file" | grep -q "^---$"; then
            continue
        fi

        # Extract frontmatter (between first two ---)
        frontmatter=$(sed -n '2,/^---$/p' "$file" | sed '$d')

        if [[ -z "$frontmatter" ]]; then
            pass "$relative_path: frontmatter is valid (empty)"
        elif validate_yaml "$frontmatter"; then
            pass "$relative_path: frontmatter YAML is valid"
        else
            fail "$relative_path: frontmatter has invalid YAML syntax"
        fi

        ((file_count++))
    done

    if [[ $file_count -eq 0 ]]; then
        skip "No markdown files with frontmatter found"
    fi
fi
