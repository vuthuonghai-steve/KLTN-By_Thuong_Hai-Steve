## Yêu Cầu Gốc
Nghiên cứu đào sâu về vấn đề không sử dụng đúng và đủ lượng tài nguyên cung cấp trong quá trình build skill. Làm rõ điểm cần khắc phục và cải thiện từ phía skill-builder hay các vị trí khác.

## Kết Quả Nghiên Cứu Đào Sâu (Root Cause Analysis)

### 1. Đứt gãy tại Tooling (Skill Builder)
- **Thiếu Guardrail nội dung**: `skill-builder/SKILL.md` hiện tại chỉ nhấn mạnh vào cấu trúc (structure) và link, chưa có quy định về **mật độ thông tin (information density)**.
- **Mơ hồ trong định nghĩa "Derive"**: Cụm từ "dẫn nguồn từ resources/" bị AI hiểu nhầm thành "tóm tắt từ resources/".

### 2. Đứt gãy tại Lập kế hoạch (Architect/Planner)
- **Task thiếu tính "Full-fidelity"**: `todo.md` mô tả task theo kiểu "Tạo file X", không kèm theo điều kiện "Chuyển hóa 100% nội dung kỹ thuật".
- **Thiếu mapping chi tiết**: Không chỉ định rõ đoạn nào trong resource cần map vào đoạn nào trong kết quả.

### 3. Thành kiến mô hình (Default AI Bias)
- **Summarization Bias**: Mặc định, LLM ưu tiên tóm tắt để giảm token và tăng tính súc tích. Điều này gây hại cho các tài liệu tri thức kỹ thuật cần độ chính xác 1-1.

## Đề Xuất Cải Tiến (The "Hard-Link" Approach)

1. **Nâng cấp Builder Skill**:
   - Thêm Guardrail **"Bảo toàn tri thức"**: Cấm tóm tắt tài nguyên Critical.
   - Thêm cơ chế **Double-Pass**: Lần 1 tạo cấu trúc, lần 2 điền chi tiết từ Resource.

2. **Chuẩn hóa Todo/Design**:
   - Sử dụng các động từ mạnh: `Transform 100%`, `Exhaustive Implementation`, `Implement with high-fidelity`.
   - Bắt buộc đính kèm line-range hoặc section-range từ resource vào task.

3. **Validation Kỹ thuật**:
   - Thêm script check dung lượng/mật độ từ khóa giữa source và result (Semantic audit).
