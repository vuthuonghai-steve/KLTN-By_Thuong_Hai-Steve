# API Specification

> **Mục đích:** Đặc tả danh sách REST endpoints cho toàn bộ hệ thống.
> **Format:** Path, Method, Description, Module logic.

---

## 🔑 1. Authentication (Module M1)

| Method | Path | Description | Access |
|---|---|---|---|
| `POST` | `/api/users/login` | Đăng nhập hệ thống | Public |
| `POST` | `/api/users/logout` | Đăng xuất | Auth |
| `POST` | `/api/users/register` | Đăng ký người dùng mới | Public |
| `GET` | `/api/users/me` | Lấy thông tin session hiện tại | Auth |

## 👤 2. User & Profile (Module M1)

| Method | Path | Description | Access |
|---|---|---|---|
| `GET` | `/api/users/:id` | Lấy Profile chi tiết | Public |
| `PATCH` | `/api/users/:id` | Cập nhật thông tin Profile/Settings | Owner |
| `POST` | `/api/follows` | Follow một người dùng | Auth |
| `DELETE` | `/api/follows/:id` | Unfollow người dùng | Owner |

## 📝 3. Content Engine (Module M2)

| Method | Path | Description | Access |
|---|---|---|---|
| `GET` | `/api/posts` | Lấy danh sách bài viết (theo filter) | Public |
| `POST` | `/api/posts` | Tạo bài viết mới | Auth |
| `PATCH` | `/api/posts/:id` | Cập nhật bài viết | Owner |
| `DELETE` | `/api/posts/:id` | Xóa bài viết | Owner |
| `POST` | `/api/media` | Upload file đa phương tiện | Auth |

## 🚀 4. Discovery & Feed (Module M3)

| Method | Path | Description | Access |
|---|---|---|---|
| `GET` | `/api/v1/feed` | Lấy news feed đã rank | Auth/Guest |
| `GET` | `/api/v1/search` | Tìm kiếm (Posts/Users/Tags) | Public |
| `GET` | `/api/v1/search/suggest` | Autocomplete gợi ý tìm kiếm | Public |

## 💾 5. Social Bookmarking (Module M5)

| Method | Path | Description | Access |
|---|---|---|---|
| `GET` | `/api/user-collections` | Lấy các bộ sưu tập của user | Auth |
| `POST` | `/api/user-collections` | Tạo mới bộ sưu tập | Auth |
| `PATCH` | `/api/user-collections/:id/save` | Lưu bài vào collection | Owner |
| `PATCH` | `/api/user-collections/:id/unsave`| Xóa bài khỏi collection | Owner |

## 🔔 6. Notifications (Module M6)

| Method | Path | Description | Access |
|---|---|---|---|
| `GET` | `/api/notifications` | Lấy danh sách thông báo | Auth |
| `PATCH` | `/api/notifications/:id` | Đánh dấu đã đọc | Owner |

---

*Ghi chú: Các endpoint `/api/v1/*` là các custom route handler được định nghĩa trong Next.js App Router để xử lý logic phức tạp ngoài Payload default.* 🥰
