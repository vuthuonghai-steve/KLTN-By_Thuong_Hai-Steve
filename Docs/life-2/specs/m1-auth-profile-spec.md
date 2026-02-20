# Specification: Module M1 - Authentication & Profile

> **Mục đích:** Đặc tả chi tiết để AI Agent thực hiện code cho module Auth & Profile.  
> **Trạng thái:** Draft | **Version:** 1.0.0

---

## 1. Overview
Cung cấp khả năng đăng nhập, đăng ký và quản lý thông tin cá nhân. Hỗ trợ Email/Password truyền thống (Tính năng Google OAuth tạm thời bị 🔒 khóa).

## 2. Data Models (PayloadCMS)

### Collection: `users`
- **Fields**:
  - `email`: string (required)
  - `username`: string (unique, required)
  - `roles`: select (admin, user) - default: user
  - `profile`: group {
      display_name, avatar (upload), bio, social_links (array)
    }
- **Access Control**:
  - Read: Anyone (Public profile)
  - Update: Owner only

## 3. API Endpoints (Centralized)
Dựa trên `ENDPOINTS` config:
- `AUTH.LOGIN`: `/api/users/login` (Payload default)
- `AUTH.REGISTER`: `/api/users/register` (Custom handler to auto-create profile)
- `PROFILE.UPDATE`: `/api/users/:id`

## 4. UI Requirements (Pink Petals Design System)
*   **Colors**: Primary (Pink-500), Secondary (Orange-500).
*   **Components**: Radix UI based.
*   **Screens**:
    - `LoginScreen`: Form với email/password (Nút "Sign in with Google" đã bị ẩn vì đang 🔒 khóa).
    - `RegisterScreen`: Username, Email, Password, Confirm Password.
    - `ProfileScreen`: View profile info + "Edit Profile" button.
    - `EditProfileScreen`: Form cập nhật Avatar, Bio, Social Links.

## 5. Validation Rules (Zod)
- `username`: min 3, max 20, regex: `^[a-zA-Z0-9_]+$`.
- `bio`: max 160 characters.
- `social_links`: valid URLs only.

## 6. Logic Đặc biệt
- **Auto-slug**: Tự động tạo `username` từ email nếu User không nhập.
- **Security**: Bypass `password` field trong mọi query Read trừ lúc Auth.
