# UI Screen Specification: M1 - Authentication & Profile

> **Mục đích:** Đặc tả thành phần UI và logic tương tác cho hệ thống định danh và hồ sơ người dùng.  
> **Traceability:** [Use Case M1], [detailed-m1-auth.md], [m1-auth-schema.yaml]

---

## 1. Screen Inventory (Danh sách màn hình)

| Screen ID | Tên màn hình | Mục tiêu | Actor |
|---|---|---|---|
| SC-M1-01 | Đăng ký (Register) | Tạo tài khoản mới | Guest |
| SC-M1-02 | Đăng nhập (Login) | Truy cập hệ thống | Guest |
| SC-M1-03 | Xác thực Email | Kích hoạt tài khoản | Guest |
| SC-M1-04 | Onboarding (Setup) | Cập nhật thông tin ban đầu | User (Pending) |
| SC-M1-05 | Trang cá nhân (Profile) | Xem thông tin User | Anyone |
| SC-M1-06 | Chỉnh sửa hồ sơ | Cập nhật Avatar, Bio, v.v. | Owner |

---

## 2. Detailed Screen Logic (Chi tiết từng màn hình)

### SC-M1-01 - Registration Screen

#### A. UI Components & Data Mapping
Dựa trên **Class Diagram**: `users` collection

| UI Element ID | Type | Source Field (Class) | Required | Validation/Constraint |
|---|---|---|---|---|
| `input-email` | <Input type="email"> | `users.email` | Yes | Format email chuẩn |
| `input-username` | <Input type="text"> | `users.username` | Yes | Min 3, Regex `^[a-zA-Z0-9_]+$` |
| `input-password` | <Input type="text"> | `users.passwordHash` | Yes | Min 8 characters |
| `input-confirm-pw` | Password | N/A | Yes | Phải khớp `input-password` |
| `btn-register` | Button | N/A | N/A | Trigger Flow M1-A1 |

#### B. Interaction Flow (M1-A1)
- **Pre-condition**: Chế độ "Allow Registration" đang bật.
- **Main Action**: User nhấn Đăng ký -> Hệ thống check unique Email/Username -> Tạo User trạng thái `verified: false`.
- **Post-condition**: Hiển thị thông báo yêu cầu check email.

---

### SC-M1-02 - Login Screen

#### A. UI Components & Data Mapping
| UI Element ID | Type | Source Field (Class) | Required | Validation/Constraint |
|---|---|---|---|---|
| `input-login-id` | <Input type="text"> | `users.email` | Yes |  |
| `input-login-pw` | <Input type="text"> | `users.passwordHash` | Yes |  |
| `btn-login` | Button | N/A | N/A | Trigger Flow M1-A2 |
| `link-forgot-pw` | Link | N/A | N/A | Redirect to SC-M1-03 extension |

#### B. Interaction Flow (M1-A2)
- **Error States**: 
  - Sai thông tin: Hiển thị lỗi "Sai email hoặc mật khẩu".
  - Chưa verify: Hiển thị banner "Vui lòng xác thực email".

---

### SC-M1-04 - Onboarding (Setup)

#### A. UI Components & Data Mapping
| UI Element ID | Type | Source Field (Class) | Required | Validation/Constraint |
|---|---|---|---|---|
| `upload-avatar` | ImageUpload | `users.avatar` | No | Image only, max 2MB |
| `textarea-bio` | <Textarea> | `users.bio` | No | Max 160 characters |
| `input-display-name` | <Input type="text"> | `users.displayName` | Yes |  |
| `btn-submit-setup` | Button | N/A | N/A | Trigger Flow M1-A5 |

---

## 3. Mapping ID for Automation (UI Contract)

| UI ID | Semantic Name | Technical Binding |
|---|---|---|
| `sc-m1-01` | Registration Form | `data-testid="sc-m1-01"` |
| `sc-m1-02` | Login Form | `data-testid="sc-m1-02"` |
| `input-email` | Email Field | `id="user-email"` |
| `btn-login` | Login Action | `role="button", data-action="login"` |
