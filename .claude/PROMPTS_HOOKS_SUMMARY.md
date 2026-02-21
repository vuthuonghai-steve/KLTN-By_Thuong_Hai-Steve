# Custom Prompts, Hooks & SubAgents — Tóm Tắt Nhanh

> Hướng dẫn tham khảo nhanh cho KLTN Project
>
> **Tài liệu đầy đủ:** Xem `CLAUDE_ADVANCED_GUIDE.md`

---

## Custom Prompts — Tổng quan

**Custom prompts** = Hướng dẫn bền vững mà Claude đọc ở mỗi lần bắt đầu session. Định hướng hành vi của Claude xuyên suốt mọi cuộc trò chuyện.

### Ba khái niệm cốt lõi

| Khái niệm | Là gì | Vị trí | Chia sẻ |
|-----------|-------|--------|---------|
| **CLAUDE.md** | Hướng dẫn team | `./CLAUDE.md` | ✅ Có (repo) |
| **CLAUDE.local.md** | Preferences cá nhân | `./CLAUDE.local.md` | ❌ Không (gitignored) |
| **Auto Memory** | AI tự học patterns | `~/.claude/projects/<>/memory/` | ❌ Không (personal) |

### Thứ tự ưu tiên (cao → thấp)

```
1. Managed Policy (IT admin)
2. .claude/rules/*.md  (team, theo path)
3. ./CLAUDE.md          (team, mọi file)
4. ~/.claude/rules/*.md (cá nhân)
5. ~/.claude/CLAUDE.md  (cá nhân, mọi project)
6. ./CLAUDE.local.md    (cá nhân, gitignored)
7. Auto Memory          (AI tự ghi)
```

### Nên/Không nên đưa vào CLAUDE.md

✅ **Nên:**
- Build/test commands đặc thù cho project (`npm run dev`, build steps)
- Code style rules khác với mặc định (2 spaces, semicolons, v.v.)
- Quy ước đặt tên, PR format, branch naming
- Architecture decisions quan trọng
- Biến môi trường bắt buộc, debug tips

❌ **Không nên:**
- Thứ Claude có thể tự suy ra từ code
- Convention chuẩn Claude đã biết
- API docs dài dòng (link ra ngoài thay vì paste vào)
- Thông tin thay đổi thường xuyên
- "Viết code sạch", "dùng TypeScript" — hiển nhiên

**Giữ CLAUDE.md dưới 500 dòng.** Càng ngắn càng được follow đúng hơn.

---

## Hooks — Tổng quan

**Hooks** = Scripts tất định chạy **luôn luôn** tại điểm lifecycle cụ thể (không có ngoại lệ).

### Sự khác biệt then chốt

```
CLAUDE.md: "Bạn nên dùng TypeScript"   → Claude cân nhắc, có thể bỏ
Hooks:     "Auto-format sau mỗi lần edit" → Luôn xảy ra, không ngoại lệ
```

### Tất cả 15 Hook Events

| Khi nào | Tên Event | Chặn được? | Ví dụ dùng |
|---------|-----------|-----------|------------|
| Session bắt đầu | `SessionStart` | ❌ | Inject project status |
| Trước khi Claude xử lý prompt | `UserPromptSubmit` | ✅ | Inject thêm context |
| Trước khi tool chạy | `PreToolUse` | ✅ | Chặn lệnh nguy hiểm |
| Trước dialog cấp quyền | `PermissionRequest` | ✅ | Tự động từ chối quyền |
| Trước khi nén context | `PreCompact` | ❌ | Log trước compact |
| Sau khi Claude hoàn thành | `Stop` | ✅ | Verify tests pass |
| Subagent hoàn thành | `SubagentStop` | ✅ | Kiểm tra kết quả |
| Teammate sắp idle | `TeammateIdle` | ✅ | Giữ teammate hoạt động |
| Task được đánh dấu xong | `TaskCompleted` | ✅ | Verify trước khi done |
| Config file thay đổi | `ConfigChange` | ✅ | Audit thay đổi |
| Sau khi tool thành công | `PostToolUse` | ❌ | Auto-format code |
| Sau khi tool thất bại | `PostToolUseFailure` | ❌ | Log lỗi |
| Subagent được tạo | `SubagentStart` | ❌ | Inject context |
| Thông báo được gửi | `Notification` | ❌ | Log notifications |
| Session kết thúc | `SessionEnd` | ❌ | Log timestamp |

### Exit Codes Hook

