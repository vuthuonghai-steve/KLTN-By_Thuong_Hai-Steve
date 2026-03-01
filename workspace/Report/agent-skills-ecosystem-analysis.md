# Agent Skills Ecosystem Analysis Report

> **Project:** KLTN - Steve Void Knowledge-Sharing Social Network
> **Date:** 2026-03-01
> **Analysis Focus:** Pipeline Test-2 vs Design Specifications

---

## 📊 Executive Summary

Pipeline tự động Test-2 chỉ tạo được **4/7 stages** (57% completion), bỏ qua hoàn toàn 3 stages cuối (schema, UI specs, wireframes). Chỉ **4/20 skills** (20%) và **2/15 agents** (13.3%) được sử dụng. Output quality của 4 stages đạt được ~85% so với high_quality_example, nhưng skill execution không tuân thủ skill design specification (không đọc knowledge/, loop/, scripts/).

**Root causes chính:**

1. **Critical**: Pipeline được hardcoded thủ công với 4 stages thay vì load 7 stages từ skills.yaml
2. **Critical**: Checkpoint tại Stage 4 khiến pipeline dừng hoàn toàn
3. **Major**: skill-executor không đọc knowledge/resources từ skill folders

---

## 🗺️ Skills/Agents Inventory (Step 1)

### Bảng 1: Tools được sử dụng trong Test-2.txt

| Line | Tool | Skill/Agent | Mục đích |
|:----:|:----:|:-----------:|:--------:|
| 59 | `Skill(pipeline-runner)` | pipeline-runner | Khởi tạo pipeline orchestration |
| 113 | `skill-executor(...)` | flow-design-analyst | Stage 1: Flow diagrams |
| 142 | `skill-executor(...)` | sequence-design-analyst | Stage 2: Sequence diagrams |
| 213 | `skill-executor(...)` | class-diagram-analyst | Stage 3: Class diagrams |
| 252 | `skill-executor(...)` | activity-diagram-design-analyst | Stage 4: Activity diagrams |

### Bảng 2: Skills Inventory

| Trạng thái | Số lượng | Chi tiết |
|:----------:|:--------:|:--------:|
| **Được dùng** | 4/20 (20%) | pipeline-runner, flow-design-analyst, sequence-design-analyst, class-diagram-analyst, activity-diagram-design-analyst |
| **Không được dùng** | 16/20 (80%) | skill-architect, skill-planner, skill-builder, skill-creator, schema-design-analyst, ui-architecture-analyst, ui-pencil-drawer, build-crud-admin-page, error-response-system, api-from-ui, api-integration, task-planner, prompt-improver, typescript-error-explainer, screen-structure-checker |

### Bảng 3: Agents Inventory

| Trạng thái | Số lượng | Chi tiết |
|:----------:|:--------:|:--------:|
| **Được dùng** | 2/15 (13.3%) | pipeline-orchestrator (thông qua pipeline-runner), skill-executor |
| **Không được dùng** | 13/15 (86.7%) | flow-design-analyst, sequence-design-analyst, class-diagram-analyst, activity-diagram-design-analyst, schema-design-analyst, ui-architecture-analyst, ui-architect, ui-pencil-drawer, skill-architect, skill-planner, skill-builder, spec-reviewer, payload-expert |

---

## 🔀 Pipeline Gap: 7 Stages vs 4 Stages Thực Tế (Step 2)

### Bảng so sánh Stage-by-Stage

| Stage | Skill | Trong skills.yaml? | Trong pipeline.yaml test? | Output tồn tại? |
|-------|-------|-------------------|-------------------------|------------------|
| 1 | flow-design-analyst | ✅ | ✅ | ✅ (7 files) |
| 2 | sequence-design-analyst | ✅ | ✅ | ✅ (6 files) |
| 3 | class-diagram-analyst | ✅ | ✅ | ✅ (7 files) |
| 4 | activity-diagram-design-analyst | ✅ | ✅ | ✅ (7 files) |
| **5** | schema-design-analyst | ✅ | ❌ | ❌ **MISSING** |
| **6** | ui-architecture-analyst | ✅ | ❌ | ❌ **MISSING** |
| **7** | ui-pencil-drawer | ✅ | ❌ | ❌ **MISSING** |

