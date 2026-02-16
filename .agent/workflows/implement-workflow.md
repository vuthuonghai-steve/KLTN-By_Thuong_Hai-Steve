---
description: Thực thi tasks, xử lý risks từ ultra-think, sinh code và sửa đổi dự án
---

# IMPLEMENT-WORKFLOW: Thực Thi & Xử Lý Rủi Ro

> **Vai trò**: Thực thi tasks, xử lý risks, sinh code, sửa đổi files
> 
> **QUẢN LÝ TÀI LIỆU**: Truy cập tài liệu từ thư mục session (`.agent/sessions/{name}/`).
>
> **Input**: `tasks.md`, `risks.md`, `data.yaml` từ session tương ứng.
>
> **Output**: Code changes và cập nhật trạng thái trong `tasks.md`, lưu `walkthrough-{task}.md` vào thư mục session.

---

## ⚠️ LESSONS LEARNED (SYNCED)

| # | Quy Tắc | Confirmed |
|---|---------|-----------|
| **⚠️** | **ĐỌC TOÀN BỘ FILE THAM CHIẾU** trước khi thực thi - BẮT BUỘC, không bỏ sót | 2025-12-09 |
| 1 | **LUÔN dùng XML structured prompt** | 2025-12-06 |
| 2 | **LUÔN thêm context** (working dir, tech stack, files) | 2025-12-06 |
| 3 | **Khi agent hỏi clarification → DỪNG và hỏi Steve** | 2025-12-08 |
| 4 | **CHỜ ĐỦ THỜI GIAN - WaitDurationSeconds >= 180s** | 2025-12-08 |
| 5 | **VALIDATE OUTPUT** trước khi apply | 2025-12-08 |
| 6 | **FALLBACK AGENT** - Có backup plan khi primary agent fail | 2025-12-08 |
| 7 | **Max 3 retries per agent per task** | 2025-12-08 |

> 🔴 **BẮT BUỘC TRƯỚC KHI LÀM VIỆC**:
> 1. Đọc **TOÀN BỘ** file workflow này
> 2. Đọc **TẤT CẢ** input documents từ ai-orchestration/ultra-think
> 3. Đọc **TẤT CẢ** files trong References (Section VIII)
> 4. **KHÔNG ĐƯỢC BỎ SÓT** - ảnh hưởng chất lượng output

---

## I. QUY TRÌNH THỰC THI

```
┌─────────────────────────────────────────────────────────────────┐
│  INPUT: Documents từ ai-orchestration / ultra-think            │
│  - task-list.md                                                 │
│  - risk-analysis.md                                             │
│  - implementation-guide.md                                      │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              STEP 1: Pre-Implementation Check                   │
│  • Đọc tất cả input documents                                   │
│  • Verify prerequisites                                         │
│  • Confirm risks đã có mitigations                              │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              STEP 2: Execute Tasks                              │
│  • Thực thi từng step theo guide                                │
│  • Apply risk mitigations                                       │
│  • Sinh code / sửa files                                        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              STEP 3: Verify & Test                              │
│  • Chạy tests                                                   │
│  • Verify functionality                                         │
│  • Check for regressions                                        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              STEP 4: Document & Cleanup                         │
│  • Tạo walkthrough.md                                           │
│  • Update CHANGELOG                                             │
│  • Cleanup temporary files                                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## II. STEPS CHI TIẾT

### Step 1: Pre-Implementation Check

```markdown
## Pre-Implementation Checklist

### Input Documents
- [ ] Đã đọc task description
- [ ] Đã đọc risk analysis (nếu có từ ultra-think)
- [ ] Đã đọc implementation guide (nếu có)

### Prerequisites
- [ ] Working directory đúng
- [ ] Dependencies đã install
- [ ] No pending changes (git status clean)

### Risks Acknowledged
| Risk | Mitigation Ready? | Notes |
|------|-------------------|-------|
| {risk 1} | ✅/❌ | |
| {risk 2} | ✅/❌ | |
```

### Step 2: Execute Tasks

```bash
# Dùng Claude để sinh code
claude -p "
<task>{Mô tả task cần implement}</task>
<context>
- Project: {tên dự án}
- Working dir: {đường dẫn}
- Tech stack: {stack}
- Files to modify: {list}
</context>
<risk_mitigations>
{List mitigations cần apply}
</risk_mitigations>
<instruction>
1. Implement theo specification
2. Apply risk mitigations
3. Follow coding conventions
4. Add error handling
</instruction>
" --dangerously-skip-permissions
```

**Execution Rules:**
- ✅ Commit sau mỗi step hoàn thành
- ✅ Test sau mỗi major change
- ✅ Rollback nếu tests fail
- ❌ KHÔNG skip risk mitigations

### Step 3: Verify & Test

```bash
# Chạy tests
bun test                    # Unit tests
bun run build              # Build check
bun run lint               # Lint check

