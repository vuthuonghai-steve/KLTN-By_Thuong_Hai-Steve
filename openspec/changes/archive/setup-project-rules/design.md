## Context

**Current state**: Thư mục `.agent/rules/` tồn tại nhưng trống. AI agents hiện không có hướng dẫn cụ thể khi làm việc với dự án Agent Skill Framework.

**Reference document**: `architect.md` - tài liệu kiến trúc chính định nghĩa:
- Zones chuẩn (SKILL.md, knowledge/, scripts/, templates/, data/, loop/, assets/)
- Workflow 5 bước (Khảo sát → Thiết kế → Xây dựng → Kiểm định → Bảo trì)
- Cơ chế Loop/Verify
- Progressive Disclosure
- Interaction Points

**Target AI agents**: Claude Code CLI, Cursor IDE, Antigravity

## Goals / Non-Goals

**Goals:**
- AI tuân thủ kiến trúc trong architect.md
- AI không skip workflow steps hoặc verify checkpoints
- AI dừng lại hỏi user khi có nhiều cách hiểu (chỉ ở giai đoạn đầu)
- User có thể theo dõi AI bằng checklist
- Rule files có 2 bản: English (cho AI) + Vietnamese (tạm thời cho user review)

**Non-Goals:**
- Không thay đổi architect.md
- Không tạo rule cho các dự án khác
- Không định nghĩa lại workflow - chỉ enforce workflow có sẵn

## Decisions

### Decision 1: Cấu trúc file rule

**Chosen**: Tách thành nhiều file theo chủ đề

```
.agent/rules/
├── 00-project-context.md           # AI hiểu dự án là gì
├── 01-architecture-alignment.md    # Bám architect.md, zones
├── 02-workflow-discipline.md       # Quy trình 5 bước, loop
├── 03-interaction-protocol.md      # Khi nào dừng hỏi user
├── 04-forbidden-patterns.md        # KHÔNG BAO GIỜ làm
├── 05-implementation-checklist.md  # Checklist cho user theo dõi
├── INDEX.md                        # Quick reference
└── _vi/                            # Bản Việt hóa tạm thời
    ├── 00-project-context.vi.md
    ├── 01-architecture-alignment.vi.md
    └── ... (tương ứng)
```

**Rationale**: Tách file giúp AI đọc nhanh phần cần thiết, dễ maintain, dễ extend.

**Alternative considered**: Gộp 1 file duy nhất → Khó navigate, khó update từng phần.

### Decision 2: Ngôn ngữ và bản copy

**Chosen**: 
- File chính: Tiếng Anh (AI hiểu tốt hơn)
- Bản copy: Tiếng Việt trong thư mục `_vi/` (tạm thời, sẽ dọn dẹp sau)

**Rationale**: AI agents được train chủ yếu bằng English. Vietnamese copy giúp Steve review trước khi triển khai.

### Decision 3: Interaction protocol theo giai đoạn

**Chosen**: 
- Giai đoạn đầu (Phân tích/Thiết kế): AI PHẢI hỏi khi có nhiều cách hiểu
- Giai đoạn sau (Build/Triển khai): AI chỉ verify sau khi hoàn thành, KHÔNG hỏi lại

**Rationale**: Giai đoạn đầu đã làm rõ yêu cầu, việc hỏi lại ở giai đoạn sau làm chậm tiến độ và không cần thiết.

### Decision 4: Checklist format

**Chosen**: Checklist dạng checkbox markdown cho user tick-off

```markdown
## Phase: Khảo sát
- [ ] AI đã xác định Input?
- [ ] AI đã liệt kê Tools cần dùng?
- [ ] AI đã phân tích "điểm mù"?
```

**Rationale**: User có thể follow along và verify AI đang làm đúng, đủ steps.

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| AI có thể bỏ qua rules | Thêm INDEX.md như quick reminder mỗi lần bắt đầu |
| Bản Việt hóa outdated so với English | Đánh dấu `_vi/` là temporary, xóa sau khi Steve đã quen |
| Quá nhiều rules làm AI confused | Giữ mỗi file ngắn gọn, dùng imperative form |
| Cursor/Claude Code có thể đọc rules khác nhau | Viết rules theo format chung, không dùng platform-specific syntax |
