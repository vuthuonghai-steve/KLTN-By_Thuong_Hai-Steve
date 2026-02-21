# Claude Code — Hướng Dẫn Toàn Diện

> **Tài liệu tham khảo đầy đủ về Hooks, SubAgents và Custom Prompts trong Claude Code**
>
> Cập nhật: 2026-02-21 | Nguồn: Tài liệu chính thức code.claude.com

---

## MỤC LỤC

1. [Phần 1: Custom Prompts (CLAUDE.md)](#phần-1-custom-prompts)
2. [Phần 2: Hooks](#phần-2-hooks)
3. [Phần 3: SubAgents](#phần-3-subagents)
4. [Quick Reference — Bảng tra nhanh](#quick-reference)
5. [Ví dụ thực tế cho KLTN Project](#ví-dụ-kltn)

---

## PHẦN 1: CUSTOM PROMPTS

### Thứ tự ưu tiên (cao → thấp)

```
1. Managed Policy     ← Tổ chức kiểm soát (IT admin)
2. Project Rules      ← .claude/rules/*.md (theo path cụ thể)
3. Project Memory     ← ./CLAUDE.md hoặc ./.claude/CLAUDE.md (team)
4. User Rules         ← ~/.claude/rules/*.md (cá nhân, mọi project)
5. User Memory        ← ~/.claude/CLAUDE.md (cá nhân, mọi project)
6. Project Local      ← ./CLAUDE.local.md (cá nhân, gitignored)
7. Auto Memory        ← ~/.claude/projects/<hash>/memory/ (AI tự học)
```

### Bảng các loại file

| File | Phạm vi | Chia sẻ được | Mục đích |
|------|---------|--------------|---------|
| `CLAUDE.md` (project root) | Project | ✅ Có (repo) | Quy ước team, chuẩn code |
| `.claude/CLAUDE.md` | Project | ✅ Có (repo) | Giống trên, cùng tác dụng |
| `CLAUDE.local.md` | Project | ❌ Không (gitignored) | Tuỳ chỉnh cá nhân, private |
| `~/.claude/CLAUDE.md` | Mọi project | ❌ Không (personal) | Quy ước cá nhân toàn cục |
| `.claude/rules/*.md` | Project | ✅ Có (repo) | Quy tắc theo đường dẫn cụ thể |
| `~/.claude/rules/*.md` | Mọi project | ❌ Không | Quy tắc cá nhân toàn cục |
| `MEMORY.md` (auto) | Per-project | ❌ Không | AI tự học patterns (200 dòng) |

### Cách Claude tải prompt khi bắt đầu session

**Tải ngay lập tức:**
1. Managed policy CLAUDE.md (nếu có org)
2. Tất cả CLAUDE.md từ cwd lên đến root
3. Tất cả `.claude/rules/*.md`
4. 200 dòng đầu auto memory `MEMORY.md`
5. Áp dụng @import theo cây (tối đa 5 cấp)

**Tải theo yêu cầu:**
- CLAUDE.md trong thư mục con → tải khi Claude đọc file trong thư mục đó
- Topic files của auto memory → tải khi Claude cần

**Lưu ý quan trọng:**
- Chỉnh sửa CLAUDE.md trong session không reload ngay — phải `/clear` hoặc restart
- Hooks được snapshot khi session bắt đầu, thay đổi hooks cần dùng menu `/hooks`

### Cú pháp @import

Dùng để liên kết file khác vào CLAUDE.md:

```markdown
# Project Overview
Xem @README.md để cài đặt.
API conventions: @.claude/rules/api.md
Preferences cá nhân: @~/.claude/my-overrides.md
```

**Quy tắc:**
- Đường dẫn tương đối: tính từ file chứa import
- Đường dẫn tuyệt đối: từ `/` hoặc `~`
- Tối đa 5 cấp import lồng nhau
- Lần đầu hiện dialog phê duyệt
- KHÔNG hoạt động bên trong code block (backticks)

### Path-Specific Rules (`.claude/rules/`)

Giới hạn quy tắc theo đường dẫn file cụ thể bằng YAML frontmatter:

```yaml
---
paths:
  - "src/app/api/**/*.ts"
  - "src/**/*.test.ts"
---

# Quy tắc API

- Mọi endpoint phải validate input
- Dùng format error chuẩn từ error-response-system
- Log đầy đủ context khi xảy ra lỗi
```

**Glob patterns hỗ trợ:**
- `**/*.ts` — mọi TypeScript file trong mọi thư mục
- `src/**/*.{ts,tsx}` — cả .ts và .tsx
- `{src,lib}/**/*` — nhiều thư mục
- `*.md` — chỉ trong root directory

**Không có `paths`** → áp dụng cho mọi file.

### Auto Memory (AI tự học)

Claude ghi nhớ và lưu:
- Patterns của project (build command, test structure, code style)
- Debug insights (nguyên nhân lỗi, cách sửa)
- Architecture notes (file quan trọng, module relationship)
- Vấn đề lặp lại và cách giải quyết

**Vị trí:** `~/.claude/projects/<project-hash>/memory/`
- `MEMORY.md` — file index (200 dòng đầu tự động load)
- Topic files như `debugging.md`, `patterns.md` — load theo yêu cầu

**Quản lý:** Gõ `/memory` trong Claude Code để mở memory selector.

### Viết CLAUDE.md hiệu quả

**Nên bao gồm:**
- Bash commands đặc thù cho project (`npm run test`, build steps)
- Code style khác với mặc định
- Quy ước branch, PR format
- Quyết định kiến trúc quan trọng
- Biến môi trường bắt buộc, gotchas
- Vấn đề phổ biến và cách debug

**Không nên bao gồm:**
- Thứ Claude có thể tự suy ra từ code
- Convention chuẩn mà Claude đã biết
- Tài liệu API dài dòng (link ra ngoài thay vì paste vào)
- Thông tin thay đổi thường xuyên
- Hướng dẫn hiển nhiên như "viết code sạch"

**Quy tắc vàng:** Giữ CLAUDE.md **dưới 500 dòng**. File càng dài, Claude càng bỏ qua nhiều. Dùng @import cho nội dung lớn.

---

## PHẦN 2: HOOKS

### Hooks là gì? (Kiểm soát tất định)

Hooks là scripts/prompts chạy **tự động** tại các điểm lifecycle cụ thể.

**Khác biệt so với CLAUDE.md:**
- `CLAUDE.md`: Tư vấn (Claude có thể bỏ qua)
- `Hooks`: Tất định (luôn chạy, không có ngoại lệ)

**Khi nào dùng Hooks:**
- ✅ Auto-format code sau mỗi lần edit (không được bỏ qua)
- ✅ Chặn edit file được bảo vệ
- ✅ Validate lệnh trước khi chạy
- ✅ Chạy tests tự động
- ✅ Gửi thông báo
- ✅ Enforce security policy
- ✅ Audit thay đổi config

**Không dùng Hooks cho:**
- ❌ Hướng dẫn tư vấn (dùng CLAUDE.md)
- ❌ Context thay đổi theo task
- ❌ Logic cần phán đoán của con người
- ❌ Việc cần bỏ qua đôi khi

### Tất cả Hook Events (15 loại)

```
┌──────────────────────────────────────────────────────────────────┐
│ PRE-ACTION HOOKS (có thể chặn hành động)                          │
├──────────────────────────────────────────────────────────────────┤
│ • SessionStart      — Session bắt đầu hoặc resume                │
│ • UserPromptSubmit  — Trước khi Claude xử lý prompt ⭐           │
│ • PreToolUse        — Trước khi tool chạy ⭐ (chặn được)         │
│ • PermissionRequest — Trước dialog cấp quyền ⭐                  │
│ • PreCompact        — Trước khi nén context                       │
├──────────────────────────────────────────────────────────────────┤
│ DECISION HOOKS (có thể chặn hành động tiếp theo)                  │
├──────────────────────────────────────────────────────────────────┤
│ • Stop              — Sau khi Claude hoàn thành ⭐ (chặn được)   │
│ • SubagentStop      — Subagent hoàn thành ⭐ (chặn được)         │
│ • TeammateIdle      — Teammate sắp idle ⭐ (chặn được)           │
│ • TaskCompleted     — Task được đánh dấu hoàn thành ⭐           │
│ • ConfigChange      — File config thay đổi ⭐ (chặn được)        │
├──────────────────────────────────────────────────────────────────┤
│ POST-ACTION HOOKS (không chặn được, chỉ log/notify)               │
├──────────────────────────────────────────────────────────────────┤
│ • PostToolUse          — Tool thành công                          │
│ • PostToolUseFailure   — Tool thất bại                           │
│ • SubagentStart        — Subagent được tạo                       │
│ • Notification         — Thông báo được gửi                      │
│ • SessionEnd           — Session kết thúc                        │
└──────────────────────────────────────────────────────────────────┘
```

### Cấu hình Hook trong settings.json

**Cấu trúc 3 cấp:**

```json
{
  "hooks": {
    "TênEvent": [                        // Cấp 1: Event
      {
        "matcher": "regex_pattern",      // Cấp 2: Bộ lọc (optional)
        "hooks": [
          {
            "type": "command",           // Cấp 3: Handler
            "command": "script.sh",
            "timeout": 600,
            "async": false,
            "statusMessage": "Đang kiểm tra..."
          }
        ]
      }
    ]
  },
  "disableAllHooks": false               // Tắt toàn bộ hooks tạm thời
}
```

### Ba loại Hook Handler

#### 1. Command Hook (phổ biến nhất)

```json
{
  "type": "command",
  "command": "bash .claude/hooks/my-hook.sh",
  "async": false,
  "timeout": 600
}
```

- Nhận JSON qua stdin
- Trả về quyết định qua exit code + stdout JSON
- Hỗ trợ `async: true` (chỉ cho PostToolUse)
- Timeout mặc định: **600 giây**

#### 2. Prompt Hook (LLM đơn giản)

```json
{
  "type": "prompt",
  "prompt": "Đánh giá xem Claude có nên dừng không: $ARGUMENTS",
  "model": "haiku",
  "timeout": 30
}
```

- Một lượt LLM, không có tools
- `$ARGUMENTS` được thay bằng JSON input của hook
- Trả về: `{ "ok": true/false, "reason": "..." }`
- Timeout mặc định: **30 giây**

#### 3. Agent Hook (subagent với tools)

```json
{
  "type": "agent",
  "prompt": "Xác minh tất cả tests đều pass: $ARGUMENTS",
  "model": "sonnet",
  "timeout": 60
}
```

- Tạo subagent với tools Read, Grep, Glob, Bash
- Chạy tối đa 50 turns
- Trả về: `{ "ok": true/false, "reason": "..." }`
- Timeout mặc định: **60 giây**

### Matchers (Bộ lọc theo Event)

Matcher là regex string lọc khi nào hook kích hoạt:

| Event | Trường match | Giá trị ví dụ |
|-------|-------------|---------------|
| Tool events | tool_name | `Bash`, `Edit\|Write`, `mcp__.*` |
| SessionStart | cách bắt đầu | `startup`, `resume`, `clear`, `compact` |
| SessionEnd | lý do kết thúc | `clear`, `logout`, `prompt_input_exit` |
| Notification | loại thông báo | `permission_prompt`, `idle_prompt`, `auth_success` |
| SubagentStart/Stop | agent_type | `Bash`, `Explore`, tên agent tuỳ chỉnh |
| PreCompact | trigger | `manual`, `auto` |
| ConfigChange | nguồn | `user_settings`, `project_settings`, `skills` |

**MCP Tools:**
- Pattern: `mcp__<server>__<tool>`
- Ví dụ: `mcp__github__search_repositories`
- Regex: `mcp__memory__.*` match mọi tool của Memory server

**Không có matcher** (hoặc omit) → kích hoạt với mọi trường hợp:
- `UserPromptSubmit`, `Stop`, `TeammateIdle`, `TaskCompleted`

### Exit Codes

| Code | Ý nghĩa | Hành vi |
|------|---------|---------|
| `0` | Thành công | Cho phép tiếp tục. Parse stdout JSON nếu có |
| `2` | Lỗi chặn | **Chặn hành động**. stderr hiển thị làm feedback |
| `1`, `3+` | Lỗi không chặn | Hiển thị trong verbose mode. Tiếp tục thực thi |

**Lưu ý:** Các PostToolUse, PostToolUseFailure, SubagentStart, SessionStart, SessionEnd, PreCompact → exit 2 chỉ hiển thị stderr, KHÔNG chặn được.

### Cấu trúc JSON Input (chung cho mọi event)

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/working/dir",
  "permission_mode": "default|plan|acceptEdits|dontAsk|bypassPermissions",
  "hook_event_name": "TênEvent"
}
```

**Input bổ sung theo tool (PreToolUse):**

```json
// Bash
{
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm test",
    "description": "Chạy tests",
    "timeout": 120000,
    "run_in_background": false
  }
}

// Write / Edit
{
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.ts",
    "content": "..."
  }
}
```

### Cấu trúc JSON Output

**Output chung (mọi event):**

```json
{
  "continue": true,
  "stopReason": "Lý do nếu continue = false",
  "suppressOutput": false,
  "systemMessage": "Cảnh báo hiển thị cho user"
}
```

**PreToolUse — Kiểm soát quyền:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow|deny|ask",
    "permissionDecisionReason": "Lý do",
    "updatedInput": { "command": "lệnh đã sửa" },
    "additionalContext": "Context thêm cho Claude"
  }
}
```

**PermissionRequest — Quyết định cấp phép:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow|deny",
      "message": "Lý do nếu deny"
    }
  }
}
```

**Stop / SubagentStop — Chặn dừng:**

```json
{
  "decision": "block",
  "reason": "Lý do Claude phải tiếp tục"
}
```

**UserPromptSubmit — Inject context:**

```json
{
  "additionalContext": "Context thêm vào conversation"
}
// Hoặc plain text stdout → tự động thêm vào context
```

**SessionStart — Inject context ban đầu:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Context cho session mới"
  }
}
```

