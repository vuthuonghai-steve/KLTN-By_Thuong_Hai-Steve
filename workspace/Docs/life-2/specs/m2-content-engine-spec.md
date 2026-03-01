# Specification: Module M2 - Content Engine

> **Mục đích:** Đặc tả hệ thống biên soạn và hiển thị bài viết.
> **Trạng thái:** Draft | **Version:** 1.0.0

---

## 1. Overview

Module M2 là trái tim của hệ thống, cho phép người dùng chia sẻ kiến thức thông qua văn bản, hình ảnh, mã nguồn và các liên kết bên ngoài.

## 2. Data Models (PayloadCMS)

### Collection: `posts`

- **Fields**:
  - `content`: RichText/Markdown (required)
  - `author`: Relationship (users) - auto-filled from current user
  - `media`: Array of Uploads (media collection)
  - `links`: Array of objects { title, url }
  - `tags`: Relationship (tags collection, hasMany: true)
  - `stats`: Group { likes: number, comments: number, shares: number }
  - `rankingScore`: number (cập nhật qua hook)

- **Hooks**:
  - `beforeChange`: Tự động sanitize nội dung và bóc tách `tags` từ hashtag trong `content`.
  - `afterChange`: Tính toán/Cập nhật `rankingScore`.

### Collection: `tags`

- **Fields**:
  - `name`: string (unique, required)
  - `slug`: string (auto-generate from name)
  - `postCount`: number (denormalized)

## 3. API Endpoints

- `GET /api/posts`: Lấy danh sách bài viết (theo filter: tag, author, search).
- `POST /api/posts`: Tạo bài viết mới.
- `GET /api/posts/:id`: Xem chi tiết bài viết.
- `PATCH /api/posts/:id`: Chỉnh sửa (chỉ chủ sở hữu).
- `DELETE /api/posts/:id`: Xóa bài viết.
- `GET /api/tags/trending`: Lấy danh sách tag phổ biến nhất.

## 4. UI Requirements (Design System)

- **Editor Component**: Hỗ trợ Markdown preview, dễ dàng chèn media và link.
- **PostCard**: Hiển thị snippet nội dung, avatar tác giả, và các nút tương tác (Like/Comment).
- **Tag Cloud**: Hiển thị các tag nổi bật ở Sidebar.

## 5. Logic Đặc biệt

- **Ranking Algorithm**: `score = (likes + comments*2) / (hours_since_post + 2)^1.8`.
- **Link Preview**: Tự động lấy OpenGraph meta (title, image) khi user dán link vào bài viết.
