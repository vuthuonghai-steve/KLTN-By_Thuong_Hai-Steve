# Complexity Matrix — Phân loại độ phức tạp Skill

> **Usage**: Dùng trong phase **DETECT** để tự động phân loại mức độ phức tạp của yêu cầu thiết kế và chọn workflow path phù hợp.

---

## 1. Bảng phân loại Thresholds

| Tiêu chí | Simple | Medium | Complex |
| :--- | :--- | :--- | :--- |
| **Số zones hoạt động** | 1–2 (Core + 1 zone phụ) | 3–4 zones | ≥ 5 zones |
| **Số files cần tạo trong §3** | ≤ 4 files | 5–8 files | ≥ 9 files |
| **Dependency với skill khác** | Không — skill hoạt động độc lập | Có thể đọc output từ skill khác nhưng không bắt buộc | Pipeline bắt buộc (vd: Architect→Planner→Builder) |
| **Interaction Points** | 1–2 gates đơn giản (confirm input → deliver output) | 3 gates (collect → analyze → deliver) | ≥ 4 gates + conditional gates (IP-E) |
| **Knowledge files mới cần tạo** | 0–1 file (dùng knowledge có sẵn) | 2–3 files domain mới | ≥ 4 files domain mới |
| **Scripts/Automation** | Không cần scripts | 1 script đơn giản (init, validate) | ≥ 2 scripts hoặc scripts phức tạp |
| **Loop/Verify** | 1 checklist cuối | 1 checklist + 1 phase-verify | Per-phase checklist + sim-test + final verify |

---

## 2. Ví dụ thực tế

| Mức | Ví dụ skill | Lý do phân loại |
| :--- | :--- | :--- |
| **Simple** | `greeting-responder` | 1 zone (Core), 2 files, 1 gate, không dependency |
| **Simple** | `typescript-error-explainer` | 2 zones (Core + Knowledge), 3 files, 2 gates, không scripts |
| **Medium** | `sequence-design-analyst` | 4 zones, 6 files, 3 gates, 1 script |
| **Medium** | `api-from-ui` | 3 zones, 5 files, 3 gates, không dependency chain |
| **Complex** | `skill-architect` v2 | 5 zones, 10 files, 5 gates, pipeline Architect→Planner→Builder |
| **Complex** | `master-skill` | 5+ zones, 12+ files, multi-agent coordination |

---

## 3. Tie-breaker Rules (Quy tắc phá vỡ ranh giới)

Khi một yêu cầu nằm giữa hai mức độ phức tạp, áp dụng các quy tắc sau:

1. **Mặc định upgrade**: Nếu nghi ngờ giữa Simple và Medium → chọn **Medium**. Nếu nghi ngờ giữa Medium và Complex → chọn **Complex**.
2. **Dependency rule**: Nếu skill BẮT BUỘC nằm trong một chuỗi pipeline (là đầu vào hoặc đầu ra bắt buộc của skill khác) → tự động xếp vào **Complex**.
3. **New knowledge rule**: Nếu cần thiết kế ≥ 3 knowledge files hoàn toàn mới (không có tài liệu nguồn sẵn có) → nâng cấp thêm 1 mức độ.
4. **Confidence fallback**: Nếu mức độ tự tin (confidence) < 70% → PHẢI dừng lại hỏi User: "Tôi đang phân loại đây là [Mức độ]. Bạn có đồng ý không?"

---

## 4. Tác động lên Workflow Path

| Mức | Workflow path | Phases bắt buộc | Gates |
| :--- | :--- | :--- | :--- |
| **Simple** | Path S | DETECT → COLLECT (rút gọn) → DESIGN (merge Analyze+Design) | IP-2 + IP-4 |
| **Medium** | Path M | DETECT → COLLECT → ANALYZE → DESIGN | IP-1 + IP-2 + IP-3 + IP-4 |
| **Complex** | Path C | DETECT → COLLECT → ANALYZE → ARCH-REVIEW → DESIGN | IP-1 + IP-2 + IP-3 + IP-3.5 + IP-4 |

### Chi tiết Simple Path (Workflow tối ưu)

Khi được phân loại là **Simple**, Skill Architect sẽ thực hiện:
- **COLLECT rút gọn**: Chỉ hỏi tối đa 2 câu trọng tâm (Pain Point + Expected Output). Tự động suy luận User/Context từ input ban đầu.
- **Merge Analyze + Design**: Model thực hiện ánh xạ 3 Pillars, viết §3 Zone Mapping và vẽ các diagrams trong cùng một lượt phản hồi. Chỉ duy trì 1 Checkpoint cuối cùng (IP-4).
- **Self-scoring**: Vẫn bắt buộc thực hiện nhưng chỉ áp dụng cho các sections có nội dung thực tế (§1, §3, §4, §5, §10).
