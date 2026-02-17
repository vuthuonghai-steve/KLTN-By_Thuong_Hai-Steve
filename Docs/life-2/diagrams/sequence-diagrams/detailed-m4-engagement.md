# Sequence Diagram: M4 - Engagement & Connections

> **Module:** Social
> **Mục tiêu:** Mô tả logic thiết lập mối quan hệ và các tương tác xã hội giữa người dùng.

---

## 🤝 1. Kịch bản: Friendship Handshake (Follow - M4-A1)

Mô tả luồng theo dõi người dùng khác và đồng bộ trạng thái.

```mermaid
sequenceDiagram
    actor UserA
    participant UI as ProfilePage(UserB)
    participant Service as ConnectionService
    participant Payload
    participant Notify as SSE Dispatcher

    UserA->>UI: Nhấn "Follow"
    UI->>Service: toggleFollow(follower: A, following: B)
    activate Service
    
    Service->>Payload: payload.find({ collection: 'follows', follower: A, following: B })
    Payload-->>Service: { docs: [] }
    
    Service->>Payload: payload.create({ collection: 'follows', data: { A, B } })
    activate Payload
    Payload-->>Service: followDoc
    deactivate Payload
    
    Service-->>UI: { success: true, status: 'following' }
    deactivate Service
    UI-->>UserA: Cập nhật UI nút "Đang theo dõi"

    opt Thông báo Real-time
        Service-->>Notify: trigger(type: 'NEW_FOLLOWER', target: B, actor: A)
        Notify-->>UserB: [SSE] "User A đã theo dõi bạn"
    end
```

---

## ❤️ 2. Kịch bản: Engagement Logic (Like bài viết - M4-A2)

Mô tả luồng tương tác cơ bản với Optimistic UI.

```mermaid
sequenceDiagram
    actor User
    participant App as Mobile/Web App
    participant Service as InteractService
    participant Payload
    participant DB

    User->>App: Nhấn "Like"
    App->>App: Update UI ngay lập tức (Xanh nút Like)
    App->>Service: likePost(postId, userId)
    activate Service
    
    Service->>Payload: payload.update({ collection: 'posts', id: postId, data: { $push: { likes: userId } } })
    activate Payload
    
    alt Thành công
        Payload-->>Service: updatedPost
        Service-->>App: { success: true }
    else Thất bại (Lỗi mạng/DB)
        Payload-->>Service: Error
        Service-->>App: { success: false }
        App->>App: Revert UI (Hủy trạng thái Like)
        App-->>User: Hiển thị "Không thể thực hiện, vui lòng thử lại"
    end
    deactivate Payload
    deactivate Service
```

---

## 🛡️ 3. Kịch bản: Connection Privacy (Block - M4-A3)

Mô tả luồng chặn người dùng và cắt đứt tương tác.

```mermaid
sequenceDiagram
    actor Blocker
    participant UI as Settings
    participant Service as PrivacyService
    participant Payload

    Blocker->>UI: Nhấn "Chặn" UserX
    UI->>Service: blockUser(actor: Blocker, target: UserX)
    activate Service
    
    Service->>Payload: payload.create({ collection: 'blocks', data: { Blocker, UserX } })
    
    Service->>Payload: payload.delete({ collection: 'follows', where: { or: [{follower: Blocker, following: UserX}, {follower: UserX, following: Blocker}] } })
    Note right of Service: Tự động hủy follow cả 2 chiều
    
    Service-->>UI: { success: true }
    deactivate Service
    UI-->>Blocker: Thông báo đã chặn thành công
```

---
*Ghi chú từ Tít dễ thương: Tương tác xã hội được thiết kế với cơ chế Optimistic UI giúp ứng dụng của yêu thương cảm thấy cực kỳ "nhạy" và mượt mà đấy!* 🥰
