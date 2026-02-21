---
name: api-from-ui
description: Skill xây dựng custom API endpoint từ UI đang hoạt động. Sử dụng khi cần (1) phân tích Screen để xác định fields cần thiết, (2) thiết kế DTO an toàn loại bỏ sensitive data, (3) tạo custom API thay thế Payload REST, (4) sync types giữa backend và frontend. Trigger khi UI đã ổn định và cần tối ưu API.
---

# API From UI

Skill này cung cấp quy trình chuẩn hóa để xây dựng custom API endpoint từ UI đang sử dụng Payload REST API. Mục tiêu chính là tối ưu response size, tăng bảo mật, và chuẩn hóa workflow phát triển API.

## Khi Nào Sử Dụng Skill Này

| Tình huống | Áp dụng |
|------------|---------|
| UI đang gọi Payload REST với `depth=1-2` | ✅ |
| Response chứa thông tin nhạy cảm (users, customers object) | ✅ |
| Cần giảm payload size để tối ưu performance | ✅ |
| UI đã ổn định, sẵn sàng cho production | ✅ |
| Đang develop UI mới, chưa ổn định | ❌ |
| Chỉ cần simple CRUD operations | ❌ |

## Benefits

1. **Bảo mật**: Loại bỏ sensitive fields (users, customers) khỏi response
2. **Hiệu năng**: Giảm response size 50-80% bằng cách chỉ trả fields UI cần
3. **Type Safety**: DTO interfaces rõ ràng cho cả backend và frontend
4. **Maintainability**: Workflow chuẩn hóa, dễ follow và review

---

## Quick Reference

