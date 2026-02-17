# Knowledge Item: Barrel Pattern (Export-Aggregation Pattern)

> **Mô tả**: Chiến lược quản lý tài nguyên code tập trung, giúp tối ưu hóa việc tái sử dụng và giữ cho các file import luôn gọn gàng.
> **Trạng thái**: Đã phê duyệt bởi Steve
> **Phân loại**: Coding Convention / Clean Architecture

---

## 🎯 Vấn đề giải quyết
Khi dự án lớn dần, các file typescript nằm rải rác ở nhiều cấp thư mục. Việc import từ từng file lẻ tẻ dẫn đến:
1.  **Import rườm rà**: Quá nhiều dòng import cho các thành phần trong cùng một module.
2.  **Khó bảo trì**: Khi thay đổi tên file hoặc cấu trúc bên trong module, mọi nơi sử dụng đều phải cập nhật lại đường dẫn chi tiết.
3.  **Lộ bí mật nội bộ**: Người dùng module phải biết chính xác file nào chứa hàm nào.

## 🚀 Giải pháp: Barrel Pattern (Index Pattern)
Quản lý tập trung mọi export thông qua một file `index.ts` nằm tại root của thư mục module.

### Cấu trúc thư mục chuẩn:
```text
module-name/
├── component-a.tsx
├── component-b.tsx
├── use-logic.ts
└── index.ts  <-- Điểm tập trung (The Barrel)
```

### Cách triển khai:

**1. Trong các file con (ví dụ `component-a.tsx`):**
Sử dụng **Named Export**.
```typescript
export const ComponentA = () => { ... }
```

**2. Trong file `index.ts`:**
Import và Re-export toàn bộ.
```typescript
export * from './component-a';
export * from './component-b';
export * from './use-logic';
```

**3. Khi sử dụng ở module khác:**
Chỉ cần quan tâm đến tên thư mục.
```typescript
// ✅ CORRECT: Gọn gàng, dễ quản lý
import { ComponentA, useLogic } from '@/components/module-name';

// ❌ WRONG: Quá chi tiết, khó bảo trì
import { ComponentA } from '@/components/module-name/component-a';
import { useLogic } from '@/components/module-name/use-logic';
```

## ⚖️ Lợi ích mang lại
- **Sạch sẽ (Clean)**: Giảm số lượng dòng import.
- **Tính đóng gói (Encapsulation)**: Thư mục hoạt động như một "Black Box", chỉ lộ ra những gì được export ở `index.ts`.
- **Dễ tái cấu trúc**: Có thể đổi tên file bên trong thư mục mà không làm hỏng các nơi đang import (miễn là export name không đổi).

## ⚠️ Lưu ý khi áp dụng
- Tránh **Circular Dependencies** (Phụ thuộc vòng): Cẩn thận khi `index.ts` của Module A import Module B và ngược lại.
- Trình biên dịch TypeScript/Vite sẽ tự động tìm `index.ts` khi bạn chỉ định đường dẫn thư mục.

---
**Cập nhật lần cuối**: 2026-02-17
**Tác giả**: Tít dễ thương (theo yêu cầu của Steve)
