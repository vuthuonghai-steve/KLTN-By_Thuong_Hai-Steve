# Sequence Diagram: M4 - Engagement & Connections

> **Module:** Engagement
> **Mục tiêu:** Mô tả quá trình tương tác (Like/Comment) và Follow người dùng.

---

## ❤️ 1. Kịch bản: Tương tác bài viết (Like/Comment)

```mermaid
sequenceDiagram
    actor Member
    participant UI as PostCard
    participant Service as EngagementService
    participant Payload
    participant DB as MongoDB

    Member->>UI: Click "Like"
    UI->>Service: toggleLike(postId)
    activate Service
    Service->>Payload: payload.update({ id: postId, data: { stats: { likes: +1 } } })
    activate Payload
    Payload->>DB: updateOne
    DB-->>Payload: doc
    deactivate Payload
    Service-->>UI: liked: true
    deactivate Service
    UI-->>Member: Cập nhật icon trái tim (Hồng)
```

---

## 🤝 2. Kịch bản: Theo dõi người dùng (Follow)

```mermaid
sequenceDiagram
    actor Follower
    participant UI as ProfilePage
    participant Service as ConnectionService
    participant Payload
    participant DB as MongoDB

    Follower->>UI: Nhấn "Follow" @steve
    UI->>Service: followUser(targetId)
    activate Service

    Service->>Payload: payload.create({ collection: 'follows', data: { follower, following } })
    activate Payload
    Payload->>DB: insertOne
    DB-->>Payload: doc
    deactivate Payload

    Service-->>UI: following: true
    deactivate Service
    UI-->>Follower: Đổi trạng thái nút thành "Following"
```

---
*Fidelity Note: Các hành động Engagement (Like/Comment) sẽ đồng thời trigger SSE Notification tới Author của bài viết.* 🥰
