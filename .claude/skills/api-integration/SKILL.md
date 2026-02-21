---
name: api-integration
description: Skill tich hop API backend vao frontend. Su dung khi can (1) nghien cuu API endpoint, (2) phan tich cau truc request/response, (3) ghep API vao frontend, (4) dong bo cau truc data khi backend thay doi. Skill nay nen duoc su dung khi nguoi dung cung cap duong dan file API backend hoac yeu cau lam viec voi API.
---

# API Integration

## Overview

Skill nay tu dong hoa qua trinh tich hop API tu backend (Agent-skill-api) vao frontend (Agent-skill-web). No thuc hien:
1. **Nghien cuu API**: Doc va hieu API endpoint
2. **Phan tich API**: Xac dinh request/response structure
3. **Ghep API**: Tao service methods trong frontend
4. **Dong bo**: Cap nhat types khi backend thay doi

---

## Khi Nao Su Dung Skill Nay

### 1. Nghien Cuu API
- Khi can hieu API endpoint hoat dong nhu the nao
- Khi can biet API yeu cau nhung gi (params, body, headers)
- Khi can biet API tra ve gi

### 2. Phan Tich API
- Khi can tao tai lieu cho API
- Khi can hieu cau truc data chi tiet
- Khi can validation rules cua request

### 3. Ghep API
- Khi can tao service method moi trong frontend
- Khi can ket noi frontend component voi backend API
- Khi can tao types cho API response

### 4. Dong Bo Cau Truc Data
- Khi backend API da thay doi nhung frontend chua cap nhat
- Khi types frontend khong khop voi response backend
- Khi can cap nhat interface sau khi backend sua doi

---

## Workflow Tong Quan

```
[Input: File API Backend]
         |
         v
[PHASE 1: Nghien Cuu & Phan Tich API]
- Doc file route.ts
- Xac dinh request params/body
- Xac dinh response structure
- Tao tai lieu API
         |
         v
[PHASE 2: Ghep API vao Frontend]
- Them endpoint constant
- Tao/cap nhat types
- Tao/cap nhat service method
         |
         v
[PHASE 3: Dong Bo & Kiem Tra]
- So sanh types backend vs frontend
- Cap nhat neu khong khop
- Xac nhan dong bo thanh cong
         |
         v
[Output: Frontend san sang su dung API]
```

---

## PHASE 1: Nghien Cuu & Phan Tich API

### Buoc 1.1: Doc File API Backend

Doc file API backend duoc cung cap (thuong la `route.ts`).

Tim cac thanh phan:
- **JSDoc Comment**: Mo ta API, parameters, response
- **Zod Schema**: Validation rules cho request
- **Handler Function**: GET, POST, PATCH, DELETE
- **Response Calls**: successResponse, errorResponse

### Buoc 1.2: Phan Tich Request

Trich xuat thong tin request:

```
Request Parameters:
- Query params: Tim trong searchParams hoac Zod schema
- Body: Tim trong request.json() hoac Zod schema
- Path params: Tim trong ten file [param] va function params
- Headers: Tim request.headers.get()
```

Ghi chu:
- Truong bat buoc: Khong co `.optional()` trong Zod
- Truong tuy chon: Co `.optional()` hoac `.default()`
- Validation: Tim `.min()`, `.max()`, `.email()`, etc.

### Buoc 1.3: Phan Tich Response

Tim cau truc response trong:
- `successResponse(data, message)` -> Lay cau truc `data`
- `return NextResponse.json()` -> Lay object tra ve
- PayloadCMS queries -> Tim collection va depth

Xac dinh cac truong response:
- Primitive: string, number, boolean
- Object: Nested structure
- Array: Item type
- Relationship: ID string hoac populated object

### Buoc 1.4: Tao Tai Lieu API

Tao thu muc va file:
```
docs/api/{feature-name}/
├── index.md          # Tai lieu chinh
└── examples/         # Vi du request/response (tuy chon)
```

Su dung template tu `assets/api-doc-template.md`.

---

## PHASE 2: Ghep API vao Frontend

### Buoc 2.1: Them Endpoint Constant

Tim file `Agent-skill-web/src/api/endpoints.ts`.

