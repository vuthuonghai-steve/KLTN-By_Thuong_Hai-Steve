## Context

Dự án Agent-skill sử dụng hệ thống Agent Skill (`.agent/skills/`) để mở rộng khả năng
của AI Agent. Tài liệu kiến trúc `architect.md` đã định nghĩa framework chuẩn gồm:
- **Mô hình Meta-Skill Framework**: 3 pha (Nhận diện → Chiến lược → Thực thi)
- **Kiến trúc "Ngôi nhà"**: 3 Trụ cột (Knowledge, Process, Guardrails)
- **7-Zone Architecture**: Core, Knowledge, Scripts, Templates, Data, Loop, Assets
- **Workflow xây dựng 5 bước**: Khảo sát → Thiết kế → Xây dựng → Kiểm định → Bảo trì

Skill Architect là skill #1 trong bộ Master Skill Suite (3 skill độc lập). Bộ 3 skill
chia sẻ context qua thư mục `.skill-context/` tại root dự án, mỗi skill đang xây dựng
có sub-folder riêng.

Thiết kế chi tiết đã được thảo luận và ghi nhận trong `.skill-context/DESIGN.md`
với 10 decisions đã confirmed (D1→D10).

## Goals / Non-Goals

**Goals:**
- Tạo Agent Skill `skill-architect` hoạt động như Senior Skill Architect
- Implement workflow 3 phases: Collect → Analyze → Design
- Tạo script `init_context.py` khởi tạo `.skill-context/{skill-name}/` tự động
- Tạo bộ 3 file templates chuẩn cho output
- Đảm bảo mọi thiết kế áp dụng framework từ `architect.md` (3 Trụ + 7 Zones)

**Non-Goals:**
- Không triển khai Skill #2 (Planner) hoặc Skill #3 (Builder) trong change này
- Không viết code ứng dụng — skill này chỉ thiết kế, không implement
- Không tạo test automation cho skill (sẽ làm ở phase sau nếu cần)

## Decisions

### D1: Workflow 3 Phases
**Chọn**: Collect → Analyze → Design (tuần tự, mỗi phase có interaction point)
**Lý do**: Map trực tiếp vào Bước 1-2 của workflow 5 bước trong `architect.md`.
Phase Collect thu thập input, Phase Analyze áp framework, Phase Design xuất output.
**Thay thế bỏ qua**: Single-phase (hỏi + thiết kế cùng lúc) — dễ bỏ sót chi tiết.

### D2: Init Script (Python)
**Chọn**: Python script `init_context.py` để tạo thư mục và file template
**Lý do**: Chuẩn hóa cấu trúc, tránh lỗi tay, tránh thiếu file. Python vì logic
đơn giản, chỉ cần stdlib (os, pathlib, datetime).
**Thay thế bỏ qua**: Bash script — kém portable; Tạo thủ công — dễ sai.

### D3: Project Root Detection
**Chọn**: Tìm thư mục `.agent/` để xác định project root
**Lý do**: Skill luôn nằm trong `.agent/skills/`, nên `.agent/` là marker đáng tin cậy.
**Thay thế bỏ qua**: Dùng cwd — không đáng tin nếu gọi từ sub-directory.

### D4: Template với Heading Sẵn
**Chọn**: Mỗi file template có heading framework sẵn (không để trống)
**Lý do**: Hướng dẫn AI/user điền đúng nội dung, đảm bảo output nhất quán.
**Thay thế bỏ qua**: File trống — mất chuẩn, AI có thể tự ý đặt format khác.

### D5: Safe-Create Policy
**Chọn**: Script KHÔNG ghi đè file đã tồn tại
**Lý do**: Bảo toàn context cũ, tránh mất dữ liệu khi chạy lại script.

## Risks / Trade-offs

- **Risk**: AI agent không follow đúng 3 phases, nhảy thẳng vào Design
  → **Mitigation**: Guardrails trong SKILL.md bắt buộc interaction point sau mỗi phase

- **Risk**: Template quá cứng, không phù hợp mọi loại skill
  → **Mitigation**: Template chỉ là heading framework, nội dung linh hoạt. Có thể update template theo feedback

- **Risk**: `init_context.py` không tìm được `.agent/` nếu chạy từ thư mục khác
  → **Mitigation**: Script walk up từ cwd, tối đa 10 levels. Nếu không tìm thấy, báo lỗi rõ ràng
