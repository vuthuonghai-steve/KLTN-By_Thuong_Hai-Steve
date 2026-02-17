# implementation-plan — sequence-design-analyst
> Status: 🚀 DELIVERED (Finalized)

## 1. Pre-requisites

| # | Knowledge/Resource | Tier | Purpose | Trace | Status |
|---|-------------------|------|---------|-------|--------|
| 1 | `resources/context1.md` | Domain | Cung cấp hướng dẫn chuẩn về Sequence Diagram | [TỪ AUDIT TÀI NGUYÊN] | ✅ |
| 2 | UML Sequence Standards | Domain | Tri thức về Lifelines, Synchronous Messages, alt/loop/opt fragments | [TỪ DESIGN §2.1] | ✅ |
| 3 | Mermaid Syntax v11.4+ | Technical | Cú pháp để sinh sơ đồ chính xác | [TỪ DESIGN §2.1] | ✅ |
| 4 | Project Logic Patterns | Domain | Cách các lớp Controller/Service/Repo tương tác trong dự án | [TỪ DESIGN §2.1] | ✅ |

## 2. Phase Breakdown

### Phase 1: Resource Preparation & Knowledge Base
- [x] Soạn thảo tài liệu chuẩn UML chuyên sâu tại `resources/uml-rules.md` (bao gồm rules về fragments). [TỪ AUDIT TÀI NGUYÊN]
- [x] Thu thập và soạn thảo tài liệu `resources/project-patterns.md` mô tả cách gọi Local API và cấu trúc MVC của dự án. [TỪ AUDIT TÀI NGUYÊN]
- [x] Chuyển đổi (Transform) `resources/uml-rules.md` thành `knowledge/uml-rules.md` trong skill package. [TỪ DESIGN §4]
- [x] Chuyển đổi (Transform) `resources/project-patterns.md` thành `knowledge/project-patterns.md`. [TỪ DESIGN §4]

### Phase 2: Core Implementation
- [x] Implement `SKILL.md` với đầy đủ Persona: "Senior UML Architect", 5 Phases thực thi, và các Guardrails về độ đọc (Readability Limit). [TỪ DESIGN §3, §4, §8]
- [x] Cấu tạo (Configure) hệ thống Progressive Disclosure: Tier 1 (Mandatory) và Tier 2 (Conditional). [TỪ DESIGN §7]

### Phase 3: Templates & Automation
- [x] Tạo file `templates/crud-flow.mmd` làm mẫu cho các luồng xử lý dữ liệu. [TỪ DESIGN §4]
- [x] Tạo file `templates/auth-flow.mmd` làm mẫu cho các luồng xác thực/phân quyền. [TỪ DESIGN §4]
- [x] Tạo file `templates/logic-flow.mmd` làm mẫu cho logic phức tạp nhiều rẽ nhánh. [TỪ DESIGN §4]

### Phase 4: Quality Control (Loop)
- [x] Triển khai `loop/checklist.md` với ít nhất 10 tiêu chí kiểm tra (Traceability, Fragments, Naming Consistency). [TỪ DESIGN §4, §8]
- [x] Implement `loop/verify-script.py` (Python) để tự động hóa việc kiểm tra sự tồn tại của các lifelines trong codebase thực tế. [TỪ DESIGN §4, §8]
- [x] Xây dựng bộ Test Cases mẫu tại `loop/test-cases/` bao gồm: Luồng đăng nhập, Luồng thanh toán, Luồng CRUD sản phẩm. [GỢI Ý BỔ SUNG]

## 3. Knowledge & Resources Needed

| Resource Name | Source | Use In |
|---------------|--------|--------|
| sequence-design-analyst/design.md | `.skill-context/` | Toàn bộ quá trình |
| context1.md | `resources/` | Phase 1 |
| Mermaid Official Docs | External | Phase 3 |

## 4. Definition of Done

- [x] `SKILL.md` hoạt động đúng theo 5 pha đã thiết kế.
- [x] Mọi kiến thức từ `resources/` đã được đóng gói triệt để vào `knowledge/`.
- [x] Có ít nhất 3 templates Mermaid hoạt động tốt.
- [x] Hệ thống Loop (`checklist.md`) có khả năng phát hiện lỗi Logic ảo giác (Hallucination).
- [x] Đã kiểm tra chéo (Verify) 100% các task với `design.md`.

## 5. Notes

- **[ĐÃ XÁC NHẬN]**: Không tích hợp script export ảnh từ Mermaid (ưu tiên code Mermaid thuần).
- **[ĐÃ XÁC NHẬN]**: Chức năng Refactor code nằm ngoài phạm vi của skill này.
- **[GỢI Ý BỔ SUNG]**: Các test case trong `loop/test-cases/` cần bao phủ cả luồng thành công (Happy Path) và luồng lỗi (Edge Cases) để kiểm tra tính chính xác của các block `alt` trong Mermaid.
