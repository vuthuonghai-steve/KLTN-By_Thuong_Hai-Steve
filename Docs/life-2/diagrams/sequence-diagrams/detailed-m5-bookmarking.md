# Sequence Diagram: M5 - Bookmarking

> **Module:** Knowledge Management
> **Mục tiêu:** Mô tả luồng lưu trữ bài viết và quản lý các thư mục kiến trúc kiến thức cá nhân.

---

## 💾 1. Kịch bản: Bookmark Persistence (Lưu bài viết - M5-A1)

Mô tả luồng lưu một bài viết vào mục mặc định.

```mermaid
sequenceDiagram
    actor User
    participant UI as PostCard
    participant Service as BookmarkService
    participant Payload
    participant DB

    User->>UI: Nhấn icon "Save"
    UI->>Service: savePost(userId, postId)
    activate Service
    
    Service->>Payload: payload.find({ collection: 'bookmarks', user: userId, post: postId })
    Payload-->>Service: { docs: [] }
    
    Service->>Payload: payload.create({ collection: 'bookmarks', data: { user: userId, post: postId, collection: 'Default' } })
    activate Payload
    Payload->>DB: insertBookmark
    DB-->>Payload: doc
    Payload-->>Service: doc
    deactivate Payload
    
    Service-->>UI: { success: true, bookmarkId }
    deactivate Service
    UI-->>User: "Đã lưu vào mục mặc định"
```

---

## 📂 2. Kịch bản: Collection Orchestrator (Quản lý thư mục - M5-A2)

Mô tả luồng tạo thư mục mới và di chuyển bookmark vào đó.

```mermaid
sequenceDiagram
    actor User
    participant UI as BookmarkManager
    participant Service as FolderService
    participant Payload

    User->>UI: Nhấn "Tạo bộ sưu tập mới"
    User->>UI: Nhập tên: "Học React"
    UI->>Service: createCollection(userId, name: 'Học React')
    activate Service
    Service->>Payload: payload.update({ collection: 'user-configs', userId, data: { $push: { collections: 'Học React' } } })
    Service-->>UI: { success: true }
    deactivate Service

    User->>UI: Chuyển bài viết X vào thư mục "Học React"
    UI->>Service: moveBookmark(bookmarkId, targetCollection: 'Học React')
    activate Service
    Service->>Payload: payload.update({ collection: 'bookmarks', id: bookmarkId, data: { collection: 'Học React' } })
    Payload-->>Service: updatedDoc
    Service-->>UI: { success: true }
    deactivate Service
    UI-->>User: "Đã di chuyển thành công"
```

---
*Fidelity Note: Tính năng Bookmarking là một trong những USP (Unique Selling Point) của dự án, được thiết kế để giúp người dùng quản lý kiến thức hiệu quả.* 🥰
