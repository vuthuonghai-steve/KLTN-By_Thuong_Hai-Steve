# Global Architecture Flows

> **Mục tiêu:** Mô tả các luồng tương tác cấp cao giữa các thành phần kiến trúc chính trong hệ thống NeoSocial (Next.js 15 + Payload CMS 3.x).

---

## 🔐 1. Identity & Authorization Pipeline (Luồng định danh)

Sơ đồ này mô tả cách hệ thống xử lý từ khi người dùng chưa đăng nhập đến khi được cấp quyền truy cập vào các tài nguyên bảo mật.

```mermaid
sequenceDiagram
    actor User
    participant UI as Next.js 15 (Client/Server)
    participant Service as AuthService
    participant Payload as Payload CMS (Local API)
    participant DB as MongoDB Atlas

    User->>UI: Truy cập trang yêu cầu Auth
    UI->>UI: Kiểm tra Session/Cookie
    alt No Session
        UI-->>User: Hiển thị Login Page
        User->>UI: Submit Credentials (Email/OAuth)
        UI->>Service: login(credentials)
        activate Service
        Service->>Payload: payload.login({ collection: 'users', data })
        activate Payload
        Payload->>DB: findOne({ email })
        DB-->>Payload: UserRecord
        Payload-->>Service: { user, token }
        deactivate Payload
        Service->>Service: setSessionCookie(token)
        Service-->>UI: { success: true }
        deactivate Service
        UI-->>User: Điều hướng tới Dashboard
    else Has Session
        UI-->>User: Render Protected Content
    end
```

---

## 📝 2. Content Lifecycle (Luồng vòng đời nội dung)

Mô tả quá trình từ khi người dùng tạo bài viết đến khi bài viết được xử lý và sẵn sàng để phân phối.

```mermaid
sequenceDiagram
    actor User
    participant Editor as Rich-text Editor (UI)
    participant PostService
    participant Payload as Payload CMS
    participant DB as MongoDB Atlas
    participant SSE as SSE Dispatcher

    User->>Editor: Nhập nội dung + Upload Media
    Editor->>PostService: createPost(postData)
    activate PostService
    PostService->>PostService: validate & sanitize(data)
    
    PostService->>Payload: payload.create({ collection: 'posts', data })
    activate Payload
    Note over Payload: Chạy beforeChange hooks (tagging, integrity)
    Payload->>DB: insertOne(postDoc)
    DB-->>Payload: insertedDoc
    Note over Payload: Chạy afterChange hooks
    Payload-->>PostService: CreatedPost
    deactivate Payload

    PostService-->>Editor: { success: true, post }
    deactivate PostService
    Editor-->>User: Hiển thị trạng thái thành công

    opt Phân phối Real-time
        PostService-->>SSE: pushNotificationToFollowers(newPost)
        SSE-->>User: [SSE Event] New post from friend
    end
```

---

## 📡 3. Real-time Engagement Loop (Luồng tương tác real-time)

Mô tả cơ chế Server-Sent Events (SSE) để đẩy thông báo và cập nhật feed mà không cần tải lại trang.

```mermaid
sequenceDiagram
    actor User
    participant Client as EventSource (UI)
    participant API as SSE Route Handler
    participant DB as MongoDB Change Stream
    participant Service as NotifyService

    User->>Client: Mở App (Init Connection)
    Client->>API: GET /api/v1/notifications/sse
    activate API
    API-->>Client: Connection Established (200 OK, stream)
    
    Note over DB: Có tương tác mới (Like/Comment)
    DB->>Service: trigger(changeEvent)
    Service->>Service: Identify targets
    Service->>API: broadcast(payload)
    API-->>Client: data: { type: 'NOTIFICATION', body: '...' }
    Client->>User: Hiển thị Toast/Badge cập nhật
    deactivate API
```

---
*Fidelity Note: Các sơ đồ này tuân thủ kiến trúc Local API của Payload 3.x và cơ chế SSE được thống nhất trong arhitacture-V2.md.*