| Code | Ý nghĩa |
|------|---------|
| `0` | ✅ Thành công — parse stdout JSON nếu có |
| `2` | 🛑 **Chặn hành động** — stderr hiển thị làm feedback |
| `1`, `3+` | ⚠️ Lỗi không chặn — hiển thị trong verbose mode |

### Cấu hình cơ bản trong settings.json

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": ".claude/hooks/block-destructive.sh" }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": ".claude/hooks/verify-tests.sh" }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": ".claude/hooks/auto-format.sh", "async": true }
        ]
      }
    ]
  }
}
```

### 3 Loại Hook Handler

| Loại | Timeout mặc định | Mô tả |
|------|-----------------|-------|
| `command` | 600 giây | Shell script, nhận JSON qua stdin |
| `prompt` | 30 giây | LLM một lượt, không có tools |
| `agent` | 60 giây | Subagent với Read/Grep/Glob/Bash |

### Matchers (Bộ lọc)

| Event | Giá trị matcher |
|-------|----------------|
| Tool events | `Bash`, `Edit\|Write`, `mcp__.*`, `mcp__github__.*` |
| SessionStart | `startup`, `resume`, `clear`, `compact` |
| ConfigChange | `user_settings`, `project_settings`, `skills` |
| Notification | `permission_prompt`, `idle_prompt`, `auth_success` |

### Cách viết Hook Script (pattern chuẩn)

```bash
#!/bin/bash
INPUT=$(cat)                                          # Đọc JSON từ stdin

# Trích xuất field cần thiết
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

# Logic kiểm tra
if echo "$COMMAND" | grep -q 'rm -rf'; then
  # Cách 1: exit 2 để chặn (kèm stderr)
  echo "Lệnh nguy hiểm bị chặn" >&2
  exit 2

  # Cách 2: JSON output để chặn (với lý do cho Claude)
  # jq -n '{"decision": "block", "reason": "Lý do"}'
  # exit 0
fi

exit 0  # Cho phép tiếp tục
```

---

## SubAgents — Tổng quan

**SubAgents** = AI assistant chuyên biệt với context, tools và quyền hạn riêng.

### Cấu trúc File Agent

```markdown
---
name: ten-agent
description: Mô tả khi nào dùng agent này. Claude đọc field này để quyết định.
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: sonnet
permissionMode: default
maxTurns: 50
memory: project
---

# System Prompt

Bạn là...
Khi được gọi:
1. Bước 1
2. Bước 2
```

### Frontmatter Fields quan trọng

| Field | Ý nghĩa |
|-------|---------|
| `name` | Tên agent, lowercase, dùng gạch ngang |
| `description` | ⭐ **Quan trọng nhất** — Claude đọc để decide có delegate không |
| `tools` | Danh sách tools được phép (kế thừa tất cả nếu omit) |
| `disallowedTools` | Loại tool ra khỏi danh sách được phép |
| `model` | `sonnet`/`opus`/`haiku`/`inherit` |
| `permissionMode` | `default`/`acceptEdits`/`plan`/`bypassPermissions` |
| `memory` | `user`/`project`/`local` — lưu learning qua sessions |

### Kiểm soát Tool Access

```yaml
# Chỉ được phép đọc
tools: Read, Grep, Glob

# Không cho sửa file
tools: Read, Grep, Bash
disallowedTools: Write, Edit

# Chỉ được spawn agent worker và researcher
tools: Task(worker, researcher), Read, Bash

# Không được spawn subagent nào (không có Task)
tools: Read, Bash
```

### Vị trí Agent Files

| Vị trí | Phạm vi | Ưu tiên |
|--------|---------|---------|
| `.claude/agents/` | Project (commit vào repo) | Cao hơn |
| `~/.claude/agents/` | User (mọi project) | Thấp hơn |

### Kích hoạt Agent

**Tự động** — Claude tự quyết dựa trên `description`:
```
Kiểm tra xem code này có đúng spec không
```

**Tường minh:**
```
Dùng spec-reviewer agent để kiểm tra file src/collections/Posts.ts
Cho payload-expert agent review hooks trong bài này
```

---

## KLTN Project — Setup hiện tại

### Custom Prompts Structure

```
./CLAUDE.md                    ← Main project instructions (team)
./.claude/CLAUDE.md            ← Giống CLAUDE.md (cùng tác dụng)
./.claude/rules/
  ├── ui-stack.md              ← Tailwind v4 + Radix UI only
  ├── spec-first.md            ← Đọc specs trước khi code
  ├── payload-conventions.md  ← Payload CMS patterns
  └── lifecycle.md             ← 4-Life phase rules
