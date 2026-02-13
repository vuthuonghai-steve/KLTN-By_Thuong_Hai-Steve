## ADDED Requirements

### Requirement: Mô hình 3 tầng kiến thức
File `knowledge/skill-packaging.md` MUST định nghĩa mô hình 3 tầng kiến thức
mà Planner sử dụng khi phân tích mỗi Zone:

| Tầng | Tên | Câu hỏi |
|------|-----|---------|
| 1 | Domain | Kiến thức miền nào cần để hiểu bản chất thứ cần làm? |
| 2 | Technical | Công cụ/kỹ thuật nào cần để triển khai? |
| 3 | Packaging | Làm sao map vào Zone tương ứng của agent skill? |

#### Scenario: Planner áp dụng 3 tầng cho mỗi Zone
- **WHEN** Planner phân tích một Zone có nội dung
- **THEN** Planner hỏi 3 câu hỏi tương ứng 3 tầng và sinh entries cho todo.md

### Requirement: Nguyên tắc đóng gói kỹ năng
File MUST chứa nguyên tắc chuyển đổi human skill → agent skill:
- Kỹ năng con người = Kiến thức + Quy trình + Phán đoán
- AI cần cả 3 ở dạng TƯỜNG MINH (explicit)
- Kiến thức → knowledge/ files
- Quy trình → SKILL.md phases
- Phán đoán → loop/ checklists + guardrails

#### Scenario: Planner nhận diện kiến thức ngầm
- **WHEN** design.md mô tả capability liên quan đến phán đoán (ví dụ: "đánh giá chất lượng")
- **THEN** Planner sinh task tạo guardrail hoặc checklist, không bỏ qua

### Requirement: Checklist chuyển đổi
File MUST chứa checklist để Planner áp dụng cho mỗi Zone khi phân tích:
- Kiến thức miền nào cần? → liệt kê cho user chuẩn bị
- Công cụ/kỹ thuật nào cần? → liệt kê cho user chuẩn bị
- Quy trình nào cần chuẩn hóa? → sinh task tạo SKILL.md phases
- Phán đoán nào cần guardrail? → sinh task tạo loop/ files
- Output nào cần khuôn mẫu? → sinh task tạo templates/

#### Scenario: Checklist áp dụng cho Zone Knowledge
- **WHEN** design.md §3 ghi Zone Knowledge cần "standards.md, best-practices.md"
- **THEN** Planner sinh pre-req: "Chuẩn bị tài liệu X [TỪ DESIGN §3]" + task: "Tạo knowledge/standards.md [TỪ DESIGN §3]"

### Requirement: Nguyên tắc chống ảo giác
File MUST chứa 4 nguyên tắc:
1. Mọi task PHẢI trace về section cụ thể trong design.md
2. Không phát minh requirements mới (chỉ phân rã)
3. Không đoán kiến thức miền — liệt kê để user cung cấp
4. Đánh dấu rõ nguồn: `[TỪ DESIGN §N]` vs `[GỢI Ý BỔ SUNG]`

#### Scenario: Planner tuân thủ nguyên tắc trace
- **WHEN** Planner ghi một task vào todo.md
- **THEN** task MUST kết thúc bằng `[TỪ DESIGN §N]` hoặc `[GỢI Ý BỔ SUNG]`

#### Scenario: Planner không chắc về domain knowledge
- **WHEN** Planner gặp yêu cầu cần kiến thức miền mà không có trong design.md
- **THEN** Planner ghi vào pre-requisites "User cần chuẩn bị: ..." thay vì tự bịa nội dung

### Requirement: Plan checklist (loop/plan-checklist.md)
File `loop/plan-checklist.md` MUST chứa tiêu chí kiểm tra cho todo.md output:
- Trace check: mọi item có trace reference
- Completeness: mọi Zone có nội dung trong design đều được phân tích
- Actionability: mỗi task có verb + object cụ thể
- Dependencies: tasks xếp theo thứ tự dependency
- 3 tầng: pre-requisites phân theo 3 tầng kiến thức

#### Scenario: Planner tự kiểm tra sau khi ghi
- **WHEN** Planner hoàn tất ghi todo.md
- **THEN** Planner đọc plan-checklist.md và tự verify trước khi trình bày user
