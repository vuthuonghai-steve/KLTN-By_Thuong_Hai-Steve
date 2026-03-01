# M1-A4: Password Recovery Cycle - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Quy trình lấy lại quyền truy cập khi người dùng quên mật khẩu thông qua Mailer.
> **Kiến trúc:** B-U-E (Boundary-UseCase-Entity).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    %% Swimlanes
    subgraph User["👤 Người dùng (Member)"]
        A1["Nhấp 'Quên mật khẩu'"]
        A2["Nhập Email và gửi"]
        A3["Mở Email, click link Reset"]
        A4["Nhập mật khẩu mới"]
        A10["Nhận thông báo: Thành công"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Gửi Request /api/users/forgot-password"]
        B2["Hiển thị: Đã gửi thư (nếu email đúng)"]
        B3["Verify Token qua URL và hiện form đổi pass"]
        B4["Gửi Request /api/users/reset-password"]
        B5["Chuyển hướng về trang Login"]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Nhận yêu cầu Forgot Pass"]
        C2{"Kiểm tra Email tồn tại?"}
        C3["Tạo Reset Token (Ngắn hạn - 1h)"]
        C4["Gửi Email Reset qua Mailer"]
        C5{"Verify Token (Khớp + Còn hạn?)"}
        C6["Hash mật khẩu mới và cập nhật DB"]
        C7["Hủy Token reset ngay lập tức"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1[(Collection: Users)]
    end

    subgraph External["📧 Dịch vụ ngoài (Mailer)"]
        E1["Thư chứa link mã hóa Reset"]
    end

    %% Connections
    A1 --> A2
    A2 --> B1
    B1 --> C1
    C1 --> C2
    C2 -- "Không" --> B2
    C2 -- "Có" --> C3
    C3 --> C4
    C4 --> E1
    E1 -.-> A3
    A3 --> B3
    B3 --> C5
    C5 -- "Hợp lệ" --> A4
    A4 --> B4
    B4 --> C6
    C6 <--> D1
    C6 --> C7
    C7 --> B5
    B5 --> A10

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style Boundary fill:#e8f4fd,stroke:#2196f3
    style UseCase fill:#f9f9f9,stroke:#333
    style External fill:#fffde7,stroke:#fbc02d
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Yêu cầu** | **User/Boundary** | Chỉ yêu cầu nhập Email. Hệ thống không báo lỗi nếu email chưa tồn tại để bảo mật. |
| **Dịch vụ** | **External** | Email gửi đi phải là dạng HTML chuyên nghiệp và có link rõ ràng. |
| **Xác thực** | **UseCase** | Reset Token có thời hạn rất ngắn (ví dụ: 1 giờ) để giảm cửa sổ rủi ro. |
| **An toàn** | **UseCase** | Sau khi đổi pass thành công, Token phải bị hủy bỏ ngay lập tức để không thể dùng link đó lần thứ 2. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **RC-01** | **Spam Reset Request** | Kẻ xấu gửi yêu cầu reset hàng loạt vào 1 email của nạn nhân. | Áp dụng "Wait-time" (ví dụ: chỉ được gửi lại sau 5 phút). |
| **RC-02** | **Session Interception** | Link reset bị kẹt lại trong lịch sử trình duyệt hoặc cache. | Token được hủy ngay sau khi dùng. |
| **RC-03** | **Mail Hijacking** | Người dùng bị hack email. | Khuyến khích bật 2FA (giai đoạn sau của dự án). |

---
*Tài liệu được thiết kế bởi **Tít dễ thương**.*
