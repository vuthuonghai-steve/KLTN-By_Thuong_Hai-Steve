# DTO Design Patterns

Tài liệu này mô tả các patterns và anti-patterns khi thiết kế DTO.

## Core Principles

### 1. Only What UI Needs
DTO chỉ chứa fields mà UI thực sự sử dụng, không hơn không kém.

### 2. No Sensitive Data
Không bao giờ include sensitive fields (users, passwords, tokens).

### 3. Flat When Possible
Ưu tiên flat structure, chỉ nest khi logic hợp lý.

### 4. Type Safe
Mọi field đều có type annotations rõ ràng.

---

## Patterns

### Pattern 1: Basic DTO

```typescript
// ✅ GOOD: Simple, flat DTO
interface ProductListDTO {
  id: string
  name: string
  price: number
  status: 'active' | 'inactive'
  imageUrl: string
}
```

### Pattern 2: Nested DTO for Logical Groups

```typescript
// ✅ GOOD: Logical grouping
interface OrderDTO {
  id: string
  code: string
  
  // Delivery info grouped together
  delivery: {
    recipientName: string
    phoneNumber: string
    address: string
  }
  
  // Payment info grouped together
  payment: {
    method: string
    status: string
    amount: number
  }
}
```

### Pattern 3: DTO với Computed Fields

```typescript
// ✅ GOOD: Include computed fields nếu UI cần
interface OrderSummaryDTO {
  id: string
  itemCount: number        // computed: items.length
  subtotal: number         // computed: sum(items.price * quantity)
  discount: number         // computed: từ voucher
  total: number            // computed: subtotal - discount + shipping
  formattedTotal: string   // computed: formatted currency
}
```

### Pattern 4: List vs Detail DTO

```typescript
// ✅ GOOD: Different DTOs for different use cases

// Minimal for list views
interface OrderListItemDTO {
  id: string
  code: string
  customerName: string
  total: number
  status: string
  createdAt: string
}

// Full details for single item view
interface OrderDetailDTO extends OrderListItemDTO {
  items: OrderItemDTO[]
  deliveryAddress: DeliveryAddressDTO
  timeline: TimelineEventDTO[]
  notes: string
}
```

### Pattern 5: Array Item DTO

```typescript
// ✅ GOOD: Separate DTO for array items
interface OrderItemDTO {
  // Flatten from product relationship
  productName: string      // từ item.product.name
  productType: string      // từ item.product.type
  
  // Item specific
  quantity: number
  price: number
  totalPrice: number
}

interface OrderDTO {
  items: OrderItemDTO[]    // Array of DTOs
}
```

---

## Anti-Patterns

### Anti-Pattern 1: Including Full Relationship

```typescript
// ❌ BAD: Full nested object
interface OrderDTO {
  customer: Customer        // Full customer object với password, etc.
  createdBy: User           // Full user object
}

// ✅ GOOD: Only needed fields
interface OrderDTO {
  customerEmail: string
  customerName: string
  // createdBy không cần → bỏ
}
```

### Anti-Pattern 2: Pass-Through DTO

```typescript
// ❌ BAD: DTO giống hệt Payload entity
interface OrderDTO {
  ...Order  // Spread tất cả fields
}

// ✅ GOOD: Explicit fields
interface OrderDTO {
  id: string
  code: string
  status: string
  // Chỉ những fields cần thiết
}
```

### Anti-Pattern 3: Over-Nesting

```typescript
// ❌ BAD: Quá nhiều levels
interface OrderDTO {
  delivery: {
    address: {
      location: {
        coordinates: {
          lat: number
          lng: number
        }
      }
    }
  }
}

// ✅ GOOD: Flatten khi có thể
interface OrderDTO {
  deliveryAddress: string
  deliveryLat?: number
  deliveryLng?: number
}
```

### Anti-Pattern 4: Optional Everything

```typescript
// ❌ BAD: Mọi thứ đều optional
interface OrderDTO {
  id?: string
  code?: string
  status?: string
}

// ✅ GOOD: Explicit required/optional
interface OrderDTO {
  id: string              // Required
  code: string            // Required
  note?: string           // Optional - có lý do
}
```

### Anti-Pattern 5: Mixing Concerns

```typescript
// ❌ BAD: Mix data với UI concerns
interface OrderDTO {
  id: string
  displayColor: string    // UI concern
  isExpanded: boolean     // UI state
}

// ✅ GOOD: Only data
interface OrderDTO {
  id: string
  status: string
  // UI concerns handled in component state
}
```

---

## Naming Conventions

### DTO Names

| Pattern | Example |
|---------|---------|
| `{Feature}DTO` | `StoreOrderDTO` |
| `{Feature}ListItemDTO` | `ProductListItemDTO` |
| `{Feature}DetailDTO` | `OrderDetailDTO` |
| `{Feature}SummaryDTO` | `CustomerSummaryDTO` |

### Field Names

| Original (Payload) | DTO Field |
|--------------------|-----------|
| `item.product.name` | `productName` |
| `deliveryAddress.names[0].fullName` | `recipientName` |
| `createdAt` (ISO) | `createdAt` (ISO) hoặc `createdAtFormatted` |

---

## Type Generation Workflow

```typescript
// Step 1: Copy from Payload types
import type { Order, Product } from '@/payload-types'

// Step 2: Pick needed fields
type OrderBase = Pick<Order, 'id' | 'code' | 'status'>

// Step 3: Extend/modify
interface OrderDTO extends OrderBase {
  // Override relationship fields
  customerEmail: string  // thay vì customer: Customer
  
  // Flatten nested
  recipientName: string  // thay vì deliveryAddress.names[0].fullName
  
  // Computed
  itemCount: number
}
```

---

## Security Considerations

### Fields to NEVER Include

```typescript
// ❌ NEVER in any DTO
password: string
passwordHash: string
token: string
refreshToken: string
apiKey: string
secret: string
internalNotes: string
adminComments: string
```

### Fields to Review Before Including

```typescript
// ⚠️ Review case-by-case
email: string           // OK nếu cần cho liên hệ
phoneNumber: string     // OK nếu cần cho giao hàng
address: string         // OK nếu cần hiển thị
createdBy: string       // Có cần không?
updatedBy: string       // Có cần không?
```
