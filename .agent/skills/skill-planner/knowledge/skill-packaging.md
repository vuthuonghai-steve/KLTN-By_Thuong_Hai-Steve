# Skill Packaging — Đóng gói Kỹ năng Con người thành Agent Skill

> Tài liệu nền tảng cho Skill Planner
> Mục đích: Hướng dẫn cách phân tích và chuyển đổi kỹ năng con người
> thành Agent Skill có cấu trúc.

---

## 1. Nguyên tắc Đóng gói

Mọi kỹ năng con người đều gồm 3 thành phần:

```
KỸ NĂNG CON NGƯỜI = KIẾN THỨC + QUY TRÌNH + PHÁN ĐOÁN
```

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

| Tầng | Tên | Câu hỏi chuẩn | Ví dụ (skill vẽ sequence diagram) |
|------|-----|---------------|----------------------------------|
| **1** | **Domain** | "Kiến thức miền nào cần để HIỂU bản chất thứ cần làm?" | Sequence diagram là gì? Actors, Messages, Lifelines, Combined Fragments là gì? Khi nào dùng sync vs async? |
| **2** | **Technical** | "Công cụ/kỹ thuật nào cần để TRIỂN KHAI?" | Mermaid syntax: `sequenceDiagram`, `participant`, `->>`, `Note`, `alt/loop/opt`. Giới hạn của Mermaid |
| **3** | **Packaging** | "Làm sao MAP vào Zone tương ứng của agent skill?" | Ghi domain rules vào `knowledge/uml-standards.md`. Ghi Mermaid templates vào `templates/sequence.mmd`. Tạo checklist vào `loop/diagram-checklist.md` |

### Cách áp dụng:

```
Với MỖI Zone có nội dung trong design.md §3:
│
├── Hỏi Tầng 1 (Domain):
│   → Sinh PRE-REQUISITE: "User cần chuẩn bị kiến thức về X"
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
| C1 | Kiến thức miền nào cần? | Pre-req: liệt kê để user chuẩn bị | "Cần hiểu cấu trúc UML sequence diagram" |
| C2 | Công cụ/kỹ thuật nào cần? | Pre-req: liệt kê tài liệu kỹ thuật | "Cần tham khảo Mermaid docs" |
| C3 | Quy trình nào cần chuẩn hóa? | Task: tạo phase/step trong SKILL.md | "Tạo Phase 2: Vẽ diagram" |
| C4 | Phán đoán nào cần guardrail? | Task: tạo checklist trong loop/ | "Tạo loop/diagram-quality-checklist.md" |
| C5 | Output nào cần khuôn mẫu? | Task: tạo template trong templates/ | "Tạo templates/sequence.mmd" |

**Quy tắc**:
- Nếu câu trả lời là "Không cần" → bỏ qua, không sinh entry
- Mọi entry sinh ra PHẢI có trace tag
- C1, C2 sinh PRE-REQUISITES (user chuẩn bị)
- C3, C4, C5 sinh TASKS (builder thực hiện)

---

## 4. Nguyên tắc Chống Ảo giác

### 4 nguyên tắc BẮT BUỘC:

| # | Nguyên tắc | Giải thích | Vi phạm = |
|---|-----------|-----------|-----------|
| AH1 | **Trace bắt buộc** | Mọi task/pre-req trong todo.md PHẢI chỉ về section cụ thể trong design.md | Viết task không có `[TỪ DESIGN §N]` |
| AH2 | **Không phát minh** | Chỉ PHÂN RÃ thiết kế thành steps, KHÔNG thêm requirements mới | Viết requirement mà design.md không đề cập |
| AH3 | **Không đoán domain** | Nếu không chắc về kiến thức miền → liệt kê để user cung cấp | Tự viết nội dung domain knowledge |
| AH4 | **Đánh dấu nguồn** | Mọi entry phải ghi rõ nguồn | Không phân biệt `[TỪ DESIGN]` và `[GỢI Ý]` |

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