# Manual verification nếu cần
# Browser tests, API tests, etc.
```

**Verification Checklist:**
- [ ] All tests pass
- [ ] No new lint errors
- [ ] Build successful
- [ ] Functionality works as expected
- [ ] No regressions in existing features

### Step 4: Document, Update Status & Cleanup

1. **Cập nhật trạng thái**: Đánh dấu hoàn thành task trong `tasks.md` của thư mục session.
2. **Lưu Walkthrough**: Tạo file `walkthrough-{task-id}.md` ngay trong thư mục session.

```markdown
# Walkthrough: {Task Name}
## Changes Made
| File | Change Type | Description |
|------|-------------|-------------|
| {file} | Modified | {mô tả} |
```
3. **Cập nhật INDEX.md**: Nếu có tài liệu mới sinh ra, link vào `INDEX.md`.

---

## III. AGENT COMMANDS (EXECUTION)

| Agent | Command | Best For |
|-------|---------|----------|
| **Claude Sonnet** | `claude -p "..." --dangerously-skip-permissions` | Code generation, complex logic |
| **Claude Haiku** | `claude -p "..." --model haiku --dangerously-skip-permissions` | Simple fixes, boilerplate |
| **Codex** | `codex "..."` | Code completion |

---

## IV. ERROR HANDLING & FALLBACK

### Retry Logic

```
Step fails → Retry (max 3) → If still fail → Fallback Agent → If still fail → STOP + Report
```

| Retry # | Action |
|---------|--------|
| 1 | Thử lại với cùng prompt |
| 2 | Thử lại với prompt đơn giản hơn |
| 3 | Chuyển sang Fallback Agent |

### Fallback Agent Matrix

| Primary | Fallback | Khi Nào |
|---------|----------|---------|
| Claude Sonnet | Claude Haiku | Sonnet timeout/overload |
| Claude Haiku | Gemini | Haiku không hiểu context |
| Gemini | Claude Sonnet | Gemini error |

---

## V. ROLLBACK PROCEDURES

### Khi Cần Rollback

- Tests fail sau khi implement
- Breaking changes detected
- Unexpected side effects
- Steve yêu cầu revert

### Rollback Steps

```bash
# 1. Xác định commit cần rollback về
git log --oneline -10

# 2. Rollback
git revert <commit-hash>    # Tạo commit mới để revert
# hoặc
git reset --hard <commit-hash>  # Hard reset (cẩn thận!)

# 3. Verify sau rollback
bun test
bun run build
```

---

## VI. OUTPUT REQUIREMENTS

Sau mỗi implementation, PHẢI tạo:

1. **Walkthrough Document** (bắt buộc)
   - Summary của changes
   - Files modified
   - Tests results
   - Screenshot/evidence

2. **CHANGELOG Update** (nếu có file CHANGELOG)

3. **GEMINI.md Update** (nếu thêm exports mới)

---

## VII. CHECKLIST CUỐI

```markdown
## Implementation Complete Checklist

### Code
- [ ] All tasks implemented
- [ ] Risk mitigations applied
- [ ] Error handling added
- [ ] Code follows conventions

### Testing
- [ ] Unit tests pass
- [ ] Build successful
- [ ] Lint clean
- [ ] Manual verification done

### Documentation
- [ ] Walkthrough created
- [ ] CHANGELOG updated (if applicable)
- [ ] GEMINI.md updated (if new exports)

### Git
- [ ] Changes committed
- [ ] Commit messages clear
- [ ] Ready for review/merge
```

---

## VIII. REFERENCES

| Tài liệu | Đường dẫn |
|----------|-----------|
| AI-Orchestration | `.agent/workflows/ai-orchestration.md` |
| Ultra-Think | `.agent/workflows/ultra-think.md` |
| Lessons Learned | `.agent/references/shared/lessons-learned.md` |
| Error Handling | `.agent/references/shared/error-handling.md` |

---

## IX. CHANGELOG

| Date | Change |
|------|--------|
| 2025-12-09 | **INITIAL**: Created implement-workflow |
| 2025-12-09 | Added: Full execution pipeline |
| 2025-12-09 | Added: Error handling, rollback, verification |

---

**VERSION**: 1.0.0  
**LAST UPDATED**: 2025-12-09  
**ROLE**: Thực Thi & Xử Lý Rủi Ro
