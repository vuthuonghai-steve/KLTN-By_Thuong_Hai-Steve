┌─────────────────────────────────────────────────────────┐
│  knowledge/skill-packaging.md — Nội dung cốt lõi       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. NGUYÊN TẮC ĐÓNG GÓI                                │
│     • Kỹ năng con người = Kiến thức + Quy trình        │
│       + Phán đoán                                       │
│     • AI cần tất cả 3 thứ đó ở dạng TƯỜNG MINH         │
│     • Phán đoán → phải chuyển thành Guardrails          │
│                                                         │
│  2. MÔ HÌNH 3 TẦNG KIẾN THỨC                           │
│     ┌────────────────────────────────┐                  │
│     │ Tầng 3: PACKAGING             │ ← thế giới skill │
│     │  Map human skill → 7 Zones    │                   │
│     ├────────────────────────────────┤                  │
│     │ Tầng 2: TECHNICAL             │ ← công cụ/kỹ thuật│
│     │  Mermaid, Python, YAML...     │                   │
│     ├────────────────────────────────┤                  │
│     │ Tầng 1: DOMAIN                │ ← kiến thức miền │
│     │  Sequence diagram, API, UML...│                   │
│     └────────────────────────────────┘                  │
│                                                         │
│  3. CHECKLIST CHUYỂN ĐỔI                                │
│     Với mỗi "kỹ năng" trong design.md, hỏi:            │
│     • Kiến thức miền nào cần? → knowledge/ files        │
│     • Công cụ/kỹ thuật nào cần? → scripts/, tools      │
│     • Quy trình nào cần chuẩn hóa? → SKILL.md phases   │
│     • Phán đoán nào cần guardrail? → loop/ checklists   │
│     • Output nào cần khuôn mẫu? → templates/            │
│                                                         │
│  4. NGUYÊN TẮC CHỐNG ẢO GIÁC                            │
│     • Mọi task trong todo.md PHẢI trace về design.md    │
│     • Không phát minh requirements mới (chỉ phân rã)    │
│     • Không đoán kiến thức miền — liệt kê để user      │
│       cung cấp                                          │
│     • Đánh dấu rõ: [TỪ DESIGN] vs [GỢI Ý BỔ SUNG]     │
│                                                         │
└─────────────────────────────────────────────────────────┘