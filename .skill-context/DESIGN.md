# MASTER SKILL SUITE — DESIGN DOCUMENT

> **Mục đích**: Bộ nhớ ngoài lưu trữ toàn bộ thảo luận và quyết định thiết kế
> trong quá trình xây dựng bộ 3 Agent Skill.
>
> **Ngày tạo**: 2026-02-13
> **Tác giả**: Steve + AI Agent
> **Trạng thái**: 🟢 HOÀN THÀNH THIẾT KẾ (Bộ 3 Skill)

---

## 1. BỐI CẢNH & QUYẾT ĐỊNH ĐÃ XÁC NHẬN

### 1.1 Bộ Master Skill là gì?

Bộ Master Skill gồm **3 Agent Skill độc lập**, hoạt động theo cùng một workflow
tuần tự, chia sẻ context qua một thư mục tài liệu chung tại root dự án.

Mục tiêu: Giúp người dùng đi từ **ý tưởng mơ hồ** → **bản thiết kế kiến trúc**
→ **kế hoạch triển khai** → **skill hoàn chỉnh**.

### 1.2 Ba Skill và vai trò

| # | Tên Skill | Vai trò | Input | Output |
|---|-----------|---------|-------|--------|
| 1 | **Skill Architect** | Thu thập, phân tích, thiết kế kiến trúc | Ý tưởng + tài liệu tham khảo | `design.md` (kiến trúc skill) |
| 2 | **Skill Planner** | Liệt kê bước triển khai, tài liệu & kiến thức cần chuẩn bị | `design.md` từ Skill #1 | `todo.md` (kế hoạch chi tiết) |
| 3 | **Skill Builder** | Tổng hợp tài liệu + triển khai xây dựng | `design.md` + `todo.md` + tài liệu user | Skill package hoàn chỉnh |

### 1.3 Quyết định đã xác nhận (Confirmed Decisions)

| # | Quyết định | Ngày | Lý do |
|---|-----------|------|-------|
| D1 | Bộ 3 skill là **MỚI HOÀN TOÀN**, không thay thế master-skill cũ | 2026-02-13 | Tách biệt, không ảnh hưởng codebase hiện tại |
| D2 | Context directory tại **root dự án**: `.skill-context/` (Option A) | 2026-02-13 | Rõ ràng, dễ truy cập |
| D3 | Mỗi skill là **agent skill độc lập** (có SKILL.md riêng) nhưng làm việc chung workflow | 2026-02-13 | Modularity + mỗi skill có thể dùng độc lập |
| D4 | Nền tảng thiết kế dựa trên `architect.md` (7-Zone, Meta-Skill Framework) | 2026-02-13 | Chuẩn kiến trúc đã có sẵn |
| D5 | Thứ tự xây dựng: Skill #1 → Skill #2 → Skill #3 | 2026-02-13 | Dependency chain tuyến tính |
| D6 | Mỗi skill cần xây dựng có **sub-folder riêng** trong `.skill-context/` | 2026-02-13 | Quản lý nhiều skill, hỗ trợ update/workflow tương lai |
| D7 | Cần **init script** tạo cấu trúc thư mục + file template tự động | 2026-02-13 | Chuẩn hóa, tránh thiếu file, tránh lỗi tay |
| D8 | Naming: `skill-architect`, `skill-planner`, `skill-builder` (không prefix) | 2026-02-13 | Đơn giản, rõ nghĩa |
| D9 | `init_context.py` detect project root bằng cách **tìm thư mục `.agent/`** | 2026-02-13 | Chuẩn xác, skill luôn nằm trong `.agent/skills/` |
| D10 | **Không cần `.gitignore`** trong `.skill-context/` | 2026-02-13 | Giữ đơn giản |

---

## 2. KIẾN TRÚC TỔNG THỂ

### 2.1 Sơ đồ quan hệ giữa 3 Skill

