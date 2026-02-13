---
# Kết quả thực thi skill: list-skill/prompt-improver
# Input: prompt gốc của Steve (xác định rule dự án)
# Output: prompt đã được làm rõ theo Phase 1–4 của SKILL.md
---

# KẾT QUẢ LÀM RÕ PROMPT (PROMPT IMPROVER SKILL)

## PHASE 1: PHÂN TÍCH PROMPT GỐC

### 1.1 Các yếu tố đã xác định

| Yếu tố | Nội dung |
|--------|----------|
| **Mục tiêu** | Xác định rule làm trong dự án trước khi triển khai công việc tiếp theo; tránh AI đưa hướng sai, lòng vòng, không tập trung. |
| **Context** | Dự án Agent Skill; nền tảng = architect.md; rule đặt tại rules/, viết bằng .md. |
| **Đối tượng** | AI Agent (bạn) khi làm việc với Steve trong repo này. |
| **Độ phức tạp** | Trung bình–cao: nhiều mục tiêu (rule + mục đích dự án + tránh lệch hướng). |
| **Output mong đợi** | Rule phù hợp được xác lập (và có thể là tài liệu làm rõ). |

### 1.2 Đánh giá cấu trúc prompt gốc (theo SKILL.md)

| Thành phần | Có? | Ghi chú |
|------------|-----|--------|
| Identity/Role | ❌ | Chưa nêu rõ vai trò AI khi thực hiện. |
| Context | ✅ | Có architect.md, rules/, .md. |
| Task | ✅ | Xác lập rule; tránh hướng sai, lòng vòng. |
| Instructions | ⚠️ | Có nhưng gộp với mục đích, chưa tách bước. |
| Examples | ❌ | Chưa có ví dụ “rule tốt” hay “hướng sai cần tránh”. |
| Output Format | ❌ | Chưa nêu rõ: rule viết ở đâu, dạng gì (file .md? checklist?). |
| Constraints | ⚠️ | Có (bám architect, rules/) nhưng chưa liệt kê rõ. |

---

## PHASE 2: XÁC ĐỊNH VẤN ĐỀ

### 2.1 Phân loại vấn đề (Problem Categories)

| Category | Áp dụng? | Mô tả ngắn |
|----------|----------|------------|
| **Ambiguity** | Có | “Rule phù hợp”, “hướng đi không chính xác” chưa được định nghĩa cụ thể. |
| **Missing Context** | Nhẹ | Đã có @architect.md, @rules; có thể thêm 1 câu về scope (chỉ rule cho dự án skill vs rule cho sản phẩm). |
| **Overload** | Có | Một prompt vừa nêu mục đích dự án, vừa nêu nơi đặt rule, vừa nêu ràng buộc → dễ bỏ sót. |
| **No Structure** | Có | Đoạn văn liền; thiếu section (Context / Task / Constraints / Output). |
| **Implicit Assumptions** | Có | “Làm việc với bạn” = với AI; “công việc tiếp theo” chưa nêu là công việc gì. |
| **No Examples** | Có | Chưa có ví dụ rule tốt / ví dụ hướng sai cần tránh. |
| **Wrong Scope** | Có thể | Chưa rõ: chỉ xác lập rule thôi, hay cả thiết kế + viết nội dung rule. |

### 2.2 Mức độ (Severity)

- **Critical**: Không.
- **Major**: Thiếu cấu trúc rõ (sections), thiếu output format, một số từ ngữ mơ hồ.
- **Minor**: Thiếu examples; có thể thêm 1–2 câu context.

### 2.3 Root cause (tóm tắt)

1. AI có thể hiểu “xác lập rule” theo nhiều cách (chỉ liệt kê ý vs viết full file .md).
2. “Hướng đi không chính xác / lòng vòng” chưa được nêu ví dụ → AI khó căn chỉnh đúng.
3. Không nêu rõ bước ưu tiên: làm rõ prompt trước hay viết rule trước.

---

## PHASE 3: ĐỀ XUẤT CẢI THIỆN

### 3.1 Áp dụng CRISPE (SKILL.md)

- **C – Capacity/Role**: AI đóng vai trò người hỗ trợ xác lập rule dự án, bám architect.md và thư mục rules/.
- **R – Request**: (1) Làm rõ prompt này; (2) Xác lập rule phù hợp cho dự án.
- **I – Instructions**: Tách rõ: Context → Task → Constraints → Output format; có thể thêm bước “làm rõ trước, viết rule sau”.
- **S – Style**: Rõ ràng, có section, có bullet; có thể dùng bảng cho “nên / không nên”.
- **P – Persona**: Steve là người làm khóa luận, dự án Agent Skill; cần tránh lệch sang “chỉ code sản phẩm”.
- **E – Examples**: Thêm ví dụ “hướng sai cần tránh” và “rule đúng hướng” (1–2 dòng).

### 3.2 Context layers (SKILL.md)

