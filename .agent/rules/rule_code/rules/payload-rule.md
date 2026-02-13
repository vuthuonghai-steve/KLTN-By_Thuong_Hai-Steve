---
trigger: always_on
glob:
description:
---

# PayloadCMS Working Rules

> **Mục đích**: Quy tắc làm việc với PayloadCMS cho AI Agent
> **Áp dụng**: Claude Code khi thao tác với collections, hooks, và Local API

---

## I. TỔNG QUAN

PayloadCMS là CMS "code-first" - cấu trúc dữ liệu được định nghĩa hoàn toàn bằng TypeScript.

### Tại sao AI Agent cần hiểu Payload?

| Đặc điểm | Lợi ích cho AI |
|----------|----------------|
| **Schema-driven** | Đọc file config để biết cấu trúc dữ liệu |
| **Local API** | Thao tác trực tiếp với DB, không cần HTTP |
| **Type Safety** | Type generated tự động, giảm lỗi runtime |
| **Hooks System** | Can thiệp vào lifecycle của data |

---

## II. CẤU TRÚC DỰ ÁN

### 2.1 Vị Trí Các Thành Phần

```
Agent-skill-api/src/
├── collections/              # Định nghĩa Collections
│   ├── auth/                 # Collections liên quan auth
│   │   ├── Customer.ts
│   │   ├── Users.ts
│   │   └── config/
│   │       ├── hooks/
│   │       └── validations/
│   ├── orders/               # Collections đơn hàng
│   ├── products/             # Collections sản phẩm
│   └── index.ts              # Export tất cả collections
├── globals/                  # Định nghĩa Globals (singleton)
├── payload.config.ts         # Config chính của Payload
└── payload-types.ts          # Types tự động sinh (DO NOT EDIT)
```

### 2.2 Phân Loại Collections

| Nhóm | Thư mục | Ví dụ |
|------|---------|-------|
| **Auth** | `collections/auth/` | Customer, Users, Roles |
| **Orders** | `collections/orders/` | Order, PaymentSession |
| **Products** | `collections/products/` | Product, Category |
| **Stores** | `collections/stores/` | Store, StoreUsers |
| **Marketing** | `collections/marketing/` | Voucher, Campaign |

---

## III. LOCAL API (BẮT BUỘC SỬ DỤNG)

### 3.1 Khởi Tạo Payload Instance

```typescript
import { getPayload } from 'payload'
import config from '@/payload.config'

const payload = await getPayload({ config })
```

### 3.2 Các Thao Tác Cơ Bản

#### Find (Tìm kiếm)

```typescript
const products = await payload.find({
  collection: 'products',
  where: {
    status: { equals: 'published' },
    price: { greater_than: 100000 },
  },
  limit: 10,
  sort: '-createdAt',
  depth: 1, // Populate relations 1 cấp
})
```

#### FindByID (Tìm theo ID)

```typescript
const order = await payload.findByID({
  collection: 'orders',
  id: 'order_id_123',
  depth: 2,
})
```

#### Create (Tạo mới)

```typescript
const newOrder = await payload.create({
  collection: 'orders',
  data: {
    orderCode: 'HD20260123001',
    status: 'pending',
    totalAmount: 500000,
  },
  overrideAccess: true, // Bỏ qua access control
})
```

#### Update (Cập nhật)

```typescript
await payload.update({
  collection: 'orders',
  id: 'order_id_123',
  data: {
    status: 'completed',
    completedAt: new Date().toISOString(),
  },
})
```

#### Delete (Xóa)

```typescript
await payload.delete({
  collection: 'orders',
  id: 'order_id_123',
})
```

### 3.3 Query Operators

| Operator | Ý nghĩa | Ví dụ |
|----------|---------|-------|
| `equals` | Bằng | `{ status: { equals: 'active' } }` |
| `not_equals` | Khác | `{ status: { not_equals: 'deleted' } }` |
| `greater_than` | Lớn hơn | `{ price: { greater_than: 100000 } }` |
| `less_than` | Nhỏ hơn | `{ quantity: { less_than: 10 } }` |
| `in` | Trong danh sách | `{ status: { in: ['pending', 'processing'] } }` |
| `contains` | Chứa text | `{ name: { contains: 'hoa' } }` |
| `exists` | Tồn tại | `{ deletedAt: { exists: false } }` |

