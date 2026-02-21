# Phase Verification Checklist — Quality Gates

> **Usage**: Dùng ở cuối mỗi Phase (COLLECT, ANALYZE, DESIGN) để tự kiểm tra chất lượng trước khi mở gate Interaction Point (IP). Đảm bảo không có sai sót ngớ ngẩn trước khi làm phiền User.

---

## 1. Phase: DETECT (Auto-classification)

- [ ] Mức độ Complexity (Simple/Medium/Complex) đã được xác định rõ ràng?
- [ ] Lý do phân loại (dựa trên zones, files, dependency) có đủ thuyết phục?
- [ ] Đã áp dụng đúng Tie-breaker rules nếu nằm ở ranh giới?
- [ ] **IP-1**: Câu hỏi xác nhận với User đã chuẩn bị sẵn sàng (ngắn gọn, tập trung)?

---

## 2. Phase: COLLECT (Information Gathering)

- [ ] Đạt được sự tự tin (Confidence) ≥ 70% về các thông tin thu thập?
- [ ] **Summary Check**: Đã đủ 3 mấu chốt trọng tâm (Pain Point + User + Output)?
- [ ] Không đặt lại những câu hỏi mà User đã cung cấp thông tin ở Prompt đầu tiên?
- [ ] **IP-2**:Summary đã được trình bày dưới dạng danh sách điểm tin để User dễ confirm?

---

## 3. Phase: ANALYZE (Logic & Contract)

- [ ] **§2 Capability Map**: Đã ánh xạ đủ 3 Pillars (Knowledge, Process, Guardrails)?
- [ ] **§3 Zone Mapping**: Mọi Zone đều có Tên File cụ thể?
- [ ] **Regex Compliance**: Tất cả tên file khớp format `[a-z][a-z0-9_\-]+\.[a-z]+`? (CHỈ dùng script validate nếu có, hoặc kiểm tra bằng mắt).
- [ ] **§8 Risks**: Có tối thiểu 3 rùi ro thực tế kèm Mitigation có thể thực hiện được?
- [ ] **IP-3**: Đã trình bày bảng §3 và các Pillar quan trọng cho User?

---

## 4. Phase: DESIGN (Visualization & Scoring)

- [ ] **Mermaid Diagrams**: Đã tạo tối thiểu 3 sơ đồ (Folder, D2 Sequence, D3 Flow)?
- [ ] **§6 Interaction Points**: Danh sách IP đã khớp 100% với logic rẽ nhánh của workflow?
- [ ] **Self-scoring**: Đã thực hiện chấm điểm 1–5 cho tất cả 10 sections dựa trên `scoring-rubric.md`?
- [ ] **Score Threshold**: Tất cả các mục quan trọng (§3, §5, §8) đạt ≥ 3 điểm? 
- [ ] **IP-4**: Đã trình bày bản `design.md` hoàn chỉnh kèm điểm số (nếu có mục < 3)?

---

## 5. Sim-test: Planner Simulation (Gatekeeper Test)

> Thử đóng vai **skill-planner** đọc bản thiết kế này.

- [ ] Tôi có thể liệt kê được ít nhất 5 task nhỏ có thể thực hiện được ngay từ bảng §3 không?
- [ ] Tôi có biết phải tạo file nào trước, file nào sau không?
- [ ] Tôi có đủ thông tin để viết `README.md` hướng dẫn cho Builder không?

**Kết quả**: Nếu "Không" cho bất kỳ câu hỏi nào → Quay lại sửa §3.
