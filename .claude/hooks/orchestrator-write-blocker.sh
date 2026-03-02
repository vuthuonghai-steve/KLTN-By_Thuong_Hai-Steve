#!/bin/bash

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Block logic only triggers for the Orchestrator (it does not run inside a subagent)
if [[ "$TRANSCRIPT_PATH" != *"subagents"* ]]; then
  
  if [[ "$TOOL_NAME" == "Write" ]] || [[ "$TOOL_NAME" == "Edit" ]]; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
    
    # Block writing to Docs/life-2/diagrams or ui by Orchestrator
    if [[ "$FILE_PATH" == *"Docs/life-2/diagrams"* ]] || [[ "$FILE_PATH" == *"Docs/life-2/ui"* ]]; then
      jq -n '{
        "hookSpecificOutput": {
          "hookEventName": "PreToolUse",
          "permissionDecision": "deny",
          "permissionDecisionReason": "🚨 MỆNH LỆNH THÉP: Orchestrator KHÔNG ĐƯỢC PHÉP tự mình dùng tool Write/Edit để tạo hay sửa các file sơ đồ chuyên sâu. Bạn PHẢI dùng tool Task để uỷ quyền cho các Sub-agent (ví dụ: flow-design-analyst) làm việc này!"
        }
      }'
      exit 0
    fi
  fi
  
  if [[ "$TOOL_NAME" == "Bash" ]]; then
    COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
    if [[ "$COMMAND" == *"Docs/life-2/diagrams"* ]] || [[ "$COMMAND" == *"Docs/life-2/ui"* ]]; then
      jq -n '{
        "hookSpecificOutput": {
          "hookEventName": "PreToolUse",
          "permissionDecision": "deny",
          "permissionDecisionReason": "🚨 MỆNH LỆNH THÉP: Orchestrator KHÔNG ĐƯỢC PHÉP dùng Bash để chỉnh sửa các file sơ đồ chuyên sâu. Hãy delegate tác vụ này cho Sub-agent bằng tool Task!"
        }
      }'
      exit 0
    fi
  fi
  
fi

exit 0