```
  USER (Y tuong + Tai lieu)
       │
       ▼
┌──────────────────┐
│  SKILL #1        │
│  Architect       │     Tao & ghi vao
│  (.claude/skills/ │────────────────────▶ .skill-context/
│   skill-architect│                      ├── design.md  ◀── Skill #1 output
│   /SKILL.md)     │                      ├── todo.md    ◀── Skill #2 output
└──────────────────┘                      ├── build-log.md ◀── Skill #3 output
       │                                  └── resources/ ◀── User cung cap
       │ "Thiet ke xong"
       ▼
┌──────────────────┐
│  SKILL #2        │     Doc design.md
│  Planner         │◀───────────────────── .skill-context/
│  (.claude/skills/ │     Ghi todo.md
│   skill-planner  │────────────────────▶ .skill-context/
│   /SKILL.md)     │
└──────────────────┘
       │
       │ "Ke hoach xong"
       ▼
┌──────────────────┐
│  SKILL #3        │     Doc design.md + todo.md
│  Builder         │◀───────────────────── .skill-context/
│  (.claude/skills/ │     Trien khai xay dung
│   skill-builder  │────────────────────▶ .claude/skills/{new-skill}/
│   /SKILL.md)     │
└──────────────────┘
```

### 2.2 Context Directory (`.skill-context/`) — Mô hình Sub-folder

Thư mục gốc `.skill-context/` chứa tài liệu chung cho bộ Master Skill.
Mỗi skill cần xây dựng sẽ có **sub-folder riêng** để quản lý context độc lập.

```
{project_root}/.skill-context/
├── DESIGN.md                   # Thảo luận thiết kế bộ Master Skill (file này)
│
├── {skill-name-1}/             # Sub-folder cho skill đang xây dựng
│   ├── design.md               # Output Skill #1 - Kiến trúc skill
│   ├── todo.md                 # Output Skill #2 - Kế hoạch triển khai
│   ├── build-log.md            # Output Skill #3 - Nhật ký xây dựng
│   └── resources/              # Tài liệu user cung cấp bổ trợ
│       └── (files...)
│
├── {skill-name-2}/             # Sub-folder cho skill khác
│   ├── design.md
│   ├── todo.md
│   ├── build-log.md
│   └── resources/
│
└── ...                         # Mỗi skill một sub-folder
```

**Quy tắc**:
- Skill #1 (Architect) tạo root `.skill-context/` nếu chưa có
- Skill #1 tạo sub-folder `{skill-name}/` khi bắt đầu session mới
- Skill #2, #3 đọc/ghi vào sub-folder đã tạo bởi Skill #1
- Tên sub-folder = tên skill đang xây dựng (kebab-case)

### 2.3 Vị trí cài đặt 3 Skill

```
.agent/skills/
├── skill-architect/    # Skill #1
│   ├── SKILL.md
│   ├── knowledge/
│   │   └── architect.md   # Copy chuẩn từ root
│   ├── templates/
│   └── loop/
├── skill-planner/      # Skill #2
│   ├── SKILL.md
│   ├── knowledge/
│   ├── templates/
│   └── loop/
└── skill-builder/      # Skill #3
    ├── SKILL.md
    ├── knowledge/
    ├── scripts/
    ├── templates/
    └── loop/
```

---

## 3. SKILL #1: ARCHITECT — THIẾT KẾ CHI TIẾT

> **Trạng thái**: 🔵 Đang thiết kế (focus hiện tại)

### 3.1 Sứ mệnh (Mission)

Skill Architect là "Senior Architect" chuyên **thu thập ý tưởng** từ người dùng,
**phân tích yêu cầu** dựa trên framework kiến trúc `architect.md`, và **xuất ra
bản thiết kế kiến trúc** hoàn chỉnh cho skill mới cần xây dựng.

### 3.2 Persona

- Vai trò: **Senior Skill Architect**
- Phong cách: Hỏi đúng trọng tâm, vẽ sơ đồ trực quan, không code
- Nguyên tắc: Dựa trên 3 Trụ cột (Knowledge, Process, Guardrails) từ architect.md

### 3.3 Workflow (Phases)

