# ER Diagram

> **Mục đích:** Mô tả entities và relationships của hệ thống  
> **Format:** Mermaid erDiagram syntax  

---

```mermaid
erDiagram
    User ||--o{ Post : creates
    User ||--o{ Comment : writes
    User ||--o{ Bookmark : saves
    User ||--o{ Follow : "follows/followed by"
    Post ||--o{ Comment : has
    Post ||--o{ Like : receives
    User ||--o{ Like : gives
    
    User {
        ObjectId _id
        string email
        string name
        string avatar
        string bio
    }
    
    Post {
        ObjectId _id
        ObjectId author
        string content
        array media
        array tags
    }
    
    Comment {
        ObjectId _id
        ObjectId post
        ObjectId author
        string content
    }
```

<!-- Cập nhật với entities thực tế: User, Post, Comment, Like, Bookmark, Follow, Notification, Message -->
