# Workflow Phases - Chi Tiết

Tài liệu này mô tả chi tiết 6 phases trong workflow xây dựng API từ UI.

## Phase 1: UI Analysis (Phân Tích UI)

### Mục tiêu
Xác định chính xác những fields nào UI đang sử dụng từ API response.

### Input
- Screen component file (*.tsx)
- Data fetching hook (useXxxData.ts)
- Sub-components (Table, Dialog, Filters, Stats)

### Output
- Danh sách fields UI đang access
- Field mapping table

### Steps Chi Tiết

#### Step 1.1: Identify Files
```
src/screens/{Feature}Screen/
├── index.tsx                     # Main screen component
├── hooks/
│   └── use{Feature}Data.ts       # ⭐ BẮT ĐẦU TỪ ĐÂY
├── components/
│   ├── {Feature}Table.tsx        # Table columns → fields
│   ├── {Feature}Dialog.tsx       # Detail view → fields
│   ├── {Feature}Filters.tsx      # Filter options → fields
│   └── {Feature}Stats.tsx        # Statistics → fields
└── types/
    └── index.ts                  # Type definitions
```

#### Step 1.2: Run Analysis Script
```bash
python .agent/skills/api-from-ui/scripts/analyze-screen.py \
  src/screens/Store/StoreOrdersScreen/hooks/useStoreOrdersData.ts
```

#### Step 1.3: Manual Review
Sau khi chạy script, review thủ công:
- [ ] Fields trong table columns
- [ ] Fields trong dialog/detail view
- [ ] Fields trong filters
- [ ] Fields trong stats/summary
- [ ] Fields trong action handlers

### Example Output
```
=== Fields Detected ===

ROOT LEVEL:
  - id
  - code
  - status
  - paymentStatus

NESTED (order):
  - order.deliveryAddress.names
  - order.deliveryAddress.phoneNumbers
  - order.items

ARRAY ITEMS:
  - items[].product.name
  - items[].quantity
  - items[].price
```

---

## Phase 2: Security Audit

### Mục tiêu
Xác định tất cả fields nhạy cảm cần loại bỏ khỏi DTO.

### Input
- Field list từ Phase 1
- Collection definition file (*.ts)

### Output
- Danh sách sensitive fields
- Security recommendation

### Steps Chi Tiết

#### Step 2.1: Open Collection Definition
```bash
# Mở file collection
cat src/collections/orders/Order.ts
```

#### Step 2.2: Search for Sensitive Relationships
```typescript
// Tìm các patterns này:
relationTo: 'users'      // ⚠️ User data
relationTo: 'customers'  // ⚠️ Customer PII
type: 'relationship'     // Cần review
```

#### Step 2.3: Use Security Checklist
Xem `assets/checklists/security-audit-checklist.md`

### Sensitive Field Patterns

| Pattern | Risk Level | Action |
|---------|------------|--------|
| `users` relationship | 🔴 HIGH | Remove |
| `customers` relationship | 🔴 HIGH | Remove |
| `password*` fields | 🔴 CRITICAL | Never return |
| `*token*` fields | 🔴 HIGH | Never return |
| `*secret*` fields | 🔴 HIGH | Never return |
| Internal timestamps | 🟡 MEDIUM | Review |
| Admin notes | 🟡 MEDIUM | Remove |

---

## Phase 3: DTO Design

### Mục tiêu
Thiết kế DTO interface chỉ chứa fields UI cần.

### Input
- Field list từ Phase 1
- Security audit từ Phase 2

### Output
- DTO interface definition
- Types cho nested objects

### Steps Chi Tiết

#### Step 3.1: Determine DTO Name
```typescript
// Pattern: {Feature}DTO
interface StoreOrderDTO { ... }
interface ProductListItemDTO { ... }
```

#### Step 3.2: Map Fields to DTO
Sử dụng template từ `assets/templates/types.ts.template`

#### Step 3.3: Handle Nested Objects
```typescript
// Tách nested objects thành separate DTOs nếu phức tạp
interface DeliveryAddressDTO {
  names: Array<{ fullName: string }>
  phoneNumbers: Array<{ number: string }>
  address: string
}

interface StoreOrderDTO {
  deliveryAddress: DeliveryAddressDTO
}
```

---

## Phase 4: Backend Implementation

### Mục tiêu
Tạo custom API endpoint với DTO mapping.

### Input
- DTO interface từ Phase 3

### Output
- route.ts
- service.ts
- types.ts

### File Structure
```
src/app/api/v1/{feature}/
├── route.ts        # HTTP handler
├── service.ts      # Business logic + DTO mapping
├── types.ts        # DTO interfaces
└── validators.ts   # Zod schemas (optional)
```

### Key Implementation Points

1. **mapToDTO function**: Luôn tạo function riêng để map entity → DTO
2. **Type safety**: Import types từ payload-types và DTO types
3. **Keep logic**: Giữ nguyên business logic, chỉ thay output format

---

## Phase 5: Frontend Integration

### Mục tiêu
Sync frontend types và update hooks.

### Input
- Backend DTO từ Phase 4

### Output
- Updated frontend types
- Updated services
- Updated hooks

### Steps Chi Tiết

#### Step 5.1: Copy DTO Interface
Copy interface từ backend types.ts sang frontend:
```
src/api/services/{feature}.service.ts
```

#### Step 5.2: Update Service Function
```typescript
// Đổi return type sang DTO
export const fetchData = async (): Promise<FeatureDTO[]> => {
  // ...
}
```

#### Step 5.3: Update Hook
```typescript
// Update type annotations trong hook
const [data, setData] = useState<FeatureDTO[]>([])
```

---

## Phase 6: Verification

### Mục tiêu
Đảm bảo API mới hoạt động đúng và an toàn.

### Input
- Deployed API endpoint
- UI components

### Output
- Verification report
- Sign-off

### Verification Checklist

#### Security Verification
- [ ] Response không chứa `uploadedBy`
- [ ] Response không chứa `customer` object
- [ ] Response không chứa `password` hoặc `token`
- [ ] Response không chứa internal IDs không cần thiết

#### Functional Verification
- [ ] Table hiển thị đúng data
- [ ] Dialog/detail view hoạt động
- [ ] Filters hoạt động
- [ ] Pagination hoạt động
- [ ] Search hoạt động
- [ ] Actions (create/update/delete) hoạt động

#### Performance Verification
- [ ] Response size giảm đáng kể
- [ ] Response time chấp nhận được
- [ ] No N+1 queries

---

## Workflow Summary

```
Phase 1 ──► Phase 2 ──► Phase 3 ──► Phase 4 ──► Phase 5 ──► Phase 6
   │           │           │           │           │           │
   ▼           ▼           ▼           ▼           ▼           ▼
Fields     Security    DTO Type    Backend    Frontend    Verify
 List       Audit      Define     Service     Sync        OK
```
