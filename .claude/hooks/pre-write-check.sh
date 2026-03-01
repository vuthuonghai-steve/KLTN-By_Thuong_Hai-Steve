#!/bin/bash
# =============================================================================
# Hook: PreToolUse - Pre-write check
# Purpose: Prevent committing sensitive files
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Files to block
BLOCKED_FILES=(
    ".env"
    ".env.local"
    ".env.production"
    "credentials.json"
    "*.key"
)

# Get input and parse JSON
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || echo "")

if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
    for pattern in "${BLOCKED_FILES[@]}"; do
        if echo "$FILE_PATH" | grep -q "$pattern"; then
            echo -e "${RED}ERROR: Writing to $FILE_PATH is not allowed${NC}"
            echo "This file may contain sensitive data."
            exit 1
        fi
    done
fi

exit 0
