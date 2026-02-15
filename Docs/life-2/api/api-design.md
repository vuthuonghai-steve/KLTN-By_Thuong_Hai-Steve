# API Design

> **Mục đích:** Request/Response format, auth, errors  
> **Tham chiếu:** api-spec.md  

---

## Authentication

- **Method:** JWT (Payload Auth plugin)
- **Header:** `Authorization: Bearer <token>`
- **Refresh:** Endpoint refresh token

---

## Request/Response Format

**Request:** JSON body
**Response:** JSON

```json
{
  "docs": [...],
  "totalDocs": 100,
  "limit": 10,
  "page": 1
}
```

---

## Example: POST /api/posts

**Description:** Create a new post  
**Auth:** Required (JWT)

**Request Body:**
- `content`: string (required)
- `media`: string[] (optional)
- `tags`: string[] (optional)

**Response 201:**
- `id`: string
- `createdAt`: ISO8601

**Errors:**
- 401: Unauthorized
- 400: Validation error

---

## Example: GET /api/posts (Feed)

**Description:** List posts for feed (ranking applied)  
**Auth:** Required

**Query params:**
- `limit`: number (default 10)
- `page`: number
- `cursor`: string (for cursor-based pagination)
