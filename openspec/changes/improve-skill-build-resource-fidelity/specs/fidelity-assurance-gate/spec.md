## ADDED Requirements

### Requirement: Information Density Audit
Hệ thống xác thực (Validation) phải có khả năng đánh giá sơ bộ về "mật độ thông tin" giữa nguồn và đích.

#### Scenario: Run validate_skill.py with context check
- **WHEN** Người dùng hoặc Agent chạy script validate.
- **THEN** Script phải kiểm tra sự hiện diện của các mã định danh kỹ thuật (Technical Identifiers) từ Resource trong kết quả Build.

### Requirement: Implementation Fidelity Report
Báo cáo Build-log phải thể hiện rõ mức độ bảo toàn tri thức của từng tài nguyên.

#### Scenario: Generate Resource Usage Matrix
- **WHEN** Agent cập nhật `build-log.md`.
- **THEN** Phải có cột/ghi chú xác nhận tính "High-fidelity" của việc chuyển hóa tri thức cho từng file.
