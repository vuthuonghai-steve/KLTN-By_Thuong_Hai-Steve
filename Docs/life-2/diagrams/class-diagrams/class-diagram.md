# Class Diagram

> **Mục đích:** Cấu trúc OOP (nếu cần)  
> **Format:** Mermaid classDiagram  
> **Ghi chú:** Optional - Payload CMS dùng Collections, có thể bỏ qua hoặc map sang interface/types  

---

```mermaid
classDiagram
    class User {
        +ObjectId id
        +string email
        +string name
        +string avatar
        +string bio
        +create()
        +update()
    }
    
    class Post {
        +ObjectId id
        +ObjectId authorId
        +string content
        +array media
        +array tags
        +create()
        +update()
        +delete()
    }
    
    User "1" --> "*" Post : creates
```
