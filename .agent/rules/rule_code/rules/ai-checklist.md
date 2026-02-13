---
# === FRONTMATTER ===
schema_version: "1.0.0"
document_type: "ai-checklist"
scope: "workspace"
priority: 0

metadata:
  version: "1.0.0"
  created: "2025-12-22"
  parent: "MASTER.md"

applies_to:
  - claude
  - gemini
  - codex
  - antigravity

purpose: "Checklist bắt buộc cho AI agents để đảm bảo tuân thủ rules"
---

# AI AGENT CHECKLIST - Quality Control

> **🎯 MỤC ĐÍCH**: Checklist bắt buộc AI agents PHẢI verify trước khi tạo/sửa code
>
> **📋 USAGE**: AI đọc checklist này TRƯỚC KHI thực hiện actions
>
> **🔗 Parent**: [MASTER.md](./MASTER.md)

---

## I. TRƯỚC KHI BẮT ĐẦU TASK MỚI

### 1.1 Context Loading Checklist

- [ ] Đã đọc `MASTER.md` (Universal Rules)?
- [ ] Đã đọc project-specific `CONTEXT.md`?
  - Backend: `Agent-skill-api/.rule-project/CONTEXT.md`
  - Frontend: `Agent-skill-web/.rule-project/CONTEXT.md`
- [ ] Đã check `context-exports-inventory.md` để tránh duplicate?
- [ ] Hiểu rõ Workflow Protocol (7 bước)?

### 1.2 Requirements Understanding

- [ ] Đã phân tích yêu cầu và trình bày lại cách hiểu?
- [ ] Đã nhận được XÁC NHẬN từ Steve?
- [ ] Đã xác định rõ scope (tạo mới vs sửa existing)?

---

## II. TRƯỚC KHI TẠO FILE/FOLDER MỚI

### 2.1 Naming Convention Checklist

- [ ] **Tên < 50 ký tự**?
- [ ] **Tên mô tả rõ chức năng/vai trò**?
  - ❌ `utils.ts` → ✅ `format-currency-utils.ts`
  - ❌ `handler.ts` → ✅ `payment-webhook-handler.ts`
- [ ] **Không dùng generic names**: `data`, `temp`, `handler`, `util`
- [ ] **Dùng đúng case convention**?
  - Variables/Functions: `camelCase`
  - Components/Types: `PascalCase`
  - Folders: `kebab-case`
  - Constants: `UPPER_SNAKE_CASE`

### 2.2 Barrel Pattern Checklist

- [ ] **Step 1**: Folder đích đã có `index.ts` chưa?
  - Nếu CHƯA → Tạo `index.ts` TRƯỚC
  - Nếu CÓ → Proceed

- [ ] **Step 2**: Tạo implement file

- [ ] **Step 3**: Export ngay trong `index.ts`
  ```typescript
  export * from './my-file'
  ```

- [ ] **Step 4**: Verify import path
  - ✅ `import { X } from '@/folder'`
  - ❌ `import { X } from '@/folder/my-file'`

### 2.3 Location Checklist (Frontend)

- [ ] UI components → `components/ui/`
- [ ] Customer features → `components/customer/`
- [ ] Seller features → `components/seller/`
- [ ] Custom hooks → `hooks/`
- [ ] Global state → `stores/`
- [ ] API calls → `services/`
- [ ] Types → `types/`
- [ ] Utilities → `utils/`

### 2.4 Location Checklist (Backend)

- [ ] Collections → `collections/`
- [ ] API routes → `app/api/v1/{feature}/route.ts`
- [ ] Services → `services/`
- [ ] Lib utilities → `lib/`
- [ ] Hooks (Payload) → `collections/{collection}/hooks/`

---

## III. TRƯỚC KHI IMPORT CODE

### 3.1 Import Path Verification

- [ ] Import từ **folder path** (Barrel Pattern)?
  - ✅ `import { X } from '@/stores'`
  - ❌ `import { X } from '@/stores/authSlice'`

- [ ] Import order đúng?
  1. React imports
  2. Next.js imports
  3. External packages
  4. Internal `@/` alias
  5. Relative imports

### 3.2 Dependency Check

- [ ] Package đã có trong `package.json`?
- [ ] KHÔNG tự ý cài package mới (cần permission)?

---

## IV. TRƯỚC KHI VIẾT CODE

### 4.1 Code Style Checklist

- [ ] Comments/Logs/Errors bằng **Tiếng Việt**?
- [ ] Indentation: **2 spaces**?
- [ ] **KHÔNG** dùng semicolons?
- [ ] Quotes:
  - Frontend: Single quotes `'`
  - Backend: Double quotes `"`

### 4.2 Architecture Compliance

