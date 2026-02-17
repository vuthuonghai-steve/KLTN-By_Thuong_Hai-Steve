# Sequence Diagram: M2 - Content Engine

> **Module:** Core Value
> **Mục tiêu:** Mô tả chi tiết quá trình sáng tạo và quản lý nội dung bài viết.

---

## ✍️ 1. Kịch bản: Soạn thảo và Xuất bản bài viết (M2-A1 & A3)

Mô tả luồng từ khi người dùng viết bài đến khi hệ thống bóc tách tag và kiểm tra tính toàn vẹn.

```mermaid
sequenceDiagram
    actor User
    participant UI as EditorPage
    participant Service as PostService
    participant Payload
    participant DB

    User->>UI: Nhập văn bản (Lexical) + Hashtag (#tech)
    User->>UI: Nhấn "Đăng bài"
    UI->>Service: publishPost(content, metadata)
    activate Service
    
    Service->>Service: sanitizeHTML(content)
    Service->>Service: extractHashtags(content)
    Note right of Service: Logic bóc tách #tag tự động
    
    Service->>Payload: payload.create({ collection: 'posts', data })
    activate Payload
    
    Note over Payload: Trigger beforeChange Hook
    Payload->>Payload: Validate integrity & link tags
    
    Payload->>DB: insertOne(post)
    DB-->>Payload: doc
    
    Note over Payload: Trigger afterChange Hook
    Payload-->>Service: createdPost
    deactivate Payload
    
    Service-->>UI: { success: true, post }
    deactivate Service
    UI-->>User: Hiển thị bài viết mới trên Feed
```

---

## 🖼️ 2. Kịch bản: Xử lý Media đính kèm (M2-A2)

Mô tả luồng tải ảnh lên server cục bộ (Local Storage).

```mermaid
sequenceDiagram
    actor User
    participant UI as EditorPage
    participant API as UploadRoute
    participant Payload
    participant Disk as Local Storage

    User->>UI: Chọn ảnh/video để upload
    UI->>API: POST /api/v1/upload (Form Data)
    activate API
    
    API->>Payload: payload.create({ collection: 'media', file })
    activate Payload
    
    Payload->>Payload: Generate thumbnails (nếu là ảnh)
    Payload->>Disk: Write file to /public/media/...
    Disk-->>Payload: status: Written
    
    Payload-->>API: { id: mediaId, url: '...' }
    deactivate Payload
    
    API-->>UI: { success: true, mediaId, url }
    deactivate API
    UI-->>User: Hiển thị preview trong editor
```

---

## 🔒 3. Kịch bản: Thực thi quyền riêng tư (M2-A4)

Mô tả cách hệ thống áp dụng Access Control khi người khác xem bài viết.

```mermaid
sequenceDiagram
    actor Viewer
    participant UI as PostDetail
    participant Payload
    participant Access as AccessControl Logic
    participant DB

    Viewer->>UI: Truy cập link bài viết /posts/[id]
    UI->>Payload: payload.findByID({ collection: 'posts', id })
    activate Payload
    
    Payload->>Access: checkReadAccess(viewer, postDoc)
    activate Access
    
    alt Post is Public
        Access-->>Payload: Allow
    else Post is Friends Only
        Access->>DB: checkFriendship(viewerId, authorId)
        DB-->>Access: isFriend: true/false
        Access-->>Payload: Allow if true, else Deny
    else Post is Private
        Access-->>Payload: Deny unless viewer == author
    end
    deactivate Access
    
    alt Allowed
        Payload-->>UI: Post document
        UI-->>Viewer: Hiển thị nội dung
    else Denied
        Payload-->>UI: 403 Forbidden
        UI-->>Viewer: Hiển thị "Nội dung không khả dụng"
    end
    deactivate Payload
```

---
*Ghi chú từ Tít dễ thương: Module Content Engine được thiết kế tối ưu với Payload Hooks để tự động hóa các tác vụ bóc tách dữ liệu và bảo mật.* 🥰