### Async Hooks (chỉ PostToolUse)

```json
{
  "type": "command",
  "command": "npm test",
  "async": true,
  "timeout": 300
}
```

**Cách hoạt động:**
- Hook bắt đầu → Claude tiếp tục không chờ
- Không thể block hoặc trả về decision
- Output giao trong lượt conversation tiếp theo

### Vị trí File Hook và Ưu tiên

| Vị trí | Phạm vi | Chia sẻ | Ghi chú |
|--------|---------|---------|---------|
| `~/.claude/settings.json` | Mọi project | Không | User-level |
| `.claude/settings.json` | Project | Có | Commit vào repo |
| `.claude/settings.local.json` | Project | Không | Gitignored |
| Managed policy | Toàn tổ chức | Có | Admin-controlled |

### Biến môi trường trong Hook scripts

```bash
$CLAUDE_PROJECT_DIR    # Thư mục gốc của project
${CLAUDE_PLUGIN_ROOT}  # Thư mục gốc của plugin
$CLAUDE_CODE_REMOTE    # "true" trong web, unset trong CLI
```

---

## PHẦN 3: SUBAGENTS

### SubAgents là gì?

**Subagents** là AI assistant chuyên biệt chạy trong context window riêng với:
- System prompt tùy chỉnh
- Bộ tools được kiểm soát
- Quyền hạn độc lập
- Transcript/memory riêng biệt

