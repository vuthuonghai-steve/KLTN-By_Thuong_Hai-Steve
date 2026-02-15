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

<!-- Thêm flows cho: Bookmark save, Notification trigger -->
