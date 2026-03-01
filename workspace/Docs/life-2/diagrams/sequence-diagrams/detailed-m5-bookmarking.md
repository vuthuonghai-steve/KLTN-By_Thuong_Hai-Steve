# Sequence Diagram: M5 - Social Bookmarking

> **Module:** Social Bookmarking
> **Mục tiêu:** Mô tả quá trình lưu bài viết vào bộ sưu tập cá nhân.

---

## 💾 1. Kịch bản: Lưu bài viết vào Collection

Mô tả luồng từ khi người dùng bấm Save đến khi bài viết được nhúng (Embedded) vào document Collection.

```mermaid
sequenceDiagram
    actor Member
    participant UI as PostCard/SaveModal
    participant Service as BookmarkService
    participant Payload
    participant DB as MongoDB

    Member->>UI: Nhấn biểu tượng "Save"
    UI-->>Member: Hiển thị SaveModal (Chọn collection)
    Member->>UI: Chọn "Next.js Learning"
    
    UI->>Service: saveToCollection(postId, collectionId)
    activate Service

    Service->>Payload: payload.update({ id: collectionId, data: { $push: { bookmarks: { post: postId } } } })
    activate Payload
    
    Payload->>DB: MongoDB $push operation
    DB-->>Payload: updatedDoc
    
    deactivate Payload
    Service-->>UI: Success
    deactivate Service
    UI-->>Member: Hiển thị thông báo "Đã lưu vào bộ sưu tập"
```

---

## 📂 2. Kịch bản: Xem danh sách bài viết trong Collection

Mô tả luồng truy vấn và Populate dữ liệu bài viết từ mảng nhúng.

```mermaid
sequenceDiagram
    actor Member
    participant UI as CollectionDetail
    participant Service as BookmarkService
    participant Payload
    participant DB as MongoDB

    Member->>UI: Mở bộ sưu tập "Next.js Learning"
    UI->>Service: getCollectionDetail(collectionId)
    activate Service

    Service->>Payload: payload.findByID({ id: collectionId, depth: 2 })
    activate Payload
    Note over Payload: Populate posts from embedded IDs
    
    Payload->>DB: MongoDB findByID with population
    DB-->>Payload: fullCollectionDoc
    
    deactivate Payload
    Service-->>UI: CollectionDTO (with Posts)
    deactivate Service
    UI-->>Member: Render danh sách bài viết đã lưu
```

---
*Fidelity Note: Sử dụng chiến lược Embedded Bookmarks giúp giảm số lượng collection cần quản lý và tối ưu tốc độ đọc của Member.* 🥰