### Các Built-in SubAgents

| Tên | Model | Tools | Mục đích |
|-----|-------|-------|---------|
| `Explore` | Haiku | Read-only | Khám phá codebase, tìm kiếm |
| `Plan` | Inherited | Read-only | Nghiên cứu trong plan mode |
| `General-purpose` | Inherited | Tất cả | Task phức tạp đa bước |
| `Bash` | Inherited | Bash only | Lệnh terminal phức tạp |
| `statusline-setup` | Sonnet | Tất cả | Cấu hình status line |
| `claude-code-guide` | Haiku | Read-only | Giải đáp câu hỏi về Claude Code |

### Thứ tự ưu tiên Agent

```
1. --agents CLI flag    ← Cao nhất, chỉ session hiện tại
2. .claude/agents/      ← Project-level, chia sẻ qua repo
3. ~/.claude/agents/    ← User-level, mọi project
4. Plugin agents        ← Thấp nhất
```

**Xung đột tên:** Ưu tiên cao nhất thắng.

### Cấu trúc File Agent

**Format: Markdown với YAML frontmatter**

```markdown
---
name: code-reviewer
description: Kiểm tra code quality và security. Dùng khi user yêu cầu review code.
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: sonnet
permissionMode: default
maxTurns: 50
memory: project
---

# System Prompt

Bạn là chuyên gia review code. Khi được gọi:
1. Đọc file được chỉ định
2. Kiểm tra security vulnerabilities
3. Kiểm tra code quality
4. Báo cáo vấn đề theo mức độ nghiêm trọng
```

