# Map chức năng theo bậc & Map ưu tiên triển khai

> **Vị trí file:** `Docs/life-1/01-vision/FR/feature-map-and-priority.md`  
> **Nguồn:** Bản đồ chức năng Content-centric SNS + `requirements-srs.md` + `arhitacture-V2.md`  
> **Mục đích:** Map chức năng từng bậc cho hệ thống; map ưu tiên triển khai theo từng bậc/sprint.

---

## 1. Map chức năng theo từng bậc

### Bậc 0 — Hệ thống (System)

| Id   | Tên                    | Mô tả ngắn |
|------|------------------------|------------|
| S0   | Content-centric SNS    | Mạng xã hội chia sẻ kiến thức; trọng tâm Social Publishing + Social Bookmarking. |

---

### Bậc 1 — Module (6 nhóm chức năng)

| Id   | Module                         | Mô tả ngắn | FR tham chiếu |
|------|--------------------------------|------------|---------------|
| M1   | Tài khoản & Hồ sơ (Auth & Profile) | Identity, đăng nhập, profile | FR-1, FR-2 |
| M2   | Nội dung (Content Engine)      | Tạo/quản lý bài viết, rich text, tag | FR-3 |
| M3   | Khám phá & Phân phối (Discovery & Feed) | News feed, tìm kiếm | FR-4, FR-7 |
| M4   | Tương tác & Cộng đồng (Engagement) | Like, comment, share, follow, block | FR-5, FR-10 |
| M5   | Lưu trữ kiến thức (Social Bookmarking) | Bookmark, collections | FR-6 |
| M6   | Hệ thống & Thông báo (System & Notifications) | Realtime, kiểm duyệt | FR-8, FR-9 |

---

### Bậc 2 — Nhóm chức năng (trong từng Module)

| Bậc 1 | Id (Bậc 2) | Nhóm chức năng           | Mô tả ngắn |
|-------|------------|--------------------------|------------|
| M1    | M1.1       | Authentication           | Đăng ký, đăng nhập, OAuth, quên/đổi mật khẩu |
| M1    | M1.2       | User Profile             | Avatar, bìa, bio, social links, dashboard cá nhân |
| M2    | M2.1       | Post Creation            | Rich text, đa phương tiện, gắn thẻ (tag) |
| M2    | M2.2       | Post Management          | Chỉnh sửa, xóa, cài đặt quyền riêng tư |
| M3    | M3.1       | News Feed                | Following feed, Trending/For You (ranking) |
| M3    | M3.2       | Search                   | Full-text (posts, authors, tags), autocomplete |
| M4    | M4.1       | Tương tác cơ bản         | Like/reaction, comment (nested), share |
| M4    | M4.2       | Connections              | Follow/unfollow, block |
| M5    | M5.1       | Bookmark                 | Lưu/bỏ lưu bài viết |
| M5    | M5.2       | Collections              | Tạo thư mục, tổ chức bookmark theo collection |
| M6    | M6.1       | Notifications            | Realtime (SSE), đánh dấu đọc, xem tất cả |
| M6    | M6.2       | Moderation               | Báo cáo, auto-approve, admin duyệt báo cáo |

---

### Bậc 3 — Chức năng chi tiết (map FR + Payload)

