# Flow Diagram: Đăng ký tài khoản (UC01)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Chọn Đăng ký"])
    U2("Nhập Username, Email, Password,<br/>Confirm Password")
    U3("Nhấn nút Đăng ký")
    U4("Nhận thông báo lỗi")
    U5(["Kết thúc: Xem màn hình thành công"])
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1{"Validate input (Zod)?"}
    S2{"Kiểm tra User tồn tại?"}
    S3("Tạo dữ liệu User mới")
    S4("Gửi sự kiện Đăng ký<br/>thành công")
    S5("Trả về lỗi Validation")
    S6("Trả về lỗi Email/Username<br/>đã tồn tại")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Query: Find User<br/>by Email/Username")
    D2("Lưu User mới")
  end

  %% Flow logic
  U1 --> U2 --> U3 --> S1
  S1 -- "Không hợp lệ" --> S5 --> U4
  S1 -- "Hợp lệ" --> D1
  
  D1 --> S2
  S2 -- "Đã tồn tại" --> S6 --> U4
  S2 -- "Chưa tồn tại" --> S3 --> D2
  
  D2 --> S4 --> U5

  %% UC-ID: UC01
  %% Business Function: Đăng ký tài khoản
```

## Assumptions
- Dữ liệu input cần thỏa mãn Zod rule theo spec: `username` min 3 max 20, chỉ chứa a-zA-Z0-9_.
- Sau khi insert, PayloadCMS tự động tạo collection Profile qua Payload hooks (không thể hiện chi tiết ở đây, coi như gộp trong "Lưu User mới").
- Hệ thống gửi sự kiện đăng ký thành công (có thể gửi email chào mừng qua M6).
