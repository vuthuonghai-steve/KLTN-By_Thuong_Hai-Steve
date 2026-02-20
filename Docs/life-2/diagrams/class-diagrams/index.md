# Class Diagrams — Index & Routing

> **Mục đích**: Routing hub cho Skill 2.5 (class-diagram-analyst) và Skill 2.6 (schema-design-analyst).
> **Cập nhật tự động** bởi Skill 2.5 sau mỗi module được lock.
> **Skill 2.6 đọc bảng này trước** — chỉ load module có Status = ✅ Ready.

---

## 📊 Status Table

| Module | Markdown (Human Review) | YAML (AI Contract) | Status |
|--------|------------------------|---------------------|--------|
| **M1** Auth & Profile | [class-m1-auth-profile.md](./m1-auth-profile/class-m1-auth-profile.md) | [class-m1-auth-profile.yaml](./m1-auth-profile/class-m1-auth-profile.yaml) | ✅ Ready |
| **M2** Content Engine | [class-m2-content-engine.md](./m2-content-engine/class-m2-content-engine.md) | [class-m2-content-engine.yaml](./m2-content-engine/class-m2-content-engine.yaml) | ✅ Ready |
| **M3** Discovery Feed | [class-m3-discovery-feed.md](./m3-discovery-feed/class-m3-discovery-feed.md) | [class-m3-discovery-feed.yaml](./m3-discovery-feed/class-m3-discovery-feed.yaml) | ✅ Ready |
| **M4** Engagement     | [class-m4-engagement.md](./m4-engagement/class-m4-engagement.md) | [class-m4-engagement.yaml](./m4-engagement/class-m4-engagement.yaml) | ✅ Ready ⚠️ |
| **M5** Bookmarking    | [class-m5-bookmarking.md](./m5-bookmarking/class-m5-bookmarking.md) | [class-m5-bookmarking.yaml](./m5-bookmarking/class-m5-bookmarking.yaml) | ✅ Ready |
| **M6** Notifications & Moderation | [class-m6-notifications.md](./m6-notifications-moderation/class-m6-notifications.md) | [class-m6-notifications.yaml](./m6-notifications-moderation/class-m6-notifications.yaml) | ✅ Ready |

**Legend**: ⏳ Pending → 🔄 In Progress → 🔍 Review → ✅ Ready (LOCKED) | ⚠️ = có ASSUMPTION cần xác nhận

> **M4 Note**: `shares` entity có 3 fields `[ASSUMPTION]` — cần bổ sung Entity Dict vào `er-diagram.md` trước khi implement schema.

---

## 🗺️ Entity → Module Routing

> Skill 2.5 dùng bảng này để biết entity nào thuộc module nào.

| Entity | Module | Aggregate Root | Special Notes |
|--------|--------|---------------|---------------|
| `users` | M1 | ✅ Root | Core entity — Computed: followerCount, followingCount |
| `posts` | M2 | ✅ Root | Denormalized counters, ranking_score; Embedded: tags[], mediaItems[] |
| `media` | M2 | ✅ Root | PayloadCMS Upload collection |
| `tags` | M2 | ✅ Root | N:N với posts qua relationship (embedded strategy) |
| `post_tags` | M2 | 📦 Embedded | Join table → embedded trong Post.tags[] |
| `post_media` | M2 | 📦 Embedded | Join table → embedded trong Post.mediaItems[] |
| `feedQuery` | M3 | ❌ ValueObject | No MongoDB collection — Cross-module query strategy |
| `comments` | M4 | ✅ Root | Threaded (parentCommentId), beforeChange: sanitize |
| `likes` | M4 | ✅ Root | Unique compound index: (postId, userId) |
| `connections` | M4 | ✅ Root | Unique compound index: (followerId, followingId) |
| `shares` | M4 | ✅ Root ⚠️ | **[ASSUMPTION]** Thiếu Entity Dict — 3 fields provisional |
| `bookmark_collections` | M5 | ✅ Root | isDefault flag — 1 per user |
| `bookmarks` | M5 | ✅ Root | Unique compound index: (userId, postId) |
| `notifications` | M6 | ✅ Root | Polymorphic (entityType + entityId), SSE push |
| `reports` | M6 | ✅ Root | Polymorphic (targetType + targetId) |
| `audit_logs` | M6 | ✅ Root | Append-Only — update=nobody, delete=nobody |

