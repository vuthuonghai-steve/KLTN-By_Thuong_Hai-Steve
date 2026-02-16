# M1-A1: User Registration Flow (Email) - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng đăng ký tài khoản qua Email, đảm bảo an toàn dữ liệu và trải nghiệm người dùng.
> **Mức độ:** Cấp độ 2 (Chi tiết)

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    %% Swimlanes Definition
    subgraph User["👤 Người dùng (Guest)"]
        A1["Nhập thông tin đăng ký"]
        A2["Nhấp nút Đăng ký"]
        A11["Nhận thông báo: Kiểm tra Email"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Client-side Validation:<br/>Email format, Strength pass"]
        B2{Hợp lệ?}
        B3["Hiển thị lỗi Validation"]
        B9["Gửi Request POST /api/users"]
        B12["Điều hướng sang trang Chờ xác nhận"]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Nhận yêu cầu đăng ký"]
        C2["Sanitize Input"]
        C3{"Email đã tồn tại?"}
        C4["Tạo tài khoản mới<br/>_verified: false"]
        C5["Tạo Activation Token<br/>(Hạn 24h)"]
        C6["Xây dựng thư xác thực"]
        C10["Trả về Success Response"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1["(Collection: Users)"]
    end

    subgraph External["📧 Dịch vụ ngoài (Mailer)"]
        E1["Gửi Email kèm Link xác thực"]
    end

    %% Connections
    A1 --> A2
    A2 --> B1
    B1 --> B2
    B2 -- "Không" --> B3
    B3 --> A1
    B2 -- "Có" --> B9
    
    B9 --> C1
    C1 --> C2
    C2 --> C3
    
    C3 -- "Có" --> C10
    C3 -- "Không" --> C4
    
    C4 <--> D1
    C4 --> C5
    C5 --> C6
    C6 --> E1
    E1 -.-> A11
    
    C6 --> C10
    C10 --> B12
    B12 --> A11

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style Boundary fill:#e8f4fd,stroke:#2196f3
    style UseCase fill:#f9f9f9,stroke:#333
    style External fill:#fffde7,stroke:#fbc02d
```

---

## 2. Chú giải luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **1** | **User** | Người dùng nhập: `Email`, `Password`, `Confirm Password`. |
| **2** | **Boundary** | Kiểm tra logic cơ bản (Mật khẩu đủ mạnh, Email đúng định dạng) để giảm tải cho server. |
| **3** | **UseCase** | Nhận dữ liệu. Nếu Email đã tồn tại, hệ thống vẫn trả về "Thành công" để tránh **User Enumeration Attack** (Tấn công dò tìm email). |
| **4** | **Entity** | Lưu bản ghi User mới với cờ `_verified = false`. |
| **5** | **External** | SMTP Mailer đẩy thư chứa `activationToken` tới inbox của của người dùng. |

---

## 3. Phân tích rủi ro & Phản biện (Risk Audit)

| ID | Loại rủi ro | Mô tả | Giải pháp đề xuất |
|:---:|---|---|---|
| **SM-01** | **Spam Registration** | Bot đăng ký hàng loạt gây tràn Database. | Áp dụng Rate Limiting trên IP và yêu cầu xác thực Email trước khi cho phép hoạt động. |
| **SM-02** | **Data Leak** | Trả về lỗi "Email đã tồn tại" giúp hacker biết email nào đã đăng ký. | Luôn trả về thông báo chung: "Nếu email hợp lệ, chúng tôi đã gửi thư xác thực". |
| **SM-03** | **Mail Failure** | Email không đến được người dùng (vào Spam hoặc lỗi SMTP). | Cho phép người dùng nhấn "Gửi lại email xác thực" sau mỗi 60 giây. |

---

## 4. Quy tắc Clean Architecture (B-U-E) áp dụng

- **Boundary**: Không chứa logic tạo Token hay Encode mật khẩu. Chỉ làm nhiệm vụ hiển thị và gửi Data.
- **UseCase**: Là nơi duy nhất biết cách xây dựng một "Activation Link" và phối hợp giữa DB và Mailer.
- **Entity**: Đảm bảo cấu trúc dữ liệu `users` luôn nhất quán, không quan tâm đến việc email được gửi bằng công cụ gì.

---
*Tài liệu được tạo bởi **Tít dễ thương** - Senior System Architect.*
