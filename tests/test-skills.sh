#!/usr/bin/env bash
# Skill validation tests
# Verifies skill structure and required fields

SKILLS_DIR="$PROJECT_ROOT/skills"

# Check if skills directory exists
if [[ ! -d "$SKILLS_DIR" ]]; then
    fail "Skills directory does not exist"
    return
fi

# Get list of skill directories
SKILL_DIRS=$(find "$SKILLS_DIR" -maxdepth 1 -mindepth 1 -type d)

if [[ -z "$SKILL_DIRS" ]]; then
    fail "No skill directories found in $SKILLS_DIR"
    return
fi

# Validate each skill
for skill_dir in $SKILL_DIRS; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    # Check SKILL.md exists
    if [[ -f "$skill_file" ]]; then
        pass "$skill_name: has SKILL.md"
    else
        fail "$skill_name: missing SKILL.md file"
        continue
    fi

    # Check frontmatter exists
    if head -1 "$skill_file" | grep -q "^---$"; then
        pass "$skill_name: SKILL.md has frontmatter"
    else
        fail "$skill_name: SKILL.md missing frontmatter"
        continue
    fi

    # Extract frontmatter
    frontmatter=$(sed -n '/^---$/,/^---$/p' "$skill_file" | sed '1d;$d')

    # Check required field: name
    if echo "$frontmatter" | grep -q "^name:"; then
        fm_name=$(echo "$frontmatter" | grep "^name:" | sed 's/name:\s*//' | xargs)
        # Verify name matches directory name
        if [[ "$fm_name" == "$skill_name" ]]; then
            pass "$skill_name: 'name' field matches directory"
        else
            fail "$skill_name: 'name' field ($fm_name) doesn't match directory ($skill_name)"
        fi
    else
        fail "$skill_name: missing 'name' field in frontmatter"
    fi

    # Check required field: description
    if echo "$frontmatter" | grep -q "^description:"; then
        pass "$skill_name: has 'description' field"
    else
        fail "$skill_name: missing 'description' field in frontmatter"
    fi

    # Check that file has content after frontmatter
    content_lines=$(sed -n '/^---$/,/^---$/d; p' "$skill_file" | grep -vc "^$")
    if [[ $content_lines -gt 10 ]]; then
        pass "$skill_name: has substantive content ($content_lines non-empty lines)"
    else
        fail "$skill_name: insufficient content after frontmatter ($content_lines lines)"
    fi

    # Check for H1 heading
    if grep -q "^# " "$skill_file"; then
        pass "$skill_name: has H1 heading"
    else
        fail "$skill_name: missing H1 heading"
    fi

    # Check for no extra files (skills should only have SKILL.md)
    extra_files=$(find "$skill_dir" -maxdepth 1 -type f ! -name "SKILL.md" | wc -l)
    if [[ $extra_files -eq 0 ]]; then
        pass "$skill_name: no unexpected files"
    else
        skip "$skill_name: has $extra_files extra file(s) besides SKILL.md"
    fi
done
