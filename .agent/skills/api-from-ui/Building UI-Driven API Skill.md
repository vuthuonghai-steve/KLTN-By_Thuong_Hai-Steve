## 📊 Tổng Hợp Từ Các Skills Tham Khảo

### 1. Từ `skill-creator`:

```
┌─────────────────────────────────────────────────────────────┐
│  SKILL STRUCTURE                                           │
├─────────────────────────────────────────────────────────────┤
│  skill-name/                                               │
│  ├── SKILL.md (required)                                   │
│  │   ├── YAML frontmatter (name, description)              │
│  │   └── Markdown instructions                             │
│  └── Bundled Resources (optional)                          │
│      ├── scripts/    → Executable code                     │
│      ├── references/ → Documentation to load as needed     │
│      └── assets/     → Templates, files for output         │
└─────────────────────────────────────────────────────────────┘
```

**Key insights:**

- Progressive disclosure: Metadata → SKILL.md → Resources
- Writing style: Imperative form (verb-first)
- References keep SKILL.md lean

### 2. Từ `payload`:

- Quick Reference Table cho common tasks
- Security Pitfalls section
- Links to detailed docs in `reference/`
- Code examples với ✅ CORRECT / ❌ WRONG patterns

### 3. Từ `vercel-react-best-practices`:

- Rules organized by Priority
- Prefix system (`async-`, `bundle-`, etc.)
- Quick Reference với bullet points
- Links to individual rule files

### 4. Từ `api-integration`:

- Workflow phases: Research → Integrate → Sync
- Step-by-step process
- Input/Output examples
- Trigger phrases

---

## 🎯 Mục Tiêu Của Skill Mới

```
┌─────────────────────────────────────────────────────────────┐
│  UI-DRIVEN API BUILDER SKILL                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  INPUT:                                                     │
│  ┌──────────────────────────────────────┐                  │
│  │  Screen Component (*.tsx)            │                  │
│  │  └── hooks/useXxxData.ts            │                  │
│  │       └── Gọi Payload REST API       │                  │
│  │            với depth=2               │                  │
│  └──────────────────────────────────────┘                  │
│                          │                                  │
│                          ▼                                  │
│  PROCESS:                                                   │
│  1. Phân tích UI cần những data gì?                        │
│  2. Phát hiện relationships/populated fields               │
│  3. Xác định security concerns                             │
│  4. Thiết kế DTO (Data Transfer Object)                    │
│  5. Tạo custom API endpoint                                │
│  6. Tạo service layer cho frontend                         │
│                          │                                  │
│                          ▼                                  │
│  OUTPUT:                                                    │
│  ┌──────────────────────────────────────┐                  │
│  │  Custom API (/api/v1/xxx)           │                  │
│  │  ├── route.ts                        │                  │
│  │  ├── service.ts                      │                  │
│  │  ├── types.ts                        │                  │
│  │  └── validators.ts                   │                  │
│  └──────────────────────────────────────┘                  │
│                                                             │
│  BENEFITS:                                                  │
│  • Tối ưu payload size (-50-80%)                          │
│  • Bảo mật (loại bỏ sensitive fields)                     │
│  • Query optimization (depth, select)                      │
│  • DTO pattern cho type safety                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. **Workflow của skill**

```
┌────────────────────────────────────────────────────────────────┐
│ PROPOSED PHASES                                                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│ PHASE 1: UI ANALYSIS (Phân tích UI)                           │
│ • Đọc Screen component                                         │
│ • Đọc hook fetch data                                          │
│ • Identify fields đang được sử dụng trong UI                  │
│ • Detect populated relationships                               │
│                                                                │
│ PHASE 2: DATA DESIGN (Thiết kế DTO)                           │
│ • So sánh UI cần vs Payload trả về                            │
│ • Loại bỏ fields không cần / nhạy cảm                         │
│ • Thiết kế DTO interface                                       │
│ • Xác định query optimization (depth, select)                 │
│                                                                │
│ PHASE 3: API IMPLEMENTATION (Tạo API)                         │
│ • Tạo route.ts, service.ts, types.ts                          │
│ • Map Payload entity → DTO                                     │
│ • Implement caching nếu cần                                    │
│                                                                │
│ PHASE 4: FRONTEND INTEGRATION (Tích hợp)                      │
│ • Tạo/update service frontend                                  │
│ • Update hook để dùng API mới                                  │
│ • Verify types sync                                            │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### 3. **Tài nguyên đi kèm**

Dựa trên pattern từ các skill khác, tôi đề xuất:

```
ui-driven-api-builder/
├── SKILL.md                          # Hướng dẫn chính
├── references/
│   ├── dto-design-patterns.md        # Patterns thiết kế DTO
│   ├── security-checklist.md         # Checklist bảo mật
│   ├── query-optimization.md         # Tối ưu Payload queries
│   └── common-screen-patterns.md     # Patterns phổ biến trong screens
├── assets/
│   ├── api-template/                 # Template cho API endpoint
│   │   ├── route.ts.template
│   │   ├── service.ts.template
│   │   └── types.ts.template
│   └── dto-template.ts.template      # Template cho DTO
```

