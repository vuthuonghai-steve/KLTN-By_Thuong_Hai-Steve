## Why

Khi làm việc với AI Agents (Claude Code CLI, Cursor IDE, Antigravity), AI thường:
- Đề xuất kiến trúc khác với `architect.md` mà không xác nhận
- Chuyển sang viết code sản phẩm khi chỉ được yêu cầu thiết kế skill
- Tạo file/thư mục ngoài zones chuẩn
- Bỏ qua loop/verify trong workflow

Cần thiết lập **rule files** rõ ràng để AI tuân thủ architect.md và quy trình làm việc của dự án.

## What Changes

- Tạo bộ rule files trong `.agent/rules/` với định dạng Markdown
- Rule files bao gồm: project context, architecture alignment, workflow discipline, interaction protocol, forbidden patterns
- Mỗi rule file có 2 phiên bản: Tiếng Anh (cho AI đọc) và Tiếng Việt (tạm thời cho user review)
- Thêm INDEX.md để AI có thể quick reference

## Capabilities

### New Capabilities
- `project-rules`: Bộ rule files hướng dẫn AI Agent tuân thủ architect.md, workflow 5 bước, zones chuẩn, và interaction protocol

### Modified Capabilities
<!-- Không có capability nào đang tồn tại cần sửa đổi -->

## Impact

- **Affected locations**: `.agent/rules/` (tạo mới các file .md)
- **Related files**: `architect.md` (nguồn tham chiếu chính)
- **AI Agents affected**: Claude Code CLI, Cursor IDE, Antigravity
- **User workflow**: Sau khi triển khai, AI sẽ tự động đọc rules và tuân thủ
