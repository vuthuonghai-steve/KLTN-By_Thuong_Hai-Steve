# Complexity Thresholds — Tiêu chí phân loại độ phức tạp Skill

> Tài liệu domain cho `knowledge/complexity-matrix.md`
> Builder transform 100% nội dung này thành bảng phân loại trong knowledge file.

---

## Bảng phân loại

| Tiêu chí | Simple | Medium | Complex |
|----------|--------|--------|---------|
| **Số zones hoạt động** | 1–2 (Core + 1 zone phụ) | 3–4 zones | ≥ 5 zones |
| **Số files cần tạo trong §3** | ≤ 4 files | 5–8 files | ≥ 9 files |
| **Dependency với skill khác** | Không — skill hoạt động độc lập | Có thể đọc output từ skill khác nhưng không bắt buộc | Pipeline bắt buộc (vd: Architect→Planner→Builder) |
| **Interaction Points** | 1–2 gates đơn giản (confirm input → deliver output) | 3 gates (collect → analyze → deliver) | ≥ 4 gates + conditional gates (IP-E) |
| **Knowledge files mới cần tạo** | 0–1 file (dùng knowledge có sẵn) | 2–3 files domain mới | ≥ 4 files domain mới |
| **Scripts/Automation** | Không cần scripts | 1 script đơn giản (init, validate) | ≥ 2 scripts hoặc scripts phức tạp |
| **Loop/Verify** | 1 checklist cuối | 1 checklist + 1 phase-verify | Per-phase checklist + sim-test + final verify |

---

## Ví dụ thực tế

| Mức | Ví dụ skill | Lý do phân loại |
|-----|------------|-----------------|
| **Simple** | `greeting-responder` — respond to user greetings | 1 zone (Core), 2 files (SKILL.md + 1 template), 1 gate, không dependency |
| **Simple** | `typescript-error-explainer` — giải thích lỗi TS | 2 zones (Core + Knowledge), 3 files, 2 gates, không scripts |
| **Medium** | `sequence-design-analyst` — vẽ sequence diagram | 4 zones (Core + Knowledge + Templates + Loop), 6 files, 3 gates, 1 script |
| **Medium** | `api-from-ui` — build API từ UI | 3 zones, 5 files, 3 gates, đọc codebase nhưng không dependency chain |
| **Complex** | `skill-architect` v2 — thiết kế kiến trúc skill | 5 zones, 10 files, 5 gates (IP-1→IP-4 + IP-E), pipeline Architect→Planner→Builder |
| **Complex** | `master-skill` — orchestrate skill delivery | 5+ zones, 12+ files, multi-agent coordination |

---

## Tie-breaker Rules

Khi skill nằm ở ranh giới giữa 2 mức:

1. **Mặc định upgrade**: Nếu nghi ngờ giữa Simple và Medium → chọn **Medium**. Nếu nghi ngờ giữa Medium và Complex → chọn **Complex**.
2. **Dependency rule**: Nếu skill BẮT BUỘC chạy sau hoặc trước 1 skill khác trong pipeline → tự động **Complex**.
3. **New knowledge rule**: Nếu cần tạo ≥ 3 knowledge files hoàn toàn mới (không có source material sẵn) → upgrade 1 mức.
4. **Confidence fallback**: Nếu Architect confidence < 70% về complexity → hỏi user: "Tôi phân loại đây là [X]. Bạn đồng ý không?"

---

## Tác động của mức phân loại lên workflow

| Mức | Workflow path | Phases bắt buộc | Gates |
|-----|-------------|-----------------|-------|
| **Simple** | DETECT → COLLECT (rút gọn) → DESIGN (merge Analyze+Design) | 2 phases | IP-2 + IP-4 |
| **Medium** | DETECT → COLLECT → ANALYZE → DESIGN | 4 phases đầy đủ | IP-1 + IP-2 + IP-3 + IP-4 |
| **Complex** | DETECT → COLLECT → ANALYZE → ARCH-REVIEW → DESIGN | 5 phases | IP-1 + IP-2 + IP-3 + IP-3.5 + IP-4 |

### Simple path chi tiết

Khi skill được classify là Simple:
- **COLLECT rút gọn**: Chỉ hỏi tối đa 2 câu (Pain Point + Expected Output). Skip "User & Context" nếu đã rõ từ input.
- **Merge Analyze+Design**: Thay vì 2 phases riêng, AI làm 1 lần: map 3 Pillars + viết §3 + tạo diagrams trong cùng 1 lượt. Chỉ có 1 gate (IP-4) thay vì IP-3 + IP-4.
- **Self-score vẫn bắt buộc** nhưng chỉ cần score ≥ 3 cho các sections thực sự có nội dung (§1, §3, §4, §5, §10).