### Evidence từ Test-2.txt

**Line 42-53:** Pipeline được tạo thủ công với chỉ 4 stages:

```yaml
stages:
  - id: stage_01
    skill: flow-design-analyst
  - id: stage_02
    skill: sequence-design-analyst
  - id: stage_03
    skill: class-diagram-analyst
  - id: stage_04
    skill: activity-diagram-design-analyst
    checkpoint: true  # ← Dừng ở đây
```

**Line 47:** `checkpoint: true` tại Stage 4 khiến pipeline dừng.

### Danh sách Artifact bị thiếu (so với thủ công)

| Loại | Manual (Docs/life-2/) | Auto (Test/docs/life-2/) | Missing |
|------|----------------------|------------------------|---------|
| **Database Schema** | 13 files (schema-design/*) | 0 files | ❌ |
| **UI Specs** | 8 files (ui/specs/*) | 0 files | ❌ |
| **Wireframes** | 24 files (ui/wireframes/*) | 0 files | ❌ |

**Cụ thể các file bị thiếu:**

- `Docs/life-2/database/schema-design/m1-auth-schema.yaml` → **MISSING**
- `Docs/life-2/database/schema-design/m2-content-schema.yaml` → **MISSING**
- `Docs/life-2/database/schema-design/m3-discovery-schema.yaml` → **MISSING**
- `Docs/life-2/ui/specs/m1-auth-ui-spec.md` → **MISSING**
- `Docs/life-2/ui/wireframes/laptop-sc-m1-01-wireframe.md` → **MISSING**
- (và 30+ files khác tương tự)

---

## 🔍 Skill Quality Audit (Step 3)

### Bảng Quality Score từng Skill

| Skill | Token Usage | Source Citation | Validation Checklist | Knowledge/Loop Được Đọc? | Quality Score |
|-------|-------------|-----------------|---------------------|------------------------|---------------|
| flow-design-analyst | ~95.5k | ✅ FR-ID, UC-ID | ✅ Có | ❌ KHÔNG | **7.5/10** |
| sequence-design-analyst | ~87.8k | ✅ FR-ID | ❌ Không | ❌ KHÔNG | **6.5/10** |
| class-diagram-analyst | ~94.4k | ✅ Dual-format (Mermaid + YAML) | ✅ Trong YAML | ❌ KHÔNG | **8/10** |
| activity-diagram-design-analyst | ~135.2k | ✅ FR-ID | ✅ Có | ❌ KHÔNG | **7.5/10** |

### Evidence: Knowledge/Folder Không Được Đọc

**Grep result:** Không có tool call nào trong Test-2.txt đọc knowledge/ hoặc loop/ files:

```bash
# Tìm kiếm trong Test-2.txt
pattern: "Read.*flow-design-analyst/knowledge|Read.*flow-design-analyst/loop"
result: No matches found
```

**Trong khi skill design yêu cầu:**

- `flow-design-analyst/knowledge/` → 5 files (actor-lane-taxonomy.md, business-flow-patterns.md, etc.)
- `flow-design-analyst/loop/flow-checklist.md` → Validation checklist
- `flow-design-analyst/data/project-registry.json` → FR registry

### So sánh với high_quality_example

| Tiêu chí | high_quality_example | Thực tế (Test-2) | Đạt? |
|----------|---------------------|-------------------|------|
| Source citation rõ ràng | ✅ FR-ID, schema file | ✅ Có FR-ID | ✅ |
| Coverage M1-M6 | ✅ Đầy đủ | ✅ Có | ✅ |
| Validation checklist | ✅ Có | ✅ (Flow, Activity) | ✅ |
| Dual-format | ✅ Mermaid + YAML | ✅ (Class diagrams) | ✅ |
| Knowledge resources | ✅ Đọc từ skill | ❌ Không đọc | ❌ |

---

## ⚡ Root Cause Analysis (Step 4)

### Hypothesis Validation

| Hypothesis | Trạng thái | Evidence |
|-----------|-----------|----------|
| **H1:** Pipeline.yaml được tạo thủ công với 4 stages | ✅ **XÁC NHẬN** | Line 42-53 Test-2.txt tạo pipeline.yaml thủ công, không đọc từ skills.yaml |
| **H2:** skill-executor không đọc SKILL.md đầy đủ | ✅ **XÁC NHẬN** | Không có Read tool call đến knowledge/ hoặc loop/ folders |
| **H3:** Handoff context thiếu pipeline_awareness | ✅ **XÁC NHẬN** | pipeline.yaml không có trường pipeline_awareness |

### Danh sách Root Causes

| ID | Hypothesis | Evidence | Severity | Nhóm |
|----|-----------|----------|----------|------|
| **RC-01** | H1 | Pipeline được tạo tại Test-2.txt line 42-53 (Write .skill-context/uml-generation/pipeline.yaml), hardcoded 4 stages thay vì load 7 stages từ skills.yaml pipelines.uml-generation | **Critical** | Missing Stages |
| **RC-02** | H1 | Line 47 trong pipeline.yaml test: `checkpoint: true` tại Stage 4 khiến pipeline dừng hoàn toàn | **Critical** | Missing Stages |
| **RC-03** | H2 | Grep Test-2.txt: không có tool call nào đọc knowledge/, loop/, hoặc scripts/ từ skill folders. Output vẫn tốt nhờ AI tự xử lý | **Major** | Quality |
| **RC-04** | H3 | pipeline.yaml không có trường `pipeline_awareness`, handoff giữa các stages không truyền context về vị trí trong pipeline | **Major** | Context |

---

## 💡 Key Findings

### Top 3 Phát Hiện Quan Trọng

1. **Pipeline không tự động đọc skills.yaml** — Thay vì load pipeline definition từ `skills.yaml#pipelines.uml-generation`, Claude Code tạo pipeline.yaml thủ công với chỉ 4 stages. Đây là nguyên nhân gốc rễ nhất khiến Stage 5-7 không bao giờ chạy.

2. **Checkpoint tại Stage 4 là hardcoded** — Line 47 trong pipeline.yaml test có `checkpoint: true`, khiến pipeline dừng hoàn toàn sau Stage 4. Checkpoint này không được định nghĩa trong skills.yaml checkpoint config (chỉ có stage_02 và stage_05).

3. **Skill-executor bỏ qua skill resources** — Mặc dù mỗi skill có knowledge/, loop/, scripts/ với dữ liệu quan trọng (FR registry, validation checklists), skill-executor không đọc bất kỳ file nào trong các folders này. Output vẫn tốt nhờ AI tự xử lý, nhưng đây là design smell — skill execution không tuân thủ skill specification.

### Summary Stats

| Metric | Value |
|--------|-------|
| Stages hoàn thành | 4/7 (57%) |
| Skills được dùng | 4/20 (20%) |
| Agents được dùng | 2/15 (13.3%) |
| Output files tạo ra | 27 UML diagrams |
| Output files bị thiếu | 45+ (schema + UI specs + wireframes) |
| Root Causes Critical | 2 |
| Root Causes Major | 2 |

---

## 📋 Recommendations (Future Work)

1. **Fix Pipeline Loading** — Pipeline orchestrator nên load pipeline definition từ skills.yaml thay vì tạo thủ công
2. **Remove Hardcoded Checkpoint** — Checkpoint nên được định nghĩa trong skills.yaml và respected bởi orchestrator
3. **Enforce Skill Resource Loading** — skill-executor nên đọc knowledge/, loop/, scripts/ trước khi execute skill
4. **Add Pipeline Awareness** — Truyền context về vị trí trong pipeline đến mỗi skill execution

---

*Report generated from analysis of Test-2.txt pipeline execution log*
