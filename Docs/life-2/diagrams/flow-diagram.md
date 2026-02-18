# Flow Diagrams

> **Mục đích:** Mô tả business logic, decision points  
> **Format:** Mermaid flowchart  

---

## News Feed Ranking Flow

```mermaid
flowchart TD
    A[Trigger: User request Feed] --> B[Load user connections]
    B --> C[Calculate ranking score]
    C --> D{Score = engagement / age_weight}
    D --> E[Sort by score DESC]
    E --> F[Paginate]
    F --> G[Return results]
```

## Post Creation Flow

```mermaid
flowchart TD
    A[User submits post] --> B{Valid content?}
    B -->|No| C[Return validation error]
    B -->|Yes| D[Upload media if any]
    D --> E[Save to DB]
    E --> F[Return 201]
```


## Bookmark Save Flow

```mermaid
flowchart TD
    A[User clicks Save] --> B[Choose Collection]
    B --> C{Exists?}
    C -->|No| D[Create Collection]
    D --> E[Add Post ID to Collection.items]
    C -->|Yes| E
    E --> F[Update DB using $push]
    F --> G[Show success message]
```

## Notification Trigger Flow (Event-Driven)

```mermaid
flowchart TD
    A[Action: Like/Comment/Follow] --> B[Server handles logic]
    B --> C[Save Notification to DB]
    C --> D{Recipient Online?}
    D -->|Yes| E[Dispatch event to SSE Stream]
    D -->|No| F[Keep as Unread in DB]
    E --> G[Client UI dynamic update]
```

---
*Ghi chú: Các luồng xử lý trên đảm bảo tính nhất quán giữa UI và Data thông qua cơ chế tối ưu NoSQL.* 🥰
