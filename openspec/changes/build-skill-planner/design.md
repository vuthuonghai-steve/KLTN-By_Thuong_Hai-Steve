## Context

Thiết kế chi tiết đã được hoàn tất bởi Skill Architect và ghi tại
`.skill-context/skill-planner/design.md`. Bản thiết kế đã qua 3 phases
(Collect → Analyze → Design) với 4 decisions confirmed (P-D1→P-D4).

Lịch sử thảo luận lưu tại `workspace/History-architect/skill-planner/`.

## Goals / Non-Goals

**Goals:**
- Tạo Agent Skill `skill-planner` hoạt động như Senior Skill Planner
- Implement flow liên tục Read → Analyze → Write, confirm cuối
- Tạo `knowledge/skill-packaging.md` với mô hình 3 tầng kiến thức + chống ảo giác
- Tạo `loop/plan-checklist.md` để kiểm tra chất lượng output

**Non-Goals:**
- Không triển khai Skill #3 (Builder) trong change này
- Không tạo scripts/ hay templates/ — Planner dùng template có sẵn từ init_context
- Planner KHÔNG tự tìm kiếm tài liệu — chỉ liệt kê

## Decisions

### D1: Flow liên tục (P-D4)
**Chọn**: Read → Analyze → Write một mạch, confirm ở cuối
**Lý do**: Input (design.md) đã được confirmed bởi Architect, không cần re-confirm giữa chừng
**Thay thế bỏ qua**: Multi-phase với interaction points — quá nặng cho task phân rã

### D2: Knowledge nền thay vì dựa hoàn toàn vào design.md (P-D2)
**Chọn**: File `skill-packaging.md` riêng cho Planner
**Lý do**: Planner cần hiểu cách đóng gói kỹ năng con người → agent skill, và cần cơ chế chống ảo giác. Design.md chỉ cho biết CẦN GÌ, skill-packaging cho biết LÀM THẾ NÀO
**Thay thế bỏ qua**: Dựa hoàn toàn vào design.md — thiếu meta-knowledge

### D3: Cấu trúc gọn nhẹ 3/7 Zones
**Chọn**: Chỉ Core + Knowledge + Loop
**Lý do**: Output là markdown, không cần scripts (automation) hay templates (dùng sẵn) hay data (config) hay assets (media)

## Risks / Trade-offs

- **Risk**: AI bịa kiến thức domain khi phân tích 3 tầng
  → **Mitigation**: G1 (trace bắt buộc) + G2 (đánh dấu nguồn `[TỪ DESIGN]` vs `[GỢI Ý]`)

- **Risk**: Tasks trong todo.md quá chung chung để hành động
  → **Mitigation**: plan-checklist → mỗi task phải actionable (có verb + object cụ thể)

- **Risk**: Bỏ sót Zone khi phân rã design.md
  → **Mitigation**: plan-checklist → đối chiếu mọi Zone trong design.md §3
