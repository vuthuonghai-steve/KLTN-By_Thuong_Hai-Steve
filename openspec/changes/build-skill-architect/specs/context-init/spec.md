## ADDED Requirements

### Requirement: Script init_context.py tạo cấu trúc thư mục
Script Python `init_context.py` SHALL tạo thư mục `.skill-context/` tại root dự án
và sub-folder cho skill cần xây dựng, kèm theo các file context với khung heading sẵn.
Script MUST detect project root bằng cách tìm thư mục `.agent/`.

#### Scenario: Tạo context mới cho skill chưa tồn tại
- **WHEN** user chạy `python scripts/init_context.py my-new-skill`
- **THEN** script tạo `.skill-context/my-new-skill/` với 3 files (design.md, todo.md, build-log.md) và thư mục resources/

#### Scenario: Thư mục .skill-context/ chưa tồn tại
- **WHEN** `.skill-context/` chưa có tại project root
- **THEN** script tạo `.skill-context/` trước, sau đó tạo sub-folder

#### Scenario: Sub-folder đã tồn tại
- **WHEN** `.skill-context/my-skill/` đã tồn tại
- **THEN** script KHÔNG ghi đè files đã có, chỉ tạo files còn thiếu, thông báo trạng thái từng file

### Requirement: Project root detection
Script MUST xác định project root bằng cách walk up từ thư mục hiện tại,
tìm thư mục chứa `.agent/`. Walk tối đa 10 levels. Nếu không tìm thấy,
script MUST exit với error message rõ ràng.

#### Scenario: Script chạy từ root dự án
- **WHEN** cwd chứa `.agent/`
- **THEN** script xác định cwd là project root

#### Scenario: Script chạy từ sub-directory
- **WHEN** cwd là sub-directory (e.g., `.agent/skills/skill-architect/scripts/`)
- **THEN** script walk up và tìm thấy `.agent/` ở ancestor directory

#### Scenario: Không tìm thấy .agent/
- **WHEN** script chạy ngoài project (không có `.agent/` trong 10 levels)
- **THEN** script exit với message: "Error: Could not find .agent/ directory. Run from within the project."

### Requirement: Argument validation
Script MUST nhận đúng 1 argument là tên skill (kebab-case). Nếu thiếu argument
hoặc tên không hợp lệ, script MUST exit với usage message.

#### Scenario: Thiếu argument
- **WHEN** user chạy `python init_context.py` (không có tên skill)
- **THEN** script exit với message: "Usage: python init_context.py <skill-name>"

#### Scenario: Tên skill không hợp lệ
- **WHEN** user chạy với tên chứa ký tự đặc biệt hoặc spaces
- **THEN** script exit với message hướng dẫn dùng kebab-case

### Requirement: File templates được nạp từ templates/
Script SHALL đọc nội dung template từ `templates/*.template` trong skill directory
và thay thế placeholders ({skill_name}, {date}, {author}).

#### Scenario: Templates tồn tại
- **WHEN** script chạy và templates/ có đủ 3 file .template
- **THEN** script đọc template, thay thế placeholders, ghi vào sub-folder

#### Scenario: Templates bị thiếu
- **WHEN** một template file không tồn tại
- **THEN** script tạo file với nội dung fallback tối thiểu (chỉ heading cơ bản) và warning
