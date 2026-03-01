#!/bin/bash
# =============================================================================
# Hook: SubagentStop
# Description: Chạy khi một subagent hoàn thành thực thi
# Purpose: Log stage completion
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
SKILL_CONTEXT="$PROJECT_DIR/.skill-context"
LOGS_DIR="$SKILL_CONTEXT/logs"

INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // "unknown"')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
LAST_MESSAGE=$(echo "$INPUT" | jq -r '.last_assistant_message // ""')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

mkdir -p "$LOGS_DIR"
LOG_FILE="$LOGS_DIR/pipeline.log"
echo "[$TIMESTAMP] SUBAGENT_STOP: agent_id=$AGENT_ID, agent_type=$AGENT_TYPE" >> "$LOG_FILE"

mkdir -p "$SKILL_CONTEXT/results"
RESULT_FILE="$SKILL_CONTEXT/results/${AGENT_TYPE}_${AGENT_ID}.json"
echo "$INPUT" > "$RESULT_FILE"

jq -n \
    --arg agent_id "$AGENT_ID" \
    --arg agent_type "$AGENT_TYPE" \
    --arg timestamp "$TIMESTAMP" \
    '{"hookSpecificOutput": {"hookEventName": "SubagentStop", "additionalContext": ("Subagent " + $agent_type + " completed at " + $timestamp)}}'

exit 0
