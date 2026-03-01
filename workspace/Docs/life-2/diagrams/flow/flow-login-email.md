# Flow Diagram: Đăng nhập Email/Password (UC02)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Màn hình Đăng nhập"])
    U2("Nhập Email, Password")
    U3("Nhấn nút Đăng nhập")
    U4("Nhận thông báo lỗi")
    U5(["Kết thúc: Chuyển hướng<br/>tới màn hình chính"])
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1{"Validate input?"}
    S2{"Kiểm tra User<br/>tồn tại?"}
    S3{"Mật khẩu<br/>chính xác?"}
    S4("Sinh Token Access")
    S5("Trả về lỗi<br/>Validation")
    S6("Trả về lỗi Info<br/>không chính xác")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Query Use by Email")
  end

  U1 --> U2 --> U3 --> S1
  S1 -- "Không hợp lệ" --> S5 --> U4
  S1 -- "Hợp lệ" --> D1
  
  D1 --> S2
  S2 -- "Chưa tồn tại" --> S6 --> U4
  S2 -- "Tồn tại" --> S3
  
  S3 -- "Sai mật khẩu" --> S6
  S3 -- "Đúng mật khẩu" --> S4
  S4 --> U5

  %% UC-ID: UC02
  %% Business Function: Đăng nhập Email/Password
```

## Assumptions
- Dùng session hoặc jwt cho Token Access (theo mặc định của PayloadCMS).
- Việc xử lý "Quên mật khẩu" có thể chia rẽ nhánh tại U4 nếu người dùng quên mật khẩu (nhưng không thể hiện trong Use Case này để giữ độ tinh giản).
