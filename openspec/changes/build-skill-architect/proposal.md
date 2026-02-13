## Why

Hiện tại, khi người dùng muốn xây dựng một Agent Skill mới, quá trình thu thập ý tưởng
và thiết kế kiến trúc diễn ra không có cấu trúc — dẫn đến skill thiếu thành phần,
thiết kế không nhất quán, và AI không có framework rõ ràng để phân tích yêu cầu.

Cần một skill chuyên biệt (**Skill Architect**) đóng vai Senior Architect, sử dụng
`architect.md` làm nền tảng để phân tích yêu cầu và xuất ra bản thiết kế kiến trúc
chuẩn cho bất kỳ skill nào người dùng muốn xây dựng.

Đây là skill #1 trong bộ 3 skill của Master Skill Suite (Architect → Planner → Builder).

## What Changes

- Tạo mới Agent Skill `skill-architect` tại `.agent/skills/skill-architect/`
- Tạo `SKILL.md` với persona Senior Skill Architect và workflow 3 phases (Collect → Analyze → Design)
- Tạo `scripts/init_context.py` để tự động khởi tạo thư mục `.skill-context/{skill-name}/` với các file template
- Tạo 3 file templates (`design.md.template`, `todo.md.template`, `build-log.md.template`) với khung heading chuẩn
- Tạo `knowledge/architect.md` (copy chuẩn framework kiến trúc)
- Tạo `loop/design-checklist.md` để kiểm tra chất lượng bản thiết kế

## Capabilities

### New Capabilities
- `skill-architect-core`: Persona, workflow 3 phases (Collect → Analyze → Design), guardrails, và interaction points
- `context-init`: Script Python tự động tạo cấu trúc thư mục `.skill-context/` và sub-folder cho mỗi skill cần xây dựng
- `design-templates`: Bộ 3 file templates chuẩn cho output của cả workflow (design.md, todo.md, build-log.md)

### Modified Capabilities
_(Không có — đây là skill mới hoàn toàn)_

## Impact

- **File system**: Tạo thư mục `.agent/skills/skill-architect/` với ~8 files
- **Runtime**: Khi skill được kích hoạt, sẽ tạo `.skill-context/` tại root dự án
- **Dependencies**: Không có dependency ngoài (chỉ dùng Python stdlib cho script)
- **Liên quan**: Skill #2 (Planner) và Skill #3 (Builder) sẽ phụ thuộc vào output của skill này, nhưng chưa triển khai ở change này
