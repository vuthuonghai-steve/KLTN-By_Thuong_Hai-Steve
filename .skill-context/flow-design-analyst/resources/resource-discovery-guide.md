# Resource Discovery Guide — Intent Detection & Confidence Scoring

> **Source**: Verified từ genesys.com, mypurecloud.com, voiceflow.com (NLU best practices). Adapted cho KLTN flow skill.
> **Purpose**: Cung cấp K7 knowledge để Builder viết `knowledge/resource-discovery-guide.md`
> **Guardrail**: Tài liệu này là nền tảng cho Guardrail G6 "Discover Before Ask"

---

## 1. Nguyên Tắc Cốt Lõi — "Discover Before Ask"

**G6 Guardrail**: Skill PHẢI thực hiện Resource Discovery **trước** khi hỏi user bất kỳ câu nào.

```
❌ SAI (Vi phạm G6):
  User: "vẽ flow bookmark"
  Skill: "Bạn muốn vẽ flow cho UC nào trong M5?"

✅ ĐÚNG (Tuân thủ G6):
  User: "vẽ flow bookmark"
  Skill: [DETECT] → keyword "bookmark" → M5, UC19
         [DISCOVER] → tìm use-case-m5-bookmarking.md, m5-bookmarking-spec.md
         [REPORT] → "🔍 Tôi tìm thấy: UC19 - Lưu/Bỏ lưu bài viết (M5). Spec file sẵn sàng. Xác nhận không?"
```

---

## 2. Intent Parsing — 3 Loại Keyword

### 2.1 Action Verb (Kích hoạt phân tích)

Nhận biết user muốn **tạo flow diagram**:

| Tiếng Việt | Tiếng Anh equivalents |
|------------|----------------------|
| vẽ, vẽ flow | draw, diagram |
| tạo, tạo flow | create, generate, make |
| làm flow | build flow |
| sinh, sinh diagram | produce, output |
| show flow | show, display |
| phân tích flow | analyze flow |

→ **Nếu KHÔNG có Action Verb**: Xem xét context. Nếu user đang trong session flow skill, mặc định ngầm hiểu là "vẽ flow".

### 2.2 Domain Noun (Xác định UC/Module)

| Keyword (VI) | Keyword (EN) | Module | UC chính |
|--------------|--------------|--------|----------|
| đăng ký, tạo tài khoản, register | register, sign up, create account | M1 | UC01 |
| đăng nhập, login, xác thực | login, sign in, authenticate | M1 | UC02 |
| google login, oauth | oauth, google sign in | M1 | UC03 |
| đăng xuất, logout | logout, sign out | M1 | UC04 |
| quên mật khẩu, reset password | forgot password, reset password | M1 | UC05 |
| hồ sơ, profile, chỉnh hồ sơ | profile, edit profile, update profile | M1 | UC06 |
| xem hồ sơ người khác | public profile, view profile | M1 | UC07 |
| tạo bài, viết bài, post bài | create post, write post, new post | M2 | UC08 |
| sửa bài, chỉnh bài, edit post | edit post, update post | M2 | UC09 |
| quyền riêng tư, privacy | privacy, post visibility | M2 | UC10 |
| feed, bảng tin, news feed | feed, news feed, home | M3 | UC11 |
| tìm kiếm, search | search, find, lookup, discover | M3 | UC12 |
| gợi ý, autocomplete | autocomplete, suggest, hint | M3 | UC13 |
| like, thích, unlike | like, unlike, react | M4 | UC14 |
| bình luận, comment, phản hồi | comment, reply, nested comment | M4 | UC15 |
| chia sẻ, share | share, repost | M4 | UC16 |
| follow, theo dõi, unfollow | follow, unfollow, subscribe | M4 | UC17 |
| chặn, block | block, mute | M4 | UC18 |
| bookmark, lưu bài, bỏ lưu | bookmark, save, unsave | M5 | UC19 |
| collection bookmark, quản lý bookmark | manage bookmark, collection | M5 | UC20 |
| thông báo, notification, realtime | notification, alert, push | M6 | UC21 |
| đọc thông báo, mark read | mark as read, read notification | M6 | UC22 |
| báo cáo, report vi phạm | report, flag, abuse | M6 | UC23 |
| kiểm duyệt, moderation, duyệt | review report, moderate, admin action | M6 | UC24 |

