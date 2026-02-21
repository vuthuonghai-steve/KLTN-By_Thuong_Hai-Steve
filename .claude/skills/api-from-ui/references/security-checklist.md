# Security Checklist

Checklist này dùng để audit security khi thiết kế DTO.

## Quick Reference

| Field Type | Risk | Action |
|------------|------|--------|
| `relationTo: 'users'` | 🔴 CRITICAL | ❌ NEVER return |
| `relationTo: 'customers'` | 🔴 CRITICAL | ❌ NEVER return |
| `password`, `passwordHash` | 🔴 CRITICAL | ❌ NEVER return |
| `token`, `refreshToken` | 🔴 CRITICAL | ❌ NEVER return |
| `apiKey`, `secret` | 🔴 CRITICAL | ❌ NEVER return |
| `internalNotes`, `adminNotes` | 🟠 HIGH | ❌ Remove |
| `createdBy`, `updatedBy` | 🟡 MEDIUM | ⚠️ Review |
| `email`, `phone` | 🟡 MEDIUM | ⚠️ Only if needed |
| Basic data fields | 🟢 LOW | ✅ Usually OK |

---

## Detailed Checklist

### 1. User Relationships

```typescript
// ❌ NEVER RETURN
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

{
  name: 'assignedTo',
  type: 'relationship',
  relationTo: 'users',  // ⚠️ SENSITIVE
}
```

**Action**: Không bao giờ return full user object. Nếu cần, chỉ return ID hoặc tên hiển thị.

### 2. Customer Relationships

```typescript
// ❌ NEVER RETURN FULL OBJECT
{
  name: 'customer',
  type: 'relationship',
  relationTo: 'customers',  // ⚠️ SENSITIVE
}
```

**Action**: Thay vì return full customer object, extract chỉ những fields cần:
- `customerEmail` ✅
- `customerName` (từ deliveryAddress) ✅
- `customerPhone` (từ deliveryAddress) ✅
- `customer: CustomerObject` ❌

### 3. Authentication Fields

```typescript
// ❌ NEVER RETURN
{
  name: 'password',
  type: 'text',
}

{
  name: 'passwordHash',
  type: 'text',
}

{
  name: 'salt',
  type: 'text',
}
```

**Action**: Luôn exclude từ mọi query và response.

### 4. Token Fields

```typescript
// ❌ NEVER RETURN
{
  name: 'token',
  type: 'text',
}

{
  name: 'refreshToken',
  type: 'text',
}

{
  name: 'resetPasswordToken',
  type: 'text',
}

{
  name: 'verificationToken',
  type: 'text',
}
```

**Action**: Tokens chỉ dùng internal, không bao giờ expose ra API.

### 5. API Keys & Secrets

```typescript
// ❌ NEVER RETURN
{
  name: 'apiKey',
  type: 'text',
}

{
  name: 'secretKey',
  type: 'text',
}

{
  name: 'webhookSecret',
  type: 'text',
}
```

**Action**: Secrets chỉ dùng server-side.

### 6. Internal Notes

```typescript
// ❌ REMOVE FROM PUBLIC API
{
  name: 'internalNotes',
  type: 'textarea',
}

{
  name: 'adminNotes',
  type: 'textarea',
}

{
  name: 'staffComments',
  type: 'array',
}
```

**Action**: Internal notes không nên expose cho client apps.

### 7. Nested Sensitive Data

```typescript
// ⚠️ REVIEW NESTED OBJECTS
{
  name: 'beforeDelivery',
  type: 'array',
  fields: [
    {
      name: 'uploadedBy',
      type: 'relationship',
      relationTo: 'users',  // ⚠️ NESTED SENSITIVE
    }
  ]
}
```

**Action**: Khi return arrays/nested objects, đảm bảo loại bỏ sensitive fields bên trong.

---

## Security Audit Steps

### Step 1: Identify All Relationships

```bash
# Tìm tất cả relationships trong collection
grep -n "relationTo" src/collections/{feature}/*.ts
```

### Step 2: Categorize Relationships

| Relationship | Type | Action |
|--------------|------|--------|
| `users` | 🔴 Sensitive | Remove |
| `customers` | 🔴 Sensitive | Remove |
| `products` | 🟢 Public | Can keep (filtered) |
| `categories` | 🟢 Public | Can keep |
| `stores` | 🟡 Review | Depends on use case |

### Step 3: Review Nested Arrays

```typescript
// Check mọi array field
fields.filter(f => f.type === 'array').forEach(arrayField => {
  // Check nested fields cho sensitive data
  arrayField.fields.forEach(nestedField => {
    if (nestedField.relationTo === 'users' || nestedField.relationTo === 'customers') {
      // ⚠️ SENSITIVE - cần loại bỏ
    }
  })
})
```

### Step 4: Verify DTO

Sau khi tạo DTO, verify:

```typescript
// DTO không được chứa:
interface OrderDTO {
  customer: Customer       // ❌
  uploadedBy: User         // ❌
  createdBy: User          // ❌
  password: string         // ❌
  token: string            // ❌
}

// DTO nên chứa:
interface OrderDTO {
  customerEmail: string    // ✅ Only email
  customerName: string     // ✅ Only name
  customerPhone: string    // ✅ Only phone
}
```

---

## Verification Commands

### Check Response for Sensitive Data

```bash
# Gọi API và check response
curl -s "http://localhost:3000/api/v1/feature" | jq

# Search for sensitive patterns
curl -s "http://localhost:3000/api/v1/feature" | grep -i "password\|token\|secret\|uploadedBy"

# Should return empty if secure
```

### Automated Check

```bash
# Tạo script check
RESPONSE=$(curl -s "http://localhost:3000/api/v1/feature")

if echo "$RESPONSE" | grep -q '"uploadedBy"'; then
  echo "❌ SECURITY: uploadedBy found in response"
  exit 1
fi

if echo "$RESPONSE" | grep -q '"customer":.*"password"'; then
  echo "❌ SECURITY: customer password found in response"
  exit 1
fi

echo "✅ Security check passed"
```

---

## Common Payload Collections

### Orders Collection
| Sensitive Field | Location | Action |
|-----------------|----------|--------|
| `customer` | root | Remove |
| `beforeDelivery[].uploadedBy` | nested array | Remove |
| `afterDelivery[].uploadedBy` | nested array | Remove |
| `timeline[].user` | nested array | Remove |

### Users Collection
| Sensitive Field | Action |
|-----------------|--------|
| `password` | NEVER expose |
| `salt` | NEVER expose |
| `resetPasswordToken` | NEVER expose |
| `email` | Only if authenticated user's own |

### Customers Collection
| Sensitive Field | Action |
|-----------------|--------|
| `password` | NEVER expose |
| `addresses` | Only for authenticated customer |
| `paymentMethods` | NEVER expose |
| `wallet` | NEVER expose |
