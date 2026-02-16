---
description: Nghiên cứu tổng quan vấn đề, xác định phương hướng giải quyết, tạo task list
---

# AI-ORCHESTRATION: Nghiên Cứu Tổng Quan & Định Hướng

> **Vai trò**: Phân tích tổng quan, xác định vấn đề, đề xuất hướng giải quyết
> 
> **KHÔNG thực thi**: Chỉ nghiên cứu và tạo tài liệu
>
> **Output**: Tài liệu tổng quan (overview risks, approach, task list)

---

## ⚠️ LESSONS LEARNED (BAT BUOC DOC)

> **CRITICAL**: Cac quy tac nay da duoc xac nhan. PHAI TUAN THU.

| # | Quy Tac | Confirmed |
|---|---------|-----------|
| **⚠️** | **ĐỌC TOÀN BỘ FILE THAM CHIẾU** trước khi thực thi - BẮT BUỘC, không bỏ sót | 2025-12-09 |
| 1 | **LUON dung XML structured prompt** | 2025-12-06 |
| 2 | **LUON them context** (working dir, tech stack, files) | 2025-12-06 |
| 3 | **KHONG yeu cau output theo template co dinh** | 2025-12-06 |
| 4 | **Khi agent hoi clarification → DUNG va hoi Steve** | 2025-12-08 |
| 5 | **Luon include working directory trong prompt** | 2025-12-08 |
| 6 | **Khi cap nhat → SYNC ca workflow va references** | 2025-12-08 |
| 7 | **CHO DU THOI GIAN - WaitDurationSeconds >= 180s** | 2025-12-08 |
| 8 | **KHONG interrupt agent** - command_status som co the dung agent | 2025-12-08 |
| 9 | **Empty output ≠ Agent loi** - Chi la chua xong, cho tiep | 2025-12-08 |
| 10 | **VALIDATE OUTPUT** truoc khi truyen sang agent tiep theo | 2025-12-08 |
| 11 | **FALLBACK AGENT** - Co backup plan khi primary agent fail | 2025-12-08 |

> 🔴 **BẮT BUỘC TRƯỚC KHI LÀM VIỆC**:
> 1. Đọc **TOÀN BỘ** file workflow này
> 2. Đọc **TẤT CẢ** files trong References (Section VI)
> 3. **KHÔNG ĐƯỢC BỎ SÓT** - ảnh hưởng chất lượng output
>
> 📖 **Chi tiết**: `.agent/references/shared/lessons-learned.md`

---

## I. QUY TRÌNH LÀM VIỆC & QUẢN LÝ TÀI LIỆU

### 1. Nguyên Tắc Quản Lý Thư Mục (BẮT BUỘC)
- **Yêu cầu mới**: Phải tạo một thư mục riêng biệt tại `.agent/sessions/{request-name}/` để quản lý toàn bộ vòng đời của yêu cầu.
- **Yêu cầu liên quan**: Phải tập trung tất cả tài liệu mới hoặc cập nhật vào thư mục đã tạo trước đó. KHÔNG tạo thư mục mới cho cùng một luồng công việc.
- **Cấu trúc file bắt buộc trong một session**:
  - `INDEX.md`: Quản lý tiêu đề, cấu trúc, nội dung tổng quan và các quy tắc đặc thù của session.
  - `analysis.md`: Chứa nội dung phân tích tổng quan và hướng tiếp cận.
  - `tasks.md`: Danh sách các đầu việc cần thực hiện và trạng thái.
  - `risks.md`: Phân tích rủi ro và các biện pháp giảm thiểu.
  - `data.yaml`: Lưu trữ thông tin có cấu trúc như mẫu collection, định nghĩa types, constants...

### 2. Luồng Workflow
```
┌─────────────────────────────────────────────────────────────────┐
│                        USER REQUEST                             │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              AI-ORCHESTRATION (Workflow này)                    │
│  • Khởi tạo thư mục session tại .agent/sessions/{name}/         │
│  • Tạo INDEX.md, analysis.md, tasks.md                          │
│  • Phân tích scope, affected areas                              │
│  OUTPUT: Thư mục session với đầy đủ các file nền tảng           │
└────────────────────────────┬────────────────────────────────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │ Tasks đơn giản     │ Tasks phức tạp     │
        ▼                    ▼                    │
  IMPLEMENT-WORKFLOW    ULTRA-THINK               │
  (Thực thi + Update)   (Đào sâu + Risks)         │
                             │                    │
                             ▼                    │
                       IMPLEMENT-WORKFLOW ◄───────┘
                       (Hoàn thiện tài liệu)
```

---

### Step 1: Khởi Tạo Cấu Trúc Session
1. Xác định tên session dựa trên yêu cầu (kebab-case).
2. Kiểm tra nếu đã có thư mục session liên quan tại `.agent/sessions/`.
3. Tạo thư mục session và các file: `INDEX.md`, `analysis.md`, `tasks.md`, `risks.md`, `data.yaml`.

