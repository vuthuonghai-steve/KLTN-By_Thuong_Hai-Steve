# Specification: Module M4 - Engagement & Connections

> **Mục đích:** Đặc tả chi tiết cho hệ thống tương tác bài viết (Like, Comment) và quan hệ giữa người dùng (Follow).
> **Trạng thái:** Draft | **Version:** 1.0.0

---

## 1. Overview
Module này chịu trách nhiệm cho các hành động mang tính xã hội của hệ thống, giúp tăng tính tương tác giữa người dùng và nội dung.

## 2. Business Logic

### 2.1 Engagement (Tương tác bài viết)
- **Like**: Một người dùng chỉ có thể Like một bài viết một lần. Hành động Like sẽ trigger cập nhật `stats.likes` trong collection `posts`.
- **Comment**: Cho phép bình luận văn bản. Các bình luận có thể được sắp xếp theo thời gian hoặc lượt thích bài.

### 2.2 Connections (Quan hệ người dùng)
- **Follow**: Quan hệ một chiều (A follows B). Khi A follow B, bài viết của B sẽ xuất hiện trên Feed "Following" của A.
- **Unfollow**: Gỡ bỏ quan hệ.

## 3. Data Models (PayloadCMS)

### Collection: `follows`
- `follower`: Relationship (users)
- `following`: Relationship (users)
- **Constraint**: Unique index trên cặp `{follower, following}`.

### Collection: `comments`
- `post`: Relationship (posts)
- `author`: Relationship (users)
- `content`: textarea (required)
- `replies`: Array of Objects (cho nested comments - optional cho MVP)

## 4. API Endpoints
- `POST /api/follows`: Tạo quan hệ follow.
- `DELETE /api/follows/:id`: Xóa quan hệ.
- `POST /api/comments`: Gửi bình luận mới.
- `GET /api/comments?post=[id]`: Lấy danh sách bình luận của bài viết.

## 5. UI Requirements
- **Engagement Bar**: Nằm dưới mỗi bài viết, hiển thị số lượng Like/Comment.
- **Comment Section**: Danh sách các bình luận với Avatar và thời gian.
- **Follow Button**: Hiển thị trên Profile hoặc PostCard, đổi trạng thái "Follow" <-> "Following".

## 6. Access Control
- Engagement/Connection: Authenticated users only.
- Read Comments: Public.
