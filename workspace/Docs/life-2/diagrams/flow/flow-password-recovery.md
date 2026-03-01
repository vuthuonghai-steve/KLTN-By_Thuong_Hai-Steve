# Flow Diagram: Quên/Đặt lại mật khẩu (UC05)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Nhấn Quên Mật Khẩu"])
    U2("Nhập Email")
    U3("Nhận Email chứa Link Reset")
    U4("Mở Link -> Nhập<br/>Mật Khẩu Mới")
    U5(["Kết thúc: Update Thành Công"])
    U6("Báo lỗi (Không nhận mail)")
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1{"Dữ liệu Email<br/>Hợp lệ?"}
    S2{"User Tồn Tại?"}
    S3("Sinh Reset Token")
    S4("Gửi Email Reset (External Service)")
    S5{"Token có Hợp Lệ<br/>& Chưa Hạn?"}
    S6("Tiến hành Cập Nhật")
    S7("Báo lỗi Token/Email")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Kiểm tra Email")
    D2("Lưu Reset Token với Expiry")
    D3("Cập nhật Hash Mật Khẩu<br/>& Xóa Token")
  end

  U1 --> U2 --> S1
  S1 -- "Hợp lệ" --> D1
  S1 -- "Sai form" --> S7
  D1 --> S2
  
  S2 -- "Tồn tại" --> S3 --> D2 --> S4 --> U3
  S2 -- "Không tồn tại" --> S4
  %% Note: Should pretend to send email to prevent email enumeration attack

  U3 --> U4 --> S5
  S5 -- "Token hết hạn/Sai" --> S7 --> U6
  S5 -- "Hợp lệ" --> S6 --> D3 --> U5

  %% UC-ID: UC05
  %% Business Function: Quên/Đặt lại mật khẩu
```

## Assumptions
- System sẽ luôn luôn báo gửi mail thành công để tránh Data Enumeration Attack (kẻ tấn công kiểm tra được email ai đang có trong hệ thống bằng cách quên password).
- Token sẽ có Expiry Time (thường 1 giờ - 24 giờ).
