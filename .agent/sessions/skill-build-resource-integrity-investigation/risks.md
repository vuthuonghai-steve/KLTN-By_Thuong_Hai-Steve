# Risk Analysis: Resource Fidelity (Deep Dive)

## Summary
Phân tích cho thấy sự đứt gãy giữa "Sự tồn tại của tài liệu" (Structure) và "Hàm lượng tri thức" (Semantics). Việc AI mặc định tóm tắt để giảm token làm skill mất đi "linh hồn" là các quy tắc nghiệp vụ đặc thù.

## Risks Table
| # | Risk | Severity | Probability | Impact | Mitigation |
|---|------|----------|-------------|--------|------------|
| 1 | **Knowledge Flattening** | Critical | High | Skill hoạt động ngây ngô, bỏ sót edge case | Guardrail G9: Fidelity Standard |
| 2 | **Semantic Drift via Summary** | Major | Medium | Làm sai lệch ý nghĩa thuật ngữ chuyên môn | Bắt buộc 1-1 term mapping |
| 3 | **Pseudo-Pass Validation** | Major | High | Hệ thống báo PASS nhưng không thực chất | Cập nhật semantic audit check |

## Edge Cases
| # | Case | Expected Behavior | Handling |
|---|------|-------------------|----------|
| 1 | Resource quá lớn (> 500 lines) | Vẫn phải bảo toàn tri thức theo từng phần nhỏ | Phân mảnh task trong todo.md (Step-by-step transformation) |
| 2 | Resource có nội dung lặp lại | Gom nhóm nhưng phải giữ lại các ID khác nhau | Sử dụng bảng (Tables) để đối chiếu |

## Requirements Clarification Needed (Steve confirmed via behavior)
- [x] Áp dụng High-fidelity cho Zone Knowledge & Data.
- [x] Cho phép tóm tắt nhẹ cho Zone Assets (nếu là ví dụ minh họa).
