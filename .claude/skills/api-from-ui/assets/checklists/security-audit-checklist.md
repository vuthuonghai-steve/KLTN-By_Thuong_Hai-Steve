# Security Audit Checklist Template

Sử dụng template này để audit security khi thiết kế DTO.

---

## Audit Information

| Property | Value |
|----------|-------|
| **Feature Name** | {{FEATURE_NAME}} |
| **Collection** | {{COLLECTION_NAME}} |
| **Date** | {{DATE}} |
| **Auditor** | {{AUTHOR}} |

---

## 1. User Relationships Check

### 1.1 Direct User Relationships

| Field Name | Relationship To | Found | Action |
|------------|-----------------|-------|--------|
| `createdBy` | users | ☐ Yes ☐ No | ☐ Remove |
| `updatedBy` | users | ☐ Yes ☐ No | ☐ Remove |
| `uploadedBy` | users | ☐ Yes ☐ No | ☐ Remove |
| `assignedTo` | users | ☐ Yes ☐ No | ☐ Remove |
| `approvedBy` | users | ☐ Yes ☐ No | ☐ Remove |

### 1.2 Nested User Relationships

| Parent Field | Nested User Field | Found | Action |
|--------------|-------------------|-------|--------|
| `timeline[]` | `user` | ☐ Yes ☐ No | ☐ Remove |
| `comments[]` | `author` | ☐ Yes ☐ No | ☐ Remove |
| `images[]` | `uploadedBy` | ☐ Yes ☐ No | ☐ Remove |
| `beforeDelivery[]` | `uploadedBy` | ☐ Yes ☐ No | ☐ Remove |
| `afterDelivery[]` | `uploadedBy` | ☐ Yes ☐ No | ☐ Remove |

---

## 2. Customer Relationships Check

| Field Name | Type | Found | Action |
|------------|------|-------|--------|
| `customer` | relationship | ☐ Yes ☐ No | ☐ Remove full object |
| `customerEmail` | string | ☐ Yes ☐ No | ☐ Keep (contact) |
| `customerPhone` | string | ☐ Yes ☐ No | ☐ Keep (contact) |

**Cho phép giữ lại:**
- ☐ `customerEmail` (chỉ email)
- ☐ `customerName` (từ deliveryAddress)
- ☐ `customerPhone` (từ deliveryAddress)

---

## 3. Sensitive Data Fields

### 3.1 Authentication Fields

| Field Pattern | Found | Action |
|---------------|-------|--------|
| `password` | ☐ Yes ☐ No | ☒ NEVER return |
| `passwordHash` | ☐ Yes ☐ No | ☒ NEVER return |
| `salt` | ☐ Yes ☐ No | ☒ NEVER return |

### 3.2 Token Fields

| Field Pattern | Found | Action |
|---------------|-------|--------|
| `token` | ☐ Yes ☐ No | ☒ NEVER return |
| `refreshToken` | ☐ Yes ☐ No | ☒ NEVER return |
| `resetPasswordToken` | ☐ Yes ☐ No | ☒ NEVER return |
| `verificationToken` | ☐ Yes ☐ No | ☒ NEVER return |

### 3.3 API Keys & Secrets

| Field Pattern | Found | Action |
|---------------|-------|--------|
| `apiKey` | ☐ Yes ☐ No | ☒ NEVER return |
| `secretKey` | ☐ Yes ☐ No | ☒ NEVER return |
| `webhookSecret` | ☐ Yes ☐ No | ☒ NEVER return |

---

## 4. Internal Data Fields

| Field | Found | Action | Reason |
|-------|-------|--------|--------|
| `internalNotes` | ☐ Yes ☐ No | ☐ Remove | Staff only |
| `adminNotes` | ☐ Yes ☐ No | ☐ Remove | Admin only |
| `staffComments` | ☐ Yes ☐ No | ☐ Remove | Staff only |
| `costPrice` | ☐ Yes ☐ No | ☐ Remove | Internal |
| `commissionRate` | ☐ Yes ☐ No | ☐ Review | Depends |

---

## 5. Query Depth Check

### Current Query Depth

```
Depth used: ___

At depth 1, these relationships are populated:
1. 
2. 
3. 

At depth 2, these nested relationships are populated:
1. 
2. 
3. 
```

### Recommended Depth

```
☐ depth: 0 (IDs only)
☐ depth: 1 (direct relationships)
☐ depth: 2 (nested relationships)

Reason: ___
```

---

## 6. Verification Commands

```bash
# Command to test API response
curl -s "http://localhost:3000/api/v1/{{endpoint}}" | jq

# Check for sensitive patterns
curl -s "http://localhost:3000/api/v1/{{endpoint}}" | grep -i "password\|token\|secret"

# Check for user objects
curl -s "http://localhost:3000/api/v1/{{endpoint}}" | grep -i "uploadedBy\|createdBy"

# Check for customer objects
curl -s "http://localhost:3000/api/v1/{{endpoint}}" | jq '.[] | .customer'
```

---

## 7. Summary

### Sensitive Fields to Remove

| # | Field Path | Risk Level | Status |
|---|------------|------------|--------|
| 1 | | 🔴 High | ☐ Removed |
| 2 | | 🔴 High | ☐ Removed |
| 3 | | 🟠 Medium | ☐ Removed |
| 4 | | 🟠 Medium | ☐ Removed |

### Safe Contact Info to Keep

| # | Field | Purpose |
|---|-------|---------|
| 1 | `customerEmail` | Liên hệ |
| 2 | `deliveryAddress.names` | Tên người nhận |
| 3 | `deliveryAddress.phoneNumbers` | SĐT giao hàng |
| 4 | `deliveryAddress.address` | Địa chỉ giao |

---

## 8. Sign-off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Developer | | | ☐ Approved |
| Reviewer | | | ☐ Approved |
| Security | | | ☐ Approved |

---

## Notes

```
Additional notes or concerns:


```