- **Layer 2 – Project**: Dự án = ý tưởng + phân tích + thiết kế Agent Skill; đóng gói luồng đơn điệu thành skill; giảm thời gian code, tăng phân tích/thiết kế.
- **Layer 3 – Domain**: Cốt lõi = architect.md; rule = trong rules/, file .md.
- **Layer 4 – Task-specific**: @architect.md, @rules là nguồn tham chiếu bắt buộc.

### 3.3 Kỹ thuật cải thiện

- **Structure**: Chia prompt thành Context, Mục đích dự án, Task, Constraints, Output format.
- **Specificity**: Định nghĩa ngắn “hướng sai” (vd: đề xuất kiến trúc khác architect, hoặc chỉ code mà không thiết kế skill).
- **Examples**: Thêm 1–2 ví dụ “tránh” và “nên”.
- **Step-by-step**: Bước 1 = làm rõ prompt (skill); Bước 2 = xác lập rule (có thể tách request sau).

---

## PHASE 4: PROMPT ĐÃ LÀM RÕ (OUTPUT)

Dưới đây là **bản prompt đã được làm rõ** để dùng cho lần sau hoặc để AI thực hiện đúng ý:

---

## PROMPT ĐÃ LÀM RÕ (Dùng để thực hiện hoặc lưu lại)

### Role
Bạn là trợ lý xác lập rule cho dự án, bám theo tài liệu **architect.md** (Agent Skill Framework) và thư mục **.agent/rules/**; mọi rule viết bằng **Markdown (.md)**.

### Context

**Dự án:** Ý tưởng, phân tích, thiết kế Agent Skill; đóng gói các luồng làm việc đơn điệu thành module skill.

**Mục đích:** Giảm thời gian code lặp lại; dành nhiều thời gian hơn cho phân tích và thiết kế phần mềm/sản phẩm.

**Nền tảng cốt lõi:**
- Kiến trúc và quy trình: **architect.md**
- Vị trí rule: **.agent/rules/** (các file .md)

### Task

1. **Làm rõ** thông tin prompt này (ví dụ bằng skill Prompt Improver: phân tích, xác định vấn đề, đề xuất cải thiện, tạo bản prompt rõ ràng).
2. **Xác lập** các rule phù hợp cho dự án, tập trung trong **.agent/rules/**, viết bằng **.md**, nhất quán với **architect.md**.

### Mục tiêu của rule

- Tránh khi làm việc với AI nảy sinh **hướng đi không chính xác** (ví dụ: đề xuất kiến trúc khác architect, hoặc bỏ qua loop/verify).
- Tránh **hướng đi lòng vòng, không tập trung** (ví dụ: nhảy sang viết code sản phẩm khi đang yêu cầu thiết kế skill; hoặc thêm file/cấu trúc không thuộc zones chuẩn).

### Constraints

- Rule phải **nhất quán với architect.md** (zones, workflow 5 bước, loop, progressive disclosure).
- Rule được **xây dựng và lưu trong .agent/rules/**; định dạng **Markdown (.md)**.
- Khi có nhiều cách hiểu (ví dụ: chỉ liệt kê rule vs viết full nội dung file), **hỏi lại Steve** trước khi thực hiện.

### Output mong đợi

1. **Bản làm rõ prompt** (như file này): có Phân tích (Phase 1), Vấn đề (Phase 2), Đề xuất (Phase 3), **Prompt đã làm rõ** (Phase 4).
2. **Rule đã xác lập**: có thể là file mới hoặc cập nhật trong **.agent/rules/** (ví dụ: .agent/rules/00-project-purpose-and-core-rules.md, .agent/rules/INDEX-rules.md), nội dung bám architect và mục đích trên.

### Ví dụ (nên / tránh)

| Tránh (hướng sai / lòng vòng) | Nên (đúng trọng tâm) |
|-------------------------------|------------------------|
| Đề xuất kiến trúc skill khác architect.md mà không nêu rõ và không được xác nhận | Bám architect.md; mọi thay đổi nêu rõ và chờ OK |
| Tự chuyển sang viết code feature Agent-skill khi user chỉ yêu cầu “xác lập rule” | Ưu tiên: làm rõ prompt (skill) → xác lập rule (trong rules/, .md) |
| Tạo nhiều file/cấu trúc ngoài zones chuẩn (SKILL.md, knowledge/, scripts/, …) | Chỉ thêm theo zones và quy trình trong architect.md |

---

## VALIDATION (Checklist theo SKILL.md Phase 4.3)

- [x] Mục tiêu được nêu rõ (làm rõ prompt + xác lập rule; tránh hướng sai, lòng vòng).
- [x] Có Context (dự án, architect, .agent/rules/).
- [x] Có Task (2 bước) và Constraints.
- [x] Có Output format (bản làm rõ + rule trong .agent/rules/, .md).
- [x] Có ví dụ (bảng tránh/nên).
- [x] Có thể verify (đối chiếu với architect.md và nội dung trong .agent/rules/).

---

**Skill đã dùng:** `list-skill/prompt-improver` (SKILL.md)  
**File kết quả:** `rules/prompt-clarified-by-skill.md`  
**Ngày tạo:** 2026-02-10
