# Data Access Patterns Mapping

> **Mục đích:** Khớp các Use Case nghiệp vụ với chiến lược truy vấn dữ liệu (Read/Write) để tối ưu NoSQL.  
> **Tham chiếu:** diagrams/UseCase/index.md, database/schema-design.md

---

## 🛠️ Mapping Table

| Use Case (Feature) | Collection chính | Thao tác (R/W) | Key truy vấn (Filter/Sort) | Ghi chú tối ưu |
|--------------------|------------------|----------------|--------------------------|----------------|
| **Load News Feed** | `posts` | Read | `rankingScore`, `createdAt` | Dùng Index phức hợp. |
| **View Profile** | `users` + `posts` | Read | `username` (user), `author_id` (posts) | Truy vấn song song. |
| **Create Post** | `posts` | Write | - | Trigger SSE notification. |
| **Save Bookmark** | `user_collections` | Write (Update) | `owner_id`, `collection_name` | Dùng `$push` vào mảng `bookmarks`. |
| **Check Follow** | `follows` | Read | `follower_id`, `following_id` | Check tồn tại 1 document. |
| **Load Notifications**| `notifications` | Read | `recipient_id`, `createdAt` | Phân trang (Pagination). |

---

## 🚀 Complex Query Patterns

### 1. News Feed Ranking Logic
*   **Input**: `user_id`
*   **Process**:
    1. Lấy danh sách `following_ids` từ collection `follows`.
    2. Query `posts` có `author_id` trong danh sách HOẶC có `rankingScore` cao.
    3. Sort theo `rankingScore` (giảm dần) và `createdAt` (giảm dần).

### 2. Social Bookmarking Discovery
*   **Input**: `collection_id`
*   **Process**:
    1. Query `user_collections` để lấy danh sách `post_ids`.
    2. Query `posts` dùng `$in` operator với danh sách `post_ids` vừa lấy.
