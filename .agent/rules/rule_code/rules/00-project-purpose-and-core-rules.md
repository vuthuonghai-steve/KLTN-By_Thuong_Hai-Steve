---
# === FRONTMATTER ===
schema_version: "1.0.0"
document_type: "project-purpose-and-core-rules"
scope: "workspace"
priority: 0

metadata:
  version: "1.0.0"
  created: "2026-02-10"

applies_to:
  - claude
  - cursor
  - codex
  - all-ai-agents

purpose: "Làm rõ mục đích dự án và xác lập rule trọng tâm để tránh hướng đi sai, lòng vòng, không tập trung"
---

# 🎯 MỤC ĐÍCH DỰ ÁN & RULE TRỌNG TÂM

> **Vị trí file**: `rules/00-project-purpose-and-core-rules.md`  
> **Đọc khi**: Bắt đầu mỗi phiên làm việc hoặc khi cần xác định lại “dự án này đang làm gì”.  
> **Cốt lõi**: Mọi rule và công việc phải bám theo tài liệu **architect.md** (Agent Skill Framework).

---

## I. LÀM RÕ THÔNG TIN DỰ ÁN

### 1.1 Mục đích dự án (Project Purpose)

| Nội dung | Mô tả |
|----------|--------|
| **Mục đích** | Lên ý tưởng, **phân tích**, **thiết kế** Agent Skill; đóng gói các **luồng làm việc đơn điệu** thành **module skill** để AI thực hiện có quy trình, có kiểm soát. |
| **Giá trị** | **Giảm thời gian code** lặp đi lặp lại; **dành nhiều thời gian hơn** cho phân tích, thiết kế phần mềm/sản phẩm. |
| **Không phải** | Không phải mục tiêu chính là “viết thật nhiều code cho sản phẩm” mà là “thiết kế skill để khi cần thì AI code đúng luồng, đúng chuẩn”. |

### 1.2 Chức năng cốt lõi (Core Functions)

1. **Ý tưởng & phân tích**: Nhận diện pain point, use case, input/output của từng loại công việc lặp.
2. **Thiết kế skill**: Phân vùng (zones), quy trình (phases), checklist, guardrails theo **architect.md**.
3. **Đóng gói thành skill**: Tạo cấu trúc thư mục chuẩn (SKILL.md, knowledge/, scripts/, templates/, data/, loop/, assets/) và nạp tài nguyên.
4. **Kiểm định & bảo trì**: Verify theo loop/checklist; cập nhật skill khi môi trường hoặc nhu cầu thay đổi.

### 1.3 Nền tảng cốt lõi (Core Foundation)

- **Tài liệu nền tảng**: `architect.md` (Agent Skill Framework – kiến trúc meta-skill, zones, workflow 5 bước, loop/verify, progressive disclosure).
- **Rule dự án**: Nằm trong thư mục **`rules/`**, viết bằng **Markdown (.md)**.
- **Skill mẫu**: Các skill thực tế nằm trong **`list-skill/`** (và có thể `.cursor/skills/`, `.codex/skills/`, …) theo đúng cấu trúc trong architect.md.

---

## II. RULE TRỌNG TÂM (CORE RULES)

### 2.1 Rule bắt buộc đọc và tuân thủ

