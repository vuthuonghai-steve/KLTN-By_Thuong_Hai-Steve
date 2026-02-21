# UI Screen Specification: M2 - Content Engine

> **Mục đích:** Đặc tả thành phần UI và logic tương tác cho việc sáng tạo, quản lý và hiển thị nội dung bài viết.  
> **Traceability:** [Use Case M2], [detailed-m2-content.md], [m2-content-schema.yaml]

---

## 1. Screen Inventory (Danh sách màn hình)

| Screen ID | Tên màn hình | Mục tiêu | Actor |
|---|---|---|---|
| SC-M2-01 | Trình soạn thảo (Editor) | Soạn thảo & Xuất bản bài viết | Member |
| SC-M2-02 | Chi tiết bài viết | Xem nội dung & Bình luận | Member, Public |
| SC-M2-03 | Quản lý Media | Tải lên & Chọn tệp tin | Member |

---

## 2. Detailed Screen Logic (Chi tiết từng màn hình)

### SC-M2-01 - Post Editor

#### A. UI Components & Data Mapping
Dựa trên **Class Diagram**: `posts` collection

| UI Element ID | Type | Source Field (Class) | Required | Validation/Constraint |
|---|---|---|---|---|
| `input-post-title` | Text | `posts.title` | No | Max 100 char |
| `rich-editor-content`| RichText | `posts.content` | Yes | Lexical format, sanitize HTML |
| `select-visibility` | Select | `posts.visibility` | Yes | public, friends, private |
| `btn-upload-media` | Button | N/A | No | Open SC-M2-03 |
| `tag-list-preview` | Chips | `posts.tags` | No | Auto-extract from content |
| `btn-publish` | Button | N/A | N/A | Trigger Flow M2-A1 |

#### B. Interaction Flow (M2-A1)
- **Hashtag Extraction**: Khi User gõ nội dung, hệ thống tự động bóc tách `#tag`. Hiển thị dưới dạng Chips bên dưới Editor.
- **Media Binding**: Các media đã upload sẽ được liên kết vào `posts.mediaItems`.
- **Error States**: 
  - Nội dung rỗng: Vô hiệu hóa nút Đăng bài.
  - Media upload lỗi: Hiển thị cảnh báo màu đỏ tại khu vực preview media.

---

### SC-M2-02 - Post Detail View

#### A. UI Components & Data Mapping
| UI Element ID | Type | Source Field (Class) | Technical Binding |
|---|---|---|---|
| `display-author` | Link | `posts.authorId.username`| Nav to SC-M1-05 |
| `display-content` | HTML/JSON | `posts.content` | Render Lexical JSON |
| `media-gallery` | Carousel | `posts.mediaItems` | Render Image/Video |
| `btn-like` | IconBtn | N/A | Trigger M4 Interaction |
| `display-stats` | Text | `likesCount`, `commentsCount`| Auto-update |

---

## 3. Mapping ID for Automation (UI Contract)

| UI ID | Semantic Name | Technical Binding |
|---|---|---|
| `rich-editor-content`| Main Editor | `data-testid="post-editor"` |
| `btn-publish` | Publish Action | `id="btn-publish-post"` |
| `media-item-[id]` | Media Preview | `data-media-id="[id]"` |
