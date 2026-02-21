# Steve Void — Knowledge-Sharing Social Network

Website Mạng Xã Hội Chia Sẻ Kiến Thức cho cộng đồng developer, sinh viên CNTT và tech learners tại Việt Nam.

---

## Tech Stack

| Layer | Choice |
|-------|--------|
| Frontend | Next.js 15 + React 19 (App Router) |
| Backend | Payload CMS 3.x (Headless, Local API) |
| Database | MongoDB Atlas |
| Styling | **Tailwind CSS v4 + Radix UI** _(no shadcn/antd/mui/chakra)_ |
| Realtime | SSE (Server-Sent Events) |
| Search | MongoDB Atlas Search |
| State | Redux Toolkit |
| Hosting | Vercel |

---

## Working with Claude Code

Dự án này được tối ưu để làm việc với **Claude Code** — Anthropic's official CLI agent. Toàn bộ workflow từ thiết kế spec đến sinh code đều có thể được thực thi thông qua AI agent.

### Cài đặt Claude Code

```bash
npm install -g @anthropic/claude-code
```

### Khởi động session

```bash
# Chạy từ thư mục gốc của dự án
cd /home/steve/Documents/KLTN
claude
```

---

## Cấu trúc `.claude/`

Thư mục `.claude/` là trung tâm cấu hình Claude Code cho dự án. Mọi cấu hình đều được version-control (trừ `settings.local.json`).

```
.claude/
├── settings.json          # Team-shared permissions và plugin settings
├── settings.local.json    # Personal overrides (gitignored)
├── CLAUDE.md              # Project memory — tự động load mỗi session
├── agents/                # Custom AI subagents cho từng vai trò
│   ├── spec-reviewer/     # Kiểm tra code vs Life-2 specs
│   ├── payload-expert/    # Chuyên gia Payload CMS
│   └── ui-architect/      # UI component với Tailwind + Radix UI
└── rules/                 # Luật dự án — auto-load theo file context
    ├── ui-stack.md        # Tailwind v4 + Radix UI ONLY
    ├── spec-first.md      # Đọc spec trước khi code
    ├── payload-conventions.md  # Payload collection patterns
    └── lifecycle.md       # 4-Life phase system
```

### `settings.json` — Permissions

Định nghĩa lệnh nào Claude được phép chạy tự động:

```json
{
  "permissions": {
    "allow": ["Bash(npm run dev)", "Bash(npm run test)", "Bash(git status)"],
    "deny":  ["Bash(rm -rf *)", "Bash(git push --force *)"]
  }
}
```

Sửa `.claude/settings.local.json` để thêm permission riêng (không commit).

### `agents/` — Custom Subagents

Ba agent chuyên biệt cho dự án:

| Agent | Kích hoạt khi | Lệnh |
|-------|--------------|------|
| `spec-reviewer` | Verify code vs spec | Claude tự dispatch khi review |
| `payload-expert` | Thiết kế/implement Payload collections | Claude tự dispatch cho Payload tasks |
| `ui-architect` | Build React components | Claude tự dispatch cho UI tasks |

Claude tự chọn agent phù hợp dựa trên `description` field. Bạn cũng có thể yêu cầu trực tiếp: _"dùng spec-reviewer để kiểm tra M3"_.

### `rules/` — Project Rules

Rules được auto-load theo context file đang làm việc:

| Rule File | Áp dụng cho |
|-----------|-------------|
| `ui-stack.md` | `src/components/**`, `src/app/**/*.tsx` |
| `spec-first.md` | Mọi implementation task trong `src/` |
| `payload-conventions.md` | `src/collections/**`, `payload.config.ts` |
| `lifecycle.md` | Mọi task trong dự án |

---

## Skills — Công cụ tự động hóa

Skills là các workflow tái sử dụng được. Kích hoạt bằng lệnh `/skill-name`.

Skills nằm tại `~/.codex/skills/` (user-level, dùng được trên mọi project).

### Nhóm Thiết kế (Life-2)

| Skill | Lệnh | Dùng khi |
|-------|------|----------|
| Sequence Diagram | `/sequence-design-analyst` | Vẽ luồng tương tác giữa objects |
| Activity Diagram | `/activity-diagram-design-analyst` | Vẽ luồng nghiệp vụ (B-U-E lanes) |
| Flow Diagram | `/flow-design-analyst` | Vẽ Business Process Flow (swimlane) |
| Schema Design | `/schema-design-analyst` | Thiết kế MongoDB collection schema |
| Class Diagram | `/class-diagram-analyst` | Phân tích cấu trúc static |

### Nhóm OpenSpec (Change Management)

| Skill | Lệnh | Dùng khi |
|-------|------|----------|
| New Change | `/openspec-new-change` | Bắt đầu một thay đổi mới |
| Apply Change | `/openspec-apply-change` | Implement tasks từ change |
| Continue Change | `/openspec-continue-change` | Tiếp tục artifact tiếp theo |
| Verify | `/openspec-verify-change` | Kiểm tra implementation vs spec |
| Archive | `/openspec-archive-change` | Archive change đã xong |
| Fast-forward | `/openspec-ff-change` | Skip nhanh qua artifact creation |
| Sync Specs | `/openspec-sync-specs` | Sync delta specs vào main specs |
| Explore | `/openspec-explore` | Thinking partner, khám phá vấn đề |

### Nhóm Payload CMS (Life-3)

| Skill | Lệnh | Dùng khi |
|-------|------|----------|
| CRUD Admin Page | `/build-crud-admin-page` | Tạo trang quản lý Payload collection |
| Error Response | `/error-response-system` | Chuẩn hóa API error codes |
| API from UI | `/api-from-ui` | Build custom API từ UI đang có |
| API Integration | `/api-integration` | Tích hợp API vào frontend |
| Screen Checker | `/screen-structure-checker` | Kiểm tra cấu trúc thư mục screen |

