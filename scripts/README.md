# Steve Void Project Setup

Hệ thống quản lý và cài đặt Claude Code cho dự án **NeoSocial - Knowledge Sharing Social Network**.

## Tổng Quan

Steve Void là dự án khóa luận tốt nghiệp - một mạng xã hội chia sẻ kiến thức cho cộng đồng developer/tech Việt Nam.

**Giai đoạn hiện tại:** Life-2 (Design & Specification)

## Cài Đặt

### Cách 1: Chạy Setup Script (dự án hiện tại)

```bash
bash scripts/setup.sh
```

### Cách 2: Sử dụng Package (cho dự án mới)

```bash
# Giải nén package
unzip scripts/steve-void-setup.zip

# Chạy setup
cd steve-void-setup
bash setup.sh
```

## Cấu Trúc Thư Mục

```
KLTN/
├── Docs/
│   ├── life-1/           # Vision, research, technical decisions
│   ├── life-2/           # Specifications, diagrams, DB schema
│   │   ├── specs/        # Module specs (M1-M6)
│   │   ├── database/     # Schema design
│   │   ├── api/          # API specifications
│   │   ├── diagrams/     # UML diagrams
│   │   └── ui/           # Wireframes
│   ├── life-3/           # Implementation (sẽ bắt đầu)
│   └── life-4/           # Verification
│
├── .claude/
│   ├── settings.json      # Claude Code configuration
│   ├── hooks/            # Hook scripts
│   │   ├── pre-write-check.sh
│   │   ├── session-end.sh
│   │   ├── subagent-start.sh
│   │   └── subagent-stop.sh
│   ├── rules/            # Claude Code rules
│   │   ├── lifecycle.md
│   │   ├── payload-conventions.md
│   │   ├── spec-first.md
│   │   └── ui-stack.md
│   └── memory/           # Session memory
│
├── .agent/
│   └── skills/           # All agent skills (canonical source)
│
└── scripts/
    ├── setup.sh          # Main setup script
    ├── package.sh        # Package creation script
    └── README.md         # This file
```

## Các Skills Được Cài Đặt

### Design & Specification (Life-2)

| Skill | Mô Tả |
|-------|-------|
| `flow-design-analyst` | Thiết kế Business Process Flow Diagram (3-lane Swimlane) |
| `sequence-design-analyst` | Thiết kế Sequence Diagram (UML Mermaid) |
| `class-diagram-analyst` | Thiết kế Class Diagram (Dual-format: Mermaid + YAML Contract) |
| `activity-diagram-design-analyst` | Thiết kế Activity Diagram (Clean Architecture B-U-E) |
| `schema-design-analyst` | Thiết kế Database Schema (PayloadCMS/MongoDB) |
| `ui-architecture-analyst` | Phân tích UI Architecture (Schema → Screens) |
| `ui-pencil-drawer` | Vẽ UI Wireframes trong Pencil canvas |

### Implementation (Life-3)

| Skill | Mô Tả |
|-------|-------|
| `build-crud-admin-page` | Xây dựng trang admin CRUD cho PayloadCMS |
| `error-response-system` | Hệ thống chuẩn hóa error response |
| `api-from-ui` | Xây dựng custom API từ UI |
| `api-integration` | Tích hợp API backend vào frontend |
| `screen-structure-checker` | Kiểm tra cấu trúc thư mục screens |

### Skill Development

| Skill | Mô Tả |
|-------|-------|
| `skill-architect` | Thiết kế kiến trúc Agent Skill mới |
| `skill-builder` | Triển khai Agent Skill từ design.md |
| `skill-planner` | Lập kế hoạch triển khai chi tiết (todo.md) |
| `skill-creator` | Hướng dẫn tạo skill mới |

### OpenSpec Workflow

| Skill | Mô Tả |
|-------|-------|
| `openspec-new-change` | Tạo change mới với artifacts |
| `openspec-apply-change` | Triển khai tasks từ change |
| `openspec-verify-change` | Xác minh implementation vs spec |
| `openspec-archive-change` | Lưu trữ completed change |
| `openspec-sync-specs` | Đồng bộ specs từ change |

### Utilities

| Skill | Mô Tả |
|-------|-------|
| `task-planner` | Phân tách requirement thành tasks |
| `prompt-improver` | Cải thiện và tối ưu prompt |
| `typescript-error-explainer` | Giải thích lỗi TypeScript |
| `latex-report-specialist` | Hỗ trợ viết báo cáo LaTeX |

## Sử Dụng Skills

Gọi skill bằng lệnh `/skill-name`:

```bash
# Design skills
/flow-design-analyst
/sequence-design-analyst
/class-diagram-analyst

# Implementation skills
/payload
/build-crud-admin-page
/api-from-ui

# Meta skills
/skill-architect
/task-planner
```

## Life-2 Modules (Specs)

| Module | Spec File | Coverage |
|--------|-----------|----------|
| M1 | `m1-auth-profile-spec.md` | Authentication & Profile |
| M2 | `m2-content-engine-spec.md` | Posts (create/edit/delete) |
| M3 | `m3-discovery-feed-spec.md` | News Feed (ranking algorithm) |
| M4 | `m4-engagement-spec.md` | Likes, Comments, Connections |
| M5 | `m5-bookmarking-spec.md` | Collections & Bookmarks |
| M6 | `m6-notifications-moderation-spec.md` | SSE Notifications, Reports |

## Công Nghệ Sử Dụng

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 15 + React 19 |
| Backend | Payload CMS 3.x |
| Database | MongoDB Atlas |
| Styling | Tailwind CSS v4 + Radix UI |
| State | Redux Toolkit |

## Giải Quyết Sự Cố

### Hook không hoạt động

1. Kiểm tra settings.json có hợp lệ không:
   ```bash
   jq . .claude/settings.json
   ```

2. Kiểm tra hook scripts có quyền thực thi không:
   ```bash
   ls -la .claude/hooks/*.sh
   ```

3. Restart Claude Code để load hooks mới.

### Skills không hoạt động

Kiểm tra skills đã được cài đặt đúng:
```bash
ls -la .agent/skills/
```

## License

MIT
