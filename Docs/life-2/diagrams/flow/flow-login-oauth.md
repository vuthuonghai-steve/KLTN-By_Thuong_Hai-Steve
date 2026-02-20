# Flow Diagram: Đăng nhập OAuth Google (UC03)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Chọn Login Google"])
    U2("Xác thực trên trang Google")
    U3(["Kết thúc: Đăng nhập thành công"])
    U4("Nhận thông báo thất bại")
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("Gọi Google OAuth Endpoint")
    S2{"Nhận mã code/token<br/>thành công?"}
    S3("Verify token với Google API")
    S4{"Email đã liên kết<br/>tài khoản?"}
    S5("Tự động tạo<br/>Profile mới (Auto-slug)")
    S6("Tiến hành cấp Token<br/>Đăng nhập")
    S7("Trả về lỗi<br/>Xác thực thất bại")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Query User by Email")
    D2("Insert User mới")
  end

  U1 --> S1 --> U2 --> S2
  S2 -- "Thực hiện thất bại" --> S7 --> U4
  S2 -- "Google trả Token" --> S3
  S3 --> D1
  
  D1 --> S4
  S4 -- "Đã tồn tại" --> S6
  S4 -- "Chưa có tài khoản" --> S5 --> D2 --> S6
  S6 --> U3

  %% UC-ID: UC03
  %% Business Function: Đăng nhập OAuth Google
```

## Assumptions
- Giả định hệ thống sẽ tự động tạo `username` auto-slug từ email nếu chưa tồn tại (giống như spec yêu cầu).
- Password sẽ được hệ thống sinh ngẫu nhiên mạnh bên dưới hoặc null (Google Auth).
