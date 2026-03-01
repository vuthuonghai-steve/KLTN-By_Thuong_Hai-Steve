#!/bin/bash
# =============================================================================
# Hook: Stop - Session End
# Purpose: Log session end for tracking
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
LOGS_DIR="$PROJECT_DIR/.claude/logs"

mkdir -p "$LOGS_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LOG_FILE="$LOGS_DIR/session.log"

echo "[$TIMESTAMP] Session ended" >> "$LOG_FILE"

exit 0
