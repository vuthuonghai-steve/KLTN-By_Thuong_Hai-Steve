# Huong Dan Phan Tich API - Agent-skill

> Tai lieu nay huong dan cach phan tich API backend de tich hop vao frontend

---

## I. CAU TRUC FILE API BACKEND

### 1.1 Vi Tri File

```
Agent-skill-api/src/app/api/v1/{feature}/route.ts
```

### 1.2 Thanh Phan Chinh

```typescript
// 1. JSDoc Comment - Mo ta API
/**
 * Mo ta API
 * METHOD /api/v1/{endpoint}
 *
 * Query parameters / Body:
 * - param1: type (bat buoc/tuy chon) - Mo ta
 *
 * Response:
 * - field1: Mo ta
 */

// 2. Imports
import { NextRequest } from 'next/server'
import { successResponse, errorResponse } from '@/lib/api-response'
import { catchAsync } from '@/lib/catch-async'
import { z } from 'zod'

// 3. Zod Schema Validation
const requestSchema = z.object({
  field1: z.string(),
  field2: z.number().optional()
})

// 4. Handler Function
export const GET = catchAsync(async (request: NextRequest) => {
  // Logic
  return successResponse(data, 'Message')
})
```

---

## II. PHAN TICH REQUEST

### 2.1 Query Parameters (GET)

```typescript
// Tim trong file
const searchParams = request.nextUrl.searchParams

// Hoac trong Zod schema
const schema = z.object({
  lat: z.string().transform(val => parseFloat(val)),
  lng: z.string().min(1, 'Bat buoc'),
  maxDistance: z.string().optional()
})
```

### 2.2 Request Body (POST/PUT/PATCH)

```typescript
// Tim trong file
const body = await request.json()

// Hoac trong Zod schema
const bodySchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
  items: z.array(z.object({
    productId: z.string(),
    quantity: z.number()
  }))
})
```

### 2.3 Path Parameters

```typescript
// File: /api/v1/products/[slug]/route.ts
// Tim trong function
const { slug } = params
```

### 2.4 Headers

```typescript
// Tim trong file
const token = request.headers.get('authorization')
```

---

## III. PHAN TICH RESPONSE

### 3.1 Response Format Chuan

```typescript
// Success Response
interface ApiResponse<T> {
  success: true
  data: T
  message: string
}

// Error Response
interface ApiError {
  success: false
  error: string
}
```

### 3.2 Tim Cau Truc Data

```typescript
// Tim successResponse hoac return
return successResponse({
  store: nearestStore,           // Object
  distance: number,              // Primitive
  items: Item[],                 // Array
  pagination: {                  // Nested object
    totalDocs: number,
    page: number
  }
}, 'Message')
```

### 3.3 Cac Kieu Response Thuong Gap

| Helper | HTTP Status | Khi Nao |
|--------|-------------|---------|
| `successResponse(data, msg)` | 200 | Thanh cong |
| `errorResponse(msg, 400)` | 400 | Validation fail |
| `notFoundResponse(msg)` | 404 | Khong tim thay |
| `unauthorizedResponse()` | 401 | Chua dang nhap |
| `forbiddenResponse()` | 403 | Khong co quyen |

---

## IV. PAYLOAD CMS RESPONSE

### 4.1 Single Document

```typescript
interface Document {
  id: string
  fieldName: value
  relationship?: RelatedDoc | string  // Tuy depth
  createdAt: string
  updatedAt: string
}
```

### 4.2 Paginated Response

```typescript
interface PaginatedResponse<T> {
  docs: T[]
  totalDocs: number
  limit: number
  page: number
  totalPages: number
  hasNextPage: boolean
  hasPrevPage: boolean
  nextPage: number | null
  prevPage: number | null
}
```

---

## V. MAPPING BACKEND -> FRONTEND

### 5.1 Vi Tri Types Frontend

```
Agent-skill-web/src/
├── types/
│   ├── api/
│   │   ├── response.types.ts   # ApiResponse, PaginatedResponse
│   │   ├── product.types.ts    # Product types
│   │   └── index.ts            # Re-exports
│   └── {feature}.ts            # Feature-specific types
```

### 5.2 Vi Tri Services Frontend

```
Agent-skill-web/src/
├── api/
│   ├── services/               # API service classes
│   └── endpoints.ts            # API_ENDPOINTS constants
├── services/                   # Business logic services
└── hooks/                      # React hooks su dung services
```

### 5.3 Quy Tac Dong Bo

1. **Type Response**: Copy cau truc tu backend response
2. **Type Request**: Copy tu Zod schema
3. **Service Method**: Tao method trong service tuong ung
4. **Endpoint**: Them vao API_ENDPOINTS

---

## VI. TEMPLATE TAI LIEU API

```markdown
# {API_NAME}

## Thong Tin Chung
- **Endpoint**: `{METHOD} /api/v1/{path}`
- **Mo ta**: {description}
- **Auth**: {Required/Optional/None}

## Request

### Query Parameters / Body
| Truong | Kieu | Bat buoc | Mo ta |
|--------|------|----------|-------|
| field1 | string | Co | ... |

## Response

### Success (200)
\`\`\`json
{
  "success": true,
  "data": { ... },
  "message": "..."
}
\`\`\`

### Data Structure
| Truong | Kieu | Mo ta |
|--------|------|-------|
| field1 | string | ... |

## Frontend Integration

### Type Definition
\`\`\`typescript
// File: src/types/api/{feature}.types.ts
interface {TypeName} {
  field1: string
}
\`\`\`

### Service Method
\`\`\`typescript
// File: src/api/services/{feature}-service.ts
static async methodName(params): Promise<Type> {
  // implementation
}
\`\`\`
```
