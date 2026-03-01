# Requirements (SRS)

> **Mục đích:** Functional Requirements (FR) + Non-functional Requirements (NFR)  
> **Format:** Markdown, có thể tham chiếu user-stories.md  

---

## Functional Requirements

### FR-1: Authentication
- Email/password đăng ký, đăng nhập
- payload auth, refresh token
- Logout

### FR-2: Profile
- Avatar upload (Local Storage)
- Bio, social links (GitHub, LinkedIn)
- Xem profile public của user khác
- Danh sách posts của user

### FR-3: Posts
- CRUD posts (text, rich text, images, links)
- Tags cho posts
- Visibility: public, followers only

### FR-4: News Feed
- Feed từ connections (follow)
- Ranking: time-decay + engagement
- Pagination (cursor-based)

### FR-5: Interactions
- Like/unlike post
- Comment, nested replies
- Share (copy link)

### FR-6: Bookmarking
- Save/unsave post
- Collections/Folders
- List bookmarks by collection

### FR-7: Search
- Full-text search: users, posts, tags
- MongoDB Atlas Search
- Autocomplete

### FR-8: Notifications
- SSE realtime
- Types: like, comment, follow
- Mark as read

### FR-9: Moderation
- Report post/comment
- Admin review reports
- Auto-approve new content

### FR-10: Privacy & Connections
- Follow/unfollow
- Block user
- Profile visibility settings

---

## Non-functional Requirements

### NFR-1: Performance
- Page load < 3s
- Search response < 500ms
- SSE latency < 1s

### NFR-2: Security
- Password hashing (bcrypt)
- JWT expiration, refresh flow
- RBAC với Payload Access Control

### NFR-3: Scalability
- Cursor pagination cho feed
- Indexes cho queries phổ biến
- Vercel serverless scale
