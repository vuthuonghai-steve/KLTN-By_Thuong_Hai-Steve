## Why

Sau khi Skill Architect tạo bản thiết kế kiến trúc (design.md), người dùng không biết
bắt đầu từ đâu, cần chuẩn bị kiến thức gì (domain, technical, packaging), và triển khai
theo thứ tự nào. Cần một skill chuyên biệt (**Skill Planner**) đọc design.md và tạo
kế hoạch triển khai chi tiết với traceability về thiết kế gốc.

Đây là skill #2 trong bộ Master Skill Suite (Architect → **Planner** → Builder).

## What Changes

- Tạo mới Agent Skill `skill-planner` tại `.agent/skills/skill-planner/`
- Tạo `SKILL.md` với persona Senior Skill Planner, flow Read→Analyze→Write, 5 guardrails
- Tạo `knowledge/skill-packaging.md` — kiến thức đóng gói human skill thành agent skill (3 tầng, checklist chuyển đổi, chống ảo giác)
- Tạo `loop/plan-checklist.md` — kiểm tra chất lượng todo.md output

## Capabilities

### New Capabilities
- `planner-core`: Persona, workflow Read→Analyze→Write, 5 guardrails, output spec cho todo.md
- `skill-packaging-knowledge`: Knowledge file về đóng gói kỹ năng (3 tầng Domain→Technical→Packaging, checklist chuyển đổi, nguyên tắc chống ảo giác)

### Modified Capabilities
_(Không có — đây là skill mới hoàn toàn)_

## Impact

- **File system**: Tạo thư mục `.agent/skills/skill-planner/` với ~4 files
- **Dependencies**: Phụ thuộc vào output của Skill Architect (design.md) và init_context đã chạy sẵn
- **Liên quan**: Skill #3 (Builder) sẽ phụ thuộc output của skill này (todo.md), nhưng chưa triển khai ở change này
