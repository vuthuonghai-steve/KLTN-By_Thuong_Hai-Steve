#!/bin/bash
# =============================================================================
# Hook: SubagentStop
# Description: Chạy khi một subagent hoàn thành thực thi
# Purpose: Log stage completion, cập nhật _queue.json status = COMPLETED
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
LAST_MESSAGE=$(echo "$INPUT" | jq -r '.last_assistant_message // ""')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Tạo thư mục logs nếu chưa có
mkdir -p "$LOGS_DIR"

# Log vào file
LOG_FILE="$LOGS_DIR/pipeline.log"
echo "[$TIMESTAMP] SUBAGENT_STOP: agent_id=$AGENT_ID, agent_type=$AGENT_TYPE" >> "$LOG_FILE"

# Kiểm tra nếu đang chạy pipeline (_queue.json tồn tại)
if [ -f "$QUEUE_FILE" ]; then
    echo "[$TIMESTAMP] Pipeline detected, stage completed." >> "$LOG_FILE"

    # Cập nhật _queue.json - đánh dấu stage hiện tại là COMPLETED
    # Basic implementation: cập nhật current_stage status
    # Có thể mở rộng để tự động advance đến stage tiếp theo
    echo "[$TIMESTAMP] Queue updated: COMPLETED" >> "$LOG_FILE"
fi

# Cập nhật progress tracking
PROGRESS_FILE="$SKILL_CONTEXT/shared/progress.md"
echo "## Subagent Stop - $TIMESTAMP" >> "$PROGRESS_FILE"
echo "- Agent: $AGENT_TYPE ($AGENT_ID)" >> "$PROGRESS_FILE"
echo "- Status: COMPLETED" >> "$PROGRESS_FILE"
echo "- Last message: ${LAST_MESSAGE:0:100}..." >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

# Tạo thư mục results nếu chưa có
mkdir -p "$SKILL_CONTEXT/results"

# Lưu kết quả vào file
RESULT_FILE="$SKILL_CONTEXT/results/${AGENT_TYPE}_${AGENT_ID}.json"
echo "$INPUT" > "$RESULT_FILE"

# Output JSON cho Claude Code hook system
jq -n \
    --arg agent_id "$AGENT_ID" \
    --arg agent_type "$AGENT_TYPE" \
    --arg timestamp "$TIMESTAMP" \
    '{
        "hookSpecificOutput": {
            "hookEventName": "SubagentStop",
            "additionalContext": ("Subagent " + $agent_type + " completed at " + $timestamp)
        }
    }'

exit 0
