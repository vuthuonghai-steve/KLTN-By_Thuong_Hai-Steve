# Risk Analysis: Resource Fidelity & Information Density

## Task từ ai-orchestration
Nghiên cứu nguyên nhân và đề xuất cải thiện việc chuyển hóa tài nguyên tri thức từ `.skill-context/` sang `.agent/skills/` nhằm đảm bảo hàm lượng thông tin cao nhất.

## 1. Phân Tách Vấn Đề (Decompose)

### 1.1 Technical Layers
- **Source Artifacts**: `resources/*.md` (Tri thức thô), `data/*.yaml` (Luật cứng).
- **Target Artifacts**: `knowledge/*.md`, `data/*.yaml`.
- **Transformation Engine**: Các Agent (Implementing Agent) điều hướng bởi `SKILL.md` và `todo.md`.
- **Validation Engine**: `validate_skill.py`.

### 1.2 Các Khía Cạnh Cần Phân Tích
1. **The "Summarization Trap"**: Cơ chế AI tự động nén thông tin.
2. **Instruction Ambiguity**: Sự khác biệt giữa "Based on" và "High-fidelity Implementation".
3. **Validation Gap**: Các quy tắc hiện tại chỉ kiểm tra "SỰ TỒN TẠI" thay vì "CHẤT LƯỢNG NỘI DUNG".
4. **Context Balance**: Rủi ro khi làm phình file quá mức dẫn đến "Context Rot" (mất tập trung khi file quá dài).

---

## 2. Các Hidden Risks Phát Hiện Sơ Bộ

| # | Risk | Severity | Mô tả |
|---|------|----------|-------|
| 1 | **Knowledge Erosion** | **Critical** | Tri thức quý giá trong resource (vd: cách xử lý deadlock) bị tóm tắt thành "Xử lý lỗi cơ bản", dẫn đến skill build ra bị ngây ngô. |
| 2 | **Validation Illusion** | **Major** | Script báo PASS nhưng thực chất nội dung bên trong rỗng tuếch hoặc sai lệch. |
| 3 | **Planning Disconnect** | **Major** | Planner tạo task quá ngắn gọn, không cưỡng ép Builder phải đọc sâu resource. |
| 4 | **Fidelity Bloat** | **Minor** | Ép copy 100% tài nguyên có thể bao gồm cả noise hoặc các phần không liên quan, làm nhiễu skill. |

---

## 3. Requirements Clarification Needed
- [ ] Định nghĩa "High-fidelity" là bao nhiêu %? (Vd: Bảo toàn 100% định nghĩa kỹ thuật, cho phép gom nhóm các ví dụ tương tự).
- [ ] Có cần công cụ so sánh độ dài (Length Ratio) giữa source và target không?
- [ ] Làm thế nào để xử lý các tài nguyên cực lớn (> 500 lines) mà không làm "nổ" context của Agent?
