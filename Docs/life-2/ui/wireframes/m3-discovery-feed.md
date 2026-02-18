# Wireframes: Module M3 - Discovery & Feed

> **Mục đích:** Phác thảo cấu trúc giao diện cho luồng khám phá bài viết và tìm kiếm.
> **Phong cách:** Pink Petals Design System.

---

## 1. Main News Feed (`/`)

```text
+-------------------------------------------------------+
|  [Logo]   [ Search Knowledge...      ]   [Noti] [User]|
+-------------------------------------------------------+
|                                                       |
|  [Tab: For You]   [Tab: Following]   [Tab: Trending]  |
|  ---------------------------------------------------  |
|                                                       |
|  +-------------------------------------------------+  |
|  | [ M2 PostCard: Steve Thuong Hai ]               |  |
|  | "Why NoSQL is great for social apps..."        |  |
|  | [ Image ]                                       |  |
|  | [Heart] 1.2k  [Comment] 45  [Save]              |  |
|  +-------------------------------------------------+  |
|                                                       |
|  +-------------------------------------------------+  |
|  | [ M2 PostCard: Tech Learner ]                  |  |
|  | "My first Next.js 15 project experience..."     |  |
|  | [Heart] 850   [Comment] 22  [Save]              |  |
|  +-------------------------------------------------+  |
|                                                       |
|  [ Loading... (Spinner) ]                             |
+-------------------------------------------------------+
```

---

## 2. Search Autocomplete UI (Dropdown)

```text
+-----------------------------------------+
| [ Search Knowledge...             ]     |
+-----------------------------------------+
|  **Suggested Topics**                   |
|  # [NextJS]                             |
|  # [React19]                            |
|                                         |
|  **People**                             |
|  (Av) [Steve Thuong Hai] @steve         |
|  (Av) [Tech Student] @student123        |
|                                         |
|  [ Search for "..." in posts ]          |
+-----------------------------------------+
```

---

## 3. Search Results Page (`/search?q=...`)

```text
+-------------------------------------------------------+
| [Back]   Search results for "NoSQL"                   |
+-------------------------------------------------------+
|                                                       |
|  [Filter: All]  [Posts]  [People]  [Tags]             |
|                                                       |
|  Found 120 posts:                                     |
|                                                       |
|  +-------------------------------------------------+  |
|  | **Post Title/Snippet highlighting "NoSQL"**    |  |
|  | by @author...                                   |  |
|  +-------------------------------------------------+  |
|                                                       |
|  People:                                              |
|  (Av) @nosql_expert  [Follow]                         |
+-------------------------------------------------------+
```
