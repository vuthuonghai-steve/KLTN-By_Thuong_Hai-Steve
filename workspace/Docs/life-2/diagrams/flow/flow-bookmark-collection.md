# Flow Diagram: Quản lý collection bookmark (UC20)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Trang Bookmark Dashboard"])
    U2("Chọn Create New Collection")
    U3("Nhập Name, Mô tả, và thiết lập Public/Private")
    U4("Nhấn Tạo")
    U5(["Kết thúc: Collection mới hiển thị trên Grid"])
    U6("Báo lỗi Validated Name")
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("Gọi POST /api/v1/collections")
    S2{"Tên Collection đã<br/>tồn tại cho User?"}
    S3("Lưu thông báo cấu hình Collection")
    S4("Gửi lại UI lỗi Duplicated Name")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Insert document vào `user_collections`")
  end

  U1 --> U2 --> U3 --> U4 --> S1
  S1 --> S2
  S2 -- "Tồn tại Name" --> S4 --> U6
  S2 -- "Chưa có" --> D1 --> S3
  S3 --> U5

  %% UC-ID: UC20
  %% Business Function: Tạo / Sửa / Xóa Custom Bookmarks Folders / Collections
```

## Assumptions
- Dữ liệu `isPublic: false` mặc định giúp Collection có thể được chia sẻ cho người khác.
- Mỗi User không được phép có hai Collection trùng Tên.
