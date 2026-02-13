## 1. Khởi tạo cấu trúc thư mục Skill Architect

- [x] 1.1 Tạo thư mục `.agent/skills/skill-architect/` với các sub-directories: knowledge/, scripts/, templates/, loop/
- [x] 1.2 Copy `architect.md` từ root dự án vào `knowledge/architect.md`

## 2. Tạo SKILL.md (Core)

- [x] 2.1 Viết SKILL.md với frontmatter (name, description)
- [x] 2.2 Định nghĩa Mission: Senior Skill Architect chuyên phân tích yêu cầu và thiết kế kiến trúc
- [x] 2.3 Viết Mandatory Boot Sequence: đọc SKILL.md → đọc knowledge/architect.md
- [x] 2.4 Viết Phase 1 (Collect): thu thập ý tưởng, hỏi tối đa 3 câu, chạy init_context.py
- [x] 2.5 Viết Phase 2 (Analyze): áp 3 Trụ cột, map 7 Zones, trình bày và chờ confirm
- [x] 2.6 Viết Phase 3 (Design): vẽ Mermaid diagrams, tạo capability map, ghi design.md, gate check
- [x] 2.7 Viết Guardrails: không code, không tự đoán, phải có Mermaid, phải qua Gate, dựa trên architect.md
- [x] 2.8 Viết Output Format: 10 sections bắt buộc trong design.md

## 3. Tạo Script init_context.py

- [x] 3.1 Implement argument parsing (nhận skill-name, validate kebab-case)
- [x] 3.2 Implement project root detection (tìm `.agent/`, walk up tối đa 10 levels)
- [x] 3.3 Implement tạo `.skill-context/` root directory nếu chưa có
- [x] 3.4 Implement tạo sub-folder `.skill-context/{skill-name}/` nếu chưa có
- [x] 3.5 Implement đọc templates từ `templates/*.template` và thay thế placeholders
- [x] 3.6 Implement tạo 3 files (design.md, todo.md, build-log.md) với safe-create policy
- [x] 3.7 Implement tạo thư mục resources/
- [x] 3.8 Implement output report (files created / already existed)

## 4. Tạo File Templates

- [x] 4.1 Tạo `templates/design.md.template` với 10 sections và HTML comment hướng dẫn
- [x] 4.2 Tạo `templates/todo.md.template` với 5 sections (pre-req, phases, resources, DoD, notes)
- [x] 4.3 Tạo `templates/build-log.md.template` với 5 sections (log, files, decisions, issues, status)

## 5. Tạo Loop Checklist

- [x] 5.1 Tạo `loop/design-checklist.md` với tiêu chí kiểm tra chất lượng bản thiết kế
