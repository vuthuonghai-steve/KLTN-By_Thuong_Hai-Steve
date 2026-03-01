# M1-A3: Email Verification Handshake - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả quy trình kích hoạt tài khoản khi người dùng click vào link chuyển tới từ Email.
> **Kiến trúc:** B-U-E (Boundary-UseCase-Entity).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    %% Swimlanes
    subgraph User["👤 Người dùng (Member)"]
        A1["Mở Email xác thực"]
        A2["Nhấp vào Link kích hoạt"]
        A10["Nhận thông báo: Thành công / Thất bại"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Nhận yêu cầu qua URL<br/>/verify?token=..."]
        B2["Hiển thị trạng thái Loading"]
        B3["Cập nhật UI: Chúc mừng thành viên mới"]
        B4["Hiển thị lỗi: Link hết hạn / Không hợp lệ"]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Hứng Request GET /api/users/verify"]
        C2{"Kiểm tra tính hợp lệ của Token"}
        C3["Tìm User tương ứng với Token"]
        C4{"User tìm thấy?"}
        C5["Cập nhật trạng thái:<br/>_verified = true"]
        C6["Hủy Token đã dùng"]
        C7["Tạo Log kích hoạt thành công"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1[(Collection: Users)]
    end

    %% Connections
    A1 --> A2
    A2 --> B1
    B1 --> C1
    C1 --> C2
    
    C2 -- "Không hợp lệ / Hết hạn" --> B4
    C2 -- "Hợp lệ" --> C3
    
    C3 --> C4
    C4 -- "Không thấy" --> B4
    C4 -- "Thấy" --> C5
    
    C5 <--> D1
    C5 --> C6
    C6 --> C7
    C7 --> B3
    
    B3 --> A10
    B4 --> A10

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style Boundary fill:#e8f4fd,stroke:#2196f3
    style UseCase fill:#f9f9f9,stroke:#333
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Khởi đầu** | **User** | Hành động này diễn ra bên ngoài ứng dụng (trong Client Email của User). |
| **Tiếp nhận** | **Boundary** | Frontend bắt được `token` từ Query Parameter trong URL và gửi xuống Backend để thẩm định. |
| **Thẩm định** | **UseCase** | Backend kiểm tra sự tồn tại của Token trong DB và xem nó có còn hạn (24h) không. |
| **Kích hoạt** | **Entity** | Sau khi xác thực, trường `_verified` được chuyển sang `true`, chính thức biến Guest thành Member có đầy đủ quyền lợi. |
| **Dọn dẹp** | **UseCase** | Token xác thực nên được xóa hoặc vô hiệu hóa ngay để tránh tái sử dụng (Replay Attack). |

---

## 3. Phản biện rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **VR-01** | **Token Expiry** | Người dùng click vào link sau vài ngày. | Hệ thống báo lỗi và cung cấp nút "Gửi lại link mới". |
| **VR-02** | **Replay Attack** | Link bị click nhiều lần bởi hacker hoặc bot scan mail. | Token chỉ được sử dụng đúng 1 lần. Lần 2 sẽ báo lỗi. |
| **VR-03** | **Logic Gap** | User đã verified rồi nhưng vẫn click link cũ. | Trả về trạng thái "Tài khoản đã được xác thực từ trước" thay vì báo lỗi Token không hợp lệ. |

---
*Tài liệu được biên soạn bởi **Tít dễ thương**.*