| # | Rule | Mục đích |
|---|------|----------|
| **R0** | Mọi thiết kế skill, quy trình, cấu trúc thư mục **phải nhất quán với architect.md**. | Tránh “tự nghĩ” kiến trúc khác, dẫn lệch hướng. |
| **R1** | Khi làm việc **trong phạm vi dự án Agent Skill** (ý tưởng skill, thiết kế skill, tạo/sửa SKILL, loop, knowledge): ưu tiên **phân tích & thiết kế** trước, code/script là công cụ phục vụ skill. | Tập trung đúng mục đích: giảm code tay, tăng thời gian phân tích/thiết kế. |
| **R2** | Trước khi đề xuất hướng đi mới (công nghệ, cấu trúc, quy trình): **kiểm tra lại architect.md** và các rule trong **rules/**; nếu trái với architect hoặc rule hiện có thì **nêu rõ và chờ xác nhận** trước khi thay đổi. | Tránh hướng đi không chính xác hoặc đi lòng vòng. |
| **R3** | Khi user yêu cầu “làm rõ”, “xác lập rule”, “thiết kế skill”: **không mặc định chuyển sang viết code sản phẩm** (ví dụ feature Agent-skill) trừ khi user nói rõ. | Tránh nhảy sang task khác không đúng trọng tâm. |
| **R4** | Các rule chi tiết (coding, API, testing, …) trong **rules/** áp dụng cho **từng ngữ cảnh**: rule cho **sản phẩm (Agent-skill)** tách bạch với rule cho **bản thân dự án skill** (architect, SKILL.md, loop, knowledge). | Tránh lẫn lộn “rule của sản phẩm” với “rule của framework skill”. |

### 2.2 Hành vi cần tránh (Anti-patterns)

| ❌ Tránh | ✅ Thay vào đó |
|----------|-----------------|
| Đề xuất kiến trúc skill khác với architect.md mà không nêu rõ và không được xác nhận | Bám architect.md; nếu muốn thay đổi thì nêu lý do và chờ OK |
| Ưu tiên “viết code thật nhanh” thay vì “thiết kế skill rõ ràng” | Ưu tiên phân tích/thiết kế (persona, phases, checklist, guardrails) rồi mới đóng gói thành skill |
| Tạo nhiều file/cấu trúc mới không nằm trong zones chuẩn (SKILL.md, knowledge/, scripts/, templates/, data/, loop/, assets/) | Chỉ thêm theo đúng zones và quy trình trong architect.md |
| Bỏ qua loop/verify (checklist, phase-verify, final-verify) khi thiết kế skill | Mỗi skill phải có cơ chế kiểm soát (loop) theo architect Phần 4 |
| Trả lời chung chung, không tham chiếu rule hoặc architect | Trả lời có tham chiếu rõ: “theo architect.md Phần X”, “theo rules/YYY.md” |

### 2.3 Điểm dừng tương tác (Interaction Points)

AI **phải dừng lại và hỏi/xác nhận** với user khi:

- Đề xuất thay đổi **kiến trúc** hoặc **quy trình** so với architect.md.
- Có **nhiều cách hiểu** về “task hiện tại thuộc dự án skill hay thuộc sản phẩm (Agent-skill)”.
- Cần **tạo/sửa rule** mới trong **rules/** (để tránh rule mâu thuẫn hoặc trùng lặp).
- **Phạm vi** công việc không rõ (chỉ phân tích vs cả thiết kế + implement skill).

---

## III. VỊ TRÍ RULES VÀ CÁCH DÙNG

### 3.1 Thứ tự ưu tiên khi đọc rule

1. **rules/00-project-purpose-and-core-rules.md** (file này) – Mục đích dự án & rule trọng tâm.
2. **architect.md** – Nền tảng kiến trúc skill (zones, workflow 5 bước, loop, execution flow).
3. Các file khác trong **rules/** theo ngữ cảnh (ví dụ: làm code sản phẩm thì đọc project-overview, ai-checklist, …).

### 3.2 Các rule trong thư mục rules/

| File | Nội dung chính | Khi nào đọc |
|------|----------------|-------------|
| **00-project-purpose-and-core-rules.md** | Mục đích dự án, rule trọng tâm, anti-patterns | Mỗi session hoặc khi cần xác định hướng |
| **project-overview.md** | Tech stack, kiến trúc Agent-skill, convention code | Làm feature/code cho sản phẩm Agent-skill |
| **ai-checklist.md** | Checklist trước khi tạo/sửa code (naming, barrel, workflow 7 bước) | Trước khi tạo/sửa code |
| **reflection-protocol.md** | Tự đánh giá output (producer-critic) trước khi submit | Sau khi generate code/analysis |
| **design-system.md**, **api-***, **testing-standards.md**, … | Chi tiết theo từng lĩnh vực | Khi làm đúng domain đó |

*Các rule khác (about-steve, user-profile, name-and-structure, …) dùng theo mô tả trong từng file.*

### 3.3 Tóm tắt một dòng

- **Dự án này**: Thiết kế và đóng gói **Agent Skill** (theo architect.md) để giảm thời gian code lặp, tăng thời gian phân tích/thiết kế.
- **Rule trọng tâm**: Bám **architect.md** và **rules/**; ưu tiên **phân tích & thiết kế skill**; tránh hướng đi sai, lòng vòng, hoặc nhảy sang “chỉ code sản phẩm” khi không được yêu cầu.

---

**VERSION**: 1.0.0  
**CREATED**: 2026-02-10  
**Cốt lõi tham chiếu**: `architect.md`