### Tất cả Frontmatter Fields

| Field | Bắt buộc | Type | Giá trị / Ví dụ | Ghi chú |
|-------|---------|------|-----------------|---------|
| `name` | Có | string | `code-reviewer` | Chữ thường, dùng gạch ngang |
| `description` | Có | string | "Kiểm tra code quality" | Claude dùng để quyết định delegate |
| `tools` | Không | string | `Read, Grep, Glob, Bash` | Kế thừa tất cả nếu omit |
| `disallowedTools` | Không | string | `Write, Edit` | Loại khỏi tools được phép |
| `model` | Không | string | `sonnet`, `opus`, `haiku`, `inherit` | Mặc định `inherit` |
| `permissionMode` | Không | string | `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan` | Override mode của parent |
| `maxTurns` | Không | number | `50`, `100` | Số turns tối đa |
| `memory` | Không | string | `user`, `project`, `local` | Phạm vi lưu trữ memory |
| `background` | Không | boolean | `true`, `false` | Luôn chạy background |
| `isolation` | Không | string | `worktree` | Git worktree riêng biệt |
| `skills` | Không | array | `[skill1, skill2]` | Inject đầy đủ nội dung skill |
| `mcpServers` | Không | array | `[slack, github]` | MCP servers cho agent |
| `hooks` | Không | object | Standard hook config | Scoped trong agent lifecycle |

