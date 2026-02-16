---
description: Nghiên cứu chuyên sâu một task cụ thể, phát hiện risks ẩn, làm rõ requirements
---

# ULTRA-THINK: Nghiên Cứu Chuyên Sâu & Phân Tích Rủi Ro

> **Vai trò**: Nghiên cứu sâu 1 task cụ thể, phát hiện hidden risks, làm rõ requirements
> 
> **QUẢN LÝ TÀI LIỆU**: Mọi tài liệu sinh ra PHẢI nằm trong thư mục session đã tạo bởi `ai-orchestration` (`.agent/sessions/{name}/`).
>
> **Input**: Task cụ thể từ `tasks.md` của session.
>
> **Output**: Cập nhật `risks.md`, `data.yaml` và làm rõ giải pháp trong session.

---

## ⚠️ LESSONS LEARNED (SYNCED VỚI AI-ORCHESTRATION)

> **CRITICAL**: Các quy tắc này dùng chung cho cả 3 workflows.

| # | Quy Tắc | Confirmed |
|---|---------|-----------|
| **⚠️** | **ĐỌC TOÀN BỘ FILE THAM CHIẾU** trước khi thực thi - BẮT BUỘC, không bỏ sót | 2025-12-09 |
| 1 | **LUÔN dùng XML structured prompt** | 2025-12-06 |
| 2 | **LUÔN thêm context** (working dir, tech stack, files) | 2025-12-06 |
| 3 | **KHÔNG yêu cầu output theo template cố định** | 2025-12-06 |
| 4 | **Khi agent hỏi clarification → DỪNG và hỏi Steve** | 2025-12-08 |
| 5 | **Luôn include working directory trong prompt** | 2025-12-08 |
| 6 | **CHỜ ĐỦ THỜI GIAN - WaitDurationSeconds >= 180s** | 2025-12-08 |
| 7 | **KHÔNG interrupt agent** - command_status sớm có thể dừng agent | 2025-12-08 |
| 8 | **Empty output ≠ Agent lỗi** - Chỉ là chưa xong, chờ tiếp | 2025-12-08 |
| 9 | **VALIDATE OUTPUT** trước khi truyền sang bước tiếp theo | 2025-12-08 |

> 🔴 **BẮT BUỘC TRƯỚC KHI LÀM VIỆC**:
> 1. Đọc **TOÀN BỘ** file workflow này
> 2. Đọc **TẤT CẢ** files trong References (Section VI)
> 3. **KHÔNG ĐƯỢC BỎ SÓT** - ảnh hưởng chất lượng output

---

## I. KHI NÀO DÙNG ULTRA-THINK

**Được gọi từ ai-orchestration khi task có:**

- [ ] Nhiều edge cases chưa rõ
- [ ] Ảnh hưởng nhiều components
- [ ] Có potential breaking changes
- [ ] Cần cross-validation từ nhiều góc nhìn
- [ ] Logic phức tạp cần phân tích sâu
- [ ] Requirements chưa rõ ràng

**KHÔNG dùng khi:**

- Task đơn giản → Chuyển thẳng sang `/implement-workflow`

---

## II. QUY TRÌNH 5 BƯỚC

### Step 1: DECOMPOSE - Phân Tách Vấn Đề

```markdown
## Task từ ai-orchestration
{Copy task description}

## Các Khía Cạnh Cần Phân Tích
1. **Technical**: {khía cạnh kỹ thuật cần deep dive}
2. **Business Logic**: {nghiệp vụ chưa rõ}
3. **Edge Cases**: {cases đặc biệt}
4. **Dependencies**: {phụ thuộc cần check}
5. **Breaking Changes**: {potential breaking}
```

### Step 2: RESEARCH - Thu Thập Thông Tin Sâu

```bash
# Dùng Gemini cho research sâu
gemini "
<task>Nghiên cứu sâu về: {task cụ thể}</task>
<context>
- Project: {tên dự án}
- Working dir: {đường dẫn}
- Tech stack: {stack}
- Files liên quan: {list files}
</context>
<instruction>
1. Đọc và phân tích tất cả files liên quan
2. Identify tất cả edge cases có thể xảy ra
3. Tìm potential issues và conflicts
4. Check backward compatibility
5. Phát hiện hidden dependencies
</instruction>
<output>Markdown chi tiết, tiếng Việt</output>
" --yolo
```

### Step 3: ANALYZE - Phân Tích Đa Chiều

```bash
# Dùng Claude để phân tích logic
claude -p "
<task>Phân tích rủi ro cho: {task}</task>
<research_data>{output từ Gemini}</research_data>
<instruction>
1. Đánh giá mỗi edge case: probability + impact
2. Xếp hạng risks theo severity
3. Đề xuất mitigation cho mỗi risk
4. Identify requirements cần clarify với user
</instruction>
<output>Bảng risks + mitigations</output>
" --dangerously-skip-permissions
```