### 3.4 Logical Operators

```typescript
// AND (mặc định)
where: {
  status: { equals: 'active' },
  price: { greater_than: 100000 },
}

// OR
where: {
  or: [
    { status: { equals: 'pending' } },
    { status: { equals: 'processing' } },
  ],
}

// Kết hợp AND + OR
where: {
  and: [
    { status: { equals: 'active' } },
    {
      or: [
        { category: { equals: 'flower' } },
        { category: { equals: 'gift' } },
      ],
    },
  ],
}
```

---

## IV. ACCESS CONTROL

### 4.1 Khi Nào Dùng `overrideAccess: true`

| Trường hợp | overrideAccess |
|------------|----------------|
| API route xử lý cho user đã auth | `false` |
| Background job, cron task | `true` |
| Hook nội bộ (afterChange) | `true` |
| Migrate/seed data | `true` |

### 4.2 Ví Dụ Thực Tế

```typescript
// Trong API route - user đã auth
const orders = await payload.find({
  collection: 'orders',
  user: req.user, // Truyền user để check access
  depth: 1,
})

// Trong service nội bộ - bypass access
await payload.update({
  collection: 'orders',
  id: orderId,
  data: { status: 'completed' },
  overrideAccess: true, // AI/system thao tác
})
```

---

## V. HOOKS (LIFECYCLE)

### 5.1 Các Loại Hooks

| Hook | Thời điểm | Use case |
|------|-----------|----------|
| `beforeValidate` | Trước validate | Normalize data |
| `beforeChange` | Trước create/update | Enrich data, check logic |
| `afterChange` | Sau create/update | Tạo related records, send notification |
| `beforeDelete` | Trước delete | Check constraint |
| `afterDelete` | Sau delete | Cleanup related data |
| `beforeRead` | Trước read | Filter sensitive data |
| `afterRead` | Sau read | Transform response |

### 5.2 Cấu Trúc Hook File

```typescript
// collections/auth/config/hooks/createWallet.ts
import { CollectionAfterChangeHook } from 'payload'

export const createCustomerWalletHook: CollectionAfterChangeHook = async ({
  doc,
  operation,
  req,
}) => {
  // Chỉ chạy khi CREATE
  if (operation !== 'create') return doc

  // Tạo wallet cho customer mới
  await req.payload.create({
    collection: 'customer-wallets',
    data: {
      customer: doc.id,
      balance: 0,
    },
    overrideAccess: true,
  })

  return doc
}
```

### 5.3 Đăng Ký Hook

```typescript
// collections/auth/Customer.ts
import { createCustomerWalletHook } from './config/hooks'

export const Customer: CollectionConfig = {
  slug: 'customers',
  // ...fields
  hooks: {
    afterChange: [createCustomerWalletHook],
  },
}
```

---

## VI. ĐỊNH NGHĨA COLLECTION

### 6.1 Cấu Trúc Cơ Bản

```typescript
import { CollectionConfig } from 'payload'

export const MyCollection: CollectionConfig = {
  slug: 'my-collection',           // Tên collection (kebab-case)
  labels: {
    singular: 'Tên đơn số',
    plural: 'Tên số nhiều',
  },
  admin: {
    useAsTitle: 'name',            // Field hiển thị làm title
    defaultColumns: ['name', 'status', 'createdAt'],
    group: 'Tên Nhóm',             // Nhóm trong sidebar
  },
  access: {
    create: () => true,
    read: () => true,
    update: () => true,
    delete: () => false,
  },
  fields: [/* ... */],
  hooks: {/* ... */},
  timestamps: true,                // Tự động thêm createdAt, updatedAt
}
```

### 6.2 Các Loại Field Phổ Biến

