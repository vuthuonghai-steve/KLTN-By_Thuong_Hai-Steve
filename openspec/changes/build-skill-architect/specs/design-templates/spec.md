## ADDED Requirements

### Requirement: design.md template
Template `design.md.template` SHALL chứa khung heading chuẩn 10 sections cho output
của Skill Architect. Template MUST có placeholder {skill_name}, {date}, {author}.

#### Scenario: Template được sử dụng bởi init_context.py
- **WHEN** init_context.py tạo design.md cho skill mới
- **THEN** file design.md chứa 10 sections: Problem Statement, Capability Map (3 Trụ cột), Zone Mapping (bảng 7 Zones), Folder Structure, Execution Flow, Interaction Points, Progressive Disclosure Plan, Risks & Blind Spots, Open Questions, Metadata

#### Scenario: Template có HTML comments hướng dẫn
- **WHEN** AI hoặc user mở file design.md vừa tạo
- **THEN** mỗi section có HTML comment giải thích cần điền gì

### Requirement: todo.md template
Template `todo.md.template` SHALL chứa khung heading chuẩn cho output của Skill Planner.
Gồm 5 sections: Pre-requisites, Phase Breakdown (có checkbox), Knowledge & Resources
Needed (bảng), Definition of Done (checkbox), Notes.

#### Scenario: Template tạo todo.md với checkbox sẵn
- **WHEN** init_context.py tạo todo.md cho skill mới
- **THEN** file chứa phase breakdown với các `- [ ]` placeholder tasks và bảng resources

### Requirement: build-log.md template
Template `build-log.md.template` SHALL chứa khung heading chuẩn cho output của
Skill Builder. Gồm 5 sections: Build Session Log, Files Created (bảng),
Decisions Made During Build (bảng), Issues Encountered (bảng), Final Status (checkbox).

#### Scenario: Template tạo build-log.md với bảng tracking
- **WHEN** init_context.py tạo build-log.md cho skill mới
- **THEN** file chứa 3 bảng tracking (files, decisions, issues) và final status checklist

### Requirement: Placeholders chuẩn
Tất cả templates MUST sử dụng bộ placeholders nhất quán:
- `{skill_name}` — tên skill (kebab-case)
- `{date}` — ngày tạo (ISO format YYYY-MM-DD)
- `{author}` — mặc định "Skill Architect" hoặc "Skill Planner" hoặc "Skill Builder"

#### Scenario: Placeholders được thay thế đúng
- **WHEN** init_context.py xử lý template với skill_name = "api-analyzer"
- **THEN** `{skill_name}` → "api-analyzer", `{date}` → "2026-02-13", `{author}` → "Skill Architect"