### Kiểm soát Tool Access

**Allowlist (chỉ cho phép tools này):**
```yaml
tools: Read, Grep, Glob, Bash
```

**Denylist (loại khỏi danh sách kế thừa):**
```yaml
disallowedTools: Write, Edit
```

**Kiểm soát tạo Subagent:**
```yaml
# Chỉ được tạo agent 'worker' và 'researcher'
tools: Task(worker, researcher), Read, Bash

# Cho phép tạo mọi subagent
tools: Task, Read, Bash

# Không cho phép tạo subagent nào (không có Task tool)
tools: Read, Bash
```

**Chặn trong settings.json:**
```json
{
  "permissions": {
    "deny": ["Task(Explore)", "Task(my-agent)"]
  }
}
```

### Permission Modes

| Mode | Hành vi | Khi nào dùng |
|------|---------|-------------|
| `default` | Hỏi permission bình thường | Mặc định, duyệt thủ công |
| `acceptEdits` | Tự động chấp nhận sửa file | Tin tưởng agent sửa file |
| `dontAsk` | Tự động từ chối dialogs | Enforce restrictions, không dialog |
| `bypassPermissions` | Bỏ qua mọi kiểm tra | Tin tuyệt đối (cẩn thận!) |
| `plan` | Read-only, chỉ khám phá | Research-only mode |

**Lưu ý:** Parent dùng `bypassPermissions` → subagent không thể override lại.

### Memory Scopes cho Agents

| Scope | Vị trí | Use Case |
|-------|--------|---------|
| `user` | `~/.claude/agent-memory/<name>/` | Kiến thức xuyên mọi project |
| `project` | `.claude/agent-memory/<name>/` | Chia sẻ trong team (version control) |
| `local` | `.claude/agent-memory-local/<name>/` | Project-specific, không commit |

