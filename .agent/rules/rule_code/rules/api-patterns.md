---
trigger: always_on
description: API data fetching patterns and service layer conventions
---

# 🔌 API Patterns & Data Fetching

> **Agent-skill Admin Management System** - API Service Layer Standards
> 
> **Last Updated**: 2026-02-08 | **Version**: 1.2.0

---

## Service Layer Pattern

```typescript
// ✅ CORRECT: Service file structure
import { ApiService } from '@/services/ApiService'
import type { Product, PaginatedResponse } from '@/types'

export async function fetchProducts(
  page: number = 1,
  limit: number = 10,
  filters?: ProductFilters
): Promise<PaginatedResponse<Product>> {
  try {
    const response = await ApiService.get('/products', {
      params: {
        page,
        limit,
        ...filters,
      },
    })
    return response.data
  } catch (error) {
    throw new Error(`Failed to fetch products: ${error}`)
  }
}

export async function createProduct(data: CreateProductInput): Promise<Product> {
  try {
    const response = await ApiService.post('/products', data)
    return response.data.doc
  } catch (error) {
    throw new Error(`Failed to create product: ${error}`)
  }
}
```

---

## PayloadCMS Response Format

```typescript
// ✅ CORRECT: Handle PayloadCMS response format
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

interface SingleDocResponse<T> {
  doc: T
}

// Usage
const response = await fetchProducts(1, 10)
const products = response.docs  // Array of products
const totalPages = response.totalPages
```

---

## Error Handling

```typescript
// ✅ CORRECT: Error handling with toast notifications
const handleDeleteProduct = async (id: string) => {
  try {
    await deleteProductService(id)
    toast.success('Product deleted successfully')
    refetch()
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error'
    toast.error(`Failed to delete product: ${message}`)
  }
}

// ❌ WRONG: Silent failures
const handleDeleteProduct = async (id: string) => {
  await deleteProductService(id)
  refetch()
}
```

---

## Query Parameters

```typescript
// ✅ CORRECT: PayloadCMS query parameters
const filters = {
  'where[status][equals]': 'active',
  'where[category][like]': 'flowers',
  'sort': '-createdAt',  // Descending order
  'depth': 1,  // Include relationships
  'page': 1,
  'limit': 20,
}

const response = await ApiService.get('/products', { params: filters })
```

---

## Centralized API Endpoints

⚠️ **BẮT BUỘC**: Tất cả endpoints PHẢI được định nghĩa tập trung!

**Vị trí file**: `src/api/config/endpoint.ts`

```typescript
// ✅ CORRECT: Define endpoints in a central file
export const ENDPOINTS = {
  AUTH: {
    LOGIN: '/api/v1/auth/login',
    REGISTER: '/api/v1/auth/register',
  },
  STORES: {
    DASHBOARD: '/api/v1/stores/store-dashboard',
    ORDERS: '/api/v1/stores/orders',
  },
  // ...
} as const
```

**Quy tắc sử dụng**:
1. ❌ **Không hardcode** chuỗi URL trực tiếp trong các service file
2. ✅ **Sử dụng** `ENDPOINTS` object từ file config
3. ✅ Nếu endpoint có tham số (ví dụ: `/api/v1/users/:id`), định nghĩa dưới dạng hàm

```typescript
// ✅ CORRECT: Use centralized endpoints
import { ENDPOINTS } from '@/api/config/endpoint'

export const fetchDashboard = (params) => {
  return ApiService.get(ENDPOINTS.STORES.DASHBOARD, { params })
}

// ❌ WRONG: Hardcoded URL
export const fetchDashboard = (params) => {
  return ApiService.get('/api/v1/stores/store-dashboard', { params })
}
```

---

## Common Pitfalls & Solutions

### 1. Direct API Calls Instead of Services

```typescript
// ❌ WRONG
const response = await fetch('/api/products')
const data = await response.json()

// ✅ CORRECT
import { fetchProducts } from '@/api/services/products.service'
const data = await fetchProducts()
```

### 2. Missing Error Handling

```typescript
// ❌ WRONG
const handleSubmit = async () => {
  const result = await createProduct(formData)
  setProduct(result)
}

// ✅ CORRECT
const handleSubmit = async () => {
  try {
    const result = await createProduct(formData)
    setProduct(result)
    toast.success('Product created successfully')
  } catch (error) {
    toast.error(error instanceof Error ? error.message : 'Failed to create product')
  }
}
```

### 3. Missing Type Safety

```typescript
// ❌ WRONG
const handleChange = (data) => {
  setFilters(data)
}

// ✅ CORRECT
const handleChange = (data: ProductFilters) => {
  setFilters(data)
}
```

---

## Quick Reference Checklist

When creating API services, ensure:

- [ ] **Types**: Import từ `@/types`, không định nghĩa inline
- [ ] **Endpoints**: Use `ENDPOINTS` config, không hardcode URLs
- [ ] **Error Handling**: Try-catch với toast notifications
- [ ] **Service Layer**: Tất cả API calls đi qua service functions
- [ ] **Type Safety**: Explicit types cho params và return values
- [ ] **Documentation**: JSDoc comments cho complex functions

---

**Related Rules**:
- [Design System](./design-system.md)
- [Testing Standards](./testing-standards.md)
- [Project Overview](./project-overview.md)