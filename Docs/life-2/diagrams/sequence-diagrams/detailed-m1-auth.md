# Sequence Diagram: M1 - Auth & Profile

> **Module:** Identity Foundation
> **Mục tiêu:** Mô tả chi tiết các kịch bản xác thực và quản lý định danh người dùng.

---

## 📋 1. Kịch bản: Đăng ký tài khoản (M1-A1)

```mermaid
sequenceDiagram
    actor User
    participant RegisterPage
    participant AuthService
    participant Mailer
    participant Payload
    participant DB

    User->>RegisterPage: Điền Form (Email, Password)
    RegisterPage->>AuthService: register(data)
    activate AuthService
    AuthService->>Payload: payload.find({ collection: 'users', email })
    Payload-->>AuthService: { docs: [] } (Check unique)
    
    alt Email đã tồn tại
        AuthService-->>RegisterPage: { error: 'Email already exists' }
        RegisterPage-->>User: Hiển thị lỗi trùng email
    else Email chưa tồn tại
        AuthService->>Payload: payload.create({ collection: 'users', data, status: 'pending' })
        activate Payload
        Payload->>DB: insertUser
        DB-->>Payload: userObj
        Payload-->>AuthService: userObj
        deactivate Payload
        
        AuthService->>Mailer: sendVerificationEmail(email, token)
        activate Mailer
        Mailer-->>AuthService: { success: true }
        deactivate Mailer
        
        AuthService-->>RegisterPage: { success: true }
        deactivate AuthService
        RegisterPage-->>User: Yêu cầu kiểm tra email
    end
```

---

## 🔐 2. Kịch bản: Đăng nhập nội bộ (M1-A2)

```mermaid
sequenceDiagram
    actor User
    participant LoginPage
    participant AuthService
    participant Payload
    participant DB

    User->>LoginPage: Nhập Email + Password
    LoginPage->>AuthService: login(email, password)
    activate AuthService
    
    AuthService->>Payload: payload.login({ collection: 'users', data })
    activate Payload
    Payload->>DB: find & verify hash
    
    alt Thông tin sai
        DB-->>Payload: null
        Payload-->>AuthService: AuthError
        AuthService-->>LoginPage: { success: false, message: 'Sai thông tin' }
        LoginPage-->>User: Hiển thị thông báo lỗi
    else Tài khoản chưa verify
        DB-->>Payload: user { verified: false }
        Payload-->>AuthService: AuthError
        AuthService-->>LoginPage: { success: false, code: 'UNVERIFIED' }
        LoginPage-->>User: Yêu cầu verify email trước
    else Thành công
        DB-->>Payload: userRecord
        Payload-->>AuthService: { user, token }
        deactivate Payload
        AuthService->>AuthService: setSessionCookie(token)
        AuthService-->>LoginPage: { success: true }
        LoginPage-->>User: Chuyển hướng tới Home
    end
    deactivate AuthService
```

---

## 📧 3. Kịch bản: Xác thực Email (M1-A3)

```mermaid
sequenceDiagram
    actor User
    participant Mail as Hộp thư cá nhân
    participant UI as VerifyPage (Next.js)
    participant AuthService
    participant Payload

    User->>Mail: Click link xác thực (token)
    Mail->>UI: Truy cập /verify-email?token=...
    UI->>AuthService: verifyToken(token)
    activate AuthService
    AuthService->>Payload: payload.update({ collection: 'users', where: { token }, data: { verified: true } })
    activate Payload
    
    alt Token hợp lệ
        Payload-->>AuthService: updatedUser
        AuthService-->>UI: { success: true }
        UI-->>User: Thông báo xác thực thành công, mời Login
    else Token hết hạn/sai
        Payload-->>AuthService: Error
        AuthService-->>UI: { success: false }
        deactivate Payload
        UI-->>User: Thông báo link không hợp lệ, mời gửi lại mail
    end
    deactivate AuthService
```

---

## 🛠️ 4. Kịch bản: Onboarding Setup (M1-A5)

```mermaid
sequenceDiagram
    actor User
    participant Page as OnboardingPage
    participant Service as ProfileService
    participant Payload

    User->>Page: Cập nhật Avatar, Bio, Interests
    Page->>Service: setupProfile(userId, profileData)
    activate Service
    
    alt Có tải ảnh Avatar
        Service->>Payload: payload.create({ collection: 'media', file })
        Payload-->>Service: { id: mediaId, url: '...' }
    end
    
    Service->>Payload: payload.update({ collection: 'users', id: userId, data: profileData })
    activate Payload
    Payload-->>Service: updatedUser
    deactivate Payload
    
    Service-->>Page: { success: true }
    deactivate Service
    Page-->>User: Chào mừng tới cộng đồng NeoSocial!
```

---
*Ghi chú từ Tít dễ thương: Luồng Auth này đảm bảo tính bảo mật cao và trải nghiệm người dùng mượt mà ngay từ bước đầu tiên.* 🥰
