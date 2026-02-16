## Context

Quy trình build skill hiện tại (`skill-builder`) đang bị mất mát thông tin nghiêm trọng do "Thành kiến tóm tắt" của AI. Chúng ta cần thiết lập các rào cản kỹ thuật (Guardrails) và quy trình (Workflow) để bảo đảm tri thức được chuyển hóa nguyên vẹn.

## Goals / Non-Goals

**Goals:**
- Nâng cấp `skill-builder/SKILL.md` với Guardrail G9.
- Nâng cấp `build-guidelines.md` để hướng dẫn chi tiết về mật độ thông tin.
- Cập nhật persona "Senior Implementation Engineer" của builder để đề cao tính chính xác 1:1.

**Non-Goals:**
- Tự động hóa 100% việc copy nội dung (vẫn cần Agent xử lý thông minh để format MD).
- Thay đổi cấu trúc 7-zone hiện tại của Skills.

## Decisions

1. **Decision: Guardrail G9 - Knowledge Fidelity Standard**
   - Rationale: Cần một luật "cứng" để ngăn AI tự ý tóm tắt.
   - Impact: Agent sẽ dành nhiều token hơn để mô tả chi tiết, nhưng kết quả sẽ chuyên sâu hơn.

2. **Decision: Double-Pass Transformation Flow**
   - Rationale: AI thường mệt mỏi hoặc quên chi tiết khi build file dài. Việc chia làm 2 lượt (Structure -> Infusion) giúp tập trung vào mật độ thông tin ở lượt thứ 2.

3. **Decision: Explicit Task Descriptions**
   - Rationale: Thay vì task chung chung, chúng ta sẽ hướng dẫn Agent sử dụng các động từ mạnh `Implement Exhaustively` trong `todo.md`.

## Risks / Trade-offs

- **Risk: Context Overflow** 
  - Trade-off: Các file kiến thức quá chi tiết có thể làm tốn dung lượng context của Agent. 
  - Mitigation: Sử dụng Progressive Disclosure (PD) hiệu quả để chỉ nạp những file cần thiết.
- **Risk: Increased Token Usage**
  - Trade-off: Quá trình build sẽ chậm hơn và tốn phí token hơn do yêu cầu viết chi tiết.
  - Mitigation: Đáng giá để đổi lấy chất lượng skill "Expert".
