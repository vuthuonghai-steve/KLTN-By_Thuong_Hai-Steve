# 🎬 Animation Specification Guide (Next.js + Framer Motion)

> **Mục đích:** Định nghĩa bộ từ điển hiệu ứng chuyển động đồng bộ giữa Thiết kế (Pencil) và Thực thi (Code).
> **Phạm vi:** Áp dụng cho toàn bộ UI Components (shadcn/ui) trong dự án KLTN.

---

## I. NGUYÊN TẮC CHUNG (ANIMATION PHILOSOPHY)

1. **Subtle over Flashy**: Hiệu ứng phải nhẹ nhàng, hỗ trợ người dùng nhận biết hệ thống, không gây xao nhãng.
2. **Standard Timing**:
   - *Fast*: 150ms (Hover states, feedbacks)
   - *Normal*: 300ms (Page transitions, entry animations)
   - *Slow*: 500ms (Complex layout shifts, onboarding)
3. **Primary Trigger**:
   - `initial`: Tự động chạy khi mount.
   - `hover`: Khi di chuột vào.
   - `tap`: Khi click/chạm.
   - `viewport`: Khi node xuất hiện trên màn hình.

---

## II. BỘ TỪ ĐIỂN ANIMATION TOKENS

Dưới đây là các key mà Agent sẽ dùng để gán vào thuộc tính `context` trong Pencil.

| Token | Mô tả | Framer Motion Spec |
| :--- | :--- | :--- |
| `fade-up` | Hiện dần và trượt nhẹ từ dưới lên | `initial: {opacity: 0, y: 10}, animate: {opacity: 1, y: 0}` |
| `fade-in` | Hiện dần tại chỗ | `initial: {opacity: 0}, animate: {opacity: 1}` |
| `scale-in` | Phóng to nhẹ từ tâm | `initial: {opacity: 0, scale: 0.95}, animate: {opacity: 1, scale: 1}` |
| `hover-lift` | Nổi nhẹ lên khi hover (Card) | `whileHover: {y: -4, shadow: "lg"}` |
| `hover-scale` | Phóng to nhẹ khi hover (Button) | `whileHover: {scale: 1.02}` |
| `stagger-child` | Hiệu ứng xuất hiện lần lượt cho con | `transition: {staggerChildren: 0.1}` |
| `bounce-subtle` | Nhấp nhô nhẹ (Dùng cho CTA quan trọng) | `animate: {y: [0, -5, 0]}, transition: {repeat: Infinity}` |

---

## III. QUY TRÌNH ÁP DỤNG TRONG PENCIL (.PEN)

Khi vẽ bằng Pencil MCP, Agent (ui-pencil-drawer) sẽ thực hiện:

1. **Gán Meta-data**: Thêm vào trường `context` của Node JSON.

```json
{
  "id": "card-01",
  "type": "ref",
  "context": {
    "animation": "fade-up",
    "delay": 100,
    "priority": "high"
  }
}
```
1. **Self-Critique (Kiểm thử)**:

   - AI gọi `get_screenshot()` để xác nhận vị trí "Final State" của animation.
   - Nếu animation có `fade-up`, AI phải đảm bảo padding dưới của container đủ để không bị cắt (clip) khi element dịch chuyển `y: 10`.

---

## IV. WORKFLOW CHUYỂN ĐỔI SANG CODE (NEXTJS)

Khi Agent thực hiện chuyển từ `.pen` sang Code:

1. **Detect Token**: AI đọc `context.animation`.
2. **Generate Wrapper**: Tự động bọc component shadcn bằng `motion`.

```tsx
// Output Code mẫu
import { motion } from 'framer-motion'
import { Card } from '@/components/ui/card'

export const MyComponent = () => (
  <motion.div
    initial={{ opacity: 0, y: 10 }}
    animate={{ opacity: 1, y: 0 }}
    transition={{ duration: 0.3 }}
  >
    <Card>Content</Card>
  </motion.div>
)
```

---

## V. CHECKLIST KIỂM THỬ THỰC TẾ

- [ ] Hiệu ứng không gây giật lag (sử dụng `transform` và `opacity`).
- [ ] Không làm thay đổi layout flow của các element xung quanh (tránh layout shift).
- [ ] Hỗ trợ `reduced-motion` cho người dùng có nhu cầu đặc biệt.