Them endpoint moi:
```typescript
{FEATURE}: {
  {ACTION}: '/api/v1/{path}',
}
```

### Buoc 2.2: Tao/Cap Nhat Types

Tim trong frontend:
```
Agent-skill-web/src/types/api/{feature}.types.ts
Agent-skill-web/src/types/{feature}.ts
```

Tao type moi neu chua co:
```typescript
// Request type (tu Zod schema)
export interface {FeatureName}Request {
  field1: string
  field2?: number  // optional
}

// Response type
export interface {FeatureName}Response {
  success: boolean
  data: {FeatureData}
  message: string
}

// Data type
export interface {FeatureData} {
  id: string
  field1: string
  field2: number
}
```

### Buoc 2.3: Tao/Cap Nhat Service

Tim hoac tao file:
```
Agent-skill-web/src/api/services/{feature}-service.ts
```

Tao method:
```typescript
static async methodName(params: ParamsType): Promise<ResponseType> {
  const response = await apiClient.{method}(
    API_ENDPOINTS.{FEATURE}.{ACTION},
    { params }  // hoac body cho POST
  )
  return response.data
}
```

---

## PHASE 3: Dong Bo & Kiem Tra

### Buoc 3.1: So Sanh Types

So sanh cau truc:
- Backend response fields vs Frontend type fields
- Backend Zod schema vs Frontend request type
- Nested objects va arrays

### Buoc 3.2: Cap Nhat Khong Khop

Neu types khong khop:
1. **Them truong moi**: Neu backend co truong moi
2. **Sua kieu du lieu**: Neu type khac nhau
3. **Xoa truong cu**: Neu backend da xoa (can than)

### Buoc 3.3: Xac Nhan Dong Bo

Kiem tra:
- [ ] Types frontend khop voi response backend
- [ ] Service method goi dung endpoint
- [ ] Request params/body dung format
- [ ] Error handling phu hop

---

## Vi Du Su Dung

### Input: File API

```
/home/steve/Desktop/Intern/work/Flower/Agent-skill-api/src/app/api/v1/get-store/route.ts
```

### Output:

1. **Tai lieu** tai `docs/api/get-store/index.md`
2. **Types** cap nhat trong `Agent-skill-web/src/types/`
3. **Endpoint** them trong `Agent-skill-web/src/api/endpoints.ts`
4. **Service** cap nhat trong `Agent-skill-web/src/services/`

---

## Luu Y Quan Trong

### Naming Conventions

| Backend | Frontend |
|---------|----------|
| `route.ts` | `{feature}-service.ts` |
| `z.object({})` | `interface {}` |
| `successResponse` | `ApiResponse<T>` |
| `z.string().optional()` | `field?: string` |

### Kiem Tra Truoc Khi Cap Nhat

1. Khong ghi de code nguoi dung da viet
2. Giu lai comments va logic cu
3. Chi them/cap nhat truong can thiet
4. Backup file truoc khi sua doi lon

### Duong Dan Quan Trong

```
Backend:
- API: Agent-skill-api/src/app/api/v1/
- Lib: Agent-skill-api/src/lib/api-response.ts
- Types: Agent-skill-api/src/payload-types.ts

Frontend:
- Types: Agent-skill-web/src/types/api/
- Services: Agent-skill-web/src/api/services/
- Endpoints: Agent-skill-web/src/api/endpoints.ts
```

---

## Resources

### references/

- `api-analysis-guide.md`: Huong dan chi tiet phan tich API backend

### assets/

- `api-doc-template.md`: Template cho tai lieu API

---

## Trigger Phrases

Skill nay duoc kich hoat khi nguoi dung:

### Nghien Cuu API
- "nghien cuu API nay"
- "doc API"
- "hieu API hoat dong"
- "API nay lam gi"

### Phan Tich API
- "phan tich API"
- "analyze API"
- "tao tai lieu API"
- "document API"

### Ghep API
- "ghep API"
- "integrate API"
- "tich hop API"
- "tao service cho API"
- "ket noi frontend voi API"

### Dong Bo Cau Truc
- "dong bo types"
- "sync types"
- "cap nhat types tu backend"
- "backend da thay doi, cap nhat frontend"
- "types khong khop, sua lai"
- "API da sua, dong bo lai"
