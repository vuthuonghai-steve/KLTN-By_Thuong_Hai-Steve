# Handoff: Skill Build Resource Fidelity Improvement

## From: ultra-think
## To: implement-workflow

### Task Summary
Nâng cấp hệ thống Skill Suite (Builder, Planner, Validator) để cưỡng ép việc chuyển hóa tri thức từ Resource sang Skill đạt độ chính xác và hàm lượng thông tin cao nhất (High-fidelity).

### Documents Created
1. `risk-analysis-resource-fidelity.md` - Phân tích rủi ro sâu về tóm tắt tri thức.
2. `implementation-guide-fidelity.md` - Hướng dẫn chi tiết cách cấu hình lại SKILL.md và Guidelines.

### Critical Risks (P0/P1)
- **Knowledge Flattening**: Nguy cơ lớn nhất là AI tiếp tục tóm tắt tri thức kỹ thuật thành nội dung phổ thông làm rỗng skill.
- **Solution**: Áp dụng Guardrail G9 và cơ chế "Double-Pass" khi build.

### Implementation Ready
- [x] All risks have mitigations defined in analysis.md and risks.md.
- [x] Requirements clarified: Focus on preservation of identifiers and granular logic.
- [x] Rollback plan: Sao lưu SKILL.md trước khi sửa đổi.

### Next: Run `/implement-workflow`
Vui lòng cập nhật `SKILL.md` và `build-guidelines.md` của `skill-builder` theo hướng dẫn trong `implementation-guide-fidelity.md`.
