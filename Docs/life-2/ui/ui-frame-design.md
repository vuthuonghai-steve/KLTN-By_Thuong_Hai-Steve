# UI Frame Design

> **Mục đích:** Tổng hợp layout các màn hình chính  
> **Wireframes chi tiết:** ui/wireframes/  

---

## Các màn hình chính

1. **Auth** - Login, Register (ui/wireframes/auth.md)
2. **Feed** - Home feed, post cards (ui/wireframes/feed.md)
3. **Profile** - User profile, posts list (ui/wireframes/profile.md)
4. **Post Detail** - Chi tiết bài viết, comments

## Layout chung

- **Header:** Logo, Search, Notifications, Avatar
- **Sidebar (optional):** Navigation, tags
- **Main content:** Feed/Post list
- **Responsive:** Mobile-first, collapse sidebar trên mobile

## Component structure

- PostCard: avatar, author, content, actions (like, comment, share, bookmark)
- CommentSection: nested comments