```typescript
fields: [
  // Text
  { name: 'name', type: 'text', required: true },
  
  // Email (tự động validate)
  { name: 'email', type: 'email', unique: true },
  
  // Number
  { name: 'price', type: 'number', min: 0 },
  
  // Select
  {
    name: 'status',
    type: 'select',
    options: [
      { label: 'Pending', value: 'pending' },
      { label: 'Active', value: 'active' },
    ],
    defaultValue: 'pending',
  },
  
  // Relationship (1-1)
  { name: 'customer', type: 'relationship', relationTo: 'customers' },
  
  // Relationship (1-N)
  { name: 'items', type: 'relationship', relationTo: 'products', hasMany: true },
  
  // Upload
  { name: 'image', type: 'upload', relationTo: 'media' },
  
  // Group (gom nhóm fields)
  {
    name: 'address',
    type: 'group',
    fields: [
      { name: 'street', type: 'text' },
      { name: 'city', type: 'text' },
    ],
  },
  
  // Array (lặp lại)
  {
    name: 'items',
    type: 'array',
    fields: [
      { name: 'product', type: 'relationship', relationTo: 'products' },
      { name: 'quantity', type: 'number' },
    ],
  },
]
```

---

## VII. QUY TẮC VÀNG

### 7.1 Checklist Trước Khi Code

```markdown
## Trước khi thao tác với Payload:

- [ ] Đọc schema trong `collections/` để hiểu cấu trúc
- [ ] Kiểm tra `payload-types.ts` để biết types
- [ ] Xác định cần `overrideAccess` hay không
- [ ] Xác định `depth` phù hợp (tránh over-fetch)
```

### 7.2 PHẢI LÀM

| Quy tắc | Lý do |
|---------|-------|
| **Luôn dùng Local API** | Nhanh hơn, type-safe hơn REST |
| **Đọc schema trước** | Hiểu cấu trúc data trước khi code |
| **Dùng Types generated** | Tránh lỗi sai tên field |
| **Tách hooks ra file riêng** | Dễ test, dễ maintain |
| **Dùng `depth` có chừng mực** | Tránh query quá nặng |

### 7.3 KHÔNG NÊN LÀM

| Anti-pattern | Thay thế bằng |
|--------------|---------------|
| Gọi REST API từ backend | Dùng Local API |
| Hardcode collection slug | Import từ constants |
| Query với `depth: 10` | Chỉ dùng `depth: 1-2` |
| Sửa file `payload-types.ts` | Để Payload tự generate |
| Để logic phức tạp trong hook | Tách ra service riêng |

---

## VIII. VÍ DỤ THỰC TẾ

### 8.1 Tạo Order Với Customer Check

```typescript
import { getPayload } from 'payload'
import config from '@/payload.config'

async function createOrder(orderData: CreateOrderInput) {
  const payload = await getPayload({ config })

  // 1. Tìm hoặc tạo customer
  const existingCustomer = await payload.find({
    collection: 'customers',
    where: { phone: { equals: orderData.phone } },
    limit: 1,
  })

  let customerId: string
  if (existingCustomer.docs.length > 0) {
    customerId = existingCustomer.docs[0].id
  } else {
    const newCustomer = await payload.create({
      collection: 'customers',
      data: {
        name: orderData.customerName,
        phone: orderData.phone,
        email: orderData.email,
      },
      overrideAccess: true,
    })
    customerId = newCustomer.id
  }

  // 2. Tạo order
  const order = await payload.create({
    collection: 'orders',
    data: {
      customer: customerId,
      items: orderData.items,
      totalAmount: orderData.totalAmount,
      status: 'pending',
    },
    overrideAccess: true,
  })

  return order
}
```

### 8.2 Hook Auto-Assign Store

```typescript
// collections/orders/config/hooks/autoAssignStore.ts
import { CollectionAfterChangeHook } from 'payload'

export const autoAssignStoreHook: CollectionAfterChangeHook = async ({
  doc,
  operation,
  req,
}) => {
  // Chỉ chạy khi CREATE và chưa có store
  if (operation !== 'create' || doc.store) return doc

  // Tìm store gần nhất (simplified)
  const stores = await req.payload.find({
    collection: 'stores',
    where: { isActive: { equals: true } },
    limit: 1,
  })

  if (stores.docs.length > 0) {
    await req.payload.update({
      collection: 'orders',
      id: doc.id,
      data: { store: stores.docs[0].id },
      overrideAccess: true,
    })
  }

  return doc
}
```

---

## IX. THAM KHẢO

- [Payload Official Docs](https://payloadcms.com/docs)
- [Collection Schema Guide](../../src/collections/CLAUDE.md)
- [Original AI Agent Guide](../../docs/payload_ai_agent_guide.md)

---

**VERSION**: 1.0.0 | **CREATED**: 2026-01-23 | **AUTHOR**: Steve