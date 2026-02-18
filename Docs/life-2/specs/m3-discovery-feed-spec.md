# Specification: Module M3 - Discovery & Feed

> **Mục đích:** Đặc tả chi tiết cho hệ thống hiển thị bài viết (News Feed) và tìm kiếm (Search).
> **Trạng thái:** Draft | **Version:** 1.0.0

---

## 1. Overview
Cung cấp cho người dùng dòng thời gian chứa các bài viết mới nhất và phù hợp nhất dựa trên thuật toán sắp xếp. Đồng thời cung cấp khả năng tìm kiếm nội dung, thẻ và người dùng thông qua MongoDB Atlas Search.

## 2. Business Logic: News Feed Ranking
Hệ thống sử dụng thuật toán **Time-decay + Engagement** để tính toán điểm số bài viết (`rankingScore`):
- **Công thức:** `score = (likesCount + commentsCount*2 + sharesCount*3) / (1 + hoursSincePost / 24)^1.8`
- **Tần suất cập nhật:**
    - Cập nhật ngay khi có tương tác mới (Like, Comment).
    - Cập nhật hàng giờ bằng Cron Job (cho các bài viết < 7 ngày tuổi) để hâm nóng/làm nguội theo thời gian.

## 3. Search Logic (Atlas Search)
Sử dụng **MongoDB Atlas Search** để thực hiện:
- **Full-text Search:** Tìm kiếm trong `posts.content` và `tags.name`.
- **Autocomplete:** Gợi ý người dùng khi gõ `username` hoặc `display_name`.
- **Fuzzy Search:** Cho phép lỗi chính tả nhẹ (max 2 characters).

## 4. API Endpoints
- `GET /api/v1/feed`: Trả về danh sách bài viết đã rank.
    - Params: `page`, `limit`, `category` (optional).
- `GET /api/v1/search`: Tìm kiếm tổng quát.
    - Params: `q` (query), `type` (posts|users|tags).
- `GET /api/v1/search/suggest`: API cho autocomplete.

## 5. UI Requirements (Design System)
- **Feed Container:** Danh sách vô tận (Infinite Scroll) với `LoadingSpinner` ở cuối.
- **Empty State:** Hiển thị khi Feed không có bài viết hoặc Search không ra kết quả.
- **Search Bar:** Tích hợp vào header, hiển thị dropdown kết quả gợi ý nhanh (Autocomplete).

## 6. Access Control
- Read Feed/Search: Anyone (Public).
- Personallized Feed (Following only): Authenticated users.