**Cấu trúc memory:**
```
agent-memory/<name>/
├── MEMORY.md      # Index 200 dòng (tự động load khi bắt đầu)
├── debugging.md   # Topic file (load theo yêu cầu)
├── patterns.md
└── ...
```

### Cách Claude Quyết định Dùng Agent

Claude tự động delegate khi:
1. Mô tả task match với field `description` của agent
2. Task cần capability đặc biệt của agent
3. Task được hưởng lợi từ context/tool restriction riêng

**Để kích hoạt chủ động:** Thêm "use proactively" vào description.

**Gọi tường minh:**
```
Dùng code-reviewer agent để review file này
Cho debugging-agent tìm nguyên nhân lỗi
```

### Foreground vs Background

**Foreground (mặc định):**
- Chặn main conversation
- Prompt chảy qua cho user
- Có thể hỏi câu hỏi làm rõ

**Background:**
- Chạy song song
- User pre-approve permissions
- Tự động từ chối operation chưa được duyệt

**Kiểm soát:**
```yaml
background: true  # Luôn chạy background
```
Hoặc nhấn `Ctrl+B` khi task đang chạy.

### Hooks trong Agent Frontmatter

```yaml
---
name: my-agent
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./validate.sh"
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "./lint.sh"
---
```

**Lưu ý:** Stop hooks trong frontmatter → tự động chuyển thành `SubagentStop` event.

### SubagentStart/SubagentStop Hook Input/Output

**SubagentStart Input:**
```json
{
  "agent_id": "agent-abc123",
  "agent_type": "Explore",
  "hook_event_name": "SubagentStart"
}
```

**SubagentStop Input:**
```json
{
  "agent_id": "agent-abc123",
  "agent_type": "code-reviewer",
  "agent_transcript_path": "~/.claude/projects/.../subagents/agent-abc123.jsonl",
  "last_assistant_message": "Review hoàn tất...",
  "stop_hook_active": false
}
```

---

## QUICK REFERENCE

### Checklist Custom Prompts

- [ ] Tạo `.claude/CLAUDE.md` với quy ước team
- [ ] Giữ dưới 500 dòng
- [ ] Dùng @imports cho nội dung lớn
- [ ] Tạo `.claude/rules/` cho quy tắc theo path
- [ ] Chỉ include thứ Claude không tự suy ra
- [ ] Dùng **IMPORTANT**, **CRITICAL**, **YOU MUST** cho quy tắc quan trọng

### Checklist Hooks

- [ ] Xác định điều PHẢI xảy ra mỗi lần (tất định)
- [ ] Chọn event đúng (PreToolUse, PostToolUse, Stop, v.v.)
- [ ] Viết script với error handling đúng
- [ ] Test exit codes (0, 2)
- [ ] Thêm matcher nếu cần lọc
- [ ] Cấu hình trong `.claude/settings.json`
- [ ] Test thủ công trước khi dùng
- [ ] `chmod +x` script file

### Checklist SubAgents

- [ ] Tạo file `.claude/agents/<name>.md`
- [ ] Viết description rõ ràng (Claude dùng để decide)
- [ ] Chỉ định tools cần thiết
- [ ] Set model phù hợp (haiku cho fast, sonnet cho balanced)
- [ ] Test bằng cách gọi tường minh trước
- [ ] Set memory scope nếu cần persist learning

### Patterns Hook phổ biến

```json
// Chặn lệnh nguy hiểm
{ "matcher": "Bash", "hooks": [{ "type": "command", "command": ".claude/hooks/block-destructive.sh" }] }

// Auto-format khi edit
{ "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": "prettier --write $(jq -r '.tool_input.file_path')" }] }

// Bảo vệ file nhạy cảm
{ "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": ".claude/hooks/protect-files.sh" }] }

// Verify tests trước khi dừng
{ "hooks": [{ "type": "command", "command": ".claude/hooks/verify-tests.sh" }] }
```

---

## VÍ DỤ KLTN

### 1. Hook: Chặn lệnh phá hoại

