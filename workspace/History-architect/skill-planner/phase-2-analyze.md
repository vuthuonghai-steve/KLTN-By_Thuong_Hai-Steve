# Skill Planner — Phase 2: Analyze (Kết quả)

> Date: 2026-02-13
> Framework áp dụng: architect.md (3 Trụ cột + 7 Zones)

---

## Trụ cột 1: Tri thức (Knowledge)

| # | Tri thức | Loại | Mô tả |
|---|---------|------|-------|
| K1 | **skill-packaging.md** | Nền tảng (static) | Cách đóng gói human skill → agent skill. Mô hình 3 tầng. Checklist chuyển đổi. Nguyên tắc chống ảo giác |
| K2 | **design.md** (input) | Theo ngữ cảnh (dynamic) | Bản thiết kế từ Skill Architect — ground truth. Input từ `.skill-context/{name}/design.md` |

**Không cần** architect.md — đó là việc của Architect. Planner chỉ cần hiểu cách phân rã thiết kế.

---

## Trụ cột 2: Quy trình (Process)

### Flow tổng quan

```
READ ──────────────▶ ANALYZE ──────────────▶ WRITE ──▶ ✋ Confirm
```

### Chi tiết từng bước

| Bước | Hành động | Input | Output nội bộ |
|------|----------|-------|--------------|
| **READ** | Đọc design.md + resources/ + context prompt | design.md, resources/, user prompt | Hiểu rõ skill cần xây |
| **ANALYZE** | Với mỗi Zone trong design.md → phân tích 3 tầng (Domain, Technical, Packaging) | Dữ liệu từ READ + knowledge/skill-packaging.md | Bảng phân tích kiến thức + danh sách tasks |
| **WRITE** | Ghi todo.md theo template có sẵn. Trace mọi item về design.md | Kết quả ANALYZE | `.skill-context/{name}/todo.md` |

### Logic bước ANALYZE

```
Với MỖI Zone trong design.md (§3 Zone Mapping):
│
├── Zone có nội dung? (không phải "Không cần")
│   │
│   ├── CÓ → Phân tích 3 tầng:
│   │   ├── Tầng 1 (Domain): Kiến thức miền nào cần?
│   │   ├── Tầng 2 (Technical): Công cụ/kỹ thuật nào cần?
│   │   └── Tầng 3 (Packaging): Map vào zone bằng cách nào?
│   │
│   └── Sinh ra:
│       ├── Pre-requisite entries (bảng kiến thức)
│       └── Task entries (checkbox steps)
│
└── KHÔNG → Bỏ qua zone này
```

---

## Trụ cột 3: Kiểm soát (Guardrails)

| # | Guardrail | Mô tả | Lý do |
|---|-----------|-------|-------|
| G1 | **Trace bắt buộc** | Mọi item trong todo.md PHẢI trace về section cụ thể trong design.md | Chống ảo giác |
| G2 | **Phân biệt nguồn** | Đánh dấu `[TỪ DESIGN]` vs `[GỢI Ý BỔ SUNG]` | User biết đâu là yêu cầu, đâu là gợi ý |
| G3 | **Không phát minh** | Chỉ PHÂN RÃ thiết kế, không thêm requirements mới | Planner không phải Architect |
| G4 | **Liệt kê, không tự làm** | Liệt kê kiến thức cần → user chuẩn bị | User kiểm soát base kiến thức |
| G5 | **Neo vào design.md** | Dùng design.md làm ground truth duy nhất | Nếu thiếu → ghi Open Questions, không đoán |

---

## 7 Zones Mapping

| Zone | Cần? | Nội dung |
|------|------|---------|
| **Core (SKILL.md)** | ✅ | Persona: Senior Skill Planner. Flow: Read → Analyze → Write. 5 Guardrails |
| **Knowledge** | ✅ | `skill-packaging.md` — 3 tầng, checklist chuyển đổi, chống ảo giác |
| **Scripts** | ❌ | Không cần automation |
| **Templates** | ❌ | Dùng todo.md.template từ init_context |
| **Data** | ❌ | Không có config tĩnh |
| **Loop** | ✅ | `plan-checklist.md` — kiểm tra chất lượng todo.md |
| **Assets** | ❌ | Không có media |

**3/7 Zones cần thiết** → Skill gọn nhẹ.

---

## AI Blind Spots

| # | Blind Spot | Nguy cơ | Phòng tránh |
|---|-----------|---------|-------------|
| B1 | Bịa kiến thức miền | AI viết sai kiến thức domain | G1+G2: trace + đánh dấu nguồn |
| B2 | Tasks quá chung chung | "Viết SKILL.md" không đủ chi tiết | Checklist: mỗi task phải actionable |
| B3 | Bỏ sót Zone | Design nói cần Zone nhưng Planner quên | Đối chiếu mọi Zone trong design.md §3 |
| B4 | Sai thứ tự dependencies | Task B phụ thuộc A nhưng xếp A sau B | Tasks xếp theo dependency |
| B5 | Không phân biệt 3 tầng | Gộp Domain+Technical+Packaging | skill-packaging.md bắt buộc tách |

---

## Tools cần thiết

- File System (view_file): Đọc design.md, resources/
- File System (write_to_file): Ghi todo.md
- Không cần Terminal/Browser

---

**Status**: Phase 2 DONE ✅ — Sẵn sàng chuyển Phase 3 (Design)