---

Planner Response

Xuất sắc! File prompt này rất chi tiết và là nguồn cảm hứng tuyệt vời. Để tôi tổng hợp lại:

---

## 📋 Phân Tích File Prompt Gốc

```
┌─────────────────────────────────────────────────────────────────┐
│  WORKFLOW TỪ PROMPT GỐC                                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Step 0: [Skill] Đọc list skills, xác định skill áp dụng       │
│          ↓                                                      │
│  Step 1: [Research UI] Đọc hook + components                   │
│          → Liệt kê fields UI đang dùng                          │
│          → Tạo checklist "Fields UI cần"                        │
│          ↓                                                      │
│  Step 2: [Security Audit] Tìm relationships gây rò rỉ          │
│          → users, customers → Không trả về                      │
│          ↓                                                      │
│  Step 3: [Define DTO] Tạo StoreOrderDTO                        │
│          → Chỉ chứa fields UI cần                               │
│          → Loại bỏ sensitive fields                             │
│          ↓                                                      │
│  Step 4: [Implement] Map Order → DTO trong service             │
│          → Trả về { orders: DTO[], pagination, summary }        │
│          ↓                                                      │
│  Step 5: [Sync Frontend] Update types client                   │
│          → Apply Vercel React best practices                    │
│          ↓                                                      │
│  Step 6: [Verify] Test API + UI                                │
│          → Kiểm tra bảo mật                                     │
│          → Review accessibility                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Key Requirements Từ Prompt:

| ID | Requirement                               |
| -- | ----------------------------------------- |
| R1 | Nghiên cứu UI → Liệt kê fields cần  |
| R2 | Bảo mật → Không trả users/customers  |
| R3 | DTO → Type/interface cho API             |
| R4 | Giữ nguyên logic nghiệp vụ            |
| R5 | Config → Gom magic numbers               |
| R6 | Skills → Áp dụng các skill liên quan |

---

## 🎯 Cấu Trúc Skill `api-from-ui`

Dựa trên phân tích, tôi đề xuất cấu trúc skill như sau:

```
api-from-ui/
├── SKILL.md                              # Hướng dẫn chính (~2000 words)
│
├── references/
│   ├── workflow-phases.md                # Chi tiết 6 phases
│   ├── dto-design-patterns.md            # Patterns thiết kế DTO
│   ├── security-checklist.md             # Checklist bảo mật (users, customers, etc.)
│   ├── field-extraction-guide.md         # Hướng dẫn trích xuất fields từ UI
│   └── common-collections.md             # Collections hay gặp (orders, products, etc.)
│
├── assets/
│   ├── templates/
│   │   ├── types.ts.template             # Template cho DTO types
│   │   ├── service.ts.template           # Template cho backend service
│   │   └── client-service.ts.template    # Template cho frontend service
│   │
│   └── checklists/
│       ├── ui-fields-checklist.md        # Template checklist fields UI
│       └── security-audit-checklist.md   # Template audit bảo mật
│
└── scripts/ (optional)
    └── analyze-screen.py                 # Helper script phân tích screen
```

---

## 📝 Draft SKILL.md Content

Đây là draft structure cho SKILL.md:

```markdown
# api-from-ui

## When To Use
- Khi cần xây dựng custom API endpoint từ UI đang sử dụng Payload REST
- Khi cần tối ưu response size (loại bỏ fields không cần)
- Khi cần bảo mật response (loại bỏ users, customers object)
- Khi UI đã ổn định và cần custom API để tối ưu performance

## Workflow Overview

| Phase | Mô tả | Output |
|-------|-------|--------|
| 1. UI Analysis | Đọc Screen + Hook | Field Checklist |
| 2. Security Audit | Tìm sensitive relationships | Security Report |
| 3. DTO Design | Thiết kế interface | StoreOrderDTO |
| 4. Backend Implementation | Service + Route | API Endpoint |
| 5. Frontend Integration | Update service + types | Sync Types |
| 6. Verification | Test API + UI | Verification Report |

## Phase Details

### Phase 1: UI Analysis
[Chi tiết steps, examples]

### Phase 2: Security Audit
[Chi tiết steps, checklist]

... (các phase khác)

## Quick Reference