---

## ⚠️ Assumptions Register

> Field/entity được thiết kế mà không có nguồn tài liệu gốc.

| Entity | Field | Assumption | Nguồn tham chiếu | Người confirm |
|--------|-------|-----------|-------------------|---------------|
| `shares` | `postId` | Suy luận từ POSTS→SHARES relation trong ERD tổng quan | er-diagram.md ERD section 1 | ⏳ Chờ xác nhận |
| `shares` | `userId` | Suy luận từ USERS→SHARES relation trong ERD tổng quan | er-diagram.md ERD section 1 | ⏳ Chờ xác nhận |
| `shares` | `createdAt` | Theo pattern tương tự `likes` collection | er-diagram.md#LIKES.created_at | ⏳ Chờ xác nhận |

> **Action required**: Thêm SHARES Entity Dictionary vào `er-diagram.md` để lock assumptions và chuẩn bị cho Skill 2.6.

---

## 📊 Tổng kết validation (Skill 2.5 — All Modules)

| Module | Total Fields | With Source | Assumptions | Status |
|--------|------------|-------------|-------------|--------|
| M1 | 11 | 11 | 0 | ✅ PASS |
| M2 | 23 | 23 | 0 | ✅ PASS |
| M3 | 9 | 9 | 0 | ✅ PASS |
| M4 | 18 | 18 | 3 | ✅ PASS ⚠️ |
| M5 | 9 | 9 | 0 | ✅ PASS |
| M6 | 21 | 21 | 0 | ✅ PASS |
| **TOTAL** | **91** | **91** | **3** | **✅ ALL PASS** |

---

## 📌 Hướng dẫn sử dụng

### Cho Skill 2.5 (class-diagram-analyst):
1. Đọc bảng Entity → Module Routing để biết scope
2. Cập nhật Status sau mỗi module hoàn thành
3. Cập nhật Assumptions Register nếu có field không có nguồn

### Cho Skill 2.6 (schema-design-analyst):
1. **ĐỌC FILE NÀY TRƯỚC** — biết module nào đã ✅ Ready
2. Chỉ load YAML file của module có Status = ✅ Ready
3. KHÔNG load module status ⏳ hoặc 🔄
4. **M4 Warning**: Resolve assumptions cho `shares` trước khi generate PayloadCMS schema

---

## 🔗 YAML Contracts Summary

Các file YAML đã được lock, sẵn sàng cho Skill 2.6:

```
Docs/life-2/diagrams/class-diagrams/
├── m1-auth-profile/
│   ├── class-m1-auth-profile.md    ✅
│   └── class-m1-auth-profile.yaml ✅ LOCKED
├── m2-content-engine/
│   ├── class-m2-content-engine.md    ✅
│   └── class-m2-content-engine.yaml ✅ LOCKED
├── m3-discovery-feed/
│   ├── class-m3-discovery-feed.md    ✅ (ValueObject — no MongoDB collection)
│   └── class-m3-discovery-feed.yaml ✅ LOCKED
├── m4-engagement/
│   ├── class-m4-engagement.md    ✅ (⚠️ shares assumptions)
│   └── class-m4-engagement.yaml ✅ LOCKED
├── m5-bookmarking/
│   ├── class-m5-bookmarking.md    ✅
│   └── class-m5-bookmarking.yaml ✅ LOCKED
└── m6-notifications-moderation/
    ├── class-m6-notifications.md    ✅
    └── class-m6-notifications.yaml ✅ LOCKED
```

---

*Last updated: 2026-02-20 | Generated by Skill 2.5 (class-diagram-analyst) | All modules LOCKED via IP3*