./CLAUDE.local.md              ← Cá nhân (gitignored, tạo nếu cần)
```

### Hooks hiện tại

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "command": ".claude/hooks/block-destructive.sh" }]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [{ "command": ".claude/hooks/protect-env.sh" }]
      }
    ],
    "Stop": [
      {
        "hooks": [{ "command": ".claude/hooks/verify-tests.sh" }]
      }
    ]
  }
}
```

### Agents hiện tại

| Agent | Vị trí | Chức năng |
|-------|--------|----------|
| `spec-reviewer` | `.claude/agents/spec-reviewer/` | Verify code vs Life-2 specs |
| `payload-expert` | `.claude/agents/payload-expert/` | Payload CMS patterns |
| `ui-architect` | `.claude/agents/ui-architect/` | React + Tailwind v4 + Radix UI |

---

## Thêm mới

### Thêm quy tắc cho team

1. Tạo `.claude/rules/ten-topic.md`:
```yaml
---
paths:
  - "src/app/api/**/*.ts"
---

# Quy tắc API

- Mọi endpoint phải validate input
- Dùng error-response-system
```

2. Claude tự động load khi edit file trong path đó.

### Thêm preferences cá nhân

1. Tạo `./CLAUDE.local.md`:
```markdown
# Preferences Cá Nhân

- Dùng `pnpm` thay vì `npm`
- Dev URL: http://localhost:3001
- Test data: ~/test-data/
```

2. Không commit vào repo.

### Thêm Hook mới

```bash
# Bước 1: Tạo script
cat > .claude/hooks/my-hook.sh << 'EOF'
#!/bin/bash
INPUT=$(cat)
# Logic của bạn
exit 0
EOF

# Bước 2: Cấp quyền thực thi
chmod +x .claude/hooks/my-hook.sh

# Bước 3: Thêm vào settings.json
```

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "command": ".claude/hooks/my-hook.sh" }]
      }
    ]
  }
}
```

### Thêm Agent mới

1. Tạo `.claude/agents/ten-agent.md`:
```markdown
---
name: ten-agent
description: Khi nào Claude nên dùng agent này
tools: Read, Grep, Glob
model: haiku
---

# System Prompt
...
```

2. Gọi tường minh: "Dùng ten-agent để..."

---

## Khi nào dùng gì

| Tình huống | Công cụ | File |
|-----------|---------|------|
| Thêm quy tắc cho team | CLAUDE.md | `./CLAUDE.md` |
| Preferences cá nhân | CLAUDE.local.md | `./CLAUDE.local.md` |
| Quy tắc theo đường dẫn | Rules file | `.claude/rules/*.md` |
| Việc PHẢI xảy ra mọi lần | Hook | `.claude/hooks/*.sh` |
| Chặn hành động xấu | PreToolUse hook | `.claude/settings.json` |
| Validate kết quả | PostToolUse hook | `.claude/settings.json` |
| Ngăn Claude dừng sớm | Stop hook | `.claude/settings.json` |
| Chuyên gia đặc biệt | Custom Agent | `.claude/agents/*.md` |

---

## Câu hỏi thường gặp

**Q: `./CLAUDE.md` hay `./.claude/CLAUDE.md`?**
A: Cả hai đều được load. Convention: dùng `./CLAUDE.md` ở root.

**Q: Hook không hoạt động?**
A: Kiểm tra: (1) `chmod +x script.sh`, (2) exit code đúng (0 hoặc 2), (3) JSON output hợp lệ.

**Q: Test hook thủ công?**
```bash
echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf /"}}' | .claude/hooks/block-destructive.sh
echo $?  # Phải là 2 để chặn
```

**Q: Debug hooks?**
A: Bật verbose mode: `Ctrl+O` trong Claude Code.

**Q: CLAUDE.md dài quá Claude bỏ qua?**
A: Đúng. Giữ dưới 500 dòng, dùng @imports cho nội dung lớn, thêm **IMPORTANT** cho quy tắc critical.

**Q: Agent có thể sửa file không?**
A: Phụ thuộc `tools` và `permissionMode`. Thêm `disallowedTools: Write, Edit` để ngăn.

---

**Tài liệu đầy đủ:** `.claude/CLAUDE_ADVANCED_GUIDE.md`
