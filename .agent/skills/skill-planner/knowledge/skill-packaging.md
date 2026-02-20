# Skill Packaging — Đóng gói Kỹ năng Con người thành Agent Skill

> Tài liệu nền tảng cho Skill Planner
> Mục đích: Hướng dẫn cách phân tích và chuyển đổi kỹ năng con người
> thành Agent Skill có cấu trúc.

---

## 1. Nguyên tắc Đóng gói

Mọi kỹ năng con người đều gồm 3 thành phần:

```
KỸ NĂNG CON NGƯỜI = KIẾN THỨC + QUY TRÌNH + PHÁN ĐOÁN
TRẠNG THÁI SẴN SÀNG = TÀI LIỆU RICH (Đủ chi tiết) + TRACEABILITY (Dẫn nguồn)
```

## 2. Tiêu chuẩn Sẵn sàng của Tài nguyên (Resource Readiness)

Một tài nguyên kiến thức trong `resources/` chỉ được coi là đạt chuẩn (✅) khi:
1. **Content Density**: Không được là file rỗng hoặc chỉ có heading chung chung. Phải có quy tắc (rules), ví dụ (examples), hoặc quy trình (procedures) cụ thể.
2. **Context Alignment**: Phải giải quyết được ít nhất một "Blind Spot" hoặc "Domain Knowledge" được liệt kê trong `design.md`.
3. **Builder Friendly**: Thông tin phải ở dạng mà Builder có thể copy/transform thành các file `knowledge/` trong skill package.

**Quy tắc Gatekeeper**:
- Planner **KHÔNG ĐƯỢC** đánh dấu hoàn thành (🟢 COMPLETE) nếu còn tài nguyên quan trọng ở trạng thái `⬜ Missing`.
- Nếu tài nguyên quan trọng thiếu, Planner phải yêu cầu user cung cấp hoặc hỗ trợ user viết nháp.

| Thành phần | Ở con người | Ở Agent Skill | Zone tương ứng |
|-----------|-------------|---------------|----------------|
| **Kiến thức** | Học từ sách, kinh nghiệm, training | `knowledge/` files | Knowledge Zone |
| **Quy trình** | Trình tự bước làm, know-how | `SKILL.md` phases/steps | Core Zone |
| **Phán đoán** | Trực giác, kinh nghiệm xử lý tình huống | `loop/` checklists + guardrails | Loop Zone |

**Nguyên tắc cốt lõi**: AI cần cả 3 thành phần ở dạng **TƯỜNG MINH** (explicit).
- Kiến thức ngầm (tacit) → phải được viết ra thành tài liệu
- Quy trình trong đầu → phải được code hóa thành steps
- Phán đoán bằng cảm giác → phải được chuyển thành rules/checklists

---

## 2. Mô hình 3 Tầng Kiến thức

Khi phân tích mỗi Zone trong design.md, Planner PHẢI hỏi 3 câu hỏi theo 3 tầng:

| Tầng | Tên | Câu hỏi chuẩn | Logic Audit (MỚI) |
|------|-----|---------------|-------------------|
| **1** | **Domain** | "Kiến thức miền nào cần để HIỂU bản chất thứ cần làm?" | **BẮT BUỘC Audit**: Kiểm tra thư mục `resources/`. Nếu chưa có tài liệu tương ứng → sinh **TASK** chuẩn bị tài liệu. Nếu đã có → sinh **PRE-REQ** và đánh dấu `✅`. |
| **2** | **Technical** | "Công cụ/kỹ thuật nào cần để TRIỂN KHAI?" | Kiểm tra tài liệu kỹ thuật/hướng dẫn tool. |
| **3** | **Packaging** | "Làm sao MAP vào Zone tương ứng của agent skill?" | Ghi domain rules vào `knowledge/`. Tạo templates, script validation, và loop checklist. |

### Cách áp dụng:

```
├── Hỏi Tầng 1 (Domain):
│   ├── Audit `resources/`: Tài liệu X đã có chưa?
│   ├── CÓ → Sinh PRE-REQUISITE (đánh dấu ✅)
│   └── KHÔNG → Sinh **TASK**: "Soạn thảo tài liệu X" [TỪ AUDIT TÀI NGUYÊN]
│
├── Hỏi Tầng 2 (Technical):
│   → Sinh PRE-REQUISITE: "User cần chuẩn bị tài liệu kỹ thuật Y"
│
└── Hỏi Tầng 3 (Packaging):
    → Sinh TASK: "Tạo file Z trong zone T" [TỪ DESIGN §N]
```

