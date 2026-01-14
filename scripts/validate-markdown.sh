#!/usr/bin/env bash
#
# PostToolUse hook to validate markdown files after Write/Edit operations.
# Receives JSON input from stdin with tool_input.file_path.
#
# Exit codes:
#   0 - Success (pass) or skip (non-markdown/no markdownlint)
#   2 - Failure (blocking) - markdownlint found errors
#

set -euo pipefail

# Check if jq is installed
if ! command -v jq &>/dev/null; then
  echo "Warning: jq not installed. Cannot parse hook input."
  exit 0
fi

# Read JSON input from stdin
input=$(cat)

# Extract file path from tool_input.file_path
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# If no file path found, skip validation
if [[ -z "$file_path" ]]; then
  exit 0
fi

# Skip non-markdown files
if [[ ! "$file_path" =~ \.(md|markdown)$ ]]; then
  exit 0
fi

# Check if markdownlint is installed
if ! command -v markdownlint &>/dev/null; then
  echo "Warning: markdownlint not installed. Skipping validation."
  echo "Consider installing: npm install -g markdownlint-cli"
  exit 0
fi

# Ensure file exists
if [[ ! -f "$file_path" ]]; then
  echo "Warning: File does not exist: $file_path"
  exit 0
fi

# Run markdownlint
if markdownlint "$file_path"; then
  echo "Markdown validation passed: $file_path"
  exit 0
else
  echo "Markdown validation failed: $file_path"
  echo "Fix all markdownlint errors before proceeding."
  exit 2
fi
