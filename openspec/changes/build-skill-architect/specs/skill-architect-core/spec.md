## ADDED Requirements

### Requirement: Skill Architect persona và boot sequence
Khi skill-architect được kích hoạt, AI agent SHALL đọc SKILL.md trước tiên
và nhận vai trò Senior Skill Architect. AI MUST đọc `knowledge/architect.md`
làm nền tảng framework trước khi bắt đầu bất kỳ phase nào.

#### Scenario: Skill được kích hoạt lần đầu
- **WHEN** user kích hoạt skill-architect (qua mention hoặc description match)
- **THEN** AI đọc SKILL.md, đọc knowledge/architect.md, nhận persona Senior Skill Architect

### Requirement: Phase 1 - Thu thập (Collect)
AI agent SHALL thu thập thông tin từ user về skill muốn xây dựng. AI MUST hỏi
tối đa 3 câu hỏi ngắn nếu thiếu thông tin: (1) Pain point, (2) User & Context,
(3) Expected output. AI MUST chạy `init_context.py` để tạo thư mục context
trước khi tiến sang phase tiếp theo.

#### Scenario: User cung cấp đầy đủ thông tin ban đầu
- **WHEN** user mô tả ý tưởng skill kèm pain point, context, và expected output
- **THEN** AI xác nhận lại cách hiểu, chạy init_context.py, và chuyển sang Phase 2

#### Scenario: User cung cấp thông tin chưa đầy đủ
- **WHEN** user mô tả ý tưởng nhưng thiếu pain point hoặc expected output
- **THEN** AI hỏi tối đa 3 câu ngắn để bổ sung thông tin còn thiếu

#### Scenario: User cung cấp tài liệu tham khảo
- **WHEN** user đính kèm file hoặc reference tài liệu bổ trợ
- **THEN** AI ghi nhận tài liệu vào `.skill-context/{skill-name}/resources/`

### Requirement: Phase 2 - Phân tích (Analyze)
AI agent SHALL phân tích yêu cầu dựa trên framework architect.md. AI MUST áp dụng
3 Trụ cột (Knowledge, Process, Guardrails) và map vào 7 Zones (Core, Knowledge,
Scripts, Templates, Data, Loop, Assets). AI MUST trình bày kết quả phân tích
và chờ user confirm trước khi chuyển sang Phase 3.

#### Scenario: Phân tích với framework 3 Trụ cột
- **WHEN** AI có đủ thông tin từ Phase 1
- **THEN** AI phân tích theo 3 Trụ cột: (1) Knowledge - skill cần tri thức gì, (2) Process - workflow logic ra sao, (3) Guardrails - cần kiểm soát gì

#### Scenario: Map vào 7 Zones
- **WHEN** AI hoàn tất phân tích 3 Trụ cột
- **THEN** AI xác định từng Zone cần gì: Core (SKILL.md content), Knowledge (files gì), Scripts (cần không), Templates (format output), Data (config gì), Loop (checklist gì), Assets (media gì)

#### Scenario: Interaction point cuối Phase 2
- **WHEN** AI hoàn tất phân tích
- **THEN** AI trình bày bản phân tích cho user và PHẢI chờ confirmation trước khi tiếp tục

### Requirement: Phase 3 - Thiết kế và Output (Design)
AI agent SHALL tạo bản thiết kế kiến trúc hoàn chỉnh và ghi vào
`.skill-context/{skill-name}/design.md`. Output MUST chứa ít nhất 2 sơ đồ Mermaid
(folder structure + execution flow). AI MUST hỏi user xác nhận bản thiết kế
trước khi đánh dấu hoàn tất.

#### Scenario: Tạo output design.md thành công
- **WHEN** user confirm kết quả phân tích ở Phase 2
- **THEN** AI vẽ sơ đồ Mermaid (mindmap cấu trúc + sequence flow), tạo capability map, xác định risks, và ghi toàn bộ vào `.skill-context/{skill-name}/design.md`

#### Scenario: Output design.md phải có đủ sections
- **WHEN** AI ghi file design.md
- **THEN** file MUST chứa 10 sections: Problem Statement, Capability Map, Zone Mapping, Folder Structure, Execution Flow, Interaction Points, Progressive Disclosure Plan, Risks & Blind Spots, Open Questions, Metadata

#### Scenario: Gate check cuối Phase 3
- **WHEN** AI hoàn tất design.md
- **THEN** AI hỏi user xác nhận bản thiết kế. Chỉ khi user confirm thì phase mới hoàn tất

### Requirement: Guardrails
AI agent MUST tuân thủ các guardrails sau trong suốt quá trình hoạt động:
- KHÔNG viết code implementation (chỉ thiết kế)
- KHÔNG tự đoán khi thiếu thông tin (hỏi user, tối đa 3 câu)
- Output MUST có ít nhất 2 sơ đồ Mermaid
- Mỗi phase MUST kết thúc bằng interaction point
- Mọi thiết kế MUST map được về 3 Trụ cột + 7 Zones từ architect.md
- MUST chạy init_context.py trước khi ghi output

#### Scenario: User yêu cầu viết code
- **WHEN** user yêu cầu skill-architect viết code thay vì thiết kế
- **THEN** AI từ chối và hướng dẫn user sử dụng skill-builder để implement

#### Scenario: Thiếu thông tin nghiêm trọng
- **WHEN** AI không đủ thông tin để phân tích (confidence < 70%)
- **THEN** AI dừng lại và hỏi user, tối đa 3 câu ngắn gọn
