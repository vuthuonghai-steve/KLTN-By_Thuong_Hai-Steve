# **BUILD GUIDELINES (Usage: Quy chuẩn viết nội dung)**

> **Usage**: Hướng dẫn Kỹ sư cách viết và tổ chức nội dung cho từng Zone. Dùng trong Step BUILD.

---

## 1. NGUYÊN TẮC VIẾT SKILL.MD (CORE)

- **Ngôn ngữ**: Tuyệt đối dùng thể mệnh lệnh (Imperative).
- **Phân tầng (PD)**: Mọi file trong `knowledge/`, `scripts/`, `loop/` phải có ít nhất 1 link tham chiếu từ `SKILL.md`.
- **Phases**: Chia workflow thành các Phase có thể đánh dấu hoàn thành.

## 2. NGUYÊN TẮC VIẾT KNOWLEDGE

- Mỗi file phải có header **Usage** mô tả mục đích và thời điểm sử dụng.
- Ưu tiên bảng và sơ đồ Mermaid.
- Nội dung domain phải dẫn nguồn từ `resources/`.

## 3. NGUYÊN TẮC VIẾT LOOP (CHECKLIST & LOG)

- **Checklist**: Phải ghi rõ tiêu chí có thể đo lường (measurable).
- **Build-log**: Phải phản ánh trung thực thực tế:
  * Số lượng Placeholder thực tế.
  * Tick checkbox `[x]` chỉ khi task ĐÃ hoàn thành thực sự.
  * Ghi rõ lý do nếu dừng build (Error Policy).

## 4. QUY TẮC ĐẶT TÊN (Naming)

- **Skill Name**: kebab-case (ví dụ: `skill-builder`).
- **Files trong Knowledge**: kebab-case.
- **Scripts**: snake_case hoặc kebab-case.
- **Checklist/Log**: kebab-case.
