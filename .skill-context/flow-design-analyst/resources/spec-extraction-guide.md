# Spec Extraction Guide — Trích Xuất Thông Tin Từ Tài Liệu Dự Án

> **Source**: fsu.edu, logrocket.com, neu.edu — Use Case Specification standards. Adapted for KLTN project.
> **Purpose**: Cung cấp framework để Builder viết `knowledge/spec-extraction-guide.md`

---

## 1. 6 Yếu Tố Use Case Specification Chuẩn

Mọi flow diagram cần trích xuất đủ 6 yếu tố sau từ tài liệu dự án:

| # | Yếu tố | Định nghĩa | Tìm ở đâu |
|---|--------|-----------|-----------|
| 1 | **Trigger** | Sự kiện kích hoạt flow — phải đứng TRƯỚC step 1 | Đầu Use Case, sau "Trigger:" hoặc suy từ tên UC |
| 2 | **Actors** | Primary Actor (khởi phát) + Secondary Actors (tương tác) | Cột "UC" trong Use Case Diagram |
| 3 | **Preconditions** | Điều kiện PHẢI đúng trước khi flow bắt đầu | Phần "Preconditions" — nếu không có, suy luận từ context |
| 4 | **Steps** | Numbered list các bước tuần tự Actor↔System | Phần "Basic Flow" / "Main Scenario" |
| 5 | **Conditions** | Điều kiện rẽ nhánh trong narrative | Câu chứa: "if", "when", "unless", "except", "provided that" |
| 6 | **Outcomes** | State của hệ thống sau khi flow hoàn thành | Phần "Postconditions" / "Success Criteria" |

---

## 2. Cách Đọc Spec File (`life-2/specs/{module}-spec.md`)

Các spec file KLTN nằm tại: `Docs/life-2/specs/`
- `m1-auth-profile-spec.md`
- `m2-content-engine-spec.md`
- `m3-discovery-feed-spec.md`
- `m4-engagement-spec.md`
- `m5-bookmarking-spec.md`
- `m6-notifications-moderation-spec.md`

### 2.1 Vị trí tìm từng yếu tố

```
File: m1-auth-profile-spec.md
├── "## 1. Overview"          → Trigger (suy luận từ mô tả), Actors
├── "## 2. Data Models"       → Preconditions (fields required), DB structure
├── "## 3. API Endpoints"     → Steps (HTTP method + path = action trong System Lane)
├── "## 4. UI Requirements"   → User Lane steps (Screens = các bước user thấy)
├── "## 5. Validation Rules"  → Conditions (validation fail cases)
└── "## 6. Logic Đặc biệt"   → Alternative Path (auto-slug, special behaviors)
```

### 2.2 Pattern nhận biết từng yếu tố trong spec

**Trigger:**
- Thường không explicit trong spec KLTN — suy luận từ tên UC:
  - UC01 "Đăng ký" → Trigger: "User truy cập trang Register và Submit form"
  - UC19 "Lưu bài viết" → Trigger: "User nhấn nút Bookmark trên bài viết"

**Steps:**
- Numbered list trong spec
- Pattern: `Actor + verb + object`
  - "User điền email" → User Lane action
  - "System validate" → System Lane action
  - "Hệ thống lưu vào DB" → DB Lane action

**Conditions (từ khóa rẽ nhánh):**
```
"if / nếu / khi"         → Decision diamond {}
"when / khi"             → Decision diamond {}
"unless / ngoại trừ"     → Exception branch
"except / ngoại lệ"      → Exception branch
"provided that / với điều kiện" → Precondition check
"otherwise / otherwise"  → Alternative branch
"already exists / đã tồn tại"  → 409 Conflict → Exception path
"not found / không tìm thấy"   → 404 → Exception path
"invalid / không hợp lệ"       → 400 → Exception path
```

**Outcomes:**
- "Postconditions:" section
- "Success Criteria:" section
- Nếu không có → suy từ kết quả cuối cùng của flow:
  - UC01: "User record đã được tạo trong DB, email xác nhận đã gửi"

---

## 3. Cách Đọc Use Case Files (`life-2/diagrams/UseCase/`)

Các Use Case files chứa UC-ID chính thức:

```
use-case-m1-auth-profile.md    → UC01–UC07
use-case-m2-content-engine.md  → UC08–UC10
use-case-m3-discovery-feed.md  → UC11–UC13
use-case-m4-engagement-connections.md  → UC14–UC18
use-case-m5-bookmarking.md     → UC19–UC20
use-case-m6-notifications-moderation.md → UC21–UC24
```

**Cách đọc Traceability Table:**

```markdown
| UC   | Use Case                | Module | FR   |
|------|-------------------------|--------|------|
| UC01 | Đăng ký tài khoản       | M1.1   | FR-1 |
```

→ Format UC-ID: `UC[số]` (UC01, UC02, ..., UC24)

---

## 4. Cách Đọc User Story (`life-1/user-stories.md`)

### 4.1 Format chuẩn

```
As a [actor], I want [action], so that [outcome].
```

### 4.2 Mapping sang 6 yếu tố

| User Story part | Yếu tố |
|----------------|--------|
| `[actor]` | **Actors** — Primary Actor |
| `I want [action]` | **Trigger** + **Steps** đầu tiên |
| `so that [outcome]` | **Outcomes** (Postconditions) |
| Acceptance Criteria dòng 1+ | **Conditions** + **Steps** chi tiết |

