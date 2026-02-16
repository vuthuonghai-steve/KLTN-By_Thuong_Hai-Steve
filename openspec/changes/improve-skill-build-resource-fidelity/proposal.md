## Why

Hiện tại, các Agent Skills (như `activity-diagram-design-analyst`) đang gặp vấn đề về **"Sụt giảm tri thức" (Knowledge Erosion)** trong quá trình build. Dù tài nguyên nghiên cứu (`.skill-context/resources/`) rất chi tiết và chuyên sâu, nhưng khi qua tay `skill-builder`, nội dung thường bị tóm tắt hóa (summarized) quá mức, dẫn đến kết quả build chỉ giữ được ~30-40% hàm lượng thông tin kỹ thuật.

Điều này do `skill-builder` hiện tại tập trung quá nhiều vào tính hợp lệ của cấu trúc (structure) mà thiếu định mức về mật độ thông tin (information density) và độ trung thực (fidelity).

## What Changes

Chúng ta sẽ nâng cấp lõi của `skill-builder` để cưỡng ép quy trình **"High-fidelity Knowledge Transformation"**:
1. Cập nhật `SKILL.md` của builder với Guardrail G9 (Knowledge Fidelity Standard).
2. Nâng cấp `build-guidelines.md` định nghĩa tiêu chuẩn mật độ thông tin.
3. Cải thiện quy trình tạo `todo.md` để mapping tài nguyên rõ ràng hơn.

## Capabilities

### New Capabilities
- `skill-builder-fidelity`: Tiêu chuẩn và quy trình chuyển hóa tri thức đạt độ chính xác 1:1 từ tài nguyên gốc.
- `fidelity-assurance-gate`: Quy trình và công cụ xác thực hàm lượng thông tin của skill sau khi build.

### Modified Capabilities
- `skill-builder-core`: Cập nhật quy trình thực thi phase để hỗ trợ "Double-Pass" (Xây khung -> Bơm tri thức).

## Impact

- **Affected Area**: `.agent/skills/skill-builder/`
- **Dependencies**: Tác động đến cách `skill-planner` tạo ra tasks.
- **Benefits**: Đảm bảo các skill build ra có độ thông tin sâu như chuyên gia thực thụ.