### Nhóm Agent Skill (Meta-workflow)

| Skill | Lệnh | Dùng khi |
|-------|------|----------|
| Skill Architect | `/skill-architect` | Thiết kế Agent Skill mới |
| Skill Planner | `/skill-planner` | Lập kế hoạch build skill |
| Skill Builder | `/skill-builder` | Implement skill từ design |
| Master Skill | `/master-skill` | Orchestrate end-to-end skill delivery |

### Công cụ hỗ trợ

| Skill | Lệnh | Dùng khi |
|-------|------|----------|
| Prompt Improver | `/prompt-improver` | Cải thiện prompt không hiệu quả |
| TypeScript Explainer | `/typescript-error-explainer` | Giải thích TS error bằng tiếng Việt |
| Task Planner | `/task-planner` | Phân tách task thành phase + subtask |
| NotebookLM | `/notebooklm` | Query Google NotebookLM notebooks |

---

## 4-Life Lifecycle System

Dự án theo hệ thống 4 giai đoạn. Tài liệu trong `Docs/` vừa là hướng dẫn cho người đọc vừa là **context cho AI Agent thực thi**.

```
Life-1 (Done)    → Docs/life-1/   — Vision, personas, technical decisions
Life-2 (Active)  → Docs/life-2/   — Specs, diagrams, DB schema, wireframes
Life-3 (Next)    → Docs/life-3/   — Implementation (spec-driven)
Life-4 (Future)  → Docs/life-4/   — Verification, test reports, release
```

**Trạng thái hiện tại:** Life-2 — đang hoàn thiện M4 (Engagement) và M6 (Notifications/Moderation).

Theo dõi tiến độ: `Docs/check.list.md`

### Module Specs (nguồn duy nhất cho code)

| Module | File | Nội dung |
|--------|------|---------|
| M1 | `Docs/life-2/specs/m1-auth-profile-spec.md` | Auth, Registration, Profile |
| M2 | `Docs/life-2/specs/m2-content-engine-spec.md` | Posts CRUD, Media |
| M3 | `Docs/life-2/specs/m3-discovery-feed-spec.md` | News Feed, Ranking |
| M4 | `Docs/life-2/specs/m4-engagement-spec.md` | Likes, Comments, Follow |
| M5 | `Docs/life-2/specs/m5-bookmarking-spec.md` | Collections, Bookmarks |
| M6 | `Docs/life-2/specs/m6-notifications-moderation-spec.md` | SSE, Reports |

---

## Development Workflow

### Life-2 — Thiết kế Spec mới

```
1. /openspec-new-change        → Mô tả thay đổi
2. /sequence-design-analyst    → Vẽ sequence diagram
3. /activity-diagram-design-analyst → Vẽ activity diagram
4. /openspec-sync-specs        → Cập nhật vào main specs
5. /openspec-archive-change    → Archive change
```

### Life-3 — Implement tính năng

```
1. Đọc spec: Docs/life-2/specs/<module>-spec.md
2. /openspec-new-change        → Tạo implementation plan
3. /openspec-apply-change      → Claude tự implement từng task
4. /openspec-verify-change     → Verify vs spec
5. /openspec-archive-change    → Archive
```

### Quick tasks (không cần OpenSpec)

```bash
# Tạo CRUD admin page cho Payload collection
/build-crud-admin-page

# Fix TypeScript error
/typescript-error-explainer

# Review code vs spec
# → Claude sẽ dispatch spec-reviewer agent tự động
```

---

## Environment Setup

```bash
# 1. Clone project và install
npm install

# 2. Setup env
cp .env.example .env
# Điền vào: MONGODB_URI, PAYLOAD_SECRET, NEXT_PUBLIC_SERVER_URL

# 3. Chạy dev server
npm run dev
```

Biến môi trường đầy đủ: `Docs/life-3/setup/env-setup.md`

---

## Sync Skills

Một số skill tồn tại ở cả `.agent/skills/` và `.codex/skills/`. Dùng runbook để sync:

```bash
# skill-architect: .agent → .codex
rsync -av .agent/skills/skill-architect/ .codex/skills/skill-architect/

# skill-builder: .codex → .agent
rsync -av .codex/skills/skill-builder/ .agent/skills/skill-builder/

# Verify parity
diff -qr .codex/skills/skill-architect .agent/skills/skill-architect
diff -qr .codex/skills/skill-builder .agent/skills/skill-builder
```

Hướng dẫn đầy đủ: `Docs/skill-sync-runbook.md`

---

## Key Rules (bất di bất dịch)

1. **Tailwind v4 + Radix UI only** — không dùng shadcn, antd, mui, chakra
2. **Đọc spec trước khi code** — `Docs/life-2/specs/` là nguồn duy nhất
3. **Field names phải khớp schema** — `Docs/life-2/database/schema-design.md`
4. **API contracts từ api-spec.md** — không tự thêm endpoint
5. **Local API cho server-side** — không gọi REST từ Server Components

---

## Tài liệu tham khảo

| Tài liệu | Mô tả |
|---------|-------|
| `CLAUDE.md` | Project memory cho Claude Code |
| `GEMINI.md` | Project will và workflow rules (chi tiết) |
| `workspace/architect.md` | Agent Skill Framework architecture |
| `Docs/check.list.md` | Trạng thái hiện tại theo giai đoạn |
| `Docs/life-1/01-vision/product-vision.md` | Tầm nhìn sản phẩm |
| `Docs/life-1/02-decisions/technical-decisions.md` | Quyết định kỹ thuật |
| `openspec/config.yaml` | OpenSpec configuration |