**Frontend**:
- [ ] `/app/` routes là thin wrappers (5-10 dòng)?
- [ ] Business logic nằm trong `/screens/`?
- [ ] API flow: Component → Hook → Service → API?

**Backend**:
- [ ] Dùng helpers từ `@/lib/api-response.ts`?
- [ ] Validation dùng Zod từ `@/lib/validation.ts`?
- [ ] KHÔNG tạo CRUD manual cho PayloadCMS collections?

### 4.3 Security Checklist

- [ ] **KHÔNG** có hardcoded secrets?
- [ ] **KHÔNG** có fallback values cho secrets?
  - ❌ `process.env.SECRET || 'default'`
  - ✅ `if (!process.env.SECRET) throw Error()`
- [ ] **KHÔNG** bypass authentication cho dev environment?
- [ ] Sensitive endpoints có rate limiting?

---

## V. TRƯỚC KHI TẠO CODE MẪU

### 5.1 Permission Check

- [ ] Steve có **YÊU CẦU** tạo code không?
- [ ] Nếu KHÔNG → **NGHIÊM CẤM** tạo code mẫu
  - Lý do: Làm loạn tầm nhìn của Steve về cách tiếp cận

### 5.2 Example Code Policy

- [ ] Chỉ tạo code khi:
  - Steve yêu cầu implement
  - Steve xác nhận hướng tiếp cận
  - Đã trình bày và được approve

---

## VI. TRƯỚC KHI SUBMIT CODE (FINAL CHECK)

### 6.1 Quality Gates

- [ ] Code tuân thủ naming convention?
- [ ] All imports dùng Barrel Pattern?
- [ ] Comments/logs bằng Tiếng Việt?
- [ ] Không có generic names (`data`, `temp`, etc.)?
- [ ] Không có hardcoded secrets?

### 6.2 Documentation Update

- [ ] Cần update `context-exports-inventory.md`?
  - Khi tạo: Component mới, Hook mới, Store mới, Service mới
- [ ] Cần update `CONTEXT.md`?
  - Khi thay đổi architecture
  - Khi thêm collection mới (backend)

### 6.3 Testing Verification

- [ ] Code có lỗi syntax không?
- [ ] Import paths hoạt động đúng?
- [ ] Type errors resolved?

---

## VII. WORKFLOW PROTOCOL REMINDER

```
1. PHÂN TÍCH yêu cầu → Trình bày cách hiểu
2. CHỜ XÁC NHẬN từ Steve
3. NGHIÊN CỨU codebase (đọc CONTEXT.md)
4. ĐỀ XUẤT hướng tiếp cận (NGÔN NGỮ TỰ NHIÊN + LAYERS)
5. CHỜ XÁC NHẬN lần 2
6. THỰC HIỆN task
7. CẬP NHẬT documentation
```

**CRITICAL**: KHÔNG bỏ qua bước CHỜ XÁC NHẬN!

---

## VIII. COMMON MISTAKES TO AVOID

| ❌ Mistake | ✅ Correct Behavior |
|-----------|---------------------|
| Import trực tiếp từ file | Import từ folder (Barrel Pattern) |
| Tạo code mẫu không được yêu cầu | Chỉ mô tả approach, CHỜ xác nhận |
| Dùng generic names | Dùng descriptive names |
| Bỏ qua workflow protocol | Tuân thủ 7 bước |
| Tự ý cài package | Xin phép trước |
| Hardcode secrets | Require từ env, throw error nếu thiếu |

---

## IX. SELF-VERIFICATION QUESTIONS

Trước khi submit, tự hỏi:

1. **Đã đọc MASTER.md chưa?** → Nếu chưa, đọc ngay
2. **Đã check exports-inventory chưa?** → Tránh duplicate
3. **Import path đúng Barrel Pattern chưa?** → Verify lại
4. **Tên file/function có rõ nghĩa không?** → Generic name = BAD
5. **Có hardcoded secrets không?** → Nguy hiểm!
6. **Đã nhận xác nhận từ Steve chưa?** → KHÔNG được bỏ qua

---

## X. REFERENCES

| Document | Path | Khi nào đọc |
|----------|------|------------|
| **Master Rules** | `.rules/MASTER.md` | Mỗi session mới |
| Backend Context | `Agent-skill-api/.rule-project/CONTEXT.md` | Làm backend |
| Frontend Context | `Agent-skill-web/.rule-project/CONTEXT.md` | Làm frontend |
| Exports Inventory (BE) | `Agent-skill-api/.rule-project/context-exports-inventory.md` | Trước khi tạo mới |
| Exports Inventory (FE) | `Agent-skill-web/.rule-project/context-exports-inventory.md` | Trước khi tạo mới |

---

**VERSION**: 1.0.0
**CREATED**: 2025-12-22
**MAINTAINED BY**: Development Team
**COMPLIANCE**: MANDATORY for all AI Agents
