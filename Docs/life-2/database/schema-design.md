# Database Schema Design

> **Mục đích:** Chi tiết MongoDB collections, fields, indexes  
> **Tham chiếu:** diagrams/er-diagram.md, artkitacture.md  

---

## Collections Overview

| Collection     | Mục đích                    |
|----------------|-----------------------------|
| users          | User accounts, profiles     |
| posts          | Bài viết, content           |
| comments       | Bình luận (có thể nested)   |
| bookmarks      | Lưu bài viết vào collection |
| follows        | Quan hệ follow/unfollow     |
| notifications  | Thông báo cho user          |
| messages       | Tin nhắn 1-1 (nếu có)      |
| blocks         | Chặn user                   |

---

## Collection: users

**Fields:**
- `_id`: ObjectId (auto)
- `email`: string (unique, required)
- `password`: hash (required for email auth)
- `name`: string
- `avatar`: url
- `bio`: string
- `createdAt`: date
- `updatedAt`: date

**Indexes:**
- `{ email: 1 }` unique

---

## Collection: posts

**Fields:**
- `_id`: ObjectId (auto)
- `author`: ObjectId (ref: users)
- `content`: string/richtext
- `media`: array of urls
- `tags`: array of string
- `visibility`: enum (public, followers, private)
- `rankingScore`: number (cho feed ranking)
- `likesCount`, `commentsCount`, `savesCount`: number
- `createdAt`, `updatedAt`: date

**Indexes:**
- `{ rankingScore: -1, createdAt: -1 }` (feed query)
- `{ author: 1, createdAt: -1 }`

---

<!-- Thêm các collections khác theo artkitacture.md -->
