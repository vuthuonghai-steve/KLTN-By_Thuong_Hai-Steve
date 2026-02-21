# Scoring Criteria — Rubric tự đánh giá chất lượng Design

> Tài liệu domain cho `knowledge/scoring-rubric.md`
> Định nghĩa benchmark 1–5 cho từng section trong `design.md` nhằm đảm bảo tính sẵn sàng cho Planner và Builder.

---

## 1. Benchmark chung (Core Rubric)

| Score | Trạng thái | Mô tả chi tiết | Hành động tiếp theo |
| :--- | :--- | :--- | :--- |
| **5** | **Gold Standard** | Thông tin tuyệt đối rõ ràng, 100% trace được từ requirements. Builder/Planner có thể implement ngay mà không cần bất kỳ quyết định suy diễn nào. | Pass gate ngay lập tức. |
| **4** | **High Quality** | Cấu trúc tốt, thông tin đầy đủ. Chỉ có một vài chi tiết cực nhỏ có thể được tối ưu thêm bởi AI trong quá trình build (không ảnh hưởng logic chính). | Pass gate. |
| **3** | **Acceptable** | Đạt yêu cầu tối thiểu. Đủ thông tin để build nhưng buộc Planner/Builder phải tự đưa ra 1-2 quyết định nhỏ (vd: chọn kiểu diagram, chọn tên biến phụ). | Pass gate nhưng cần highlight rủi ro nhẹ. |
| **2** | **Need Rework** | Thiếu thông tin quan trọng hoặc logic có điểm mâu thuẫn. AI phải suy đoán (hallucinate) để lấp đầy khoảng trống nếu tiếp tục. | **RE-WORK section này ngay lập tức.** |
| **1** | **Unusable** | Thiếu nội dung cơ bản, sai format contract (§3), hoặc hoàn toàn bịa đặt thông tin. | **STOP + RE-WRITE hoàn toàn.** |

---

## 2. Tiêu chí cho từng Section (§1 - §10)

### §1. Problem Statement

- **Score 5**: Xác định rõ Pain Point thực tế, User cụ thể (Persona), và Output mong đợi.
- **Penalty (-1)**: Không giải thích được "Lý do cần skill" (Business Value).
- **Penalty (-1)**: Mô tả chung chung, không có ranh giới (scope) rõ ràng.

### §2. Capability Map

- **Score 5**: Phân tách rõ ràng 3 Pillars (Knowledge, Process, Guardrails). Knowledge có file cụ thể, Process có workflow logic, Guardrails giải quyết trực tiếp pain points v1.
- **Penalty (-1)**: Knowledge zone chỉ liệt kê chung chung, không có tên file hoặc link resource.

### §3. Zone Mapping (CRITICAL CONTRACT)

- **Score 5**: Mọi Zone hoạt động đều có ít nhất 1 file kèm tên file cụ thể (regex compliant). Cột nội dung mô tả chính xác trách nhiệm file.
- **Penalty (-2)**: Tên file là placeholder (vd: `{name}_skill.md`) hoặc quá chung chung (vd: `utils.js`).
- **Penalty (-1)**: Thiếu cột "Bắt buộc?" hoặc "Nội dung".

### §4. Folder Structure

- **Score 5**: Sơ đồ Mermaid khớp 100% với danh sách files ở §3. Phản ánh đúng 7 Zones framework.
- **Penalty (-1)**: Mermaid syntax lỗi hoặc không khớp với logic ở §3.

### §5. Execution Flow

- **Sequence Diagram (D2)**: Mô tả rõ runtime tương tác giữa User, Skill, và các Files.
- **Adaptive Workflow (D3)**: Mô tả rõ logic rẽ nhánh Simple/Medium/Complex.
- **Penalty (-1)**: Thiếu Interaction Points (IP) trong sơ đồ.

### §6. Interaction Points

- **Score 5**: Định nghĩa rõ thời điểm dừng, lý do dừng và câu hỏi cụ thể của AI cho từng IP.
- **Penalty (-1)**: Thiếu gate blocking (ví dụ: chỉ thông báo mà không chờ user confirm).

### §7. Progressive Disclosure Plan

- **Score 5**: Phân loại rõ Tier 1 (Load ngay) và Tier 2 (Load khi cần). Quy tắc load logic.
- **Penalty (-1)**: Không có logic kích hoạt (khi nào đọc file nào).

### §8. Risks & Blind Spots

- **Score 5**: Tối thiểu 3 rủi ro thực tế (P0/P1) kèm biện pháp Mitigation (phòng ngừa) cụ thể.
- **Penalty (-2)**: Có risk nhưng mitigation ghi "Sẽ cẩn thận hơn" (không có cơ chế code/loop).

### §9. Open Questions

- **Score 5**: Danh sách câu hỏi rõ ràng hoặc ghi "Đã resolve" kèm quyết định cuối cùng.
- **Score 1**: Bỏ trống trong khi logic design còn nhiều điểm mơ hồ.

### §10. Metadata

- **Score 5**: Đầy đủ Version, Status, Phase Tags, và Handoff Checklist.
- **Penalty (-1)**: Version không nhảy hoặc phase-tag không khớp thực tế.

---

## 3. Hệ thống điểm trừ (Penalty Rules)

1. **Contract Violation**: Bất kỳ lỗi logic nào vi phạm "Zone Mapping Contract" (vd: sai regex tên file) → Tự động trừ 2 điểm ở §3.
2. **Hallucination Alert**: AI tự bịa ra resource không tồn tại trong input mà không đánh dấu là "Giả định" → Tự động trừ 2 điểm toàn design.
3. **Guardrail Bypass**: Design không giải quyết được ít nhất 1 Pain Point đã nêu ở §1 → Tự động trừ 1 điểm ở §2 và §8.

---

## 4. Ngưỡng chặn (Blocking Threshold)

- **Total Average Score < 3.5**: Không được phép deliver design.md.
- **Any Critical Section (§3, §5, §8) < 3**: Bắt buộc loop re-work cho đến khi đạt điểm.
