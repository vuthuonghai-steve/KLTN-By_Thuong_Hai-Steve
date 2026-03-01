# Flow Diagram: Tạo bài viết (UC08)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Mở Editor (Tạo bài viết)"])
    U2("Nhập nội dung Markdown / RichText")
    U3{"Có đính kèm<br/>Media/Link?"}
    U4("Tải ảnh/video lên")
    U5("Dán URL Link")
    U6("Nhấn nút 'Đăng bài'")
    U7(["Kết thúc: Đăng thành công<br/>& Xem bài viết"])
    U8("Nhận thông báo lỗi")
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("Xử lý file upload")
    S2("Lấy OpenGraph meta<br/>cho URL (Link Preview)")
    S3{"Validate nội dung<br/>(có trống?)"}
    S4("Sanitize nội dung & bóc tách Tags")
    S5("Khởi tạo RankingScore")
    S6("Báo lỗi (VD: không có nội dung)")
    S7("Trả kết quả Upload lỗi")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Lưu Uploads vào collection Media")
    D2("Tạo Tags mới (nếu chưa có)<br/>hoặc Cập nhật postCount")
    D3("Insert record vào collection Posts")
  end

  U1 --> U2 --> U3
  U3 -- "Có Media" --> U4 --> S1
  S1 -- "Upload lỗi" --> S7 --> U8
  S1 -- "Upload OK" --> D1 --> U6
  
  U3 -- "Có URL" --> U5 --> S2 --> U6
  U3 -- "Không" --> U6

  U6 --> S3
  S3 -- "Không hợp lệ" --> S6 --> U8
  S3 -- "Hợp lệ" --> S4 --> S5 --> D2 --> D3
  D3 --> U7

  %% UC-ID: UC08
  %% Business Function: Tạo bài viết
```

## Assumptions
- Hook `beforeChange` của PayloadCMS xử lý sanitize và extract keywords/tags tự động từ trường content.
- Media upload có thể gọi API Upload độc lập trước, sau đó gửi ID về khi tạo Post (`Array of Uploads`).
