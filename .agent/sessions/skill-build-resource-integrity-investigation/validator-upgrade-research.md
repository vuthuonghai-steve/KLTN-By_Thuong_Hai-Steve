# Technical Research: Semantic Fidelity Validator (v2.0 Proposal)

## Concept
Validator hiện tại chỉ kiểm tra "SỰ TỒN TẠI" (Structural). Chúng ta cần một lớp kiểm tra "CHẤT LƯỢNG NỘI DUNG" (Semantic) bằng cách đối chiếu Identifiers từ Resource sang kết quả Build.

## Logic đề xuất cho `validate_skill.py`

### 1. Hàm `extract_technical_identifiers(content)`
- Sử dụng Regex để trích xuất các mã định danh có cấu trúc:
  - Rule IDs: `[A-Z]{2,}-\d+` (Vd: CF-01, UML-23)
  - Error Codes: `[E]\d{2,}` (Vd: E01, E404)
  - CamelCase/PascalCase Technical Terms.

### 2. Hàm `check_fidelity_score(source_path, target_path)`
- **Input**: Đường dẫn file Resource và file Knowledge tương ứng.
- **Process**:
  - Trích xuất IDs từ source.
  - Kiểm tra xem bao nhiêu % IDs đó xuất hiện trong target.
- **Threshold**:
  - > 90%: PASS
  - 50% - 90%: WARNING (Potential Summarization)
  - < 50%: FAIL (Information Density too low)

### 3. Tích hợp vào CLI
- Thêm flag `--fidelity` để bật tính năng này (vì nó tốn tài nguyên xử lý hơn).

## Ví dụ minh họa
- **Source**: Chứa 20 quy tắc rủi ro từ `refactor-risk-patterns.md`.
- **Target**: `knowledge/refactor-risk-patterns.md` chỉ liệt kê 5 quy tắc.
- **Kết quả**: Validator báo FAIL: *"Fidelity Check Failed: Only 25% of technical identifiers found. High-fidelity transformation required for Critical resources."*

---

## Conclusion
Việc nâng cấp này sẽ chuyển đổi Validator từ "Người gác cổng" sang "Người thẩm định nội dung", ép buộc Agent phải triển khai triệt để tri thức kỹ thuật.