| Bậc 2 | Id (Bậc 3) | Chức năng cụ thể | FR | Collection / Ghi chú |
|-------|------------|-------------------|-----|----------------------|
| M1.1  | M1.1.1     | Đăng nhập Email/Password | FR-1 | Users (payload auth) |
| M1.1  | M1.1.2     | Đăng nhập Google (OAuth) [🔒 Đã khóa] | FR-1 | Users |
| M1.1  | M1.1.3     | Quên mật khẩu / Đổi mật khẩu | FR-1 | Users |
| M1.1  | M1.1.4     | Logout, refresh token | FR-1 | — |
| M1.2  | M1.2.1     | Ảnh đại diện & ảnh bìa (Local Storage) | FR-2 | Users |
| M1.2  | M1.2.2     | Bio (tiểu sử) | FR-2 | Users |
| M1.2  | M1.2.3     | Liên kết xã hội (GitHub, LinkedIn, Portfolio) | FR-2 | Users |
| M1.2  | M1.2.4     | Dashboard cá nhân (danh sách bài viết, bookmark) | FR-2 | — (query Posts, Bookmarks) |
| M1.2  | M1.2.5     | Xem profile public của user khác | FR-2 | Users (read) |
| M2.1  | M2.1.1     | Rich text (H1, H2, Bold, Italic, Code block) | FR-3 | Posts (content) |
| M2.1  | M2.1.2     | Đa phương tiện (ảnh, video, nhúng link) | FR-3 | Posts |
| M2.1  | M2.1.3     | Gắn thẻ (hashtag) | FR-3 | Posts (tags) |
| M2.2  | M2.2.1     | Chỉnh sửa / Xóa bài viết | FR-3 | Posts |
| M2.2  | M2.2.2     | Visibility: Public / Followers only | FR-3 | Posts (visibility) |
| M3.1  | M3.1.1     | Following Feed | FR-4 | Posts + Follows |
| M3.1  | M3.1.2     | Trending/For You Feed (time-decay + engagement) | FR-4 | Posts (rankingScore) |
| M3.1  | M3.1.3     | Pagination cursor-based | FR-4 | — |
| M3.2  | M3.2.1     | Full-text search (posts, authors, tags) | FR-7 | MongoDB Atlas Search |
| M3.2  | M3.2.2     | Autocomplete | FR-7 | — |
| M4.1  | M4.1.1     | Like/Unlike post | FR-5 | Posts (likesCount) / Likes |
| M4.1  | M4.1.2     | Comment, nested replies | FR-5 | Comments (parent_id) |
| M4.1  | M4.1.3     | Share (copy link / reshare) | FR-5 | — |
| M4.2  | M4.2.1     | Follow/Unfollow | FR-10 | Follows |
| M4.2  | M4.2.2     | Block user | FR-10 | Blocks |
| M5.1  | M5.1.1     | Lưu bài viết (Save/Unsave) | FR-6 | Bookmarks |
| M5.2  | M5.2.1     | Tạo/sửa/xóa collection (thư mục) | FR-6 | Bookmarks (collection_name) |
| M5.2  | M5.2.2     | List bookmarks theo collection | FR-6 | Bookmarks |
| M6.1  | M6.1.1     | Thông báo realtime (SSE): like, comment, follow | FR-8 | Notifications |
| M6.1  | M6.1.2     | Đánh dấu đã đọc / Xem tất cả | FR-8 | Notifications (is_read) |
| M6.2  | M6.2.1     | Báo cáo nội dung (report) | FR-9 | Reports (hoặc field trong Post/Comment) |
| M6.2  | M6.2.2     | Auto-approve nội dung mới | FR-9 | — |
| M6.2  | M6.2.3     | Admin xem xét báo cáo | FR-9 | — |

---

## 2. Map ưu tiên triển khai theo từng bậc

### Nguyên tắc

- **Bậc ưu tiên** = Sprint (Sprint 1 → Sprint 4).  
- Triển khai theo **phụ thuộc**: Auth & Profile trước → Content → Discovery → Engagement & Notifications.  
- Mỗi sprint gắn với **Module (Bậc 1)** và **nhóm chức năng (Bậc 2)** rõ ràng.

---

### Bậc ưu tiên 1 — Sprint 1 (Nền tảng)

| Ưu tiên | Module (Bậc 1) | Nhóm (Bậc 2) | Chức năng chính (Bậc 3) | Collection Payload | Ghi chú |
|--------|----------------|--------------|--------------------------|---------------------|--------|
| P1     | M1             | M1.1, M1.2   | M1.1.1–M1.1.4, M1.2.1–M1.2.5 | Users               | Auth + Profile; Local storage setup. |

