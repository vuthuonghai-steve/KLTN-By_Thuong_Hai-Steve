# Flow Diagram: Like/Unlike bài viết (UC14)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Thấy nút Like trên Post/Comment"])
    U2("Nhấn nút Like <br/>(Toggle: Like <-> Unlike)")
    U3(["Kết thúc: Đổi màu nút Like<br/>và cập nhật đếm Like lập tức (Optimistic UI)"])
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("Nhận API Request POST/DELETE /api/likes")
    S2{"Kiểm tra Trạng thái Like trước đó?"}
    S3("Từ chối (không Auth)")
    S4("Gửi thông báo <br/>SSE tới người đăng")
    S5("Cập nhật lại cache (nếu lỗi UI rollback)")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Đếm số lượng Like hiện tại")
    D2("Lưu bản ghi Like")
    D3("Xóa bản ghi Like")
    D4("Hook: Auto cập nhật `stats.likes` của Post")
  end

  U1 --> U2 --> U3
  U2 -.->|Gửi Request nền| S1
  S1 -- "No Auth" --> S3
  S1 -- "Auth OK" --> D1 --> S2

  S2 -- "Đã Like" --> D3
  S2 -- "Chưa Like" --> D2
  
  D2 --> D4
  D3 --> D4
  
  D2 --> S4
  
  D4 --> S5

  %% UC-ID: UC14
  %% Business Function: Tương tác thả tim (Like) - Optimistic
```

## Assumptions
- "Optimistic UI" thường được áp dụng cho tính năng Like: giao diện trả về trạng thái Like và tăng bộ đếm **ngay lập tức** mà không chờ server xử lý, nếu server báo lỗi sẽ tự động hoàn tác. Lên diagram thể hiện luồng UI hoàn thành sớm hơn nền.
