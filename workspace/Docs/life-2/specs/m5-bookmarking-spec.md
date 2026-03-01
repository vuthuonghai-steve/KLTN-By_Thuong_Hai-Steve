# Specification: Module M5 - Social Bookmarking

> **Mục đích:** Đặc tả hệ thống lưu trữ bài viết và tổ chức theo bộ sưu tập (Collections).
> **Trạng thái:** Draft | **Version:** 1.0.0

---

## 1. Overview
Hệ thống cho phép người dùng lưu bài viết ("Save for later") và phân loại các bài viết đã lưu vào các bộ sưu tập (Collections) hoặc thư mục (Folders) để dễ dàng quản lý kiến thức.

## 2. Data Models (PayloadCMS)

### Collection: `user_collections`
- **Fields**:
  - `name`: string (required)
  - `owner`: Relationship (users)
  - `description`: textarea
  - `isPublic`: checkbox (mặc định: false)
  - `items`: Array of Objects (Embedded Bookmarks)
    - `post`: Relationship (posts)
    - `savedAt`: Date (default: now)
- **Strategy**: Sử dụng cơ chế **Embedded Array** để lưu danh sách ID bài viết vào document Collection, giúp truy vấn nhanh danh sách đã lưu chỉ trong 1 lần đọc document.

## 3. Business Logic
- **Quick Save**: Hành động lưu nhanh bài viết vào collection mặc định ("My Bookmarks").
- **Custom Collections**: Người dùng có thể tạo không giới hạn collection (vídụ: "Học Next.js", "AI Research").
- **Public/Private**: Các collection có thể được công khai để chia sẻ cho người khác xem (Social Bookmarking).

## 4. API Endpoints
- `GET /api/v1/collections`: Lấy danh sách collection của user hiện tại.
- `POST /api/v1/collections`: Tạo collection mới.
- `PATCH /api/v1/collections/:id/save`: Thêm một bài viết vào collection (Dùng `$push`).
- `PATCH /api/v1/collections/:id/unsave`: Xóa một bài viết khỏi collection (Dùng `$pull`).
- `GET /api/v1/collections/:id`: Lấy chi tiết collection và Populate các bài viết bên trong.

## 5. UI Requirements
- **Save Modal**: Hiển thị khi bấm nút "Save" trên bài viết, cho phép chọn collection hoặc tạo mới.
- **Collection View**: Giao diện dạng lưới (Grid) hiển thị các collection với ảnh cover (lấy từ bài viết đầu tiên trong collection).
- **Manage Items**: Giao diện xóa hoặc di chuyển bài viết giữa các collections.

## 6. Access Control
- Read Public Collections: Anyone.
- Manage Collections: Owner only.
