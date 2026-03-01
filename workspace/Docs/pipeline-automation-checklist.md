# 📋 Pipeline Automation Checklist — UML Documentation Generator

> **File:** `Docs/pipeline-automation-checklist.md`
> **Purpose:** Lộ trình hoàn thiện hệ sinh thái tự động hóa tạo tài liệu UML từ Functional Requirements
> **Date:** 2026-03-01

---

## 1. Bối Cảnh & Vấn Đề

### 1.1. Kết Quả Test Gần Nhất

| Test | Kết quả | Nguyên nhân |
|------|----------|--------------|
| Chạy pipeline với input `/Test/docs/life-1` | **THẤT BẠI** | Không có skill nào được khởi động |

### 1.2. Nguyên Nhân Cốt Lõi

```
❌ Thiếu Entry Point Skill — Không có skill nào handle pipeline initiation
❌ Skill chưa có pipeline frontmatter — Không có contract với orchestrator
❌ Meta-skills (architect/planner/builder) chưa được sync/cập nhật
❌ Thiếu shared context giữa các skills
```

---

## 2. Mục Tiêu Hệ Thống

### 2.1. Input → Output Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    TARGET SYSTEM FLOW                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   USER INPUT (DUY NHẤT)                                       │
│   "Chạy pipeline UML cho dự án X từ tài liệu trong /path"  │
│                         │                                        │
│                         ▼                                        │
│   ┌─────────────────────────────────────────────────────────┐    │
│   │  ORCHESTRATOR (pipeline-runner)                      │    │
│   │  • Đọc input                                         │    │
│   │  • Xác định skills cần chạy                          │    │
│   │  • Spawn sub-agents tuần tự                          │    │
│   │  • Validate output                                    │    │
│   └─────────────────────────┬───────────────────────────────┘    │
│                             │                                    │
│         ┌───────────────────┼───────────────────┐              │
│         ▼                   ▼                   ▼                │
│   ┌───────────┐      ┌───────────┐      ┌───────────┐       │
│   │   Skill   │ ───▶ │   Skill   │ ───▶ │   Skill   │       │
│   │     1     │      │     2     │      │     N     │       │
│   └───────────┘      └───────────┘      └───────────┘       │
│         │                   │                   │                │
│         ▼                   ▼                   ▼                │
│   ┌───────────┐      ┌───────────┐      ┌───────────┐       │
│   │  Output   │      │  Output   │      │  Output   │       │
│   │  Diagram  │      │  Diagram  │      │  Diagram  │       │
│   └───────────┘      └───────────┘      └───────────┘       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2. Input Documents Types

| Loại | Ví dụ | Skill对应 |
|------|--------|-----------|
| **FR Documents** | `feature-map.md`, `requirements.md` | skill-planner → phân tích requirement |
| **Technical Decisions** | `technical-decisions.md` | skill-architect → reference |
| **User Stories** | `user-stories.md` | flow-design-analyst |
| **API Specs** | `api-spec.md` | sequence-design-analyst |

---

## 3. Skills Hiện Tại Trong Hệ Sinh Thái

### 3.1. Meta-Skills (Skill Creation)

| Skill | Vị trí | Chức năng | Trạng thái |
|-------|--------|-----------|-------------|
| `skill-architect` | `.agent/skills/` | Thiết kế kiến trúc skill mới | Cần cập nhật |
| `skill-planner` | `.agent/skills/` | Tạo kế hoạch từ design | Cần cập nhật |
| `skill-builder` | `.agent/skills/` | Build skill từ design+plan | Cần cập nhật |

### 3.2. Domain Skills (UML Generation)

| Skill | Output | Pipeline Stage |
|-------|--------|---------------|
| `flow-design-analyst` | Flow Diagram (Mermaid) | Stage 1 |
| `sequence-design-analyst` | Sequence Diagram (Mermaid) | Stage 2 |
| `class-diagram-analyst` | Class Diagram (Mermaid) | Stage 3 |
| `activity-diagram-design-analyst` | Activity Diagram (Mermaid) | Stage 4 |
| `schema-design-analyst` | ER Diagram + Database Schema | Stage 5 |
| `ui-architecture-analyst` | UI Screen Specifications | Stage 6 |
| `ui-pencil-drawer` | Pencil Wireframes | Stage 7 |

