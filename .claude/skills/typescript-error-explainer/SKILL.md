---
name: typescript-error-explainer
description: Giải thích lỗi TypeScript một cách dễ hiểu bằng tiếng Việt. Sử dụng khi gặp lỗi type, generic, inference, hoặc bất kỳ lỗi TS nào cần được giải thích rõ ràng.
---

# TypeScript Error Explainer

Skill này giúp giải thích các lỗi TypeScript bằng tiếng Việt, dễ hiểu cho cả người mới học.

## Khi nào sử dụng skill này

- Khi user hỏi về lỗi TypeScript
- Khi cần giải thích error message từ compiler
- Khi gặp các lỗi liên quan đến type, generic, inference
- Khi user paste lỗi TS và hỏi "tại sao", "là gì", "sửa sao"

## Quy trình giải thích lỗi

### Bước 1: Xác định loại lỗi

| Mã lỗi | Loại | Ý nghĩa |
|--------|------|---------|
| TS2322 | Type Mismatch | Không thể gán type A cho type B |
| TS2339 | Property Missing | Property không tồn tại trên type |
| TS2345 | Argument Type | Argument không khớp với parameter |
| TS2531 | Possibly Null | Object có thể là null/undefined |
| TS2551 | Typo Suggestion | Có thể bạn muốn viết... |
| TS2304 | Cannot Find Name | Không tìm thấy tên/biến/type |
| TS2307 | Module Not Found | Không tìm thấy module |
| TS2769 | Overload Mismatch | Không khớp với bất kỳ overload nào |
| TS7006 | Implicit Any | Parameter ngầm định là 'any' |

### Bước 2: Giải thích theo format này

```markdown
## 🔴 [Mã lỗi] - [Tên lỗi ngắn gọn]

### Thông báo lỗi
> [Copy nguyên văn]

### Giải thích đơn giản
[1-2 câu bằng ngôn ngữ đời thường]

### Nguyên nhân
[Phân tích ngắn gọn tại sao xảy ra]

### Cách sửa
\`\`\`typescript
// Code sửa lỗi
\`\`\`

### Lưu ý
[Tips phòng tránh lỗi tương tự]
```

## Các lỗi thường gặp

### TS2322 - Type Mismatch

**Ví dụ**: `Type 'string' is not assignable to type 'number'`

**Giải thích**: Bạn đang gán chuỗi vào biến kiểu số. Giống như nhét quả táo vào hộp chỉ dành cho cam.

**Cách sửa**:
- Kiểm tra type khai báo
- Chuyển đổi type nếu cần (`parseInt()`, `toString()`)
- Sửa source data

### TS2339 - Property Missing

**Ví dụ**: `Property 'name' does not exist on type 'User'`

**Giải thích**: Type `User` chưa khai báo property `name`.

**Cách sửa**:
- Thêm property vào interface/type
- Dùng optional chaining: `user?.name`
- Kiểm tra đúng type chưa

### TS2531 - Possibly Null

**Ví dụ**: `Object is possibly 'null'`

**Giải thích**: Biến có thể null, truy cập trực tiếp sẽ crash.

**Cách sửa**:
```typescript
// Optional chaining
user?.name

// Nullish coalescing  
user?.name ?? 'Default'

// Type guard
if (user) { user.name }

// Non-null assertion (chỉ khi CHẮC CHẮN)
user!.name
```

### TS2345 - Argument Type

**Ví dụ**: `Argument of type 'string' is not assignable to parameter of type 'number'`

**Giải thích**: Function yêu cầu số nhưng bạn truyền chuỗi.

**Cách sửa**:
- Kiểm tra function signature
- Chuyển đổi type trước khi truyền

### TS7006 - Implicit Any

**Ví dụ**: `Parameter 'x' implicitly has an 'any' type`

**Giải thích**: Strict mode yêu cầu khai báo type rõ ràng.

**Cách sửa**:
```typescript
// ❌ Lỗi
function process(data) { }

// ✅ Đúng
function process(data: MyType) { }
```

## Mẹo đọc lỗi TypeScript

1. **Đọc từ dưới lên** - Chi tiết nhất ở dòng cuối
2. **Tìm 2 type được highlight** - Type bạn dùng vs Type TS mong đợi
3. **Chú ý từ khóa**:
   - `is not assignable to`: Không thể gán
   - `does not exist on`: Không tồn tại
   - `possibly`: Có thể null/undefined
   - `implicitly`: Thiếu khai báo

## Nguyên tắc khi giải thích

1. **Dùng tiếng Việt** - Theo quy tắc dự án
2. **Ví dụ thực tế** - So sánh với đời thường
3. **Đưa code mẫu** - Cách sửa cụ thể
4. **Không dùng `any`** - Trừ khi cực kỳ cần thiết
5. **Không dùng `@ts-ignore`** - Mà không giải thích lý do
