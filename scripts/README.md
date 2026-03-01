# Claude Code Pipeline Runner

Hệ thống tự động hóa workflow cho Life-2 (Design & Specification phase).

## Tổng Quan

Pipeline Runner cho phép tự động chạy chuỗi các skill (flow-design, sequence-design, class-diagram,...) theo thứ tự được định nghĩa trong pipeline configuration.

```
Input (FR/Requirements) → [Skill 1] → [Skill 2] → [Skill 3] → Output (Life-2 deliverables)
```

## Cài Đặt

### Cách 1: Sử dụng Setup Script

```bash
# Chạy setup script
bash scripts/setup.sh
```

### Cách 2: Sử dụng Package (cho dự án mới)

```bash
# Giải nén package
unzip claude-pipeline-setup.zip

# Chạy setup
cd claude-pipeline-setup
bash setup.sh
```

## Cấu Trúc Thư Mục

```
.claude/
├── settings.json        # Cấu hình hooks
└── hooks/
    ├── subagent-start.sh   # Hook khi subagent bắt đầu
    └── subagent-stop.sh    # Hook khi subagent kết thúc

.skill-context/
├── skills/            # Tất cả skill được đóng gói
├── logs/              # Pipeline logs
├── results/           # Kết quả từ mỗi stage
├── shared/            # Shared state giữa các stage
├── pipelines/         # Pipeline configuration files
└── templates/         # Templates cho pipeline

scripts/
├── setup.sh           # Script setup chính
├── package.sh        # Script đóng gói
└── README.md         # Hướng dẫn sử dụng
```

## Cách Sử Dụng

### 1. Tạo Pipeline Configuration

```bash
# Copy template
cp .skill-context/templates/pipeline-template.yaml .skill-context/pipelines/my-pipeline.yaml

# Chỉnh sửa pipeline.yaml theo nhu cầu
```

### 2. Cấu Hình Pipeline

Xem file `pipeline-template.yaml` để biết các tùy chọn:

```yaml
name: "my-pipeline"
version: "1.0"
description: "My custom pipeline"

stages:
  - id: stage_01
    skill: flow-design-analyst
    depends_on: []
    input: .skill-context/tasks/stage_01_input.json
    output_path: Docs/life-2/diagrams/flow/

execution:
  mode: sequential  # sequential | parallel
  max_retries: 2
  continue_on_error: false
```

### 3. Chạy Pipeline

Sau khi restart Claude Code, hệ thống sẽ tự động:
- Log khi subagent bắt đầu (`SubagentStart` hook)
- Log khi subagent kết thúc (`SubagentStop` hook)
- Lưu kết quả vào `.skill-context/results/`
- Cập nhật progress vào `.skill-context/shared/progress.md`

## Các Skill Được Hỗ Trợ

### Design Skills (Analysis)

| Skill | Mô Tả |
|-------|-------|
| `flow-design-analyst` | Thiết kế Business Process Flow Diagram (3-lane Swimlane) |
| `sequence-design-analyst` | Thiết kế Sequence Diagram (UML Mermaid) |
| `class-diagram-analyst` | Thiết kế Class Diagram (Dual-format: Mermaid + YAML Contract) |
| `activity-diagram-design-analyst` | Thiết kế Activity Diagram (Clean Architecture B-U-E) |
| `schema-design-analyst` | Thiết kế Database Schema (PayloadCMS/MongoDB) |
| `ui-architecture-analyst` | Phân tích UI Architecture (Schema → Screens) |
| `ui-pencil-drawer` | Vẽ UI Wireframes trong Pencil canvas |

### Meta Skills (Skill Development)

| Skill | Mô Tả |
|-------|-------|
| `skill-architect` | Thiết kế kiến trúc Agent Skill mới |
| `skill-builder` | Triển khai Agent Skill từ design.md |
| `skill-planner` | Lập kế hoạch triển khai chi tiết (todo.md) |
| `master-skill` | Orchestrate end-to-end skill delivery |

### Pipeline Skills

Skills trong `.skill-context/skills/` được đóng gói và sẵn sàng sử dụng khi cài đặt package.

## Templates

### Pipeline Template

Xem `.skill-context/templates/pipeline-template.yaml` để biết cấu trúc đầy đủ.

### Queue Template

Xem `.skill-context/templates/_queue-template.json` để biết cấu trúc queue.

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

### Logs không được tạo

Kiểm tra thư mục `.skill-context/logs/` có tồn tại không.

## Giấy Phép

MIT License
