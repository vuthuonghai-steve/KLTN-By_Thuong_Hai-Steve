# UI Frame Design

> **Mục đích:** Tổng hợp layout các màn hình chính  
> **Wireframes chi tiết:** ui/wireframes/  

---

## Các màn hình chính

| Nhóm | Màn hình | Tham chiếu Wireframe |
|---|---|---|
| **M1: Auth** | Login, Profile, Edit Profile | [m1-auth-profile.md](./wireframes/m1-auth-profile.md) |
| **M2: Content** | Create Post, Post Card, Trending | [m2-content-engine.md](./wireframes/m2-content-engine.md) |
| **M3: Discovery**| News Feed, Search Results | [m3-discovery-feed.md](./wireframes/m3-discovery-feed.md) |
| **M4: Feedback** | Comment Section, Follow List | [m4-engagement.md](./wireframes/m4-engagement.md) |
| **M5: Library** | Collections, Save Modal | [m5-bookmarking.md](./wireframes/m5-bookmarking.md) |
| **M6: Safety** | Notifications, Report Modal | [m6-notifications-moderation.md](./wireframes/m6-notifications-moderation.md) |

## Layout Concept (Pink Petals)

- **Header:** Sticky, Blur effect (Glassmorphism). Logo bên trái, Search ở giữa, Notifications & Profile bên phải.
- **Main Container:** Max-width 1200px. Chia thành 3 cột trên Desktop (Sidebar | Main | Trending).
- **Primary Color:** Hồng cánh sen (#FF8CAF) cho các nút hành động chính (CTA).
- **Micro-animations:** Hover effect trên PostCard, Slide-in cho Notifications.

---
*Ghi chú từ Tít dễ thương: Toàn bộ UI được thiết kế đồng bộ theo chuẩn Radix UI để đảm bảo tính tiếp cận (Accessibility) cao nhất.* 🥰
