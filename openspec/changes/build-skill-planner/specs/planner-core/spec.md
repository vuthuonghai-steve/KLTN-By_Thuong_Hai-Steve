## ADDED Requirements

### Requirement: Skill Planner persona và boot sequence
Khi skill-planner được kích hoạt, AI agent SHALL đọc SKILL.md trước tiên
và nhận vai trò Senior Skill Planner. AI MUST đọc `knowledge/skill-packaging.md`
làm nền tảng về đóng gói kỹ năng trước khi bắt đầu flow.

#### Scenario: Skill được kích hoạt
- **WHEN** user kích hoạt skill-planner (qua mention hoặc description match)
- **THEN** AI đọc SKILL.md, đọc knowledge/skill-packaging.md, nhận persona Senior Skill Planner

### Requirement: Bước READ — Đọc input
AI agent SHALL đọc design.md từ `.skill-context/{skill-name}/` làm ground truth.
AI MUST đọc resources/ và context prompt nếu có. AI MUST xác định skill-name
từ user input hoặc từ design.md metadata.

#### Scenario: Đọc design.md thành công
- **WHEN** user cung cấp skill-name và design.md tồn tại tại `.skill-context/{skill-name}/design.md`
- **THEN** AI đọc design.md, extract Zone Mapping (§3), và chuẩn bị cho bước Analyze

#### Scenario: design.md không tồn tại
- **WHEN** `.skill-context/{skill-name}/design.md` không tồn tại hoặc rỗng
- **THEN** AI thông báo lỗi, hướng dẫn user chạy Skill Architect trước

#### Scenario: resources/ có tài liệu
- **WHEN** `.skill-context/{skill-name}/resources/` chứa files
- **THEN** AI đọc và tích hợp nội dung vào phân tích

### Requirement: Bước ANALYZE — Phân tích 3 tầng kiến thức
AI agent SHALL phân tích mỗi Zone có nội dung trong design.md §3 Zone Mapping
theo 3 tầng: Domain (kiến thức miền), Technical (kỹ thuật), Packaging (đóng gói).
Kết quả phân tích MUST sinh ra pre-requisite entries và task entries.

#### Scenario: Phân tích Zone có nội dung
- **WHEN** design.md §3 ghi Zone Knowledge cần "UML standards, Mermaid syntax"
- **THEN** AI phân tích: Tầng 1 (Domain) = hiểu UML, Tầng 2 (Technical) = Mermaid syntax, Tầng 3 (Packaging) = ghi vào knowledge/ files

#### Scenario: Zone không cần
- **WHEN** design.md §3 ghi Zone Assets = "Không cần"
- **THEN** AI bỏ qua Zone này, không sinh task

#### Scenario: Phân tích tạo trace
- **WHEN** AI sinh task từ Zone analysis
- **THEN** mỗi task MUST chứa trace reference `[TỪ DESIGN §N]` hoặc `[GỢI Ý BỔ SUNG]`

### Requirement: Bước WRITE — Ghi todo.md
AI agent SHALL ghi kết quả phân tích vào `.skill-context/{skill-name}/todo.md`.
File MUST chứa 5 sections theo template: Pre-requisites, Phase Breakdown,
Knowledge & Resources Needed, Definition of Done, Notes.

#### Scenario: Ghi todo.md thành công
- **WHEN** AI hoàn tất phân tích
- **THEN** AI ghi todo.md với 5 sections, mọi task có checkbox `- [ ]`, mọi item có trace

#### Scenario: todo.md đã tồn tại
- **WHEN** `.skill-context/{skill-name}/todo.md` đã có nội dung
- **THEN** AI hỏi user: ghi đè hay bổ sung

### Requirement: Confirm ở cuối
AI agent SHALL trình bày todo.md cho user sau khi ghi. AI MUST chờ user
confirm hoặc phản hồi. Nếu user cần sửa, AI cập nhật todo.md và trình bày lại.

#### Scenario: User confirm
- **WHEN** user xác nhận todo.md ổn
- **THEN** AI đánh dấu hoàn tất

#### Scenario: User cần sửa
- **WHEN** user phản hồi cần thay đổi
- **THEN** AI cập nhật todo.md theo phản hồi và trình bày lại

### Requirement: 5 Guardrails
AI agent MUST tuân thủ:
- G1: Mọi item PHẢI trace về design.md `§N`
- G2: Đánh dấu `[TỪ DESIGN]` vs `[GỢI Ý BỔ SUNG]`
- G3: Chỉ phân rã, không phát minh requirements mới
- G4: Liệt kê kiến thức cần, không tự tìm/search
- G5: Neo vào design.md là ground truth, thiếu thì ghi Notes

#### Scenario: AI phát hiện thiếu info trong design.md
- **WHEN** design.md không rõ ràng về một Zone
- **THEN** AI ghi vào Notes section trong todo.md, đánh dấu `[CẦN LÀM RÕ]`

#### Scenario: AI muốn thêm requirement mới
- **WHEN** AI thấy cần thêm thứ gì đó ngoài design.md
- **THEN** AI ghi vào với tag `[GỢI Ý BỔ SUNG]`, không ghi là `[TỪ DESIGN]`
