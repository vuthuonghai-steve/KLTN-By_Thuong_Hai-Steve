# Common Payload Collections

Tài liệu này mô tả các collections phổ biến trong dự án Payload CMS và cách xử lý chúng khi tạo DTO.

## Orders Collection

### Sensitive Fields
| Field | Type | Action |
|-------|------|--------|
| `customer` | relationship → customers | ❌ Remove |
| `beforeDelivery[].uploadedBy` | relationship → users | ❌ Remove |
| `afterDelivery[].uploadedBy` | relationship → users | ❌ Remove |
| `timeline[].user` | relationship → users | ❌ Remove |
| `createdBy` | relationship → users | ❌ Remove |

### Safe Fields for DTO
```typescript
interface OrderDTO {
  // Identifiers
  id: string
  code: string
  
  // Contact (từ deliveryAddress, không phải customer)
  customerEmail: string
  deliveryAddress: {
    names: Array<{ fullName: string }>
    phoneNumbers: Array<{ number: string }>
    address: string
  }
  
  // Items (flatten product)
  items: Array<{
    name: string
    type: string
    quantity: number
    price: number
  }>
  
  // Order info
  status: OrderStatus
  paymentStatus: PaymentStatus
  orderType: 'immediate' | 'scheduled' | 'recurring'
  shippingFee: number
  total: number
  
  // Timestamps
  createdAt: string
  updatedAt: string
}
```

---

## Products Collection

### Sensitive Fields
| Field | Type | Action |
|-------|------|--------|
| `createdBy` | relationship → users | ❌ Remove |
| `supplier` | relationship → suppliers | ⚠️ Review |
| `costPrice` | number | ❌ Remove (internal) |
| `internalNotes` | text | ❌ Remove |

### Safe Fields for DTO
```typescript
interface ProductDTO {
  id: string
  name: string
  slug: string
  description: string
  price: number           // Selling price
  salePrice?: number
  type: 'bouquet' | 'single' | 'accessory'
  category: string        // Category name, not full object
  images: Array<{
    url: string
    alt?: string
  }>
  status: 'active' | 'inactive'
  stock: number
  
  // Computed
  isOnSale: boolean
  discountPercent?: number
}
```

---

## Customers Collection

### Sensitive Fields
| Field | Type | Action |
|-------|------|--------|
| `password` | text | ❌ NEVER |
| `salt` | text | ❌ NEVER |
| `resetPasswordToken` | text | ❌ NEVER |
| `wallet` | group | ❌ Remove (balance info) |
| `paymentMethods` | array | ❌ Remove |
| `addresses` | array | ⚠️ Only for owner |

### Safe Fields for DTO (Admin View)
```typescript
interface CustomerListDTO {
  id: string
  name: string
  email: string
  phone?: string
  status: 'active' | 'inactive'
  
  // Summary stats
  totalOrders: number
  totalSpent: number
  
  createdAt: string
}
```

### Safe Fields for DTO (Self View)
```typescript
interface CustomerProfileDTO {
  id: string
  name: string
  email: string
  phone?: string
  
  // Addresses (chỉ cho chính họ)
  addresses: Array<{
    id: string
    label: string
    fullAddress: string
    isDefault: boolean
  }>
  
  // Wallet (chỉ balance, không có transactions)
  walletBalance: number
  
  createdAt: string
}
```

---

## Users Collection

### Sensitive Fields
| Field | Type | Action |
|-------|------|--------|
| `password` | text | ❌ NEVER |
| `salt` | text | ❌ NEVER |
| `resetPasswordToken` | text | ❌ NEVER |
| `loginAttempts` | number | ❌ Remove |
| `lockUntil` | date | ❌ Remove |

### Safe Fields for DTO (Public)
```typescript
// Cho các relationship khác
interface UserPublicDTO {
  id: string
  name: string
  avatar?: string
}
```

### Safe Fields for DTO (Self)
```typescript
interface UserProfileDTO {
  id: string
  name: string
  email: string
  avatar?: string
  role: string
  permissions: string[]
  createdAt: string
}
```

---

## Stores Collection

### Sensitive Fields
| Field | Type | Action |
|-------|------|--------|
| `owner` | relationship → users | ⚠️ Review |
| `bankAccount` | group | ❌ Remove |
| `internalRating` | number | ❌ Remove |
| `commissionRate` | number | ⚠️ Review |

### Safe Fields for DTO (Public)
```typescript
interface StorePublicDTO {
  id: string
  name: string
  slug: string
  address: string
  phone: string
  rating: number
  reviewCount: number
  isOpen: boolean
  openHours: string
}
```

### Safe Fields for DTO (Owner View)
```typescript
interface StoreOwnerDTO extends StorePublicDTO {
  // Revenue (đã summarize)
  todayRevenue: number
  monthRevenue: number
  
  // Orders stats
  pendingOrders: number
  completedOrders: number
  
  // Balance (không có bank details)
  walletBalance: number
}
```

---

## Vouchers Collection

### Sensitive Fields
| Field | Type | Action |
|-------|------|--------|
| `budget` | number | ⚠️ Review (internal) |
| `usageStats` | group | ⚠️ Admin only |
| `createdBy` | relationship → users | ❌ Remove |

### Safe Fields for DTO (Customer)
```typescript
interface VoucherPublicDTO {
  id: string
  code: string
  type: 'percentage' | 'fixed'
  value: number
  minOrderValue: number
  maxDiscount?: number
  description: string
  expiresAt: string
  
  // Status
  isValid: boolean
  remainingUses?: number
}
```

---

## Media Collection

### Sensitive Fields
| Field | Type | Action |
|-------|------|--------|
| `uploadedBy` | relationship → users | ❌ Remove |
| `internalPath` | text | ❌ Remove |

### Safe Fields for DTO
```typescript
interface MediaDTO {
  id: string
  url: string
  alt?: string
  mimeType: string
  width?: number
  height?: number
  
  // Thumbnails nếu có
  thumbnailUrl?: string
}
```

---

## Mapping Patterns

### Relationship → ID or Name

```typescript
// ❌ BAD: Full object
category: Category

// ✅ GOOD: Just what's needed
categoryId: string
categoryName: string
```

### Nested Array → Flattened

```typescript
// ❌ BAD: Complex nesting
deliveryAddress: {
  names: [{ type, fullName }]
  phoneNumbers: [{ type, number }]
}

// ✅ GOOD: Flattened for simple use
recipientName: string      // names[0].fullName
senderName?: string        // names[1]?.fullName
recipientPhone: string     // phoneNumbers[0].number
```

### Computed Fields

```typescript
// Add computed fields to avoid client computation
interface OrderDTO {
  itemCount: number        // items.length
  subtotal: number         // sum of items
  formattedTotal: string   // "1.500.000đ"
  statusLabel: string      // "Đang giao hàng"
}
```
