#!/bin/bash

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Check if the main Orchestrator just finished a Task (Agent delegation)
if [[ "$TRANSCRIPT_PATH" != *"subagents"* ]] && [[ "$TOOL_NAME" == "Task" ]]; then
  
  # Trigger the Review Gate system message
  jq -n '{
    "systemMessage": "🚨 REVIEW GATE BẮT BUỘC: Sub-agent vừa hoàn thành xong bản vẽ của nó! ĐỪNG đinh ninh là nó đã làm đúng!\n📌 Yêu cầu đối chiếu với: module-blueprint.md\n❌ Nếu vẽ sơ sài, thiếu nhánh/lỗi: Báo lỗi và dùng tool Task gọi đệ làm lại.\n✅ Nếu duyệt: Mới được đi tiếp!",
    "suppressOutput": false
  }'
  exit 0
  
fi

exit 0
