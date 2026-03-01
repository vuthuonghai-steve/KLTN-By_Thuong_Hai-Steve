# M1-A2: Internal Login Protocol - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Quy trình xác thực thông tin đăng nhập, cấp phát JWT và quản lý phiên làm việc.
> **Kiến trúc:** B-U-E (Boundary-UseCase-Entity).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    %% Swimlanes
    subgraph User["👤 Người dùng (Member)"]
        A1["Nhập Email & Password"]
        A2["Nhấp nút Đăng nhập"]
        A10["Đã đăng nhập thành công"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Gửi Request POST /api/users/login"]
        B2{"Mã trả về (Status)?"}
        B3["Hiển thị lỗi: Sai thông tin / Tài khoản chưa kích hoạt"]
        B4["Lưu JWT vào LocalStorage / Cookie"]
        B5["Điều hướng vào Dashboard"]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Nhận yêu cầu Login"]
        C2["Tìm kiếm User theo Email"]
        C3{"User tồn tại?"}
        C4["Kiểm tra password (BCrypt compare)"]
        C5{"Kiểm tra _verified == true?"}
        C6["Tạo JWT access token"]
        C7["Ghi log đăng nhập (Thời gian, IP)"]
        C8["Trả về JWT + User Info"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1[(Collection: Users)]
    end

    %% Connections
    A1 --> A2
    A2 --> B1
    B1 --> C1
    
    C1 --> C2
    C2 <--> D1
    C2 --> C3
    
    C3 -- "Không" --> C8
    C3 -- "Có" --> C4
    
    C4 -- "Sai" --> C8
    C4 -- "Đúng" --> C5
    
    C5 -- "Chưa" --> C8
    C5 -- "Rồi" --> C6
    
    C6 --> C7
    C7 --> C8
    
    C8 --> B2
    
    B2 -- "401/403 (Lỗi)" --> B3
    B2 -- "200 (Thành công)" --> B4
    
    B3 --> A1
    B4 --> B5
    B5 --> A10

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style Boundary fill:#e8f4fd,stroke:#2196f3
    style UseCase fill:#f9f9f9,stroke:#333
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Bảo mật** | **UseCase** | Hệ thống sử dụng BCrypt để so sánh hash của Password, tuyệt đối không lưu password dạng text thô. |
| **Điều kiện** | **UseCase** | Ngay cả khi đúng password, nếu `_verified` là `false`, hệ thống sẽ từ chối truy cập (Gắn kết với M1-A3). |
| **Cấp quyền** | **UseCase** | JWT được sinh ra chứa thông tin `userId` và `role`, được ký bằng `PAYLOAD_SECRET`. |
| **Lưu trữ** | **Boundary** | Token được lưu tại Client để sử dụng cho các request tiếp theo (Header Authorization). |

---

## 3. Phản biện rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **LG-01** | **Brute Force** | Hacker thử mật khẩu liên tục. | Khóa tài khoản sau 5 lần nhập sai hoặc yêu cầu Captcha. |
| **LG-02** | **Token Theft** | JWT bị đánh cắp qua XSS. | Sử dụng `HttpOnly Cookie` để lưu Token thay vì LocalStorage. |
| **LG-03** | **Account Hijacking** | Đăng nhập trên thiết bị lạ. | Gửi email thông báo "Phát hiện đăng nhập lạ" (Module M6). |

---
*Tài liệu được thiết kế bởi **Tít dễ thương**.*
