# Flow Diagram — User Authentication (Đăng ký & Đăng nhập)

> **Module:** M1 — Authentication & Profile
> **Source:** feature-map-and-priority.md, requirements-srs.md
> **Format:** Mermaid Flowchart (3-Lane Swimlane)

---

## Flow 1: User Registration

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1["Nhập email, password, xác nhận password"]
    U2["Click nút Đăng ký"]
    U3["Nhập mã xác thực email (OTP)"]
    U4["Click xác nhận OTP"]
  end

  subgraph System ["⚙️ System"]
    direction TB
    S1["Validate input: email format, password strength, match"]
    S2{"Dữ liệu hợp lệ?"}
    S3["Hash password với bcrypt"]
    S4["Tạo user record trong Users collection"]
    S5["Gửi OTP qua email"]
    S6{"Email đã tồn tại?"}
    S7["Tạo verification token"]
    S8["Trả về error: Email exists"]
  end

  subgraph DB ["🗄️ Database"]
    direction TB
    D1["SELECT * FROM Users WHERE email = ?"]
    D2["INSERT INTO Users (email, password_hash, createdAt)"]
    D3["SELECT * FROM Users WHERE id = ?"]
  end

  U1 --> U2
  U2 --> S1
  S1 --> S2
  S2 -->|Yes| S3
  S2 -->|No| U1
  S3 --> S6
  S6 -->|No| D2
  S6 -->|Yes| S8
  S8 --> U1
  D2 --> D3
  D3 --> S5
  S5 --> U3
  U3 --> U4
```

---

## Flow 2: User Login

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1["Nhập email, password"]
    U2["Click nút Đăng nhập"]
    U3["Nhận access token + refresh token"]
    U4["Redirect to Dashboard"]
  end

  subgraph System ["⚙️ System"]
    direction TB
    S1["Validate input: email format, password not empty"]
    S2{"Dữ liệu hợp lệ?"}
    S3["Tìm user trong DB"]
    S4{"User tồn tại?"}
    S5["Compare password với bcrypt hash"]
    S6{"Password khớp?"}
    S7["Generate JWT access token + refresh token"]
    S8["Set HTTP-only cookies"]
    S9["Return tokens"]
    S10["Trả về error: Invalid credentials"]
  end

  subgraph DB ["🗄️ Database"]
    direction TB
    D1["SELECT * FROM Users WHERE email = ?"]
  end

  U1 --> U2
  U2 --> S1
  S1 --> S2
  S2 -->|Yes| S3
  S2 -->|No| U1
  S3 --> D1
  D1 --> S4
  S4 -->|Yes| S5
  S4 -->|No| S10
  S5 --> S6
  S6 -->|Yes| S7
  S6 -->|No| S10
  S7 --> S8
  S8 --> S9
  S9 --> U3
  U3 --> U4
```

---

## Flow 3: Password Reset

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1["Click Quên mật khẩu"]
    U2["Nhập email"]
    U3["Click Gửi link reset"]
    U4["Nhận email chứa link reset"]
    U5["Click link trong email"]
    U6["Nhập password mới + xác nhận"]
    U7["Click Đặt lại mật khẩu"]
  end

  subgraph System ["⚙️ System"]
    direction TB
    S1["Validate email format"]
    S2["Tìm user"]
    S3{"User tồn tại?"}
    S4["Generate reset token, lưu vào DB"]
    S5["Gửi email với reset link"]
    S6["Validate reset token"]
    S7{"Token hợp lệ?"}
    S8["Validate password mới"]
    S9{"Password hợp lệ?"}
    S10["Hash password mới"]
    S11["Update user record"]
    S12["Invalidate reset token"]
    S13["Thông báo thành công"]
    S14["Trả về error"]
  end

  subgraph DB ["🗄️ Database"]
    direction TB
    D1["SELECT * FROM Users WHERE email = ?"]
    D2["UPDATE Users SET password_reset_token = ?, reset_expires = ?"]
    D3["SELECT * FROM Users WHERE reset_token = ?"]
    D4["UPDATE Users SET password_hash = ?, reset_token = NULL"]
  end

  U1 --> U2
  U2 --> U3
  U3 --> S1
  S1 --> S2
  S2 --> D1
  D1 --> S3
  S3 -->|Yes| S4
  S3 -->|No| S14
  S4 --> D2
  D2 --> S5
  S5 --> U4
  U4 --> U5
  U5 --> S6
  S6 --> D3
  D3 --> S7
  S7 -->|Yes| S8
  S7 -->|No| S14
  S8 --> S9
  S9 -->|Yes| S10
  S9 -->|No| U6
  S10 --> D4
  D4 --> S12
  S12 --> S13
```

---

## Flow 4: Token Refresh

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1["Gọi API với expired access token"]
    U2["Nhận 401 Unauthorized"]
    U3["Gọi /api/auth/refresh với refresh token"]
    U4["Nhận access token mới"]
    U5["Retry API call ban đầu"]
  end

  subgraph System ["⚙️ System"]
    direction TB
    S1["Validate JWT access token"]
    S2{"Token expired?"}
    S3["Validate refresh token"]
    S4{"Refresh token hợp lệ?"}
    S5["Generate access token mới"]
    S6["Return access token mới"]
    S7["Return 401 + refresh_required"]
  end

  U1 --> S1
  S1 --> S2
  S2 -->|Yes| S3
  S2 -->|No| S7
  S3 --> S4
  S4 -->|Yes| S5
  S4 -->|No| S7
  S5 --> S6
  S6 --> U4
  U4 --> U5
```

---

## Assumptions

| # | Assumption | Source |
|---|------------|--------|
| 1 | Password hash dùng bcrypt với cost factor 12 | industry standard |
| 2 | JWT access token expires trong 15 phút | security best practice |
| 3 | Refresh token expires trong 7 ngày | common practice |
| 4 | OTP verification dùng 6-digit code, expires trong 5 phút | common 2FA pattern |
| 5 | Reset token là UUID v4, expires trong 1 giờ | common reset flow |

---

## UC-IDs Referenced

| UC-ID | Use Case |
|-------|----------|
| UC-101 | User Registration |
| UC-102 | User Login |
| UC-103 | Password Reset |
| UC-104 | Token Refresh |

---

*Generated: 2026-03-01*
