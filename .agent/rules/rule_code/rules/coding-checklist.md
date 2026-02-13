---
trigger: always_on
priority: 999
description: MANDATORY checklist before writing any code. ALWAYS review this first.
---

# 🚨 CODING CHECKLIST - BẮT BUỘC ĐỌC TRƯỚC KHI CODE

> **CRITICAL**: Agent PHẢI đọc checklist này TRƯỚC KHI tạo/sửa bất kỳ file code nào.

---

## 📋 PRE-CODING VALIDATION

### ✅ Step 1: Understand Requirements
- [ ] Đọc rõ yêu cầu của Steve
- [ ] Xác định files cần thay đổi
- [ ] Xác định pattern hiện tại trong codebase

### ✅ Step 2: Check Project Conventions

#### **Types Location**
```bash
❌ WRONG: Types nằm trong service/component files
✅ CORRECT: Types nằm trong src/types/
```

**Example**:
```typescript
// ❌ WRONG
// File: src/api/services/users.service.ts
export interface UserDTO { ... }

// ✅ CORRECT  
// File: src/types/users.ts
export interface UserDTO { ... }

// File: src/api/services/users.service.ts
import type { UserDTO } from '@/types/users'
```

#### **Endpoints Location**
```bash
❌ WRONG: Hardcode URL strings '/api/v1/...'
✅ CORRECT: Use ENDPOINTS from '@/api/config/endpoint'
```

**Example**:
```typescript
// ❌ WRONG
ApiService.get('/api/v1/stores/orders')

// ✅ CORRECT
import { ENDPOINTS } from '@/api/config/endpoint'
ApiService.get(ENDPOINTS.API_V1.STORES.ORDERS)
```

#### **Import Order**
```typescript
// ✅ CORRECT Order:
// 1. React & Next.js
import React from 'react'
import { useRouter } from 'next/navigation'

// 2. Third-party libraries
import { toast } from 'sonner'

// 3. Internal components
import { Button } from '@/components/ui/button'

// 4. Services & hooks
import { fetchUsers } from '@/api/services/users.service'

// 5. Types & constants
import type { User } from '@/types'
import { API_VERSION } from '@/constants'
```

#### **File Naming**
- **Components**: `PascalCase.tsx` → `ProductCard.tsx`
- **Services**: `kebab-case.service.ts` → `user-profile.service.ts`
- **Types**: `kebab-case.ts` → `withdraw-requests.ts`
- **Hooks**: `camelCase.ts` → `useUserData.ts`
- **Utils**: `kebab-case.ts` → `format-currency.ts`

### ✅ Step 3: Design System Compliance

#### **Primary Color Rule (BẮT BUỘC)**
```typescript
// ✅ CORRECT: Use primary color
<Button variant="default">Action</Button>  // auto uses primary
<a className="text-primary hover:text-primary-700">Link</a>

// ❌ WRONG: Use blue/indigo
<Button className="bg-blue-500">Action</Button>
<a className="text-blue-600">Link</a>
```

#### **Component Import Rule**
```typescript
// ✅ CORRECT: Use design system
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'

// ❌ WRONG: Forbidden libraries
import { Button } from 'antd'
import { Modal } from '@mui/material'
```

---

## 🔍 VALIDATION WORKFLOW

### Before Writing Code:
1. **Read this checklist** ← You are here
2. **Review relevant rule files**:
   - `project-overview.md` - Architecture
   - `api-design-testing.md` - API patterns
   - `component-state.md` - Component patterns
3. **Check existing patterns** trong codebase tương tự
4. **Confirm with user** nếu không chắc

### After Writing Code:
1. **Self-Review**:
   - [ ] Types in `src/types/`?
   - [ ] Endpoints from `ENDPOINTS` config?
   - [ ] Primary color used correctly?
   - [ ] No forbidden libraries imported?
   - [ ] Import order correct?
   - [ ] File naming correct?

2. **Run Mental Checklist**:
   ```
   Q: Có types mới trong service file?
   → Move to src/types/
   
   Q: Có hardcode URL string?
   → Add to ENDPOINTS config
   
   Q: Có dùng blue/indigo cho CTA?
   → Change to primary color
   
   Q: Có import antd/mui/chakra?
   → Change to design system components
   ```

---

## ⚠️ COMMON VIOLATIONS & FIXES

### Violation #1: Types in Wrong Location
```typescript
// ❌ BEFORE
// File: src/api/services/products.service.ts
export interface ProductDTO {
  id: string
  name: string
}

// ✅ AFTER
// File: src/types/products.ts
export interface ProductDTO {
  id: string
  name: string
}

// File: src/api/services/products.service.ts
import type { ProductDTO } from '@/types/products'
```

### Violation #2: Hardcoded Endpoints
```typescript
// ❌ BEFORE
const data = await ApiService.get('/api/v1/users')

// ✅ AFTER
// Step 1: Add to endpoint.ts
export const ENDPOINTS = {
  API_V1: {
    USERS: {
      LIST: '/api/v1/users',
    }
  }
}

// Step 2: Use in service
import { ENDPOINTS } from '@/api/config/endpoint'
const data = await ApiService.get(ENDPOINTS.API_V1.USERS.LIST)
```

### Violation #3: Wrong Primary Color
```typescript
// ❌ BEFORE
<Button className="bg-blue-500 hover:bg-blue-600">
  Submit
</Button>

// ✅ AFTER
<Button variant="default">
  Submit
</Button>
```

---

## 📚 Quick Links

| Rule File | Purpose |
|-----------|---------|
| `project-overview.md` | Project structure, folder organization |
| `api-design-testing.md` | API patterns, endpoints, design system |
| `component-state.md` | Component patterns, state management |
| `name-and-structure.md` | Naming conventions, file structure |

---

## 🎯 Commit Template (Mental Check)

Before committing code, mentally answer:
- [ ] Types đặt đúng vị trí (`src/types/`)?
- [ ] Endpoints dùng `ENDPOINTS` config?
- [ ] Primary color (`primary-*`) được dùng cho CTA/links?
- [ ] Không import forbidden libraries?
- [ ] Import order đúng?
- [ ] File naming đúng convention?
- [ ] Đã review `.agent/rules` liên quan?

**If ANY checkbox is NO → FIX before proceeding!**

---

**Last Updated**: 2026-02-08  
**Priority**: HIGHEST (999)  
**Trigger**: `always_on` - MUST read before ANY code changes
