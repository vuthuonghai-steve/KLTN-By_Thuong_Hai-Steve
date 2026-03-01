# pipeline-runner — Implementation Plan

## 1. Pre-requisites

| # | Tài liệu / Kiến thức | Tier | Mục đích | Trace | Status |
|---|---------------------|------|-----------|-------|--------|
| 1 | Claude Code Task tool docs | Technical | Hiểu sub-agent execution | [TỪ DESIGN §5] | ✅ |
| 2 | YAML parsing library | Technical | Parse pipeline.yaml | [TỪ DESIGN §3] | ✅ |

## 2. Phase Breakdown

### Phase 0: Core Structure
- [ ] Tạo `.claude/skills/pipeline-runner/SKILL.md` với execution logic [TỪ DESIGN §3]
- [ ] Tạo thư mục `.claude/skills/pipeline-runner/scripts/` [TỪ DESIGN §3]
- [ ] Tạo thư mục `.claude/skills/pipeline-runner/templates/` [TỪ DESIGN §3]
- [ ] Tạo thư mục `.claude/skills/pipeline-runner/loop/` [TỪ DESIGN §3]

### Phase 1: Core Scripts
- [ ] Tạo `scripts/pipeline_runner.py` - Main execution logic [TỪ DESIGN §5]
  - Hàm load_pipeline_config()
  - Hàm find_next_stage()
  - Hàm spawn_subagent()
  - Hàm validate_output()
  - Hàm update_queue()
- [ ] Tạo `scripts/variable_resolver.py` - Resolve {} variables [TỪ DESIGN §4]

### Phase 2: Templates
- [ ] Tạo `templates/pipeline.yaml.template` - Pipeline config template [TỪ DESIGN §3]
- [ ] Tạo `templates/task.json.template` - Task spec template [TỪ DESIGN §3]
- [ ] Tạo `templates/_queue.json.template` - Queue state template [TỪ DESIGN §3]

### Phase 3: Validation & Quality
- [ ] Tạo `loop/checklist.md` - Quality gate checklist [TỪ DESIGN §8]

## 3. Knowledge & Resources Needed

| Tài liệu | Nguồn |
|----------|-------|
| Claude Code Task tool spec | External docs |
| YAML parsing (PyYAML) | Python standard |

## 4. Definition of Done

- [ ] SKILL.md có đầy đủ workflow phases
- [ ] scripts/pipeline_runner.py chạy được không lỗi
- [ ] Templates parse đúng YAML/JSON
- [ ] Checklist cover tất cả validation points
- [ ] Test với mock pipeline

## 5. Notes

- [CẦN LÀM RÕ] Cần xác định default pipeline cho UML generation
- [GỢI Ý BỔ SUNG] Có thể extend cho multi-pipeline sau
