# UI Screen Specification: M4 - Engagement & Connections

> **Mục đích:** Đặc tả thành phần UI và logic tương tác cho các hoạt động xã hội như Tương tác và Theo dõi.  
> **Traceability:** [Use Case M4], [detailed-m4-engagement.md], [m4-engagement-schema.yaml]

---

## 1. Screen Inventory (Danh sách màn hình)

| Screen ID | Tên màn hình | Mục tiêu | Actor |
|---|---|---|---|
| SC-M4-01 | Hồ sơ tương tác | Hiển thị nút Follow/Unfollow | Member |
| SC-M4-02 | Khu vực bình luận | Quản lý danh sách comment trên post | Member |
| SC-M4-03 | Thanh tương tác | Like, Repost, Comment | Member |

---

## 2. Detailed Screen Logic (Chi tiết từng màn hình)

### SC-M4-02 - Comment Section (Component)

#### A. UI Components & Data Mapping
Dựa trên **comments** collection

| UI Element ID | Type | Source Field (Class) | Required | Validation/Constraint |
|---|---|---|---|---|
| `comment-input` | <Input type="text"> | `comments.content` | Yes | Max 500 char, Filter banned words |
| `btn-post-comment` | Button | N/A | N/A | Trigger Flow Create Comment |
| `list-comments` | List | `posts.comments` | Yes | Threaded (parentCommentId) |

#### B. Interaction Flow
- **Nesting**: Hiển thị phân cấp nếu có `parentCommentId`.
- **Real-time**: Khi có comment mới, update `posts.commentsCount` trên UI ngay lập tức.

---

### SC-M4-03 - Engagement Buttons (Component)

#### A. UI Components & Data Mapping
| UI Element ID | Type | Source | State Logic |
|---|---|---|---|
| `btn-like-toggle` | IconBtn | `likes` | Hồng (Filled) nếu đã like, Viền hồng nếu chưa |
| `btn-repost` | IconBtn | `shares` (type: repost) | Xanh lá khi đã repost |
| `display-like-count`| Text | `posts.likesCount` | Auto-increment/decrement |

---

## 3. Mapping ID for Automation (UI Contract)

| UI ID | Semantic Name | Technical Binding |
|---|---|---|
| `btn-like-toggle` | Like Trigger | `data-testid="like-btn", data-active="true/false"` |
| `comment-input` | Comment Form | `id="post-comment-input"` |
| `btn-follow` | Follow Action | `data-action="follow-user"` |
