# Flow Diagram: Chia sẻ bài viết (UC16)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Nhấn Share (Chia sẻ) bài viết"])
    U2("Màn hình Share Dialog")
    U3("Nhấn 'Copy Link' hoặc 'Đăng lên trang cá nhân'")
    U4(["Kết thúc: Link được Copy"])
    U5(["Kết thúc: Bài Share hiển thị trên Feed"])
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("Copy vào Clipboard")
    S2("Tạo bài viết mới dạng Share (Trích dẫn Post Gốc)")
    S3("Tăng biến đếm `stats.shares`")
    S4("Gửi thông báo tới Author gốc")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Update Posts.shares +1")
    D2("Insert Post mới (loại hình Share)")
  end

  U1 --> U2 --> U3
  U3 -- "Copy Link" --> S1 --> U4
  
  U3 -- "Chia sẻ trực tiếp" --> S2
  S2 --> D2 --> D1
  D1 --> S3
  S3 --> S4 --> U5

  %% UC-ID: UC16
  %% Business Function: Chia sẻ nội dung bài viết
```

## Assumptions
- Spec M4 có ghi "SharesCount" nhưng không nói rõ Repost là copy link hay tạo Post mới. Pattern phổ biến: tạo bài viết mới + nhúng Link/Preview hoặc Ref Post ID. Ở đây dùng giả định tạo bài Shared Post.
