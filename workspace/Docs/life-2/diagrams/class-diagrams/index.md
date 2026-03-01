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
| **M4** Engagement     | [class-m4-engagement.md](./m4-engagement/class-m4-engagement.md) | [class-m4-engagement.yaml](./m4-engagement/class-m4-engagement.yaml) | ✅ Ready |
| **M5** Bookmarking    | [class-m5-bookmarking.md](./m5-bookmarking/class-m5-bookmarking.md) | [class-m5-bookmarking.yaml](./m5-bookmarking/class-m5-bookmarking.yaml) | ✅ Ready |
| **M6** Notifications & Moderation | [class-m6-notifications.md](./m6-notifications-moderation/class-m6-notifications.md) | [class-m6-notifications.yaml](./m6-notifications-moderation/class-m6-notifications.yaml) | ✅ Ready |

**Legend**: ⏳ Pending → 🔄 In Progress → 🔍 Review → ✅ Ready (LOCKED)

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
| `shares` | M4 | ✅ Root | Audit Trail — 2 modes: copy_link / repost. Fields: postId, userId, shareType, sharedPostId, createdAt |
| `bookmark_collections` | M5 | ✅ Root | isDefault flag — 1 per user |
| `bookmarks` | M5 | ✅ Root | Unique compound index: (userId, postId) |
| `notifications` | M6 | ✅ Root | Polymorphic (entityType + entityId), SSE push |
| `reports` | M6 | ✅ Root | Polymorphic (targetType + targetId) |
| `audit_logs` | M6 | ✅ Root | Append-Only — update=nobody, delete=nobody |

---

## ✅ Assumptions Register — All Resolved

> Không còn assumption nào chưa được xác nhận. M4 shares entity đã được research và resolve đầy đủ.

| Entity | Field | Trạng thái | Resolved by | Date |
|--------|-------|-----------|-------------|------|
| `shares` | `postId` | ✅ Resolved | `er-diagram.md#SHARES.post_id` (Entity Dict added) | 2026-02-20 |
| `shares` | `userId` | ✅ Resolved | `er-diagram.md#SHARES.user_id` (Entity Dict added) | 2026-02-20 |
| `shares` | `createdAt` | ✅ Resolved | `er-diagram.md#SHARES.created_at` (Entity Dict added) | 2026-02-20 |
| `shares` | `shareType` | ✅ New field | `er-diagram.md#SHARES.share_type` + `flow/flow-post-share.md` | 2026-02-20 |
| `shares` | `sharedPostId` | ✅ New field | `er-diagram.md#SHARES.shared_post_id` + `flow/flow-post-share.md` | 2026-02-20 |

---

## 📊 Tổng kết validation (Skill 2.5 — All Modules)

| Module | Total Fields | With Source | Assumptions | Status |
|--------|------------|-------------|-------------|--------|
| M1 | 11 | 11 | 0 | ✅ PASS |
| M2 | 23 | 23 | 0 | ✅ PASS |
| M3 | 9 | 9 | 0 | ✅ PASS |
| M4 | 20 | 20 | 0 | ✅ PASS |
| M5 | 9 | 9 | 0 | ✅ PASS |
| M6 | 21 | 21 | 0 | ✅ PASS |
| **TOTAL** | **93** | **93** | **0** | **✅ ALL PASS (CLEAN)** |

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
4.> ✅ Tất cả modules **0 assumptions** — Ready cho Skill 2.6 mà không cần resolve thêm gì!

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
│   ├── class-m4-engagement.md    ✅ (shareType, sharedPostId confirmed)
│   └── class-m4-engagement.yaml  ✅ LOCKED (0 assumptions)
├── m5-bookmarking/
│   ├── class-m5-bookmarking.md    ✅
│   └── class-m5-bookmarking.yaml ✅ LOCKED
└── m6-notifications-moderation/
    ├── class-m6-notifications.md    ✅
    └── class-m6-notifications.yaml ✅ LOCKED
```

---

*Last updated: 2026-02-20 | Generated by Skill 2.5 (class-diagram-analyst) | All modules LOCKED via IP3*
