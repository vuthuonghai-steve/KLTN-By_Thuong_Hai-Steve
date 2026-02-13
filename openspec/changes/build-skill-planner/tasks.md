## 1. Khởi tạo cấu trúc thư mục

- [x] 1.1 Tạo thư mục `.agent/skills/skill-planner/` với sub-directories: knowledge/, loop/

## 2. Tạo SKILL.md (Core)

- [x] 2.1 Viết SKILL.md với frontmatter (name, description)
- [x] 2.2 Định nghĩa Mission: Senior Skill Planner — đọc design.md và tạo kế hoạch triển khai
- [x] 2.3 Viết Mandatory Boot Sequence: đọc SKILL.md → đọc knowledge/skill-packaging.md
- [x] 2.4 Viết bước READ: đọc design.md (bắt buộc), resources/ (nếu có), context prompt (nếu có). Xử lý lỗi nếu design.md không tồn tại
- [x] 2.5 Viết bước ANALYZE: với mỗi Zone có nội dung trong design.md §3 → phân tích 3 tầng (Domain, Technical, Packaging) → sinh pre-req + tasks với trace
- [x] 2.6 Viết bước WRITE: ghi todo.md theo 5 sections (Pre-reqs, Phases, Resources, DoD, Notes). Xử lý nếu todo.md đã tồn tại
- [x] 2.7 Viết Confirm: trình bày todo.md cho user, chờ confirm hoặc sửa
- [x] 2.8 Viết 5 Guardrails: G1 (trace bắt buộc), G2 (phân biệt nguồn), G3 (không phát minh), G4 (liệt kê không tự làm), G5 (neo design.md)
- [x] 2.9 Viết Error Handling: design.md thiếu → báo lỗi, info không rõ → ghi Notes [CẦN LÀM RÕ]
- [x] 2.10 Viết Output Format: mô tả 5 sections của todo.md và format trace tag

## 3. Tạo knowledge/skill-packaging.md

- [x] 3.1 Viết section "Nguyên tắc đóng gói": Kỹ năng = Kiến thức + Quy trình + Phán đoán → tường minh hóa
- [x] 3.2 Viết section "Mô hình 3 tầng kiến thức": Domain → Technical → Packaging, mỗi tầng có câu hỏi chuẩn
- [x] 3.3 Viết section "Checklist chuyển đổi": 5 câu hỏi cho mỗi Zone (miền, kỹ thuật, quy trình, guardrail, template)
- [x] 3.4 Viết section "Nguyên tắc chống ảo giác": 4 nguyên tắc (trace, không bịa, không đoán, đánh dấu nguồn)

## 4. Tạo loop/plan-checklist.md

- [x] 4.1 Viết checklist kiểm tra todo.md: trace check, completeness, actionability, dependencies, 3 tầng
