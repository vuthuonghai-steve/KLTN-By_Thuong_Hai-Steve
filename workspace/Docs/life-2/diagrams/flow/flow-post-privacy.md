# Flow Diagram: Thiết lập quyền riêng tư bài viết (UC10)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Đang nằm ở màn hình tạo/sửa bài"])
    U2("Mở modal 'Ai có thể xem bài viết?'")
    U3("Chọn: Public / Friends / Private")
    U4("Nhấn Xác nhận/Lưu")
    U5(["Kết thúc: Trạng thái hiển thị<br/>được cập nhật trên UI"])
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("Kiểm tra quyền cập nhật (nếu là bài cũ)")
    S2("Gắn thuộc tính visibility vào payload")
    S3("Lưu thay đổi xuống DB")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Cập nhật trạng thái visibility trong document")
  end

  U1 --> U2 --> U3 --> U4 --> S1
  S1 --> S2 --> S3
  S3 --> D1 --> U5

  %% UC-ID: UC10
  %% Business Function: Thiết lập quyền riêng tư bài viết
```

## Assumptions
- Mặc dù specs chưa đề cập chi tiết field `visibility`, tính năng này được liệt kê trong use-case overview. Giả định có field `visibility: enum('public', 'friends', 'private')` được thiết lập khi push bài lên DB (PATCH hoặc POST request).
