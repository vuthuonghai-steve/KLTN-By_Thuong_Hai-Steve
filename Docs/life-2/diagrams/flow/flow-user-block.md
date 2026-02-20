# Flow Diagram: Block người dùng (UC18)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Nhấn MoreOptions ở trang Hồ sơ khác"])
    U2("Chọn Block / Chặn người này")
    U3("Xác nhận thông báo cảnh báo")
    U4(["Kết thúc: Bài viết và người dùng bị ẩn"])
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("Gọi API /api/v1/blocks")
    S2("Hủy follow chéo (Xóa record Follow cả 2 chiều)")
    S3("Filter chặn Feed (M3 sẽ ngưng load bài)")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Lưu Blocked Person ID vào hồ sơ người dùng<br/>(hoặc collection Block)")
    D2("Delete Document trong collection Follows")
  end

  U1 --> U2 --> U3 --> S1
  S1 --> D1
  D1 --> S2 --> D2
  D2 --> S3 --> U4

  %% UC-ID: UC18
  %% Business Function: Chặn liên lạc & tương tác (Block)
```

## Assumptions
- Khi bị Block, hệ thống bắt buộc tự động "Unfollow" nếu hai người đang theo dõi nhau.
- Các API Read của Feed, Notification sẽ nhận một mảng danh sách Blocked Users để tự động query `$nin` che content độc.