---

## 4. Lộ Trình Triển Khai

### Phase 1: Chuẩn Hóa Meta-Skills

*Thời gian ước tính: 2-3 sessions*

- [x] **1.1** Audit `skill-architect` — Đọc SKILL.md hiện tại, xác định gaps
  - **Gap found:** Thiếu pipeline frontmatter, thiếu validation integration
- [x] **1.2** Audit `skill-planner` — Xem có work với design.md template không
  - **Gap found:** Thiếu pipeline frontmatter
- [x] **1.3** Audit `skill-builder` — Kiểm tra build-log và validation
  - **Gap found:** Thiếu pipeline frontmatter integration
- [x] **1.4** Update cả 3 meta-skills với:
  - [x] Pipeline frontmatter (`pipeline` section)
  - [x] Validation script integration
  - [x] Source citation enforcement

### Phase 2: Chuẩn Hóa Domain Skills

*Thời gian ước tính: 3-4 sessions*

- [x] **2.1** Thêm `pipeline` frontmatter vào `flow-design-analyst`
- [x] **2.2** Thêm `pipeline` frontmatter vào `sequence-design-analyst`
- [x] **2.3** Thêm `pipeline` frontmatter vào `class-diagram-analyst`
- [x] **2.4** Thêm `pipeline` frontmatter vào `activity-diagram-design-analyst`
- [x] **2.5** Thêm `pipeline` frontmatter vào `schema-design-analyst`
- [x] **2.6** Thêm `pipeline` frontmatter vào `ui-architecture-analyst`
- [x] **2.7** Thêm `pipeline` frontmatter vào `ui-pencil-drawer`

### Phase 3: Xây Dựng Orchestrator

*Thời gian ước tính: 2-3 sessions*

- [x] **3.1** Tạo `pipeline-runner` skill (orchestrator)
  - ✅ Created: `.claude/skills/pipeline-runner/SKILL.md`
- [x] **3.2** Tạo `pipeline.yaml` template cho UML pipeline
  - ✅ Created: `.claude/skills/pipeline-runner/templates/pipeline.yaml.template`
- [x] **3.3** Tạo `_queue.json` template
  - ✅ Created: `.claude/skills/pipeline-runner/templates/_queue.json.template`
- [x] **3.4** Tạo `skill-executor` sub-agent definition
  - ✅ Created: `.claude/skills/pipeline-runner/templates/task.json.template`
  - ✅ Created: `.claude/skills/pipeline-runner/loop/checklist.md`

### Phase 4: Tạo Entry Point

*Thời gian ước tính: 1 session*

- [x] **4.1** Tạo custom prompt cho user call:
  ```
  "Chạy pipeline UML từ tài liệu trong {input_path}"
  ```
- [x] **4.2** Định nghĩa entry point:
  - ✅ Created: `.claude/skills/pipeline-runner/ENTRY_POINT.md`
  - ✅ Created: `.skill-context/pipeline-commands.md`

### Phase 5: Test & Iterate

*Thời gian ước tính: 2-3 sessions*

- [x] **5.1** Test với Test/docs/life-1 input
- [x] **5.2** Verify output quality
  - ✅ er-diagram.md created
  - ✅ flow.md created
  - ✅ sequence.md created
- [x] **5.3** Fix issues discovered during testing
  - ✅ Updated pipeline.yaml với 6 stages đầy đủ
  - ✅ Updated _queue.json với tất cả stages
  - ✅ Fixed validation script paths
  - ✅ Added dynamic variables {output_base}
- [x] **5.4** Document known limitations
  - ✅ See Section 5: Known Limitations
- [x] **5.5** Full pipeline execution test
  - ✅ Stage 1-6 completed successfully
  - ✅ Generated 27 UI screens (M1-M6)
  - ✅ All domain skills executed in sequence</parameter>


---

## 5. Known Limitations

### 5.1. Pipeline Execution

| Limitation | Severity | Description | Workaround |
|------------|----------|-------------|------------|
| Manual skill invocation | 🔴 High | Pipeline không tự động chạy - cần user trigger từng skill | Sử dụng pipeline-runner skill để orchestrate |
| No auto-resume | 🟡 Medium | Khi interrupt, pipeline không tự động resume từ checkpoint | Check _queue.json và restart thủ công |
| Blocking validation | 🟡 Medium | Validation fail sẽ block pipeline - không có retry logic tự động | Sửa output rồi re-run |

