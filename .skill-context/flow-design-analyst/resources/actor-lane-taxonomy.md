# Actor Lane Taxonomy — 3-Lane Swimlane Rules

> **Source**: Verified từ lucidchart.com, geeksforgeeks.org, wikipedia.org; adapted cho kiến trúc KLTN
> **Purpose**: Cung cấp domain knowledge để Builder viết `knowledge/actor-lane-taxonomy.md`
> **Lưu ý**: "3-Lane (User/System/DB)" là convention của 3-tier architecture flow, KHÔNG phải chuẩn BPMN chính thức. Cần ghi rõ điều này trong knowledge file.

---

## 1. Định nghĩa 3 Lanes

### 1.1 User Lane — "Người dùng làm gì?"

**Phạm vi**: Mọi hành động được thực hiện **trực tiếp bởi con người** thông qua giao diện UI.

**Includes:**
- Click button, nhấn link, chọn menu
- Nhập data vào form (input, select, textarea)
- Submit form, upload file
- Điều hướng (navigate to page)
- Nhận và đọc thông tin hiển thị trên UI
- Kéo thả, zoom, scroll (gesture)

**KLTN context — Next.js/React:**
- Mọi event handler trên component (onClick, onSubmit, onChange)
- Navigation (`router.push()` triggered by user)
- File selection (`<input type="file">`)

**Ký hiệu node:** `U_[stt]` — ví dụ `U1`, `U2`, `U3`

---

### 1.2 System Lane — "Phần mềm xử lý gì?"

**Phạm vi**: Mọi **logic tự động** được thực thi bởi backend application — business logic, validation, service calls.

**Includes:**
- API endpoint handler (nhận request, parse body)
- Validation logic (Zod schema, business rules)
- Authentication/Authorization (verify JWT, check permission)
- Business logic (tính toán, transformation)
- Gọi external service (SendGrid email, Firebase, S3 upload)
- Gọi third-party API (OAuth provider, payment gateway)
- Decision node (if/else logic trong code)
- Response building và error handling

**KHÔNG includes:** Direct DB queries (thuộc DB Lane)

**KLTN context — Express/NestJS backend:**
- Route handlers (`router.post('/register', handler)`)
- Middleware (auth middleware, validation middleware)
- Service layer (`userService.createUser()`)
- External calls (`sendgridClient.send()`, `googleOAuth.verify()`)

**Ký hiệu node:** `S_[stt]` — ví dụ `S1`, `S2`, `S3`

---

### 1.3 DB Lane — "Database thao tác gì?"

**Phạm vi**: Mọi thao tác **đọc/ghi trực tiếp lên database** — persistence layer operations.

**Includes:**
- INSERT / CREATE record
- SELECT / FIND / QUERY record
- UPDATE record
- DELETE record
- Index scan, aggregation pipeline
- Transaction begin/commit/rollback

**KHÔNG includes:** External API calls (thuộc System Lane), Redis cache (xem edge case)

**KLTN context — MongoDB (PayloadCMS):**
- `payload.find({ collection: 'users', where: ... })`
- `payload.create({ collection: 'bookmarks', data: ... })`
- `payload.update({ collection: 'posts', id: ..., data: ... })`
- `payload.delete({ collection: 'bookmarks', id: ... })`

**Ký hiệu node:** `D_[stt]` — ví dụ `D1`, `D2`, `D3`. Dùng Cylinder shape: `D1[("Text")]`

---

## 2. KLTN Context Mapping — Mapping kiến trúc dự án

| Tầng kỹ thuật | Lane | Ví dụ cụ thể trong KLTN |
|---------------|------|--------------------------|
| React/Next.js UI components | **User Lane** | `<LoginForm onSubmit={...}>`, `<button onClick={...}>` |
| Next.js Router navigation | **User Lane** | `router.push('/dashboard')` do user click |
| Next.js API Routes (`/api/...`) | **System Lane** | `app/api/users/login/route.ts` |
| PayloadCMS local API calls | **DB Lane** | `payload.find({ collection: 'users' })` |
| Express middleware | **System Lane** | `authMiddleware`, `validationMiddleware` |
| SendGrid / Email service | **System Lane** | `sendgridClient.send(emailData)` |
| Google OAuth | **System Lane** | `googleOAuth.verifyToken(token)` |
| MongoDB queries | **DB Lane** | `db.collection('posts').find({...})` |

---

## 3. Decision Table — Action → Lane (25+ ví dụ KLTN)

