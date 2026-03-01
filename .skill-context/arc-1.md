# TỰ ĐỘNG HÓA QUY TRÌNH TẠO TÀI LIỆU UML
### Hướng dẫn kiến trúc Pipeline-Runner với Claude Code Sub-Agents

> **Tác giả:** Vũ Văn Đạo | **Ngày:** 2026-03-01 | **Phiên bản:** v1.0  
> Tổng hợp từ phiên thiết kế với Claude — altuvi.com

---

## MỤC LỤC

1. [Bối cảnh và vấn đề](#phần-1-bối-cảnh-và-vấn-đề)
2. [Giải pháp — Kiến trúc Pipeline-Runner](#phần-2-giải-pháp--kiến-trúc-pipeline-runner)
3. [Chi tiết các thành phần](#phần-3-chi-tiết-các-thành-phần)
4. [Cơ chế hoạt động](#phần-4-cơ-chế-hoạt-động)
5. [Các quyết định thiết kế](#phần-5-các-quyết-định-thiết-kế-quan-trọng)
6. [Kỹ thuật Sub-agent Claude Code](#phần-6-kỹ-thuật-sub-agent-trong-claude-code)
7. [Lộ trình triển khai](#phần-7-lộ-trình-triển-khai)
8. [Kết nối mục tiêu dài hạn](#phần-8-kết-nối-với-mục-tiêu-dài-hạn)

---

## PHẦN 1: BỐI CẢNH VÀ VẤN ĐỀ

### 1.1. Hệ thống Skill hiện tại

Bộ skill UML documentation được xây dựng dựa trên kiến trúc **7-Zone** với 3 meta-skill điều phối:

| # | Tên Skill | Input | Output |
|---|-----------|-------|--------|
| 1 | `skill-architect` | Ý tưởng + tài liệu tham khảo | `design.md` (kiến trúc) |
| 2 | `skill-planner` | `design.md` | `todo.md` (kế hoạch) |
| 3 | `skill-builder` | `design.md` + `todo.md` | Skill package hoàn chỉnh |

Các domain skill được build ra tạo thành pipeline:

```
flow-design-analyst
  → sequence-design-analyst
    → class-diagram-analyst
      → activity-diagram-design-analyst
        → schema-design-analyst
          → ui-architecture-analyst
            → ui-pencil-drawer
```

### 1.2. Điểm nghẽn — Vấn đề cần giải quyết

```
HIỆN TẠI (thủ công):
Input Doc → [Skill 1] → (người dùng prompt) → [Skill 2] → (người dùng prompt) → ... → Output

MỤC TIÊU (tự động):
Input Doc → [Orchestrator] → Skill 1 → Skill 2 → ... → Schema + Wireframe
                ↑___________________________________|
                         (tự động loop qua file system)
```

**3 vấn đề cốt lõi cần giải quyết:**

1. **Thiếu Orchestration Layer** — không có gì tự động kích hoạt skill tiếp theo
2. **Không có quality gate** — không biết skill đã thực sự hoàn thành đúng chưa
3. **Context window overflow** — chạy nhiều skill liên tiếp làm tràn context

---

## PHẦN 2: GIẢI PHÁP — KIẾN TRÚC PIPELINE-RUNNER

### 2.1. Nguyên lý cốt lõi: Sub-agent + Shared Memory

**Insight then chốt:** Claude Code cho phép spawn sub-agent với context window riêng biệt (~200K tokens mỗi agent). Mỗi sub-agent chạy độc lập, kết thúc rồi mới chuyển sang agent tiếp theo. Giao tiếp giữa các agents hoàn toàn qua file system — đây là giải pháp cho cả 3 vấn đề:

| Vấn đề | Giải pháp | Cơ chế |
|--------|-----------|--------|
| Không có orchestration | Pipeline-runner skill | Đọc `pipeline.yaml`, spawn sub-agents tuần tự |
| Quality gate mơ hồ | Completion Signal + `validation_script` | Script verify output trước khi ghi `COMPLETED` |
| Context overflow | Sub-agent isolation | Mỗi skill có context riêng, bị hủy sau khi xong |

### 2.2. Kiến trúc tổng thể

```
MAIN AGENT (pipeline-runner)
│   Context: chỉ giữ pipeline.yaml + _queue.json → luôn nhỏ gọn
│
├── spawn sub-agent: flow-design-analyst
│       Context riêng: SKILL.md + knowledge/ + input docs
│       Làm xong → ghi output → context bị hủy
│       → ghi _queue.json: stage_01 = COMPLETED
│
├── spawn sub-agent: sequence-design-analyst
│       Context riêng: SKILL.md + flow/index.md (từ stage trước)
│       Làm xong → ghi output → context bị hủy
│       → ghi _queue.json: stage_02 = COMPLETED
│
└── ... tiếp tục đến skill cuối cùng
```

### 2.3. Cấu trúc thư mục

```
{project_root}/
├── .skill-context/              ← SHARED MEMORY (sống xuyên suốt pipeline)
│   ├── pipeline.yaml            ← Định nghĩa thứ tự và dependency
│   ├── _queue.json              ← Runtime state (ai đang chạy, ai xong)
│   └── {project}/
│       ├── tasks/               ← Input spec cho từng skill
│       │   ├── task-001.json
│       │   └── task-002.json
│       └── results/             ← Output từ từng skill
│           ├── result-001.json
│           └── result-002.json
│
└── .claude/agents/              ← Sub-agent definitions
    └── skill-executor.md        ← Định nghĩa sub-agent executor
```

---

## PHẦN 3: CHI TIẾT CÁC THÀNH PHẦN

### 3.1. `pipeline.yaml` — Single source of truth cho ORDER

File này định nghĩa thứ tự chạy và dependency giữa các stages. Thiết kế **DAG-ready** ngay từ đầu để sau này có thể chạy parallel mà không cần refactor schema:

```yaml
# .skill-context/pipeline.yaml
pipeline_name: uml-documentation
project: life-2
version: 1.0

stages:
  - id: stage_01
    skill: flow-design-analyst
    depends_on: []
    completion_criteria:
      required_outputs:
        - "Docs/life-2/diagrams/flow/index.md"
      validation_script: "scripts/flow_lint.py"
      lint_exit_code: 0

  - id: stage_02
    skill: sequence-design-analyst
    depends_on: [stage_01]
    completion_criteria:
      required_outputs:
        - "Docs/life-2/diagrams/sequence/index.md"
      validation_script: "scripts/validate_syntax.py"

  - id: stage_03
    skill: class-diagram-analyst
    depends_on: [stage_02]
    # ... tiếp tục
```

> **Nguyên tắc thiết kế — Tách biệt 2 trách nhiệm:**
> - `pipeline.yaml` → kiểm soát **ORDER** (bạn thay đổi một file duy nhất)
> - `SKILL.md` → khai báo **CONTRACT** (input/output/validation của skill đó)

### 3.2. `_queue.json` — Runtime state

File này là bộ nhớ sống của pipeline. Bất kỳ lúc nào cũng biết chính xác pipeline đang ở đâu, ai đang chạy, ai đã xong, ai đang lỗi:

```json
{
  "pipeline_id": "pipe-20260301-001",
  "pipeline_name": "uml-documentation",
  "started_at": "2026-03-01T08:00:00+07:00",
  "stages": {
    "stage_01": {
      "skill": "flow-design-analyst",
      "status": "COMPLETED",
      "completed_at": "2026-03-01T08:15:00+07:00",
      "output_verified": true,
      "output_path": "Docs/life-2/diagrams/flow/"
    },
    "stage_02": {
      "skill": "sequence-design-analyst",
      "status": "IN_PROGRESS",
      "started_at": "2026-03-01T08:16:00+07:00"
    },
    "stage_03": {
      "skill": "class-diagram-analyst",
      "status": "PENDING"
    }
  }
}
```

**Các trạng thái có thể nhận:**

| Status | Ý nghĩa | Hành động tiếp theo |
|--------|---------|---------------------|
| `PENDING` | Chưa bắt đầu, chờ dependency | Chờ stage trước `COMPLETED` |
| `IN_PROGRESS` | Sub-agent đang chạy | Chờ sub-agent trả về kết quả |
| `COMPLETED` | Xong và đã verify | Kích hoạt stage tiếp theo |
| `FAILED` | Lỗi validation hoặc runtime | Halt + báo cáo lỗi chi tiết |
| `SKIPPED` | Bị bỏ qua (manual override) | Tiếp tục stage kế tiếp |

### 3.3. `SKILL.md` frontmatter — Contract declaration

Thêm `pipeline` section vào SKILL.md của mỗi skill để khai báo contract. Đây là thứ pipeline-runner đọc để biết cần verify gì trước khi chuyển stage:

```yaml
---
name: flow-design-analyst
pipeline:
  input_contract: []
  output_contract:
    - path: Docs/life-2/diagrams/flow/index.md
      required: true
    - path: "Docs/life-2/diagrams/flow/flow-*.md"
      min_count: 1
  validation_script: scripts/flow_lint.py
  next_stage_hint: sequence-design-analyst
---

# flow-design-analyst SKILL
...
```

### 3.4. `skill-executor` sub-agent

Sub-agent này là executor chung cho mọi domain skill. Nó không chứa logic nghiệp vụ — chỉ biết: đọc task spec, kích hoạt đúng skill, và báo cáo kết quả:

```markdown
# .claude/agents/skill-executor.md
---
name: skill-executor
description: >
  Execute a specific UML skill with isolated context.
  Use when pipeline-runner delegates a skill task.
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
permissionMode: acceptEdits
---

You are a skill executor agent with an isolated context window.

## Protocol
1. Read task specification from .skill-context/tasks/{task_id}.json
2. Load the designated SKILL.md file
3. Execute all phases of the skill as instructed
4. Run validation_script if specified in SKILL.md frontmatter
5. Write result to .skill-context/results/{task_id}.json
6. Report completion status clearly

## Completion Signal
Always end with a structured YAML block:

execution_result:
  task_id: {task_id}
  skill: {skill_name}
  status: COMPLETED | FAILED
  output_paths: [...]
  validation: PASS | FAIL
  error: null | {error_message}
```

---

## PHẦN 4: CƠ CHẾ HOẠT ĐỘNG

### 4.1. Luồng chạy hoàn chỉnh

```
BƯỚC 1: Khởi động pipeline
  User → pipeline-runner: "Run UML pipeline for project life-2"
  Runner đọc pipeline.yaml → xác định stage thứ tự
  Runner tạo _queue.json với tất cả stages = PENDING

BƯỚC 2: Vòng lặp execution
  Runner tìm stage PENDING có đủ dependencies COMPLETED
  → Tạo task spec: .skill-context/tasks/task-{id}.json
  → Cập nhật _queue.json: stage = IN_PROGRESS
  → Spawn skill-executor sub-agent (context riêng biệt)

BƯỚC 3: Sub-agent execution (isolated)
  skill-executor đọc task spec
  → Load SKILL.md của domain skill
  → Chạy tất cả phases của skill
  → Chạy validation_script
  → Ghi kết quả vào .skill-context/results/
  → Trả về completion signal cho main agent
  → Context bị hủy (giải phóng memory)

BƯỚC 4: Post-execution check
  Runner nhận completion signal từ sub-agent
  → Nếu PASS: cập nhật _queue.json = COMPLETED
  → Tìm stage tiếp theo có đủ dependencies
  → Nếu FAIL: cập nhật = FAILED, Halt + report

BƯỚC 5: Kết thúc
  Tất cả stages COMPLETED → Pipeline done
  Runner tạo final summary report
```

### 4.2. Error Handling và Rollback

Khi một stage fail, pipeline dừng lại và báo cáo chi tiết thay vì tiếp tục với dữ liệu sai:

```json
{
  "stage_02": {
    "skill": "sequence-design-analyst",
    "status": "FAILED",
    "error": {
      "type": "VALIDATION_FAIL",
      "message": "Missing UC-15 definition in flow diagrams",
      "lint_output": "sequence_lint.py: 3 errors found",
      "retry_count": 1
    }
  }
}
```

**Khi resume sau khi fix lỗi**, pipeline tự động bỏ qua các stages đã `COMPLETED`:

1. Runner đọc `_queue.json`
2. Tìm stage `FAILED` đầu tiên → đặt lại thành `PENDING`
3. Tất cả stages sau stage đó → đặt lại `PENDING`
4. Các stages trước → giữ nguyên `COMPLETED`
5. Chạy lại từ điểm fail

---

## PHẦN 5: CÁC QUYẾT ĐỊNH THIẾT KẾ QUAN TRỌNG

### 5.1. Meta-skill vs CLI Headless

| | Meta-skill (Approach A) ✅ | CLI Headless (Approach B) |
|-|--------------------------|--------------------------|
| **Ưu điểm** | Quan sát được quá trình, có thể hỏi user khi cần | Isolation tuyệt đối, không context bleed |
| **Nhược điểm** | Main context vẫn tăng (nhưng ít hơn) | Khó debug, không có conversational feedback |
| **Phù hợp khi** | Domain knowledge đang xây dựng, cần observe | Pipeline stable, output đã được validate kỹ |
| **Quyết định** | → **Dùng cho v1** | → Nâng cấp sau khi pipeline stable |

### 5.2. Centralized vs Distributed State

| | Centralized `_queue.json` ✅ | Distributed (mỗi skill tự quản) |
|-|-----------------------------|---------------------------------|
| **Ưu điểm** | Visibility toàn pipeline, dễ resume sau lỗi | Loose coupling, mỗi skill độc lập hơn |
| **Nhược điểm** | Single point of failure nếu file corrupt | Khi fail, không ai biết pipeline ở đâu |
| **Quyết định** | → **Centralized cho 7-stage pipeline** | Không phù hợp với use case này |

### 5.3. Static Sequence vs Auto-discovered DAG

| | Static `pipeline.yaml` ✅ | Auto DAG từ SKILL.md metadata |
|-|--------------------------|-------------------------------|
| **ORDER** | Một file duy nhất để thay đổi | Phải sửa nhiều SKILL.md, dễ conflict |
| **CONTRACT** | Trong SKILL.md frontmatter | Trong SKILL.md frontmatter |
| **Quyết định** | → `pipeline.yaml` quản lý **ORDER** | → SKILL.md chỉ khai báo **CONTRACT** |

> **Kết luận thiết kế — Kết hợp tốt nhất của cả hai:**
> - `pipeline.yaml` → ORDER (ai trước ai sau, dependency graph)
> - `SKILL.md` → CONTRACT (input cần gì, output là gì, verify bằng script nào)

---

## PHẦN 6: KỸ THUẬT SUB-AGENT TRONG CLAUDE CODE

### 6.1. Cơ chế Sub-agent

Claude Code spawn sub-agent thông qua **Task tool** nội bộ. Mỗi sub-agent:

- Có context window riêng biệt (~200K tokens)
- Nhận system prompt từ file definition trong `.claude/agents/`
- Chỉ nhận prompt ngắn khi được invoke (không nhận full context của main agent)
- **Không thể spawn sub-agent khác** (không có nested delegation)
- Kết quả trả về là một message duy nhất cho main agent
- Context bị hủy sau khi hoàn thành

### 6.2. Truyền Context qua File — Pattern chính thức

Đây là pattern Anthropic khuyến nghị cho multi-agent pipeline:

```
Main agent → Write task spec vào .skill-context/tasks/task-{id}.json
           → Invoke sub-agent với prompt ngắn: "Read task from tasks/task-001.json"

Sub-agent  → Đọc .skill-context/tasks/task-{id}.json (full data từ disk)
           → Xử lý trong isolated context (không pollute main context)
           → Ghi kết quả vào .skill-context/results/result-{id}.json
           → Trả về completion summary ngắn gọn cho main agent

Main agent → Đọc status từ summary (không cần đọc toàn bộ result)
           → Cập nhật _queue.json
           → Tiếp tục stage tiếp theo
```

> **Quy tắc vàng:** Không bao giờ truyền data lớn qua prompt/context giữa agents.  
> Luôn dùng file system. Sub-agent chỉ nhận pointer đến file, không nhận data trực tiếp.

### 6.3. Context Management

| Cơ chế | Cách dùng | Khi nào dùng |
|--------|-----------|--------------|
| Sub-agent isolation | Spawn executor cho mỗi skill | **LUÔN LUÔN** — đây là giải pháp chính |
| `/compact [hint]` | Nén conversation history 50-70% | Khi main agent context tăng nhiều |
| `/clear` | Xóa hoàn toàn history, giữ CLAUDE.md | Khi bắt đầu pipeline mới |
| `CLAUDE.md` | Persist instructions qua sessions | Pipeline-runner rules, routing conventions |

### 6.4. Task spec format — Giao tiếp giữa runner và executor

```json
// .skill-context/tasks/task-001.json
{
  "task_id": "task-001",
  "stage_id": "stage_01",
  "skill_name": "flow-design-analyst",
  "skill_path": ".agent/skills/flow-design-analyst/SKILL.md",
  "input": {
    "project": "life-2",
    "source_docs": [
      "Docs/life-2/specs/requirements.md",
      "Docs/life-2/diagrams/UseCase/"
    ]
  },
  "output": {
    "target_dir": "Docs/life-2/diagrams/flow/",
    "index_file": "Docs/life-2/diagrams/flow/index.md"
  },
  "validation": {
    "script": "scripts/flow_lint.py",
    "expected_exit_code": 0
  }
}
```

---

## PHẦN 7: LỘ TRÌNH TRIỂN KHAI

### 7.1. Các bước build pipeline-runner

Dùng chính bộ meta-skill (`skill-architect → skill-planner → skill-builder`) để build pipeline-runner:

1. **Chuẩn bị brief file** cho `skill-architect`:
   - Tạo `.skill-context/pipeline-runner/resources/pipeline-runner-brief.md`
   - Mô tả: Skill điều phối pipeline, spawn sub-agents, quản lý `_queue.json`
   - Input: `pipeline.yaml` + `_queue.json`
   - Output: tự động execute toàn pipeline

2. **Chạy `skill-architect`** → sinh `design.md` cho pipeline-runner

3. **Chạy `skill-planner`** → sinh `todo.md`

4. **Chạy `skill-builder`** → sinh `SKILL.md` hoàn chỉnh

5. **Thêm `pipeline` frontmatter** vào SKILL.md của mỗi domain skill hiện có

6. **Tạo** `.claude/agents/skill-executor.md`

7. **Tạo** `pipeline.yaml` cho project life-2

8. **Test** với một stage đơn trước, sau đó mở rộng dần

### 7.2. Phiên bản và lộ trình nâng cấp

| Version | Tính năng chính | Trigger mechanism | Trạng thái |
|---------|----------------|-------------------|------------|
| **v1.0** | Sequential pipeline, centralized queue, halt-on-error | Meta-skill (in-conversation) | → **BUILD NOW** |
| **v1.5** | Resume sau lỗi, retry logic, better reporting | Meta-skill + SubagentStop hooks | Sau khi v1 stable |
| **v2.0** | Parallel stages (DAG), multi-pipeline support | CLI Headless option | Tương lai |

### 7.3. Điều kiện để nâng cấp lên v2.0

- Pipeline chạy ổn định qua ít nhất 10 lần không cần can thiệp thủ công
- Tất cả `validation_script` có độ chính xác > 90%
- Domain knowledge đủ để tự đánh giá output quality
- Có ít nhất 2 pipeline khác nhau (life-2 design + life-3 implementation)

---

## PHẦN 8: KẾT NỐI VỚI MỤC TIÊU DÀI HẠN

### 8.1. Giá trị thương mại

Pipeline-runner không chỉ giải quyết bài toán cá nhân — nó là **sản phẩm có thể đóng gói**:

- **Target user:** Junior developers và sinh viên thiếu kinh nghiệm nghiệp vụ
- **Pain point giải quyết:** Không biết cách tạo tài liệu kiến trúc trước khi code
- **Differentiator:** Không phải AI viết code — AI tạo ra documentation architecture trước code
- **Lộ trình:** KLTN (proof of concept) → Template tái sử dụng → SaaS tool

### 8.2. Lộ trình thương mại hóa

1. Hoàn thiện pipeline cho project life-2 (KLTN) — proof of concept
2. Đóng gói thành template có thể apply cho bất kỳ dự án web app nào
3. Viết hướng dẫn sử dụng cho người không có nền tảng kỹ thuật sâu
4. Target: junior devs và sinh viên CNTT năm 3-4

### 8.3. Rủi ro cần chú ý

> **Cảnh báo từ phân tích lá số (Địa Không tại Mệnh):**  
> Tránh bẫy "build tool xong bỏ đó". Hệ thống này chỉ có giá trị khi được sử dụng  
> thực tế và tinh chỉnh liên tục qua từng dự án thực.

**Rủi ro kỹ thuật cụ thể:**

- `validation_script` chưa đủ tiêu chí → quality gate không có ý nghĩa
- Pipeline.yaml cứng nhắc → khó adapt khi dự án thay đổi scope
- Sub-agent executor quá generic → output thiếu domain-specific quality

---

## PHỤ LỤC: Quick Reference

### Checklist trước khi chạy pipeline

- [ ] `pipeline.yaml` đã có đủ tất cả stages
- [ ] Mỗi SKILL.md đã có `pipeline` frontmatter
- [ ] `validation_script` của mỗi skill đã test và hoạt động
- [ ] `.claude/agents/skill-executor.md` đã tạo
- [ ] `.skill-context/` directory đã tồn tại
- [ ] Input documents cho stage đầu tiên đã sẵn sàng

### Commands thường dùng

```bash
# Khởi động pipeline mới
# → prompt pipeline-runner: "Run UML pipeline for life-2"

# Resume sau khi fix lỗi
# → prompt pipeline-runner: "Resume pipeline from failed stage"

# Check trạng thái
cat .skill-context/_queue.json | python -m json.tool

# Reset một stage cụ thể
# → sửa _queue.json: đặt stage cần chạy lại thành PENDING
```

### File naming conventions

```
.skill-context/
├── tasks/task-{stage_id}-{timestamp}.json
├── results/result-{stage_id}-{timestamp}.json
└── logs/log-{pipeline_id}.txt
```

---

*Tài liệu này được tổng hợp từ phiên làm việc thiết kế hệ thống với Claude — 2026-03-01*  
*Cập nhật khi có thay đổi kiến trúc quan trọng.*