### 2.3 Module Hint (Tăng confidence nhanh)

| Hint (VI/EN) | Module |
|--------------|--------|
| "M1", "auth", "authentication", "identity" | M1 |
| "M2", "content", "post", "article" | M2 |
| "M3", "feed", "discovery", "search" | M3 |
| "M4", "engagement", "social", "connection" | M4 |
| "M5", "bookmark", "save", "collection" | M5 |
| "M6", "notification", "moderation", "admin" | M6 |

---

## 3. Confidence Score Rubric — Tính điểm (0–100)

| Thành phần | Score | Ghi chú |
|------------|-------|---------|
| **Action Verb** detected | +20pt | Ít nhất 1 từ trong bảng §2.1 |
| **Domain Noun** matched | +30pt | Ít nhất 1 keyword trong bảng §2.2 |
| **Module Hint** explicit | +30pt | User nói rõ "M1", "auth", ... trong bảng §2.3 |
| **UC matched** trong registry | +20pt | Domain Noun dẫn đến ≤ 2 UC candidates |
| **Tổng tối đa** | **100pt** | |

### 3.1 Ngưỡng quyết định

| Score | Mode | Hành động |
|-------|------|-----------|
| ≥ 70pt | **Confident Mode** | Discovery Report + Yes/No question |
| 40–69pt | **Gray Zone** | Numbered options (tối đa 3) |
| < 40pt | **Rejection** | Yêu cầu rephrase với gợi ý |

### 3.2 Tie-break Rule

Nếu ≥ 2 UC candidate có score chênh ≤ 10pt → **luôn đưa numbered options**, dù tổng điểm ≥ 70pt.

**Ví dụ:** User nhập "flow post" → UC08 (Tạo bài) +85pt, UC09 (Sửa bài) +75pt → chênh 10pt → Đưa options dù confident.

---

## 4. Quy Tắc Phân Nhánh — Decision Tree

```
INPUT user
  │
  ├─► [DETECT] Phân tích keywords
  │     ├─ Action Verb?   → +20pt
  │     ├─ Domain Noun?   → +30pt (map sang UC candidates)
  │     └─ Module Hint?   → +30pt
  │
  ├─► [DISCOVER] Tìm file trong dự án
  │     ├─ UC matched?    → +20pt
  │     └─ Spec file?     → ghi vào Discovery Report
  │
  ├─► [SCORE] Tính confidence
  │
  ├─ Score ≥ 70 AND no tie?
  │     └─► GATE 1: Discovery Report + "Xác nhận không?"
  │
  ├─ Score 40–69 OR tie?
  │     └─► GATE 1: Numbered options
  │           [1] UC-X: Tên use case (confidence: 75%)
  │           [2] UC-Y: Tên use case (confidence: 65%)
  │           [3] UC-Z: Tên use case (confidence: 55%)
  │
  └─ Score < 40?
        └─► "Tôi chưa xác định được flow bạn muốn vẽ.
              Bạn đang muốn nói đến chức năng nào trong hệ thống?
              [1] Auth & Đăng nhập (M1)
              [2] Quản lý bài viết (M2)
              [3] Feed & Tìm kiếm (M3)
              ... hoặc mô tả thêm để tôi hiểu hơn."
```

---

## 5. Discovery Report Templates — 3 Mẫu

### Mẫu 1: Confident — Input rõ ràng

> Trigger: User nói "vẽ flow đăng nhập M1"

```
🔍 **Discovery Report**

📌 **Flow được yêu cầu:**
- Use Case: UC02 — Đăng nhập Email/Password
- Module: M1 — Auth & Profile
- Confidence: 90/100

📂 **Tài liệu tìm thấy:**
- Use Case: `Docs/life-2/diagrams/UseCase/use-case-m1-auth-profile.md`
- Spec: `Docs/life-2/specs/m1-auth-profile-spec.md`

⚙️ **Kỹ thuật phát hiện:**
- Action Verb: "vẽ" (+20)
- Domain Noun: "đăng nhập" → UC02 (+30)
- Module Hint: "M1" (+30)
- UC matched in registry (+10)

→ **Xác nhận tiến hành vẽ flow UC02 không?** (Yes/No)
```

### Mẫu 2: Gray Zone — Input bán mơ hồ

> Trigger: User nói "flow post bài"

