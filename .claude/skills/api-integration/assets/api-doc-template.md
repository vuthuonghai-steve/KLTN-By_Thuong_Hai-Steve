# {{API_NAME}}

> Tai lieu API duoc tao tu dong boi api-integration skill

---

## Thong Tin Chung

| Thuoc Tinh | Gia Tri |
|------------|---------|
| **Endpoint** | `{{METHOD}} {{ENDPOINT}}` |
| **Mo ta** | {{DESCRIPTION}} |
| **Auth** | {{AUTH_REQUIRED}} |
| **File Backend** | `{{BACKEND_FILE_PATH}}` |

---

## Request

### {{REQUEST_TYPE}}

| Truong | Kieu | Bat Buoc | Mac Dinh | Mo Ta |
|--------|------|----------|----------|-------|
{{REQUEST_FIELDS}}

### Validation Rules

{{VALIDATION_RULES}}

---

## Response

### Success Response (200)

```json
{{SUCCESS_RESPONSE_EXAMPLE}}
```

### Data Structure

| Truong | Kieu | Mo Ta |
|--------|------|-------|
{{RESPONSE_FIELDS}}

### Error Responses

| Status | Error | Khi Nao |
|--------|-------|---------|
{{ERROR_RESPONSES}}

---

## Frontend Integration

### 1. Type Definitions

**File**: `Agent-skill-web/src/types/api/{{FEATURE}}.types.ts`

```typescript
{{TYPE_DEFINITIONS}}
```

### 2. API Endpoint

**File**: `Agent-skill-web/src/api/endpoints.ts`

```typescript
{{ENDPOINT_CONSTANT}}
```

### 3. Service Method

**File**: `Agent-skill-web/src/api/services/{{FEATURE}}-service.ts`

```typescript
{{SERVICE_METHOD}}
```

### 4. Usage Example

```typescript
{{USAGE_EXAMPLE}}
```

---

## Notes

{{NOTES}}

---

**Tao luc**: {{CREATED_AT}}
**Cap nhat**: {{UPDATED_AT}}
