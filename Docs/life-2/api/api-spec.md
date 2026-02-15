# API Specification

> **Mục đích:** REST endpoints tổng quan  
> **Chi tiết:** api/api-design.md  

---

## Endpoints Categories

| Category       | Base Path           | Mô tả                |
|----------------|---------------------|----------------------|
| Auth           | /api/auth/*         | Login, register, OAuth |
| Users          | /api/users/*        | Profiles, follow     |
| Posts          | /api/posts/*        | CRUD posts           |
| Comments       | /api/comments/*     | CRUD comments        |
| Bookmarks      | /api/bookmarks/*    | Save, unsave, list   |
| Notifications  | /api/notifications/*| List, mark read      |
| Search         | /api/search/*       | Users, posts, tags   |

## Payload CMS

Dự án dùng Payload CMS 3.x - REST API mặc định tại `/api/*`

Tham chiếu: [Payload REST API docs](https://payloadcms.com/docs/rest-api/overview)