| Task | Solution | Chi tiết |
|------|----------|----------|
| Phân tích Screen component | `python analyze-screen.py path/to/Screen.tsx` | [Phase 1](#phase-1-ui-analysis) |
| Tìm sensitive relationships | Check `relationTo: 'users'`/`'customers'` | [Phase 2](#phase-2-security-audit) |
| Thiết kế DTO interface | Follow `{Feature}DTO` pattern | [Phase 3](#phase-3-dto-design) |
| Map Payload entity → DTO | Implement `mapToDTO()` function | [Phase 4](#phase-4-backend-implementation) |
| Sync frontend types | Update service + hook | [Phase 5](#phase-5-frontend-integration) |
| Verify bảo mật | Check response không có users/customers | [Phase 6](#phase-6-verification) |

---

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 1: UI ANALYSIS                                          │
│  Input: Screen.tsx, useXxxData.ts                              │
│  Output: Danh sách fields UI đang sử dụng                       │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 2: SECURITY AUDIT                                       │
│  Input: Field list, Order.ts (collection)                      │
│  Output: Sensitive fields cần loại bỏ                          │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 3: DTO DESIGN                                           │
│  Input: UI fields + Security audit                             │
│  Output: StoreOrderDTO interface                               │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 4: BACKEND IMPLEMENTATION                               │
│  Input: DTO interface                                          │
│  Output: route.ts, service.ts, types.ts                        │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 5: FRONTEND INTEGRATION                                 │
│  Input: Backend DTO                                            │
│  Output: Updated service.ts, hook, types                       │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│  PHASE 6: VERIFICATION                                         │
│  Input: API endpoint, UI                                       │
│  Output: Verification report                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: UI Analysis

**Mục tiêu:** Xác định chính xác những fields nào UI đang sử dụng từ API response.

### Step 1.1: Xác định files cần phân tích

```
src/screens/{Feature}Screen/
├── index.tsx                     # Main screen
├── hooks/
│   └── use{Feature}Data.ts       # Data fetching hook ← QUAN TRỌNG
├── components/
│   ├── {Feature}Table.tsx        # Sử dụng fields cho table columns
│   ├── {Feature}Dialog.tsx       # Sử dụng fields cho detail view
│   ├── {Feature}Filters.tsx      # Sử dụng fields cho filters
│   └── {Feature}Stats.tsx        # Sử dụng fields cho statistics
└── types/
    └── index.ts                  # Type definitions
```

### Step 1.2: Chạy analyze-screen.py script

```bash
python .agent/skills/api-from-ui/scripts/analyze-screen.py \
  src/screens/Store/StoreOrdersScreen/hooks/useStoreOrdersData.ts
```

Script sẽ output danh sách fields:

```
=== Fields Detected ===

ROOT LEVEL:
  - id
  - code
  - status
  - paymentStatus
  - createdAt

NESTED (deliveryAddress):
  - deliveryAddress.names
  - deliveryAddress.phoneNumbers
  - deliveryAddress.address

ARRAY ITEMS (items):
  - items[].product.name
  - items[].product.type
  - items[].quantity
  - items[].price
```

### Step 1.3: Tạo Field Mapping Table

| UI Field Path | Payload Source | Needed in DTO | Notes |
|---------------|----------------|---------------|-------|
| `code` | `order.code` | ✅ | Mã đơn hàng |
| `status` | `order.status` | ✅ | Trạng thái |
| `deliveryAddress.names` | `order.deliveryAddress.names` | ✅ | Tên người nhận |
| `customer` | `order.customer` | ❌ | Sensitive - loại bỏ |
| `uploadedBy` | `order.beforeDelivery[].uploadedBy` | ❌ | User object - loại bỏ |

---

## Phase 2: Security Audit

**Mục tiêu:** Xác định tất cả fields nhạy cảm cần loại bỏ khỏi DTO.

### Step 2.1: Tìm relationships trong Collection

Mở file collection definition (vd: `src/collections/orders/Order.ts`) và tìm các relationships:

```typescript
// Tìm các fields có relationTo: 'users' hoặc 'customers'
{
  name: 'customer',
  type: 'relationship',
  relationTo: 'customers',  // ⚠️ SENSITIVE
}

{
  name: 'uploadedBy',
  type: 'relationship',
  relationTo: 'users',  // ⚠️ SENSITIVE
}

{
  name: 'createdBy',
  type: 'relationship',
  relationTo: 'users',  // ⚠️ SENSITIVE
}
```

### Step 2.2: Security Checklist

| Field Pattern | Risk | Action |
|---------------|------|--------|
| `relationTo: 'users'` | Expose user data | ❌ Không trả về |
| `relationTo: 'customers'` | Expose customer PII | ❌ Không trả về |
| `password`, `passwordHash` | Credentials | ❌ Không trả về |
| `tokens`, `apiKey`, `secret` | Authentication | ❌ Không trả về |
| `internalNotes`, `adminNotes` | Internal data | ❌ Không trả về |

### Step 2.3: Allowed Contact Info

Một số thông tin liên hệ CÓ THỂ giữ lại nếu UI cần:

```typescript
// ✅ ALLOWED - Thông tin giao hàng cơ bản
deliveryAddress: {
  names: [{ fullName: string }],
  phoneNumbers: [{ number: string }],
  address: string,
}

// ✅ ALLOWED - Email liên hệ
customerEmail: string

// ❌ NOT ALLOWED - Full customer object
customer: Customer  // Chứa thông tin nhạy cảm
```

---

## Phase 3: DTO Design

**Mục tiêu:** Thiết kế DTO interface chỉ chứa fields UI cần, loại bỏ sensitive data.

### Step 3.1: Naming Convention

```typescript
// Pattern: {Feature}DTO
interface StoreOrderDTO { ... }
interface ProductListItemDTO { ... }
interface CustomerSummaryDTO { ... }
```

### Step 3.2: DTO Structure

```typescript
/**
 * StoreOrderDTO - Response cho store orders API
 * 
 * @security
 * - Không chứa customer object
 * - Không chứa uploadedBy (users)
 * - Chỉ giữ thông tin liên hệ cơ bản từ deliveryAddress
 */
export interface StoreOrderDTO {
  // Identifiers
  id: string
  code: string
  assignmentId?: string
  
  // Contact info (an toàn)
  customerEmail: string
  deliveryAddress: {
    names: Array<{ fullName: string }>
    phoneNumbers: Array<{ number: string }>
    address: string
  }
  
  // Items (chỉ chứa thông tin cần thiết)
  items: Array<{
    name: string        // từ product.name
    type: 'bouquet' | 'single' | 'accessory'
    quantity: number
    price: number
    totalPrice: number
    commissionRate: number
  }>
  
  // Order info
  shippingFee: number
  createdAt: string
  status: OrderStatus
  paymentStatus: PaymentStatus
  orderType: 'immediate' | 'scheduled' | 'recurring'
  note?: string
  
  // Optional configs
  scheduledDeliveryTime?: string
  recurringConfig?: RecurringConfigDTO
}
```

### Step 3.3: Nested DTO for Complex Objects

```typescript
interface RecurringConfigDTO {
  frequency?: 'daily' | 'weekly' | 'monthly'
  daysOfWeek?: string[]
  startDate?: string
  endDate?: string
}
```

---

## Phase 4: Backend Implementation

**Mục tiêu:** Tạo custom API endpoint với DTO mapping.

### Step 4.1: File Structure

```
src/app/api/v1/{feature}/
├── route.ts        # HTTP handler
├── service.ts      # Business logic + DTO mapping
├── types.ts        # DTO interfaces
└── validators.ts   # Zod schemas (optional)
```

### Step 4.2: Implement mapToDTO Function

```typescript
// service.ts
import type { Order, Product } from '@/payload-types'
import type { StoreOrderDTO } from './types'

/**
 * Map Order (Payload) sang StoreOrderDTO
 * 
 * @security
 * - Loại bỏ customer, uploadedBy
 * - Chỉ giữ thông tin cần cho UI
 */
function mapOrderToDTO(order: Order): StoreOrderDTO {
  // Map items (loại bỏ full product object)
  const items = (order.items || []).map((item) => {
    let name = 'Sản phẩm'
    let type: 'bouquet' | 'single' | 'accessory' = 'bouquet'
    
    if (typeof item.product === 'object' && item.product !== null) {
      const product = item.product as Product
      name = product.name || 'Sản phẩm'
      type = product.type || 'bouquet'
    }
    
    return {
      name,
      type,
      quantity: item.quantity,
      price: item.price,
      totalPrice: item.totalPrice,
      commissionRate: item.commissionRate ?? 10,
    }
  })
  
  // Map deliveryAddress (chỉ giữ fields cần thiết)
  const deliveryAddress = {
    names: order.deliveryAddress?.names || [],
    phoneNumbers: order.deliveryAddress?.phoneNumbers || [],
    address: order.deliveryAddress?.address || '',
  }
  
  return {
    id: order.id,
    code: order.code,
    customerEmail: order.customerEmail,
    deliveryAddress,
    items,
    shippingFee: order.shippingFee,
    createdAt: order.createdAt,
    status: order.status,
    paymentStatus: order.paymentStatus,
    orderType: order.orderType,
    note: order.note ?? undefined,
    // ... other fields
  }
}
```

### Step 4.3: Update Service to Return DTO

```typescript
// service.ts
export async function listStoreOrders(filters: Filters): Promise<Result> {
  const payload = await getPayload({ config })
  
  // Query orders (logic giữ nguyên)
  const result = await payload.find({
    collection: 'orders',
    where: whereClause,
    page: filters.page,
    limit: filters.limit,
    depth: 1,  // Có thể giảm depth nếu không cần populate nhiều
  })
  
  // Map sang DTO trước khi return
  const ordersDTO = result.docs.map(mapOrderToDTO)
  
  return {
    orders: ordersDTO,  // ← DTO, không phải Order[]
    pagination: { ... },
    summary: { ... },
  }
}
```

---

## Phase 5: Frontend Integration

**Mục tiêu:** Sync frontend types và update hooks để sử dụng custom API.

### Step 5.1: Update Frontend Types

```typescript
// src/api/services/store-orders.service.ts
export interface StoreOrderDTO {
  // Copy từ backend types.ts
  id: string
  code: string
  // ...
}

export interface StoreOrdersResponse {
  orders: StoreOrderDTO[]
  pagination: PaginationInfo
  summary: SummaryInfo
}
```

### Step 5.2: Update Service Function

```typescript
// src/api/services/store-orders.service.ts
export const fetchStoreOrders = async (
  filters: StoreOrdersFilters
): Promise<StoreOrdersResponse> => {
  const response = await ApiService.get<StoreOrdersResponse>(
    `/v1/stores/store-orders?${params.toString()}`
  )
  return response
}
```

### Step 5.3: Update Hook

```typescript
// hooks/useStoreOrdersData.ts
import type { StoreOrderDTO, StoreOrdersResponse } from '@/api/services/store-orders.service'

// Response từ API đã là DTO, không cần map thêm
const response = await fetchStoreOrders(filters)
setOrders(response.orders)  // StoreOrderDTO[]
```

---

## Phase 6: Verification

**Mục tiêu:** Đảm bảo API mới hoạt động đúng và an toàn.

### Step 6.1: Security Verification

```bash
# Gọi API và check response
curl -s "http://localhost:3000/api/v1/stores/store-orders?storeId=xxx" | jq

# Verify KHÔNG có:
# - "uploadedBy": { ... }
# - "customer": { "id": ..., "email": ..., "password": ... }
# - Bất kỳ nested users object nào
```

### Step 6.2: UI Verification Checklist

- [ ] Table hiển thị đúng data
- [ ] Dialog detail hiển thị đúng thông tin
- [ ] Filters hoạt động (search, status, pagination)
- [ ] Stats/Summary hiển thị đúng
- [ ] Không có TypeScript errors
- [ ] Không có console errors

### Step 6.3: Performance Verification

```bash
# So sánh response size
# Before (Payload REST): ~15KB per request
# After (Custom API): ~3KB per request
# Improvement: ~80% reduction
```

---

## Code Patterns

### Pattern 1: DTO Mapping với Type Guards

```typescript
// Kiểm tra relationship đã populate chưa
function isPopulated<T>(value: string | T): value is T {
  return typeof value === 'object' && value !== null
}

// Sử dụng
if (isPopulated(item.product)) {
  name = item.product.name
} else {
  // product là ID string
  name = 'Product ID: ' + item.product
}
```

### Pattern 2: Partial DTO cho Different Use Cases

```typescript
// Full DTO cho detail view
interface OrderDetailDTO extends OrderListDTO {
  timeline: TimelineEventDTO[]
  deliveryImages: ImageDTO[]
}

// Minimal DTO cho list view
interface OrderListDTO {
  id: string
  code: string
  status: OrderStatus
  total: number
}
```

### Pattern 3: Response Wrapper

```typescript
interface ApiResponse<T> {
  data: T
  pagination?: PaginationInfo
  summary?: SummaryInfo
}

// Usage
type ListResponse = ApiResponse<StoreOrderDTO[]>
type DetailResponse = ApiResponse<StoreOrderDTO>
```

---

## Security Guidelines

### NEVER Return These Fields

```typescript
// ❌ NEVER
{
  customer: Customer,           // Full customer object
  uploadedBy: User,             // User who uploaded
  createdBy: User,              // User who created
  password: string,             // Any password field
  passwordHash: string,         // Hashed password
  tokens: Token[],              // Auth tokens
  apiKey: string,               // API keys
  internalNotes: string,        // Internal notes
}
```

### Safe Contact Info

```typescript
// ✅ SAFE to return
{
  customerEmail: string,        // Just email for contact
  deliveryAddress: {
    names: [{ fullName }],      // Just names
    phoneNumbers: [{ number }], // Just phone numbers
    address: string,            // Delivery address
  }
}
```

### Query Optimization

```typescript
// Giảm depth khi không cần nested relationships
await payload.find({
  collection: 'orders',
  depth: 0,  // Chỉ lấy IDs
})

// Sử dụng select nếu collection có nhiều fields
await payload.find({
  collection: 'orders',
  select: {
    code: true,
    status: true,
    createdAt: true,
    // Chỉ select fields cần thiết
  }
})
```

---

## Tool Usage

### analyze-screen.py Script

```bash
# Basic usage
python .agent/skills/api-from-ui/scripts/analyze-screen.py <file_path>

# Example
python .agent/skills/api-from-ui/scripts/analyze-screen.py \
  src/screens/Store/StoreOrdersScreen/hooks/useStoreOrdersData.ts

# Analyze multiple files
python .agent/skills/api-from-ui/scripts/analyze-screen.py \
  src/screens/Store/StoreOrdersScreen/**/*.tsx
```

### Templates

```bash
# DTO Types template
cat .agent/skills/api-from-ui/assets/templates/types.ts.template

# Backend Service template
cat .agent/skills/api-from-ui/assets/templates/service.ts.template

# Frontend Service template
cat .agent/skills/api-from-ui/assets/templates/client-service.ts.template
```

### Checklists

```bash
# UI Fields Checklist
cat .agent/skills/api-from-ui/assets/checklists/ui-fields-checklist.md

# Security Audit Checklist
cat .agent/skills/api-from-ui/assets/checklists/security-audit-checklist.md
```

---

## Trigger Phrases

Skill này được kích hoạt khi user nói:

### Vietnamese
- "xây API từ UI"
- "tạo custom API cho screen"
- "tối ưu API response"
- "loại bỏ thông tin nhạy cảm khỏi API"
- "tạo DTO từ UI"
- "chuyển từ Payload REST sang custom API"

### English
- "build API from UI"
- "create custom API for screen"
- "optimize API response"
- "secure API response"
- "create DTO from UI"
- "migrate from Payload REST to custom API"

---

## References

Xem thêm chi tiết tại:

- `references/workflow-phases.md` - Chi tiết 6 phases
- `references/dto-design-patterns.md` - DTO patterns và anti-patterns
- `references/security-checklist.md` - Security checklist đầy đủ
- `references/common-collections.md` - Common Payload collections

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-07 | Initial release |
