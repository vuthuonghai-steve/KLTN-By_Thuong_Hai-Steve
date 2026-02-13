# Skill Planner — Phase 1: Collect (Kết quả)

> Date: 2026-02-13
> Skill Architect session cho skill #2 trong bộ Master Skill Suite

---

## Skill Overview

- **Skill Name**: skill-planner
- **Vị trí trong bộ 3**: #2 (Architect → **Planner** → Builder)
- **Pain Point**: Sau khi có bản thiết kế kiến trúc (design.md từ Skill Architect), người dùng không biết bắt đầu từ đâu, cần chuẩn bị kiến thức gì, và triển khai theo thứ tự nào
- **User & Context**: AI Agent + người dùng đang xây dựng skill mới, đã có design.md từ Skill #1
- **Expected Output**: `.skill-context/{skill-name}/todo.md` — kế hoạch triển khai chi tiết

---

## Decisions đã thống nhất

### P-D1: Liệt kê, không tự tìm
- Planner **liệt kê** kiến thức cần chuẩn bị để user nắm bắt được cần làm gì
- Planner **KHÔNG** tự động tìm kiếm tài liệu (không search web, không read docs)
- Đây là bước chuẩn bị base kiến trúc + kiến thức cho skill

### P-D2: Có knowledge nền về đóng gói kỹ năng
- Planner cần có kiến thức riêng về **cách đóng gói kỹ năng con người → Agent Skill**
- Sử dụng design.md làm **chuẩn/neo** (ground truth) → chống ảo giác và bịa
- File knowledge: `knowledge/skill-packaging.md`
- Nội dung knowledge:
  - Nguyên tắc đóng gói (Kiến thức + Quy trình + Phán đoán → tường minh hóa)
  - Mô hình 3 tầng kiến thức
  - Checklist chuyển đổi human skill → agent skill
  - Nguyên tắc chống ảo giác (trace về design.md)

### P-D3: 3 tầng kiến thức — ĐỦ dùng
Planner phân tích kiến thức theo 3 tầng:

| Tầng | Tên | Mô tả | Ví dụ (skill vẽ sequence diagram) |
|------|-----|-------|----------------------------------|
| 1 | **Domain** | Kiến thức miền — hiểu bản chất thứ cần làm | Sequence diagram là gì, thành phần, quy tắc |
| 2 | **Technical** | Kỹ thuật triển khai — công cụ, cú pháp | Mermaid syntax, participant, ->>>, Note |
| 3 | **Packaging** | Đóng gói kỹ năng — chuyển từ human skill → AI skill | Map quy trình vào 7 Zones, externalize tacit knowledge |

### P-D4: Flow liên tục, confirm cuối
- Planner chạy một mạch: **Read → Analyze → Write todo.md**
- Chỉ confirm ở **cuối** khi đã có output
- User làm rõ/sửa nếu cần sau khi thấy kết quả
- Khác với Architect (3 interaction points) vì input đã được confirm sẵn

---

## Input của Planner

```
1. design.md (BẮT BUỘC)
   └── Bản thiết kế từ Skill Architect — đã được user confirm

2. resources/ (NẾU CÓ)
   └── Tài liệu tham khảo user cung cấp trong .skill-context/{name}/resources/

3. Context prompt (NẾU CÓ)
   └── Tài liệu user đính kèm khi gọi Planner
```

## Output của Planner

```
todo.md gồm:
├── Pre-requisites (kiến thức 3 tầng cần chuẩn bị)
├── Phase Breakdown (các bước triển khai có thứ tự, checkbox)
├── Knowledge & Resources Needed (bảng tài liệu)
├── Definition of Done (tiêu chí hoàn thành)
└── Notes
```

## Cơ chế chống ảo giác

- Mọi task trong todo.md **PHẢI trace** về section trong design.md
- Không phát minh requirements mới (chỉ phân rã)
- Không đoán kiến thức miền — liệt kê để user cung cấp
- Đánh dấu rõ: `[TỪ DESIGN]` vs `[GỢI Ý BỔ SUNG]`

---

## Kiến trúc dự kiến

```
.agent/skills/skill-planner/
├── SKILL.md                     # Persona + Flow + Guardrails
├── knowledge/
│   └── skill-packaging.md       # Cách đóng gói human skill → agent skill
├── loop/
│   └── plan-checklist.md        # Kiểm tra chất lượng todo.md
└── (không cần scripts/templates — dùng template có sẵn từ init_context)
```

## Workflow so sánh với Architect

```
Architect:  Phase 1 ──▶ ✋ ──▶ Phase 2 ──▶ ✋ ──▶ Phase 3 ──▶ ✋
            (3 interaction points — đang KHÁM PHÁ, cần align liên tục)

Planner:    Read ──▶ Analyze ──▶ Write ──▶ ✋
            (1 interaction point — INPUT đã chuẩn, chỉ PHÂN RÃ)
```

---

**Status**: Phase 1 DONE ✅ — Sẵn sàng chuyển sang Phase 2 (Analyze)