| # | Action | Lane | Lý do |
|---|--------|------|-------|
| 1 | User nhấn nút "Đăng ký" | **User** | Human interaction với UI |
| 2 | User điền email và password | **User** | Human input |
| 3 | User nhấn "Submit" form | **User** | Human action trigger |
| 4 | Validate email format (Zod) | **System** | Business logic trong backend |
| 5 | Check email đã tồn tại (logic) | **System** | Business rule decision |
| 6 | Query users collection để tìm email | **DB** | Database read operation |
| 7 | Hash password (bcrypt) | **System** | Transformation trong service |
| 8 | INSERT user record mới | **DB** | Database write operation |
| 9 | Gửi email xác nhận (SendGrid) | **System** | External service call |
| 10 | Verify JWT token | **System** | Auth middleware — business logic |
| 11 | Trả response 201/400/409 | **System** | HTTP response building |
| 12 | Hiển thị thông báo lỗi cho user | **User** | UI feedback (user nhận thấy) |
| 13 | User nhấn "Like" bài viết | **User** | Human interaction |
| 14 | Kiểm tra user chưa like bài đó | **System** | Business rule check |
| 15 | Query likes collection | **DB** | Database read |
| 16 | INSERT like record | **DB** | Database write |
| 17 | UPDATE like counter trên post | **DB** | Database write |
| 18 | Trigger gửi notification (logic) | **System** | Business event dispatch |
| 19 | User điền query tìm kiếm | **User** | Input hành động |
| 20 | Regex search / text indexing | **DB** | Database query operation |
| 21 | Render kết quả search | **User** | Display (user nhận thông tin) |
| 22 | Gọi Google OAuth để verify | **System** | External API call |
| 23 | Redirect user về trang login | **User** | UI navigation do system trigger |
| 24 | Refresh JWT token (auto) | **System** | System-triggered background task |
| 25 | DELETE bookmark record | **DB** | Database delete operation |
| 26 | Đọc danh sách posts (feed) | **DB** | Database read — aggregate |
| 27 | Xử lý pagination logic | **System** | Business logic: tính offset/limit |

---

## 4. Edge Cases — Tình huống hay nhầm lẫn

| Action | ❌ Hay nhầm sang | ✅ Đúng | Giải thích |
|--------|-----------------|---------|------------|
| Gọi SendGrid API | DB Lane | **System Lane** | External service call, không phải persistence |
| Gọi Google OAuth | DB Lane | **System Lane** | Third-party API, không phải local DB |
| Verify JWT | DB Lane | **System Lane** | Middleware logic, không query DB (nếu stateless JWT) |
| Redis cache read | DB Lane | **System Lane** | Convention: cache = System, chỉ persistent DB = DB Lane. Có thể tách "Cache Lane" nếu cần |
| S3 file upload | DB Lane | **System Lane** | Object storage = external service, không phải relational/document DB |
| Hiển thị error message | System Lane | **User Lane** | User "nhìn thấy" = User Lane — System chỉ "gửi" response |
| router.push() (programmatic) | System Lane | **User Lane** | Nếu triggered by user action → User Lane. Nếu auto-redirect by system → System Lane |

---

## 5. Ví dụ Đúng/Sai — 3 Cặp

### Cặp 1: Validate email

```
❌ SAI: Đặt "Validate email format" trong User Lane
  → Vì user không validate — user chỉ "nhập" email. Backend validate.

✅ ĐÚNG: User Lane: "Nhập email"
           System Lane: "Validate email format (Zod)"
```

### Cặp 2: Gửi email xác nhận

```
❌ SAI: Đặt "Gửi email xác nhận" trong DB Lane
  → Gọi SendGrid là external service call, KHÔNG phải DB operation.

✅ ĐÚNG: System Lane: "Gọi SendGrid API để gửi email"
           (DB Lane chỉ có: "Lưu sent_at timestamp vào DB" nếu cần track)
```

### Cặp 3: Nhận thông báo

```
❌ SAI: Đặt "Nhận notification realtime" trong System Lane
  → User là người nhận và đọc thông báo trên UI.

✅ ĐÚNG: System Lane: "Dispatch notification event (WebSocket)"
           User Lane: "Nhận và đọc thông báo trên UI"
```

---

## 6. Quick Reference — Card nhận biết lane

```
User Lane:        CON NGƯỜI + GIAO DIỆN
  → Click, Input, Submit, View, Navigate, Upload, Read result on UI

System Lane:      PHẦN MỀM + LOGIC + EXTERNAL SERVICES  
  → Validate, Authenticate, Process, Transform, Call API, Decide, Respond

DB Lane:          PERSISTENCE + DATABASE ONLY
  → INSERT, SELECT, UPDATE, DELETE, QUERY trực tiếp lên MongoDB/SQL
```