### 5.2. Skill Integration

| Limitation | Severity | Description | Workaround |
|------------|----------|-------------|------------|
| Missing validation scripts | 🟡 Medium | Một số skills không có validate.py | Thêm scripts/validate.py cho mỗi skill |
| No source citation enforcement | 🟡 Medium | Skills không yêu cầu citation bắt buộc | Thêm rule vào SKILL.md |
| Skill dependency not enforced | 🟢 Low | Không kiểm tra skill tồn tại trước khi gọi | Thêm pre-check trong orchestrator |

### 5.3. Entry Point

| Limitation | Severity | Description | Workaround |
|------------|----------|-------------|------------|
| No natural language trigger | 🔴 High | Claude Code không nhận diện "chạy pipeline" tự động | Sử dụng explicit skill invocation |
| Template variables not resolved | 🟡 Medium | {} variables trong pipeline.yaml chưa được resolve | Sử dụng hard-coded paths hoặc thêm resolver |

### 5.4. Output Quality

| Limitation | Severity | Description | Workaround |
|------------|----------|-------------|------------|
| Partial diagram coverage | 🟡 Medium | ER/Flow/Sequence đơn giản - thiếu chi tiết | Enhance skill prompts |
| No cross-validation | 🟢 Low | Không kiểm tra consistency giữa các diagrams | Thêm cross-reference validation |

### 5.5. Recommendations for Future

```
## Priority Improvements

🔴 HIGH PRIORITY:
1. Tích hợp pipeline-runner vào Claude Code invocation
2. Thêm auto-resume từ _queue.json
3. Tạo entry point command

🟡 MEDIUM PRIORITY:
4. Thêm validation scripts cho tất cả skills
5. Implement source citation enforcement
6. Thêm retry logic với exponential backoff

🟢 LOW PRIORITY:
7. Cross-validation giữa diagrams
8. Quality gates với configurable thresholds
9. Dashboard với real-time progress
```

---

## 6. Pipeline Frontmatter Schema

Mỗi skill cần có section này trong SKILL.md:

```yaml
---
name: {skill_name}
description: ...
pipeline:
  # Contract với orchestrator
  stage_order: {1-10}
  input_contract:
    - type: {file|directory}
      path: "{input_path_pattern}"
      required: {true|false}
  output_contract:
    - type: {file|directory}
      path: "{output_path_pattern}"
      format: {markdown|mermaid|yaml|json}
  validation:
    script: "{script_path}"
    expected_exit_code: 0
  successor_hints:
    - skill: {next_skill_name}
      needs: [{artifact_1}, {artifact_2}]
---
```

---

---

## 7. Custom Prompt Cho User

### 7.1. Entry Point Format

```
# Format prompt để khởi động pipeline

"Chạy UML pipeline cho dự án {project_name} từ tài liệu trong {input_path}"

Ví dụ:
"Chạy UML pipeline cho Steve Void từ tài liệu trong Test/docs/life-1"
```

### 7.2. Pipeline Runner Skill Trigger

```markdown
# Khi user prompt như trên, hệ thống sẽ:

1. Nhận diện intent: "chạy UML pipeline"
2. Trích xuất {input_path} từ prompt
3. Khởi động pipeline-runner với input đó
4. Tự động execute through các stages
5. Output kết quả vào thư mục được chỉ định
```

---

## 8. Tài Liệu Tham Khảo

| File | Mục đích |
|------|----------|
| `DESIGN.md` | Kiến trúc tổng thể Dynamic Variables |
| `.skill-context/arc-1.md` | Pipeline-runner design chi tiết |
| `.claude/CLAUDE_ADVANCED_GUIDE.md` | Claude Code features |
| `.claude/PROMPTS_HOOKS_SUMMARY.md` | Hooks & prompts |

---

## 9. Ghi Chú

- **Tiêu chí đánh dấu [x]:** Chỉ khi task thực sự hoàn thành và tested
- **Checkpoint:** Sau mỗi phase, verify lại hệ thống có hoạt động không trước khi tiếp tục
- **Rollback:** Nếu test fail, document lỗi và quay lại fix trước khi tiếp tục

---

*Cập nhật: 2026-03-01*
