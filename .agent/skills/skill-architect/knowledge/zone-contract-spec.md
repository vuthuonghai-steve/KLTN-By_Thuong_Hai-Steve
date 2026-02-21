# Zone Mapping Contract Spec — Chuẩn hóa §3

> **Usage**: Dùng trong phase **ANALYZE** để hướng dẫn và kiểm tra tính hợp lệ của bảng §3 Zone Mapping. Đảm bảo contract giữa Architect và Planner luôn tường minh.

---

## 1. Schema bắt buộc cho §3

Bảng Zone Mapping PHẢI có đúng 4 cột sau:

| Cột | Quy định | Ví dụ |
| :--- | :--- | :--- |
| **Zone** | Tên zone theo 7-Zone Framework | `Knowledge`, `Scripts`, `Loop` |
| **Files cần tạo** | Tên file cụ thể, regex: `[a-z][a-z0-9_\-]+\.[a-z]+` | `knowledge/rules.md` |
| **Nội dung** | Mô tả ngắn gọn trách nhiệm của file (ngôi thứ 3) | "Chứa các rule validation..." |
| **Bắt buộc?** | Dùng emoji ✅ (Có) hoặc ❌ (Không) | ✅ |

---

## 2. Quy tắc Validation (Regex)

Tên file trong cột **Files cần tạo** PHẢI tuân thủ:
- Không dùng placeholder dạng `{name}`, `xxx`, `...`.
- PHẢI có đường dẫn tương đối từ gốc skill (vd: `knowledge/`).
- Ký tự cho phép: chữ thường, số, gạch nối, gạch dưới.

**Regex**: `[a-z][a-z0-9_\-]+\.[a-z]+`

---

## 3. Ví dụ chuẩn (Source: skill-architect v2)

| Zone | Files cần tạo | Nội dung | Bắt buộc? |
| :--- | :--- | :--- | :--- |
| Core | `SKILL.md` | Persona v2, adaptive workflow, guardrails, self-scoring hook | ✅ |
| Knowledge | `knowledge/complexity-matrix.md` | Bảng phân loại Simple/Medium/Complex + tie-breaker rule | ✅ |
| Knowledge | `knowledge/zone-contract-spec.md` | Schema bắt buộc §3: format, regex, examples | ✅ |
| Knowledge | `knowledge/scoring-rubric.md` | Rubric tự đánh giá 1–5 cho 10 sections | ✅ |
| Scripts | `scripts/init_context.py` | Khởi tạo cấu trúc `.skill-context/{name}/` | ✅ |
| Templates | `templates/design.md.template` | 10-section template mới kèm self-score row | ✅ |
| Loop | `loop/design-checklist.md` | Quality gate tổng (thêm per-phase check markers) | ✅ |
| Loop | `loop/phase-verify.md` | Checklist nhỏ nhúng cuối mỗi phase; sim-test Planner | ✅ |

---

## 4. Các lỗi thường gặp (Negative Case)

| Lỗi | Tại sao sai? | Cách sửa |
| :--- | :--- | :--- |
| `{name}_rules.md` | Dùng placeholder | Thay bằng tên cụ thể: `skill_rules.md` |
| `knowledge/...` | Thiếu file name cụ thể | Liệt kê chính xác file: `knowledge/flow-rules.md` |
| `N/A` | Bỏ trống cột bắt buộc | Ghi rõ ❌ nếu không cần thiết |
| Bỏ hàng Knowledge | Thiếu Zone | Luôn liệt kê đủ các Zones chính, ghi "Không cần" nếu không dùng |