**Deliverable:** Đăng ký/đăng nhập (email + OAuth Google), profile (avatar, bio, links), xem profile người khác, dashboard cá nhân cơ bản.

---

### Bậc ưu tiên 2 — Sprint 2 (Nội dung & tương tác cơ bản)

| Ưu tiên | Module (Bậc 1) | Nhóm (Bậc 2) | Chức năng chính (Bậc 3) | Collection Payload | Ghi chú |
|--------|----------------|--------------|--------------------------|---------------------|--------|
| P2a    | M2             | M2.1, M2.2   | M2.1.1–M2.2.2            | Posts               | CRUD posts, rich text, tags, visibility. |
| P2b    | M4             | M4.1 (một phần) | M4.1.1, M4.1.2, M4.1.3 | Comments (+ Posts)  | Like, comment (nested), share. |
| P2c    | M5             | M5.1, M5.2   | M5.1.1, M5.2.1, M5.2.2   | Bookmarks           | USP: Save + Collections. |

**Deliverable:** Tạo/sửa/xóa bài viết (text + media + tag), like/comment/share, bookmark và collections.

---

### Bậc ưu tiên 3 — Sprint 3 (Khám phá & kết nối)

| Ưu tiên | Module (Bậc 1) | Nhóm (Bậc 2) | Chức năng chính (Bậc 3) | Collection Payload | Ghi chú |
|--------|----------------|--------------|--------------------------|---------------------|--------|
| P3a    | M3             | M3.1         | M3.1.1, M3.1.2, M3.1.3   | Posts, Follows      | Following feed + Trending (ranking). |
| P3b    | M3             | M3.2         | M3.2.1, M3.2.2           | — (Atlas Search)   | Full-text + autocomplete. |
| P3c    | M4             | M4.2         | M4.2.1, M4.2.2           | Follows, Blocks    | Follow/unfollow, block. |

**Deliverable:** News feed (following + for you), tìm kiếm, follow/unfollow, block.

---

### Bậc ưu tiên 4 — Sprint 4 (Realtime & kiểm duyệt)

| Ưu tiên | Module (Bậc 1) | Nhóm (Bậc 2) | Chức năng chính (Bậc 3) | Collection Payload | Ghi chú |
|--------|----------------|--------------|--------------------------|---------------------|--------|
| P4a    | M6             | M6.1         | M6.1.1, M6.1.2           | Notifications       | SSE realtime, mark read. |
| P4b    | M6             | M6.2         | M6.2.1, M6.2.2, M6.2.3   | Reports / Admin     | Report, auto-approve, admin review. |

**Deliverable:** Thông báo realtime (SSE), kiểm duyệt (report + admin).

---

## 3. Tóm tắt phụ thuộc giữa các bậc ưu tiên

```
Sprint 1 (P1)     → Users, Auth, Profile
      ↓
Sprint 2 (P2)     → Posts, Comments, Bookmarks (cần Users)
      ↓
Sprint 3 (P3)     → Follows, Blocks, Feed, Search (cần Posts, Users)
      ↓
Sprint 4 (P4)     → Notifications (SSE), Moderation (cần Comments, Posts, Users)
```

---

## 4. Đối chiếu nhanh: Module ↔ FR ↔ Collection

| Module (Bậc 1) | FR        | Collections chính   |
|----------------|-----------|----------------------|
| M1 Auth & Profile | FR-1, FR-2 | Users                |
| M2 Content      | FR-3      | Posts                |
| M3 Discovery   | FR-4, FR-7 | Posts, Follows, (Search index) |
| M4 Engagement  | FR-5, FR-10 | Comments, Follows, Blocks |
| M5 Bookmarking | FR-6      | Bookmarks            |
| M6 System & Notifications | FR-8, FR-9 | Notifications, (Reports) |

---

*Tài liệu được tạo từ context bản đồ chức năng Content-centric SNS và `Docs/life-1/01-vision/FR/requirements-srs.md`.*