```
🔍 **Discovery Report**

⚠️ **Tôi tìm thấy 2 Use Case phù hợp với "post bài":**

[1] **UC08 — Tạo bài viết** (M2, confidence: 85%)
    Spec: `m2-content-engine-spec.md`

[2] **UC09 — Chỉnh sửa/Xóa bài viết** (M2, confidence: 75%)
    Spec: `m2-content-engine-spec.md`

→ **Bạn muốn vẽ flow nào? Nhập 1 hoặc 2.**
```

### Mẫu 3: Rejection — Input quá mơ hồ

> Trigger: User nói "vẽ flow cho tính năng social"

```
⚠️ **Tôi chưa xác định được Use Case cụ thể.**

"Social" có thể liên quan đến nhiều module:

[1] M4: Like, Comment, Share, Follow (Engagement)
[2] M1: Profile công khai, kết nối người dùng
[3] M3: News Feed, Discovery

→ **Bạn đang nghĩ đến chức năng nào? Nhập số hoặc mô tả thêm.**
```

---

## 6. Worked End-to-End Example

### Input: "flow bookmark"

**Step 1 — DETECT (Keyword extraction)**

```
Input: "flow bookmark"
- "flow" → Action Verb borderline (cũng có thể là Domain Noun)
           → Xử lý như Action Verb (context = flow skill) +20pt
- "bookmark" → Domain Noun → match "bookmark, lưu bài, bỏ lưu" → M5
               → UC19 (Lưu/Bỏ lưu) AND UC20 (Quản lý collection)
               → +30pt (Domain Noun detected)
- Không có Module Hint explicit → +0pt
```

**Step 2 — DISCOVER (Tìm file)**

```
Dựa trên M5:
→ use-case-m5-bookmarking.md: UC19, UC20 ← found
→ m5-bookmarking-spec.md ← found

UC19 Score: +20pt (UC matched)
UC20 Score: +20pt (UC matched)
```

**Step 3 — SCORE**

```
UC19 Total: Action(20) + Domain(30) + Module(0) + UC(20) = 70pt
UC20 Total: Action(20) + Domain(30) + Module(0) + UC(20) = 70pt

Tie-break: UC19 vs UC20 score bằng nhau (chênh = 0pt ≤ 10pt)
→ DÙ score = 70pt (đủ confident threshold), tie → Đưa numbered options
```

**Step 4 — GATE 1 Output**

```
🔍 **Discovery Report**

⚠️ **Tôi tìm thấy 2 Use Case trong M5 — Bookmarking:**

[1] **UC19 — Lưu/Bỏ lưu bài viết** (confidence: 70%)
    Spec: `Docs/life-2/specs/m5-bookmarking-spec.md`
    Mô tả: Flow toggle bookmark (add/remove) cho một bài viết cụ thể.

[2] **UC20 — Quản lý collection bookmark** (confidence: 70%)
    Spec: `Docs/life-2/specs/m5-bookmarking-spec.md`
    Mô tả: Flow tạo/sửa/xóa collection, thêm bài vào collection.

→ **Bạn muốn vẽ flow cho UC nào? Nhập 1 hoặc 2.**
```

---

## 7. File Path Registry — Dùng để Discover

| UC | Use Case file | Spec file |
|----|--------------|-----------|
| UC01–UC07 | `Docs/life-2/diagrams/UseCase/use-case-m1-auth-profile.md` | `Docs/life-2/specs/m1-auth-profile-spec.md` |
| UC08–UC10 | `Docs/life-2/diagrams/UseCase/use-case-m2-content-engine.md` | `Docs/life-2/specs/m2-content-engine-spec.md` |
| UC11–UC13 | `Docs/life-2/diagrams/UseCase/use-case-m3-discovery-feed.md` | `Docs/life-2/specs/m3-discovery-feed-spec.md` |
| UC14–UC18 | `Docs/life-2/diagrams/UseCase/use-case-m4-engagement-connections.md` | `Docs/life-2/specs/m4-engagement-spec.md` |
| UC19–UC20 | `Docs/life-2/diagrams/UseCase/use-case-m5-bookmarking.md` | `Docs/life-2/specs/m5-bookmarking-spec.md` |
| UC21–UC24 | `Docs/life-2/diagrams/UseCase/use-case-m6-notifications-moderation.md` | `Docs/life-2/specs/m6-notifications-moderation-spec.md` |
