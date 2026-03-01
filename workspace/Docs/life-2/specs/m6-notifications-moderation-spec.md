# Specification: Module M6 - Notifications & Moderation

> **Mục đích:** Đặc tả hệ thống thông báo thời gian thực và quản lý nội dung/báo cáo.
> **Trạng thái:** Draft | **Version:** 1.0.0

---

## 1. Overview
Hệ thống giúp người dùng cập nhận các sự kiện mới (Likes, Comments, Follows) thông qua Server-Sent Events (SSE). Đồng thời cung cấp công cụ báo cáo nội dung vi phạm để bảo vệ cộng đồng.

## 2. Real-time Notifications (SSE)
- **Cơ chế**: Sử dụng `Server-Sent Events` thay vì WebSockets để tiết kiệm tài nguyên và tương thích tốt với Next.js App Router.
- **Sự kiện ghi nhận**:
    - `POST_LIKE`: Có người thích bài viết của bạn.
    - `POST_COMMENT`: Có người bình luận bài viết của bạn.
    - `USER_FOLLOW`: Có người mới follow bạn.
- **Data Persistence**: Mọi thông báo đều được lưu vào collection `notifications` để xem lại khi offline.

## 3. Moderation & Report System
- **Report Flow**: Người dùng bấm "Report" trên bài viết -> Chọn lý do (Spam, Hate speech,...) -> Admin duyệt trong trang quản trị.
- **Auto-action (Optional)**: Bài viết bị báo cáo > 10 lần bởi các người dùng khác nhau sẽ tự động ẩn tàng thời (Hidden) để chờ Admin xử lý.

## 4. Data Models (PayloadCMS)

### Collection: `notifications`
- `recipient`: Relationship (users)
- `actor`: Relationship (users) - Người gây ra hành động
- `type`: Enum (like, comment, follow, system)
- `entityId`: string (ID của bài viết hoặc comment liên quan)
- `isRead`: boolean (default: false)

### Collection: `reports`
- `reporter`: Relationship (users)
- `targetEntity`: string (Post ID)
- `reason`: Select (spam, inappropriate, toxic, other)
- `status`: Select (pending, resolved, dismissed)

## 5. API Endpoints
- `GET /api/v1/notifications/stream`: Endpoint SSE để nhận thông báo real-time.
- `GET /api/notifications`: Lấy danh sách thông báo đã lưu.
- `POST /api/reports`: Gửi báo cáo vi phạm.

## 6. UI Requirements
- **Notification Dropdown**: Hiển thị trên Header, có số thông báo chưa đọc (Red dot).
- **Report Modal**: Form chọn lý do báo cáo.
- **In-App Toast**: Hiển thị popup nhỏ khi có thông báo mới kể cả khi user không mở dropdown.