### Step 2: Nhận & Phân Tích Yêu Cầu
Cập nhật nội dung vào `analysis.md`:
```markdown
## Yêu Cầu Gốc
{Copy yêu cầu từ user}

## Phân Tích Sơ Bộ
- Scope: {Phạm vi ảnh hưởng}
- Complexity: {Low/Medium/High}
- Affected areas: {Liệt kê}
```

### Step 3: Nghiên Cứu Codebase (Tổng Quan)

```bash
# Dùng Gemini cho research context lớn
gemini "
<task>Nghiên cứu tổng quan về: {vấn đề}</task>
<context>
- Project: {tên dự án}
- Working dir: {đường dẫn}
- Tech stack: {stack}
</context>
<instruction>
1. Scan cấu trúc liên quan
2. Identify patterns đang dùng
3. Liệt kê affected files/components
4. Đề xuất approach tổng quan
</instruction>
<output>Markdown, tiếng Việt, tổng quan</output>
" --yolo
```

### Step 4: Tạo Task List & INDEX
Cập nhật `tasks.md` và `INDEX.md`:

**tasks.md**:
```markdown
## Task List

| # | Task | Complexity | Cần Ultra-Think? | Status |
|---|------|------------|------------------|--------|
| 1 | {task 1} | Low | ❌ | TODO |
| 2 | {task 2} | High | ✅ | TODO |
```

**INDEX.md**:
```markdown
# Session Index: {Tên Yêu Cầu}
- **Trạng thái**: In progress
- **Quy tắc đặc thù**: {liệt kê nếu có}
- **Cấu trúc tài liệu**: {map các file trong session}
```

## Risks Tổng Quan (Ghi vào risks.md)
- Risk 1: ...
- Risk 2: ...
```

### Step 4: Handoff

**Nếu task đơn giản** → Chuyển sang `/implement-workflow`

**Nếu task phức tạp** → Chuyển sang `/ultra-think` để nghiên cứu sâu

---

## III. AGENT ROUTING (CHO NGHIÊN CỨU)

| Agent | Command | Best For |
|-------|---------|----------|
| **Gemini** | `gemini "..." --yolo` | Codebase research, context lớn |
| **Claude Sonnet** | `claude -p "..." --dangerously-skip-permissions` | Logic analysis |
| **Claude Haiku** | `claude -p "..." --model haiku --dangerously-skip-permissions` | Quick summaries |

---

## IV. CẤU TRÚC FILE MẪU

### 4.1 INDEX.md
```markdown
# Session Index: {Yêu cầu}
- **Mô tả**: {Tóm tắt}
- **Quy tắc**: {Các quy tắc phải tuân thủ riêng cho session này}
- **Tài liệu liên quan**:
  - [Analysis](./analysis.md)
  - [Tasks](./tasks.md)
  - [Risks](./risks.md)
  - [Data Structure](./data.yaml)
```

### 4.2 data.yaml
```yaml
session_info:
  name: "{name}"
  created_at: "{date}"
collections:
  - name: "Orders"
    new_fields: ["field1", "field2"]
types:
  - name: "OrderType"
    definition: "immediate | scheduled"
```

---

## V. KHI NÀO CHUYỂN SANG ULTRA-THINK

Chuyển sang `/ultra-think` khi task có:

- [ ] Nhiều edge cases chưa rõ
- [ ] Ảnh hưởng nhiều components
- [ ] Có potential breaking changes
- [ ] Cần cross-validation từ nhiều góc nhìn
- [ ] Logic phức tạp cần phân tích sâu

---

## VI. REFERENCES

| Tài liệu | Đường dẫn |
|----------|-----------|
| Ultra-Think Workflow | `.agent/workflows/ultra-think.md` |
| Implement Workflow | `.agent/workflows/implement-workflow.md` |
| Lessons Learned | `.agent/references/shared/lessons-learned.md` |
| Templates | `.agent/references/ai-orchestration/templates/` |
| Sessions | `.agent/references/ai-orchestration/sessions/` |

---

## VII. CHANGELOG

| Date | Change |
|------|--------|
| 2025-12-09 | **MAJOR REFACTOR**: Chuyển từ execution sang nghiên cứu tổng quan |
| 2025-12-09 | Removed: Execution-related content (moved to implement-workflow) |
| 2025-12-09 | Added: Output templates, handoff guidelines |
| 2025-12-08 | Added: Rules #7-11 |
| 2025-12-06 | Initial creation |

---

**VERSION**: 2.0.0  
**LAST UPDATED**: 2025-12-09  
**ROLE**: Nghiên cứu Tổng Quan & Định Hướng