### Step 4: SYNTHESIZE - Cập nhật risks.md
Ghi các kết quả phát hiện vào file `risks.md` của session:

```markdown
## TỔNG HỢP RỦI RO CHI TIẾT
| Risk | Severity | Probability | Impact | Mitigation |
|------|----------|-------------|--------|------------|
| ... | P0/P1/P2 | High/Med/Low | ... | ... |

### Edge Cases Cần Xử Lý
1. {edge case 1}: {cách xử lý}
```

### Step 5: DECIDE - Cập nhật data.yaml và Implementation Guide
Cập nhật cấu trúc dữ liệu mới vào `data.yaml` và tạo hướng dẫn chi tiếp trong session.

---

## III. CROSS-VALIDATION FRAMEWORK

### Khi Cần Cross-Validate

| Tình huống | Approach |
|------------|----------|
| Critical architecture decision | Gemini + Claude Sonnet |
| Security concern | All agents + manual review |
| Complex algorithm | Claude Sonnet + verify với Claude Haiku |

### Cross-Validation Template

```markdown
## CROSS-VALIDATION: {Vấn đề}

### Agent 1: Gemini
**Output Summary**: {key points}
**Confidence**: High/Medium/Low

### Agent 2: Claude
**Output Summary**: {key points}
**Confidence**: High/Medium/Low

### So Sánh
| Aspect | Gemini | Claude | Match? |
|--------|--------|--------|--------|
| Core solution | | | |
| Risks identified | | | |
| Edge cases | | | |

### Consensus
{Điểm cả 2 agents đồng ý}

### Divergence
{Điểm khác biệt + agent nào tin hơn}
```

---

## IV. OUTPUT TEMPLATES

### 4.1 Hidden Risks Document

```markdown
# Risk Analysis: {Task Name}

## Summary
{Tóm tắt 2-3 dòng}

## Risks Table
| # | Risk | Severity | Probability | Impact | Mitigation | Owner |
|---|------|----------|-------------|--------|------------|-------|

## Edge Cases
| # | Case | Expected Behavior | Handling |
|---|------|-------------------|----------|

## Requirements Clarification Needed
- [ ] {question 1}
- [ ] {question 2}
```

### 4.2 Implementation Guide (cho implement-workflow)

```markdown
# Implementation Guide: {Task Name}

## Prerequisites
- [ ] {prerequisite 1}
- [ ] {prerequisite 2}

## Step-by-Step Implementation
### Step 1: {title}
{chi tiết với code snippets nếu cần}

### Step 2: {title}
{chi tiết}

## Risk Mitigation During Implementation
- Trước khi {action}: check {condition}
- Nếu gặp {error}: {action}

## Verification Checklist
- [ ] {check 1}
- [ ] {check 2}
```

---

## V. HANDOFF TO IMPLEMENT-WORKFLOW

Sau khi hoàn thành 5 bước, tạo handoff document:

```markdown
# Handoff: {Task Name}

## From: ultra-think
## To: implement-workflow

### Task Summary
{Tóm tắt task}

### Documents Created
1. `risk-analysis-{task}.md` - Phân tích rủi ro
2. `implementation-guide-{task}.md` - Hướng dẫn implement

### Critical Risks (P0/P1)
{List risks quan trọng nhất}

### Implementation Ready
- [ ] All risks have mitigations
- [ ] Requirements clarified with Steve
- [ ] Rollback plan defined

### Next: Run `/implement-workflow`
```

---

## VI. REFERENCES

| Tài liệu | Đường dẫn |
|----------|-----------|
| AI-Orchestration | `.agent/workflows/ai-orchestration.md` |
| Implement Workflow | `.agent/workflows/implement-workflow.md` |
| Lessons Learned | `.agent/references/shared/lessons-learned.md` |
| Sessions | `.agent/references/ultra-think/sessions/` |

---

## VII. CHANGELOG

| Date | Change |
|------|--------|
| 2025-12-09 | **MAJOR REFACTOR**: Chuyển thành workflow nghiên cứu chuyên sâu |
| 2025-12-09 | Removed: Code gen prompts, UI/UX prompts, execution content |
| 2025-12-09 | Added: Output templates, handoff guidelines |
| 2025-12-09 | Synced: Lessons learned với ai-orchestration |
| 2025-12-06 | Added Prompt History |
| 2025-12-05 | Initial creation |

---

**VERSION**: 2.0.0  
**LAST UPDATED**: 2025-12-09  
**ROLE**: Nghiên Cứu Chuyên Sâu & Phân Tích Rủi Ro