---

## 3. Checklist Chuyển đổi

Cho MỖI Zone trong design.md §3, hỏi 5 câu hỏi sau:

| # | Câu hỏi | Nếu CÓ → Sinh gì? | Ví dụ |
|---|---------|---------------------|-------|
| C1 | Kiến thức miền nào cần? | Audit `resources/`. Nếu thiếu sinh **Task soạn thảo** Phase 0, nếu đủ sinh **Pre-req ✅** | "Soạn thảo tài liệu cấu trúc UML Sequence" |
| C2 | Công cụ/kỹ thuật nào cần? | Pre-req: liệt kê tài liệu kỹ thuật | "Cần tham khảo Mermaid docs" |
| C3 | Quy trình nào cần chuẩn hóa? | Task: tạo file `SKILL.md` hoặc các file cụ thể từ §3 (Files cần tạo) Phase 1 / Phase 2 | "Tạo file `knowledge/domain-rules.md` [TỪ DESIGN §3]" |
| C4 | Phán đoán nào cần guardrail? | Task: tạo checklist. Phải dùng tên file từ §3 (vd `loop/checklist.md`) | "Tạo `loop/diagram-quality-checklist.md` [TỪ DESIGN §3]" |
| C5 | Output nào cần khuôn mẫu? | Task: tạo template. Phải dùng tên file từ §3 (vd `templates/output.md.template`) | "Tạo `templates/sequence.mmd` [TỪ DESIGN §3]" |

**Quy tắc**:
- Các Task được sinh ra cho C3, C4, C5 **PHẢI bám sát cột `Files cần tạo` của thiết kế (design.md §3)**. Nếu §3 ghi tên file gì, Task phải chỉ định rõ yêu cầu tạo file đó.
- Nếu câu trả lời là "Không cần" trong §3 → bỏ qua, không sinh Task/entry.
- Mọi entry sinh ra PHẢI có trace tag.
- C1, C2 sinh PRE-REQUISITES (user chuẩn bị).
- C3, C4, C5 sinh TASKS (builder thực hiện).

---

## 4. Nguyên tắc Chống Ảo giác

### 4 nguyên tắc BẮT BUỘC:

| # | Nguyên tắc | Giải thích | Vi phạm = |
|---|-----------|-----------|-----------|
| AH1 | **Trace bắt buộc** | Mọi task/pre-req trong todo.md PHẢI chỉ về section cụ thể trong design.md | Viết task không có `[TỪ DESIGN §N]` |
| AH2 | **Không phát minh** | Chỉ PHÂN RÃ thiết kế thành steps, KHÔNG thêm requirements mới | Viết requirement mà design.md không đề cập |
| AH3 | **Không đoán domain** | Nếu không chắc về kiến thức miền → liệt kê để user cung cấp | Tự viết nội dung domain knowledge |
| AH4 | **Đánh dấu nguồn** | Mọi entry phải ghi rõ nguồn | Không phân biệt `[TỪ DESIGN]` và `[GỢI Ý]` |
| AH5 | **Verify or Fail** | Phải xác minh tài nguyên thực tế trước khi kết thúc planning | Hoàn thành planning khi resources còn trống |

### Tags chuẩn:

```
[TỪ DESIGN §N]    — Nội dung lấy trực tiếp từ design.md section N
[GỢI Ý BỔ SUNG]   — Planner gợi ý thêm, KHÔNG CÓ trong design.md
[CẦN LÀM RÕ]      — Design.md không rõ ràng, cần user làm rõ
```

### Quy tắc XỬ LÝ khi gặp mập mờ:

```
Design.md rõ ràng?
├── CÓ → Sinh entry với [TỪ DESIGN §N]
├── MẬP MỜ → Sinh entry với [CẦN LÀM RÕ] vào Notes
└── KHÔNG CÓ nhưng hữu ích → Sinh entry với [GỢI Ý BỔ SUNG]
```

---

## Tóm tắt

```
Planner đọc design.md
    │
    ├── Với mỗi Zone có nội dung (§3):
    │   ├── 3 Tầng kiến thức → sinh pre-reqs + tasks
    │   └── 5 Câu checklist → sinh pre-reqs + tasks
    │
    ├── Mọi entry có trace tag (AH1, AH4)
    ├── Không bịa requirements (AH2)
    ├── Không đoán domain (AH3)
    │
    └── Output: todo.md (5 sections)
```
