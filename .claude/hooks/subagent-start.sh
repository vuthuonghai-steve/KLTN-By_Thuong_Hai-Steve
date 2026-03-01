#!/bin/bash
# =============================================================================
# Hook: SubagentStart
# Description: Chạy khi một subagent bắt đầu thực thi
# Purpose: Log stage start, cập nhật _queue.json status = IN_PROGRESS
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
SKILL_CONTEXT="$PROJECT_DIR/.skill-context"
LOGS_DIR="$SKILL_CONTEXT/logs"

INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // "unknown"')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

mkdir -p "$LOGS_DIR"
LOG_FILE="$LOGS_DIR/pipeline.log"
echo "[$TIMESTAMP] SUBAGENT_START: agent_id=$AGENT_ID, agent_type=$AGENT_TYPE" >> "$LOG_FILE"

mkdir -p "$SKILL_CONTEXT/shared"
PROGRESS_FILE="$SKILL_CONTEXT/shared/progress.md"
echo "## Subagent Start - $TIMESTAMP" >> "$PROGRESS_FILE"
echo "- Agent: $AGENT_TYPE ($AGENT_ID)" >> "$PROGRESS_FILE"
echo "- Status: IN_PROGRESS" >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

jq -n \
    --arg agent_id "$AGENT_ID" \
    --arg agent_type "$AGENT_TYPE" \
    --arg timestamp "$TIMESTAMP" \
    '{"hookSpecificOutput": {"hookEventName": "SubagentStart", "additionalContext": ("Subagent " + $agent_type + " started at " + $timestamp)}}'

exit 0