```
Phase 1: THU THAP         Phase 2: PHAN TICH         Phase 3: THIET KE
(Collect)                  (Analyze)                  (Design & Output)
┌─────────────────┐       ┌─────────────────┐        ┌─────────────────┐
│ - Hoi y tuong   │       │ - Ap vao 3 Tru  │        │ - Ve Mindmap    │
│ - Xac dinh      │──────▶│   cot (architect │──────▶ │   cau truc      │
│   pain points   │       │   .md)           │        │ - Ve Sequence   │
│ - Xac dinh      │       │ - Map vao Zones  │        │   flow          │
│   input/output  │       │ - Tim diem mu    │        │ - Ghi design.md │
│ - Doc tai lieu   │       │   cua AI         │        │   vao context   │
│   tham khao     │       │ - Xac dinh tools │        │ - Gate check    │
└─────────────────┘       └─────────────────┘        └─────────────────┘
       │                          │                          │
       ▼                          ▼                          ▼
  [Interaction]             [Interaction]              [Output Gate]
  Hoi neu thieu            Trinh bay phan tich         Confirm design
  thong tin                cho user confirm            truoc khi luu
```

### 3.4 Chi tiết từng Phase

#### Phase 1: Thu thập (Collect)
- Đọc input từ user (ý tưởng, mô tả, tài liệu tham khảo)
- Hỏi tối đa 3 câu hỏi ngắn nếu thiếu thông tin:
  1. Skill này giải quyết vấn đề gì? (Pain point)
  2. Ai dùng và dùng trong ngữ cảnh nào? (User & Context)
  3. Đầu ra mong muốn là gì? (Expected output)
- Nếu user cung cấp tài liệu tham khảo → lưu vào `.skill-context/resources/`
- Tạo thư mục `.skill-context/` nếu chưa tồn tại

#### Phase 2: Phân tích (Analyze)
- Đọc `knowledge/architect.md` (bản copy trong skill)
- Áp framework 3 Trụ cột:
  - **Trụ 1 - Tri thức (Knowledge)**: Skill mới cần knowledge gì?
  - **Trụ 2 - Quy trình (Process)**: Workflow logic ra sao?
  - **Trụ 3 - Kiểm soát (Guardrails)**: Cần loop/verify gì?
- Map vào 7 Zones: Core, Knowledge, Scripts, Templates, Data, Loop, Assets
- Xác định tools mà AI sẽ cần (Terminal, Browser, File system...)
- Tìm "điểm mù" tiềm ẩn (AI thường sai ở đâu với loại công việc này?)
- **Interaction Point**: Trình bày bản phân tích, chờ user confirm

#### Phase 3: Thiết kế & Output (Design)
- Vẽ sơ đồ cấu trúc thư mục (Mermaid Mindmap)
- Vẽ sơ đồ luồng hoạt động (Mermaid Sequence/Flowchart)
- Tạo Capability Map
- Xác định Risks & Open Questions
- Ghi toàn bộ vào `.skill-context/design.md`
- **Output Gate**: Hỏi user xác nhận bản thiết kế trước khi hoàn tất

### 3.5 Input/Output

| | Chi tiết |
|---|---------|
| **Input** | Ý tưởng mô tả bằng ngôn ngữ tự nhiên + tài liệu tham khảo (optional) |
| **Output** | File `.skill-context/design.md` chứa kiến trúc của skill mới |
| **Side Effect** | Tạo `.skill-context/` directory nếu chưa có |

### 3.6 Nội dung `design.md` (Output Format)

Bản design.md mà Skill Architect tạo ra sẽ tuân theo cấu trúc:

```markdown
# {Tên Skill} — Architecture Design

## 1. Problem Statement
## 2. Capability Map (3 Trụ cột)
## 3. Zone Mapping (7 Zones)
## 4. Folder Structure (Mermaid Mindmap)
## 5. Execution Flow (Mermaid Sequence)
## 6. Interaction Points
## 7. Progressive Disclosure Plan
## 8. Risks & Blind Spots
## 9. Open Questions
## 10. Metadata
```

### 3.7 Cấu trúc thư mục Skill Architect