| Task | Pattern | Example |
|------|---------|---------|
| Map Order → DTO | [mapOrderToDTO(order)](cci:1://file:///home/steve/Documents/Intern/work/Flower/Agent-skill-api/src/app/api/v1/stores/store-orders/service.ts:91:0-156:1) | Xem references/dto-design-patterns.md |
| Loại bỏ users | `uploadedBy: undefined` | Không populate |
| Giữ nguyên logic | Chỉ thay return | `return { orders: ordersDTO, ... }` |

## Trigger Phrases
- "xây API từ UI"
- "tạo custom API cho screen"
- "tối ưu API response"
- "bảo mật API response"
- "build API for screen"
```

### User Input

1. hãy include script analyze-screen.py
2. skill cấu trúc cụ thể và chặt chẽ : Detailed (~3000 words): Full guide trong 1 file
3. ngôn ngữ cửa skill Mix (Tiếng Anh cho technical terms, Tiếng Việt cho explanations)

### Planner Response

Tuyệt vời! Tôi đã có đầy đủ thông tin. Để tôi tổng kết lại:

---

## 📋 Tổng Kết Explore Session

### Skill: `api-from-ui`

```
┌─────────────────────────────────────────────────────────────────┐
│  FINAL SPECIFICATION                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  📁 STRUCTURE:                                                  │
│  api-from-ui/                                                   │
│  ├── SKILL.md (~3000 words, detailed, mix language)            │
│  ├── scripts/                                                   │
│  │   └── analyze-screen.py                                      │
│  ├── references/                                                │
│  │   ├── workflow-phases.md                                     │
│  │   ├── dto-design-patterns.md                                 │
│  │   ├── security-checklist.md                                  │
│  │   └── common-collections.md                                  │
│  └── assets/                                                    │
│      ├── templates/                                             │
│      │   ├── types.ts.template                                  │
│      │   ├── service.ts.template                                │
│      │   └── client-service.ts.template                         │
│      └── checklists/                                            │
│          ├── ui-fields-checklist.md                             │
│          └── security-audit-checklist.md                        │
│                                                                 │
│  🎯 SCOPE: Option C (Full flow)                                 │
│  - Phase 1: UI Analysis                                         │
│  - Phase 2: Security Audit                                      │
│  - Phase 3: DTO Design                                          │
│  - Phase 4: Backend Implementation                              │
│  - Phase 5: Frontend Integration                                │
│  - Phase 6: Verification                                        │
│                                                                 │
│  🔧 SCRIPT: analyze-screen.py                                   │
│  - Input: Screen file path (.tsx)                               │
│  - Output: List of fields being accessed                        │
│  - Detects: property access, destructuring, optional chaining   │
│                                                                 │
│  🌐 LANGUAGE: Mix                                               │
│  - English: Technical terms, code examples                      │
│  - Vietnamese: Explanations, guidelines                         │
│                                                                 │
│  📚 KEY REFERENCES:                                             │
│  - payload skill (Payload patterns)                             │
│  - vercel-react-best-practices (Performance)                    │
│  - api-integration skill (Sync pattern)                         │
│  - skill-creator (Structure)                                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### SKILL.md Content Outline:

```markdown
1. FRONTMATTER
   - name: api-from-ui
   - description: Skill xây dựng custom API từ UI...

2. OVERVIEW (~200 words)
   - Mục đích
   - Khi nào sử dụng
   - Benefits

3. QUICK REFERENCE TABLE (~300 words)
   - Common tasks → Solutions
   - Phase → Output mapping

4. WORKFLOW PHASES (~1500 words)
   - Phase 1: UI Analysis (chi tiết)
   - Phase 2: Security Audit (chi tiết)
   - Phase 3: DTO Design (chi tiết)
   - Phase 4: Backend Implementation (chi tiết)
   - Phase 5: Frontend Integration (chi tiết)
   - Phase 6: Verification (chi tiết)

5. CODE PATTERNS (~600 words)
   - DTO mapping pattern
   - Service layer pattern
   - Frontend sync pattern

6. SECURITY GUIDELINES (~200 words)
   - Sensitive fields checklist
   - Common pitfalls

7. TOOL USAGE (~200 words)
   - analyze-screen.py usage
   - Template usage

8. TRIGGER PHRASES
```

---

## ✅ All Artifacts Created!

```
┌─────────────────────────────────────────────────────────────────┐
│  CHANGE: api-from-ui-skill                                      │
│  SCHEMA: spec-driven                                            │
│  STATUS: 4/4 artifacts complete ✓                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [x] proposal.md                                                │
│      → Problem statement, capabilities, impact                  │
│                                                                 │
│  [x] design.md                                                  │
│      → Decisions, file structure, risks                         │
│                                                                 │
│  [x] specs/ (5 capability specs)                                │
│      → skill-structure                                          │
│      → ui-analysis-workflow                                     │
│      → dto-design-pattern                                       │
│      → api-implementation-guide                                 │
│      → frontend-sync-pattern                                    │
│                                                                 │
│  [x] tasks.md (23 tasks in 7 groups)                           │
│      → 1. Initialize Skill Structure                            │
│      → 2. Create SKILL.md (~13 subtasks)                        │
│      → 3. Create analyze-screen.py Script                       │
│      → 4. Create References Documents                           │
│      → 5. Create Templates                                      │
│      → 6. Create Checklists                                     │
│      → 7. Testing & Verification                                │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Artifacts Location:

```
openspec/changes/api-from-ui-skill/
├── proposal.md
├── design.md
├── tasks.md
└── specs/
    ├── skill-structure/spec.md
    ├── ui-analysis-workflow/spec.md
    ├── dto-design-pattern/spec.md
    ├── api-implementation-guide/spec.md
    └── frontend-sync-pattern/spec.md
```

---
