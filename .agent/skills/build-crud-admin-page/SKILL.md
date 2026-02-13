---
name: build-crud-admin-page
description: "Skill xay dung trang quan ly CRUD cho PayloadCMS collection. Su dung khi can tao admin screen moi theo pattern BouquetScreen. List view voi filter, pagination. Form view voi create, view, edit modes. Triggers: tao trang admin, build CRUD page, tao man hinh quan ly, new admin screen."
---

# Build CRUD Admin Page

Skill giup AI Agent xay dung trang quan ly CRUD cho bat ky PayloadCMS collection nao, theo dung pattern cua BouquetScreen.

## Overview

Skill nay cung cap workflow va references de tao:
- **ProductListView**: Danh sach voi filters, pagination, actions
- **ProductFormView**: Form voi 3 modes (create/view/edit)
- **Route files**: Next.js App Router structure

## When to Use

- User yeu cau tao trang admin moi cho collection
- Can implement CRUD interface cho PayloadCMS collection
- Refactor modal-based approach sang full-page views
- Ap dung BouquetScreen pattern cho collection khac

## Input Parameters

Khi skill duoc goi, thu thap cac thong tin sau:

| Parameter | Required | Description |
|-----------|----------|-------------|
| `collection` | Yes | Ten collection (vd: "reviews", "vouchers") |
| `fields` | No | Danh sach fields can hien thi (neu khong co se doc tu schema) |
| `docsPath` | No | Duong dan docs hien co (neu da co docs) |

---

## Workflow

### Output 1: Thu thap thong tin va Nghien cuu

**Muc tieu:** Hieu ro requirements va existing patterns

1. **Xac nhan input:**
   - Collection name
   - Fields can hien thi (hoi user neu chua ro)
   - Co can scope categories khong (nhu Accessory)

2. **Neu thieu fields:**
   - Doc collection schema tu PayloadCMS config
   - Liet ke fields va yeu cau user xac nhan

3. **Doc references:**
   ```
   ./references/architecture.md      # Folder structure, data flow
   ./references/template-guide.md    # Step-by-step guide
   ```

4. **Doi chieu voi code hien co:**
   - Tim BouquetScreen trong codebase
   - Hieu existing patterns va conventions

5. **Output cho user:**
   - Summary cua collection va fields
   - De xuat folder structure
   - Danh sach files can tao

---

### Output 2: Xay dung giao dien CRUD

**Muc tieu:** Implement day du theo checklist

1. **Tao folder structure:**
   ```
   src/screens/Admin/{Collection}Screen/
   ├── index.tsx
   ├── types/index.ts
   ├── constants/index.ts
   ├── views/
   │   ├── index.ts
   │   ├── ProductListView.tsx
   │   └── ProductFormView.tsx
   ├── components/ProductForm/
   │   ├── index.ts
   │   ├── ProductFormHeader.tsx
   │   ├── ProductFormActions.tsx
   │   ├── hooks/
   │   │   ├── index.ts
   │   │   └── useProductForm.ts
   │   └── sections/
   │       ├── index.ts
   │       └── ...Section.tsx
   └── hooks/
       ├── index.ts
       ├── useProductMetadata.ts
       └── useProductData.ts
   ```

2. **Implement theo checklist:**
   - Doc `./references/checklist.md`
   - Thuc hien tung buoc

3. **Ap dung UI/UX skills theo thu tu:**
   - Doc `./references/ui-skills-summary.md`
   - **ui-ux-pro-max** → Design system truoc khi code
   - **vercel-composition-patterns** → Component architecture
   - **vercel-react-best-practices** → Trong qua trinh implement
   - **web-design-guidelines** → Review cuoi cung

4. **Tao route files:**
   ```
   src/app/(frontend)/manager/products-{collection}/
   ├── page.tsx              # List view
   ├── new/
   │   └── page.tsx          # Create mode
   └── [id]/
       └── page.tsx          # View/Edit mode
   ```

5. **Xu ly errors:**
   - Doc `./references/errors.md` neu gap loi

---

## Key Patterns

### Form Mode Pattern

```typescript
type FormMode = 'create' | 'view' | 'edit'

// Mode determination tu URL
const currentMode = productId
  ? (urlMode === 'edit' ? 'edit' : 'view')
  : 'create'

// Mode-based behavior
const isReadOnly = mode === 'view'
const isEditing = mode === 'edit'
const isCreating = mode === 'create'
```

### Route Structure

| Route | Component | Mode |
|-------|-----------|------|
| `/manager/products-{collection}` | ProductListView | List |
| `/manager/products-{collection}/new` | ProductFormView | Create |
| `/manager/products-{collection}/[id]` | ProductFormView | View |
| `/manager/products-{collection}/[id]?mode=edit` | ProductFormView | Edit |

### Component Responsibilities

| Component | Responsibility |
|-----------|---------------|
| **ProductListView** | Fetch, display, filter, paginate, navigate |
| **ProductFormView** | Orchestrate form state, mode switching, submission |
| **Form Sections** | Handle specific field groups |
| **Hooks** | Data fetching, form state, metadata |

---

## References

| File | Description |
|------|-------------|
| `./references/README.md` | Overview cua tat ca references |
| `./references/architecture.md` | Folder structure, data flow, component responsibilities |
| `./references/template-guide.md` | Step-by-step guide ap dung cho collection moi |
| `./references/implementation-logic.md` | Chi tiet logic (form mode, metadata, categories) |
| `./references/checklist.md` | Checklist trien khai tung buoc |
| `./references/errors.md` | Loi thuong gap va cach xu ly |
| `./references/ui-skills-summary.md` | Tom tat 4 UI/UX skills can tham khao |

---

## Success Criteria

- [ ] Folder structure theo dung architecture.md
- [ ] Types va constants duoc dinh nghia
- [ ] ProductListView hoat dong voi filters va pagination
- [ ] ProductFormView hoat dong voi 3 modes
- [ ] Route files duoc tao dung
- [ ] Form validation hoat dong
- [ ] API integration hoan chinh
- [ ] UI/UX review pass

---

## Example Usage

**User request:** "Tao trang admin quan ly reviews"

**Agent response:**

1. Thu thap thong tin:
   - Collection: `reviews`
   - Fields: rating, comment, customer, product, status, createdAt

2. Doc references va code hien co

3. De xuat plan:
   - Folder: `src/screens/Admin/ReviewScreen/`
   - Views: ReviewListView, ReviewFormView
   - Routes: `/manager/reviews`, `/manager/reviews/[id]`

4. Implement theo checklist

5. Apply UI/UX skills

6. Test va review