```
.agent/skills/skill-architect/
├── SKILL.md                    # Core: Persona + Phases + Rules
├── knowledge/
│   └── architect.md            # Copy chuẩn của framework kiến trúc
├── scripts/
│   └── init_context.py         # Script tạo cấu trúc .skill-context/{name}/
├── templates/
│   ├── design.md.template      # Template cho output design.md
│   ├── todo.md.template        # Khung sẵn cho Skill #2 ghi vào
│   └── build-log.md.template   # Khung sẵn cho Skill #3 ghi vào
└── loop/
    └── design-checklist.md     # Checklist kiểm tra bản thiết kế đủ chất lượng
```

### 3.8 Script `init_context.py` — Thiết kế chi tiết

**Chức năng**: Tạo cấu trúc thư mục `.skill-context/` và sub-folder cho skill
mới, kèm theo các file context với khung heading sẵn.

**Cách gọi**:
```bash
python .agent/skills/skill-architect/scripts/init_context.py <skill-name>
# Ví dụ:
python .agent/skills/skill-architect/scripts/init_context.py my-api-analyzer
```

**Logic**:
```
1. Nhận argument: skill_name (kebab-case)
2. Xác định project_root (thư mục chứa .agent/ hoặc cwd)
3. Tạo .skill-context/ nếu chưa có
4. Tạo .skill-context/{skill_name}/ nếu chưa có
5. Tạo các file từ template (chỉ khi file chưa tồn tại):
   - design.md      ← từ design.md.template
   - todo.md         ← từ todo.md.template
   - build-log.md    ← từ build-log.md.template
6. Tạo resources/ sub-directory
7. In kết quả: files created / already existed
```

**Nguyên tắc an toàn**:
- KHÔNG ghi đè file đã tồn tại (tránh mất context cũ)
- KHÔNG xóa bất kỳ thứ gì
- Chỉ tạo mới

### 3.9 File Templates — Khung heading

#### `design.md.template`
```markdown
# {skill_name} — Architecture Design

> Generated by Skill Architect | Date: {date}
> Status: 🔵 IN PROGRESS

## 1. Problem Statement
<!-- Skill nay giai quyet van de gi? -->

## 2. Capability Map
### 2.1 Tri thuc (Knowledge)
### 2.2 Quy trinh (Process)
### 2.3 Kiem soat (Guardrails)

## 3. Zone Mapping
| Zone | Noi dung | Bat buoc? |
|------|----------|----------|
| Core (SKILL.md) | | ✅ |
| Knowledge | | |
| Scripts | | |
| Templates | | |
| Data | | |
| Loop | | |
| Assets | | |

## 4. Folder Structure
<!-- Mermaid Mindmap -->

## 5. Execution Flow
<!-- Mermaid Sequence/Flowchart -->

## 6. Interaction Points
<!-- Khi nao AI phai dung lai hoi user? -->

## 7. Progressive Disclosure Plan
<!-- Tang 1 bat buoc doc gi? Tang 2 tu quyet dinh? -->

## 8. Risks & Blind Spots
<!-- AI thuong sai o dau voi loai cong viec nay? -->

## 9. Open Questions
| # | Cau hoi | Trang thai |
|---|---------|------------|

## 10. Metadata
- Created: {date}
- Author: {author}
- Based on: architect.md v2.0
```

#### `todo.md.template`
```markdown
# {skill_name} — Implementation Plan

> Generated by Skill Planner | Date: {date}
> Status: ⚪ PENDING

## 1. Pre-requisites
<!-- Tai lieu & kien thuc can chuan bi truoc -->

## 2. Phase Breakdown
### Phase 1: Foundation
- [ ] Task 1.1
- [ ] Task 1.2

### Phase 2: Core Logic
- [ ] Task 2.1
- [ ] Task 2.2

### Phase 3: Quality
- [ ] Task 3.1
- [ ] Task 3.2

## 3. Knowledge & Resources Needed
| # | Tai lieu | Muc dich | Trang thai |
|---|---------|---------|------------|

## 4. Definition of Done
- [ ] Criterion 1
- [ ] Criterion 2

## 5. Notes
```

