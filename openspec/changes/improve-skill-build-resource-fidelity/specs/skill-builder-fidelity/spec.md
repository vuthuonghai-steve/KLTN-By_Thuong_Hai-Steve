## ADDED Requirements

### Requirement: Knowledge Fidelity Enforcement (G9)
Hệ thống phải cưỡng ép việc bảo toàn tri thức từ tài nguyên nguồn (Resources) sang kết quả đầu ra (Knowledge/Data). Mọi định nghĩa kỹ thuật, mã định danh (Rule IDs, Error codes) và logic nghiệp vụ phải được chuyển hóa đầy đủ, không được tóm tắt.

#### Scenario: Chuyển hóa file Knowledge từ Resource
- **WHEN** Agent thực hiện Task build file Knowledge từ một file Resource Tier-Critical.
- **THEN** Agent phải trích xuất ít nhất 90% các thông tin kỹ thuật định danh và không được sử dụng các cụm từ tóm tắt như "Và các bước tương tự...".

### Requirement: Double-Pass Transformation
Quy trình build phải bao gồm 2 lượt: 1 lượt xây dựng cấu trúc và 1 lượt "Infusion" (truyền tri thức) để đảm bảo mật độ thông tin.

#### Scenario: Build Phase Implementation
- **WHEN** Agent hoàn thành việc tạo các file trong một Phase.
- **THEN** Agent phải thực hiện một lượt rà soát lại (Refinement Pass) đối chiếu với Resource để bổ sung các chi tiết còn thiếu.
