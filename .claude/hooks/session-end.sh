#!/usr/bin/env bash
# Hook: Stop (async)
# Ghi log ngày/giờ kết thúc session để theo dõi hoạt động

LOG_FILE="/home/steve/Documents/KLTN/.claude/agent-memory/.session-log.txt"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Session ended" >> "$LOG_FILE"
