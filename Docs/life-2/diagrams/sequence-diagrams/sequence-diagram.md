# Sequence Diagrams

> **Mục đích:** Mô tả flow chi tiết cho từng use case  
> **Format:** Mermaid sequenceDiagram  
> **Ghi chú:** Có thể tách thành nhiều file trong thư mục này (auth-flow.md, post-creation.md, feed-load.md)  

---

## Authentication Flow

```mermaid
sequenceDiagram
    participant C as Client
    participant API as API
    participant Auth as Auth Service
    participant DB as Database
    
    C->>API: POST /api/auth/login
    API->>Auth: validate credentials
    Auth->>DB: find user
    DB-->>Auth: user
    Auth-->>API: token
    API-->>C: 200 + JWT
```

## Post Creation Flow

```mermaid
sequenceDiagram
    participant C as Client
    participant API as API
    participant DB as Database
    
    C->>API: POST /api/posts
    API->>API: validate auth
    API->>DB: insert post
    DB-->>API: post
    API-->>C: 201 + post
```

<!-- Thêm: News Feed Load, Bookmark Save -->