**Ví dụ mapping:**

```
User Story: "As a Member, I want to bookmark a post, so that I can read it later."
  → Actors:   Member (Primary)
  → Trigger:  "Member muốn lưu một bài viết"
  → Outcomes: "Bài viết được lưu, có thể xem lại trong trang Bookmarks"

Acceptance Criteria:
  - "Given user is logged in, when they click Bookmark icon, then icon changes state"
  → Precondition: User đã đăng nhập (JWT hợp lệ)
  → Step: User nhấn Bookmark icon
  → Outcome: Icon đổi trạng thái

  - "Given bookmark already exists, when user clicks again, then Remove bookmark"
  → Condition: "Đã bookmark?" → Decision diamond
  → Alternative Path: Remove instead of Add
```

---

## 5. Worked Example — UC01: Đăng ký tài khoản (M1)

### 5.1 Input tài liệu

**Từ `use-case-m1-auth-profile.md`:**
```
| UC01 | Đăng ký tài khoản | M1.1 | FR-1 |
Actors: Guest (Primary)
```

**Từ `m1-auth-profile-spec.md`:**
```
## 1. Overview
"Cung cấp khả năng đăng nhập, đăng ký và quản lý thông tin cá nhân."

## 2. Data Models
Collection: users
Fields: email (required), username (unique, required), roles (default: user)

## 4. UI Requirements
Screens:
- RegisterScreen: Username, Email, Password, Confirm Password.

## 5. Validation Rules (Zod)
- username: min 3, max 20, regex: ^[a-zA-Z0-9_]+$
- bio: max 160 characters

## 6. Logic Đặc biệt
- Auto-slug: Tự động tạo username từ email nếu User không nhập.
```

### 5.2 Trích xuất 6 yếu tố

| Yếu tố | Nội dung trích xuất | Nguồn |
|--------|---------------------|-------|
| **Trigger** | "Guest truy cập trang Register và Submit form đăng ký" | Suy từ UC01 name + RegisterScreen |
| **Actors** | Primary: Guest; Secondary: Email Service (SendGrid) | use-case-m1 Traceability |
| **Preconditions** | "User chưa có tài khoản. Email chưa tồn tại trong DB." | Suy từ "email (required, unique)" |
| **Steps** | 1. Guest nhập Username, Email, Password, Confirm Password → 2. Submit form → 3. System validate schema → 4. System kiểm tra email tồn tại → 5. System hash password → 6. DB insert user record → 7. System gửi email xác nhận | UI screens + Validation rules + API endpoint |
| **Conditions** | IF email đã tồn tại → 409 Conflict. IF validation fail → 400 Bad Request. IF username empty → auto-generate từ email (Alt Path) | Spec §5, §6 |
| **Outcomes** | Success: "User record tạo mới trong DB. Email xác nhận gửi. User redirect về trang Login." | Suy từ flow hoàn thành |

### 5.3 Map ra Mermaid Nodes

```
Trigger → U1["Truy cập trang Register"]
Step 1  → U2["Nhập Username, Email, Password"]
Step 2  → U3["Submit form"]
Step 3  → S1["Validate schema (Zod)"]
Condition 1 → S2{"Validation OK?"}
  → Exception: S3["Trả 400 Bad Request"] → U_err["Hiển thị lỗi validation"]
Step 4  → S4{"Email đã tồn tại?"] + D1[("Query users")]
  → Exception: S5["Trả 409 Conflict"] → U_dup["Hiển thị: Email đã dùng"]
Step 5  → S6["Hash password (bcrypt)"]
Step 6  → D2[("INSERT user record")]
Condition 2 (Alt Path) → S7["Auto-generate username từ email"]
Step 7  → S8["Gọi SendGrid: Gửi email xác nhận"]
Outcome → U4["✅ Redirect về trang Login + Thông báo thành công"]
```

---

## 6. Fallback Khi Spec Thiếu Thông Tin

Khi không tìm đủ 6 yếu tố trong tài liệu:

| Yếu tố thiếu | Fallback hành động |
|-------------|-------------------|
| **Trigger** | Suy từ tên UC: UC[verb] → "User [verb] tài nguyên" |
| **Preconditions** | Check dependencies crossmodule trong Use Case file |
| **Steps** | Suy từ API endpoints (`## 3. API Endpoints` trong spec) |
| **Conditions** | Suy từ Validation Rules (`## 5.`) và Logic Đặc biệt (`## 6.`) |
| **Outcomes** | Suy từ HTTP response codes (201, 200, 400, 409, ...) |
| **Bất kỳ yếu tố nào** | Ghi vào `## Assumptions` ở cuối flow file để transparent |

### Mẫu Assumptions section:

```markdown
## ⚠️ Assumptions (Thông tin suy luận)

> Các phần sau CHƯA có trong spec, được suy luận từ context:

- **Trigger**: Chưa explicit trong spec. Suy luận: "Member nhấn button 'Bookmark' trên PostCard component."
- **Preconditions**: Spec không đề cập. Giả định: "Member đã đăng nhập (JWT hợp lệ)."
- **Outcomes (Error)**: Suy từ HTTP 409 response code.

> Cần Steve review và xác nhận trước khi finalize diagram.
```
