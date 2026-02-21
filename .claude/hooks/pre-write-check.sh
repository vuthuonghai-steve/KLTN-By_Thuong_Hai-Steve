#!/usr/bin/env bash
# Hook: PreToolUse → Write | Edit
# Cảnh báo nếu Claude chuẩn bị ghi vào file .env hoặc secret files

TOOL_INPUT=$(cat)
FILE_PATH=$(echo "$TOOL_INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

if [[ "$FILE_PATH" == *".env"* ]] || [[ "$FILE_PATH" == *"secret"* ]] || [[ "$FILE_PATH" == *"credentials"* ]]; then
  echo "⚠️  WARNING: Attempting to write to sensitive file: $FILE_PATH" >&2
  exit 2
fi

exit 0