#### `build-log.md.template`
```markdown
# {skill_name} — Build Log

> Generated by Skill Builder | Date: {date}
> Status: ⚪ PENDING

## 1. Build Session Log
<!-- Nhat ky tung buoc xay dung -->

## 2. Files Created
| # | File | Muc dich |
|---|------|----------|

## 3. Decisions Made During Build
| # | Quyet dinh | Ly do |
|---|-----------|-------|

## 4. Issues Encountered
| # | Van de | Cach xu ly |
|---|--------|------------|

## 5. Final Status
- [ ] Skill package created
- [ ] Structure validated
- [ ] Ready for use
```

### 3.10 Guardrails

| Rule | Mô tả |
|------|--------|
| Không code | Skill Architect CHỈ thiết kế, KHÔNG viết code |
| Không tự đoán | Hỏi khi thiếu thông tin, tối đa 3 câu |
| Phải có Mermaid | Output bắt buộc có ít nhất 2 sơ đồ Mermaid |
| Phải qua Gate | Mỗi phase kết thúc bằng interaction point |
| Dựa trên architect.md | Mọi thiết kế phải map được về 3 Trụ + 7 Zones |
| Chạy init script | Bắt buộc chạy `init_context.py` trước khi output |

---

## 4. SKILL #2: PLANNER — PHÁC THẢO

> **Trạng thái**: ⚪ Chưa bắt đầu (đợi Skill #1 xong)

### 4.1 Ý tưởng sơ bộ
- Đọc `design.md` từ `.skill-context/`
- Phân rã từng Zone thành các bước triển khai cụ thể
- Liệt kê tài liệu và kiến thức người dùng cần chuẩn bị
- Output: `todo.md` - danh sách bước với checklist `[ ]`

---

## 5. SKILL #3: BUILDER — THIẾT KẾ CHI TIẾT

> **Trạng thái**: 🟢 HOÀN THÀNH THIẾT KẾ (Sẵn sàng triển khai)

### 5.1 Ý tưởng sơ bộ
- Đọc `design.md` + `todo.md` từ `.skill-context/`
- Tổng hợp tài liệu user cung cấp trong `resources/`
- Thực thi xây dựng skill theo kế hoạch
- Output: Skill package hoàn chỉnh tại `.agent/skills/{skill-name}/`

---

## 6. OPEN QUESTIONS

| # | Câu hỏi | Trạng thái |
|---|---------|-----------|
| Q1 | ~~Khi user muốn xây dựng skill mới khác, `.skill-context/` có bị xóa đi tạo lại không?~~ | ✅ Resolved → D6: Sub-folder riêng |
| Q2 | ~~Skill #1 có cần script tự động (Python) hay chỉ dùng logic trong SKILL.md?~~ | ✅ Resolved → D7: Có init script |
| Q3 | ~~3 Skill có naming convention chung không?~~ | ✅ Resolved → D8: Không prefix |
| Q4 | ~~Script `init_context.py` nên detect project root bằng cách nào?~~ | ✅ Resolved → D9: Tìm `.agent/` |
| Q5 | ~~Có cần `.gitignore` trong `.skill-context/` không?~~ | ✅ Resolved → D10: Không cần |

---

## 7. CHANGELOG

| Ngày | Thay đổi |
|------|----------|
| 2026-02-13 | Khởi tạo DESIGN.md, xác nhận 5 decisions (D1-D5) |
| 2026-02-13 | Thiết kế chi tiết Skill #1 (Architect): Phases, I/O, Folder, Guardrails |
| 2026-02-13 | Phác thảo sơ bộ Skill #2 (Planner) và Skill #3 (Builder) |
| 2026-02-13 | Confirm D6 (sub-folder), D7 (init script), D8 (naming). Resolve Q1-Q3 |
| 2026-02-13 | Thiết kế chi tiết: init_context.py, 3 file templates (design/todo/build-log) |
| 2026-02-13 | Cập nhật cấu trúc context directory theo mô hình sub-folder |
| 2026-02-13 | Confirm D9 (root detection via .agent/), D10 (no .gitignore). Resolve Q4-Q5 |
