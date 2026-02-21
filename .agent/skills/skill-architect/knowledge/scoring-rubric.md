# Scoring Rubric — Tự đánh giá chất lượng thiết kế

> **Usage**: Dùng trong phase **DESIGN** để AI tự chấm điểm bản thiết kế `design.md` trước khi gửi cho User. Giúp phát hiện lỗi sớm và đảm bảo độ chính xác.

---

## 1. Benchmark chung (Core Rubric)

| Score | Trạng thái | Mô tả chi tiết | Hành động |
| :--- | :--- | :--- | :--- |
| **5** | **Gold Standard** | Tuyệt đối rõ ràng, 100% trace được từ requirements. Builder có thể làm ngay. | Pass Gate. |
| **4** | **High Quality** | Cấu trúc tốt, đầy đủ. Chỉ có chi tiết nhỏ cần tối ưu thêm. | Pass Gate. |
| **3** | **Acceptable** | Đạt yêu cầu tối thiểu. Đủ thông tin nhưng Builder cần tự quyết 1-2 điểm nhỏ. | Pass Gate. |
| **2** | **Need Rework** | Thiếu thông tin quan trọng hoặc logic mâu thuẫn. AI phải suy đoán. | **Re-work ngay.** |
| **1** | **Unusable** | Thiếu nội dung cơ bản, sai format contract (§3), hoặc bịa đặt thông tin. | **Re-write hoàn toàn.** |

---

## 2. Tiêu chí cho từng Section (§1 - §10)

### §1. Problem Statement
- **Score 5**: Xác định rõ Pain Point thực tế, User cụ thể, và Output mong đợi.
- **Penalty (-1)**: Không giải thích rõ "Lý do cần skill" (Business Value).

### §2. Capability Map
- **Score 5**: Phân tách rõ 3 Pillars. Knowledge có file cụ thể, Process có logic, Guardrails giải quyết pain points.
- **Penalty (-1)**: Knowledge zone chỉ liệt kê chung chung, không có tên file.

### §3. Zone Mapping (CRITICAL CONTRACT)
- **Score 5**: Mọi Zone hoạt động có file kèm tên file cụ thể (regex compliant). Nội dung mô tả chính xác.
- **Penalty (-2)**: Tên file là placeholder hoặc quá chung chung (vd: `utils.js`).
- **Penalty (-1)**: Thiếu cột "Bắt buộc?" hoặc "Nội dung".

### §4. Folder Structure
- **Score 5**: Sơ đồ Mermaid khớp 100% với §3. Phản ánh đúng 7 Zones.

### §5. Execution Flow
- **D2 Sequence**: Mô tả rõ runtime tương tác (User / Skill / Files).
- **D3 Adaptive**: Mô tả rõ logic rẽ nhánh Simple/Medium/Complex.
- **Penalty (-1)**: Thiếu Interaction Points (IP) trong sơ đồ.

### §6. Interaction Points
- **Score 5**: Định nghĩa rõ thời điểm dừng, lý do và câu hỏi cụ thể cho từng IP.
- **Penalty (-1)**: Thiếu gate blocking (chỉ thông báo mà không chờ confirm).

### §7. Progressive Disclosure Plan
- **Score 5**: Phân loại rõ Tier 1 và Tier 2. Có quy tắc load logic.

### §8. Risks & Blind Spots
- **Score 5**: Tối thiểu 3 rủi ro thực tế kèm Mitigation (phòng ngừa) cụ thể.
- **Penalty (-2)**: Mitigation ghi "Sẽ cẩn thận hơn" (không có cơ chế code/loop).

### §9. Open Questions
- **Score 5**: Danh sách câu hỏi rõ ràng hoặc ghi "Đã resolve" kèm quyết định cuối cùng.
- **Score 1**: Bỏ trống trong khi logic còn mơ hồ.

### §10. Metadata
- **Score 5**: Đầy đủ Version, Status, Phase Tags, và Handoff Checklist.

---

## 3. Quy tắc trừ điểm (Penalty Rules)

1. **Contract Violation**: Sai regex tên file hoặc thiếu cột trong §3 → Trừ 2 điểm tại §3.
2. **Hallucination Alert**: Tự bịa resource không có trong input mà không đánh dấu "Giả định" → Trừ 2 điểm toàn file.
3. **Guardrail Bypass**: Không giải quyết được Pain Point đã nêu ở §1 → Trừ 1 điểm ở §2 và §8.

---

## 4. Ngưỡng chặn (Blocking Threshold)

- **Total Average Score < 3.5**: Không được phép deliver design.md.
- **Any Critical Section (§3, §5, §8) < 3**: Bắt buộc loop re-work cho đến khi đạt điểm.