```bash
#!/bin/bash
# .claude/hooks/block-destructive.sh

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

BLOCKED_PATTERNS=(
  '^rm -rf'
  'DROP TABLE'
  'truncate'
  '^git reset --hard'
  '^git clean -f'
  'mongodrop'
  'force-push'
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qiE "$pattern"; then
    jq -n --arg cmd "$COMMAND" '{
      "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": ("Lệnh nguy hiểm bị chặn: " + $cmd)
      }
    }'
    exit 0
  fi
done

exit 0
```

### 2. Hook: Bảo vệ file .env

```bash
#!/bin/bash
# .claude/hooks/protect-env.sh

INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ "$FILE" == *".env"* ]] || [[ "$FILE" == *"secret"* ]]; then
  echo "Không được phép chỉnh sửa file nhạy cảm: $FILE" >&2
  exit 2
fi
exit 0
```

### 3. Hook: Verify Tests trước khi dừng

```bash
#!/bin/bash
# .claude/hooks/verify-tests.sh

INPUT=$(cat)

# Tránh vòng lặp vô hạn
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0
fi

# Chạy tests (chỉ khi có code thay đổi)
if npm test 2>&1 | tail -5; then
  exit 0
else
  jq -n '{
    "decision": "block",
    "reason": "Tests đang thất bại. Sửa lỗi trước khi dừng."
  }'
fi
```

### 4. Cấu hình settings.json đầy đủ

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash /home/steve/Documents/KLTN/.claude/hooks/block-destructive.sh",
            "timeout": 10
          }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash /home/steve/Documents/KLTN/.claude/hooks/protect-env.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash /home/steve/Documents/KLTN/.claude/hooks/verify-tests.sh",
            "timeout": 120
          }
        ]
      }
    ]
  }
}
```

### 5. Custom Agent: Spec Reviewer

```markdown
---
name: spec-reviewer
description: Kiểm tra code implementation có đúng với Life-2 specs không. Dùng khi verify feature mới hoặc sau khi implement module. Trigger khi cần spec compliance check.
tools: Read, Grep, Glob
model: sonnet
permissionMode: plan
---

# Spec Reviewer Agent

Bạn là chuyên gia kiểm tra tính nhất quán giữa code và specification.

## Quy trình
1. Đọc spec file liên quan trong `Docs/life-2/specs/`
2. Đọc schema trong `Docs/life-2/database/schema-design.md`
3. So sánh với code implementation
4. Báo cáo:
   - ✅ Đúng spec
   - ❌ Vi phạm spec (field name sai, logic thiếu)
   - ⚠️ Spec chưa cover (cần clarify)
```

### 6. Custom Rule: API Routes

```yaml
# .claude/rules/api.md
---
paths:
  - "src/app/api/**/*.ts"
---

# Quy tắc API Routes

- LUÔN dùng error response system từ `.codex/skills/error-response-system`
- KHÔNG trả về sensitive fields: password, resetToken, verificationToken
- LUÔN validate `req.user` trước mutation operations
- Mọi endpoint phải có input validation
- Format response chuẩn: `{ status, data, errors }`
```

---

## Bảng tổng hợp tất cả vị trí file

| File | Mục đích | Phạm vi | Chia sẻ |
|------|---------|---------|---------|
| `~/.claude/settings.json` | Settings + hooks user-level | Mọi project | Không |
| `.claude/settings.json` | Settings + hooks project | Project | Có |
| `.claude/settings.local.json` | Settings cá nhân | Project | Không |
| `~/.claude/CLAUDE.md` | Hướng dẫn cá nhân | Mọi project | Không |
| `./CLAUDE.md` | Hướng dẫn team | Project | Có |
| `./CLAUDE.local.md` | Preferences cá nhân | Project | Không |
| `.claude/rules/*.md` | Quy tắc modular | Project | Có |
| `~/.claude/rules/*.md` | Quy tắc cá nhân | Mọi project | Không |
| `~/.claude/agents/*.md` | Agents cá nhân | Mọi project | Không |
| `.claude/agents/*.md` | Agents project | Project | Có |
| `~/.claude/projects/<>/memory/` | Auto memory | Per-project | Không |
| `.claude/hooks/*.sh` | Hook scripts | Project | Có |

---

*Tài liệu này được cập nhật từ docs chính thức code.claude.com — 2026-02-21*
