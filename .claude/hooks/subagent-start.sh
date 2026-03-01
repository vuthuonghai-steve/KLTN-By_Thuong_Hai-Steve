#!/bin/bash
# =============================================================================
# Hook: SubagentStart
# Description: Chạy khi một subagent bắt đầu thực thi
# Purpose: Log stage start, cập nhật _queue.json status = IN_PROGRESS
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# hooks/ -> .claude/ -> project root (3 levels)
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
SKILL_CONTEXT="$PROJECT_DIR/.skill-context"
LOGS_DIR="$SKILL_CONTEXT/logs"
QUEUE_FILE="$SKILL_CONTEXT/_queue.json"

# Đọc JSON input từ stdin
INPUT=$(cat)

# Trích xuất thông tin
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // "unknown"')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Tạo thư mục logs nếu chưa có
mkdir -p "$LOGS_DIR"

# Log vào file
LOG_FILE="$LOGS_DIR/pipeline.log"
echo "[$TIMESTAMP] SUBAGENT_START: agent_id=$AGENT_ID, agent_type=$AGENT_TYPE" >> "$LOG_FILE"

# Kiểm tra nếu đang chạy pipeline (_queue.json tồn tại)
if [ -f "$QUEUE_FILE" ]; then
    # Cập nhật stage hiện tại thành IN_PROGRESS
    # Lưu ý: Đây là basic implementation, có thể mở rộng sau
    echo "[$TIMESTAMP] Pipeline detected, stage starting..." >> "$LOG_FILE"
fi

# Tạo thư mục shared cho progress tracking
mkdir -p "$SKILL_CONTEXT/shared"

# Ghi progress tracking
PROGRESS_FILE="$SKILL_CONTEXT/shared/progress.md"
echo "## Subagent Start - $TIMESTAMP" >> "$PROGRESS_FILE"
echo "- Agent: $AGENT_TYPE ($AGENT_ID)" >> "$PROGRESS_FILE"
echo "- Status: IN_PROGRESS" >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

# Output JSON cho Claude Code hook system
jq -n \
    --arg agent_id "$AGENT_ID" \
    --arg agent_type "$AGENT_TYPE" \
    --arg timestamp "$TIMESTAMP" \
    '{
        "hookSpecificOutput": {
            "hookEventName": "SubagentStart",
            "additionalContext": ("Subagent " + $agent_type + " started at " + $timestamp)
        }
    }'

exit 0
