# Use Case Documentation Hub

> **Mục tiêu:** Cung cấp bản đồ điều hướng cho hệ thống phân tích Use Case của dự án. Tài liệu được cấu trúc theo 2 cấp: Tổng quan hệ thống và Chi tiết từng Module (M1-M6).

## 1) Lộ trình đọc (Reading Paths)

### Lộ trình 1: Tổng quan hệ thống (Overview-first)
Dành cho người mới tiếp cận hoặc cần cái nhìn toàn cảnh về ranh giới hệ thống, các Actor chính và các nhóm năng lực cốt lõi.
- [ ] [**UseCase Overview**](./use-case-overview.md)

### Lộ trình 2: Chi tiết theo Module (Module-first)
Dành cho Developer hoặc Reviewer cần đi sâu vào logic nghiệp vụ của từng phân vùng chức năng.
- **M1: Auth & Profile** -> [use-case-m1-auth-profile.md](./use-case-m1-auth-profile.md)
- **M2: Content Engine** -> [use-case-m2-content-engine.md](./use-case-m2-content-engine.md)
- **M3: Discovery & Feed** -> [use-case-m3-discovery-feed.md](./use-case-m3-discovery-feed.md)
- **M4: Engagement & Connections** -> [use-case-m4-engagement-connections.md](./use-case-m4-engagement-connections.md)
- **M5: Bookmarking** -> [use-case-m5-bookmarking.md](./use-case-m5-bookmarking.md)
- **M6: Notifications & Moderation** -> [use-case-m6-notifications-moderation.md](./use-case-m6-notifications-moderation.md)

## 2) Bản đồ truy vết (Traceability Map)

| Module | Chức năng (FR) | Tài liệu Use Case |
|---|---|---|
| **M1** | Identity (FR-1), Profile (FR-2) | [M1: Auth & Profile](./use-case-m1-auth-profile.md) |
| **M2** | Content Creation (FR-3) | [M2: Content Engine](./use-case-m2-content-engine.md) |
| **M3** | Feed (FR-4), Discovery (FR-7) | [M3: Discovery & Feed](./use-case-m3-discovery-feed.md) |
| **M4** | Engagement (FR-5), Connections (FR-10) | [M4: Engagement & Connections](./use-case-m4-engagement-connections.md) |
| **M5** | Bookmark (FR-6) | [M5: Bookmarking](./use-case-m5-bookmarking.md) |
| **M6** | Notification (FR-8), Moderation (FR-9) | [M6: Notifications & Moderation](./use-case-m6-notifications-moderation.md) |

---
*Lưu ý: Mọi thay đổi về Use Case cần được cập nhật đồng bộ với danh sách Requirements tại `Docs/life-1/01-vision/FR/`.*
