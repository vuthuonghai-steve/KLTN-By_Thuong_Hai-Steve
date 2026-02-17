# Sequence Diagram: M6 - Notifications & Moderation

> **Module:** Safety & Engagement
> **Mục tiêu:** Mô tả chi tiết luồng đẩy thông báo thời gian thực và quản lý báo cáo vi phạm.

---

## 📡 1. Kịch bản: SSE Event Dispatcher (M6-A1)

Mô tả kỹ thuật cách một sự kiện từ Database kích hoạt thông báo Real-time.

```mermaid
sequenceDiagram
    participant DB as MongoDB (Change Stream)
    participant Broadcaster as SSE Service
    participant Route as Next.js SSE Route
    actor Client as User Browser

    Note over DB: Có thay đổi tại collection 'notifications'
    DB->>Broadcaster: on('change', data)
    activate Broadcaster
    
    Broadcaster->>Broadcaster: Identify owner (userId)
    Broadcaster->>Route: emitEvent(userId, payload)
    activate Route
    
    Route-->>Client: data: { "type": "NEW_NOTIFICATION", "data": {...} }
    deactivate Route
    deactivate Broadcaster
    
    Client->>Client: Hiển thị Banner thông báo
```

---

## 🚩 2. Kịch bản: Content Report Pipeline (M6-A2)

Mô tả luồng từ khi người dùng báo cáo đến khi vào hàng chờ xử lý của Admin.

```mermaid
sequenceDiagram
    actor Reporter
    participant UI as PostOptions
    participant Service as ReportService
    participant Payload
    participant AdminUI as Mod Dashboard

    Reporter->>UI: Nhấn "Báo cáo bài viết" (Lý do: Spam)
    UI->>Service: submitReport(targetId, reason, reporterId)
    activate Service
    
    Service->>Payload: payload.create({ collection: 'reports', data })
    activate Payload
    Payload-->>Service: reportDoc
    deactivate Payload
    
    Service-->>UI: { success: true }
    deactivate Service
    UI-->>Reporter: "Cảm ơn bạn đã báo cáo, chúng tôi sẽ xem xét."

    opt Thông báo cho Mod
        Service->>AdminUI: refreshQueue()
        AdminUI-->>AdminUI: Hiển thị badge báo cáo mới
    end
```

---

## 🔨 3. Kịch bản: Enforcement Action (Admin thực thi - M6-A3)

Mô tả luồng Admin xử lý vi phạm bài viết.

```mermaid
sequenceDiagram
    actor Admin
    participant Dashboard as Mod Dashboard
    participant Service as EnforcementService
    participant Payload
    participant SSE as SSE Dispatcher

    Admin->>Dashboard: Xem báo cáo, quyết định "Gỡ bài"
    Dashboard->>Service: enforceAction(reportId, action: 'REJECT_POST')
    activate Service
    
    Service->>Payload: payload.update({ collection: 'posts', id: postId, data: { status: 'rejected' } })
    Service->>Payload: payload.update({ collection: 'reports', id: reportId, data: { status: 'resolved' } })
    
    Service-->>Dashboard: { success: true }
    deactivate Service
    Dashboard-->>Admin: "Đã xử lý xong"

    opt Thông báo cho tác giả
        Service-->>SSE: trigger(type: 'POST_REMOVED', target: AuthorId)
        SSE-->>UserAuthor: [SSE] "Bài viết của bạn đã bị gỡ do vi phạm chính sách"
    end
```

---
*Ghi chú từ Tít dễ thương: Module Safety giúp bảo vệ cộng đồng NeoSocial của chúng mình luôn văn minh và tích cực đấy yêu thương ạ!* 🥰
