# Flow Diagram: Chỉnh sửa/Xóa bài viết (UC09)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Chọn tác vụ Edit/Delete trên bài viết"])
    U2{"Hành động?"}
    U3("Xác nhận xóa (Confirm)")
    U4("Sửa nội dung và Lưu")
    U5(["Kết thúc: Bài viết được xóa"])
    U6(["Kết thúc: Bài viết được cập nhật"])
    U7("Báo lỗi quyền thao tác")
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1{"Có phải Author<br/>của bài viết?"}
    S2("Nhận yêu cầu Xóa")
    S3("Nhận yêu cầu Cập nhật")
    S4("Chạy lại hook lấy Tags mới")
    S5("Cấm truy cập/Báo lỗi")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Hard Delete Post trong DB")
    D2("Cập nhật lại Post & PostCount của Tags")
  end

  U1 --> S1
  S1 -- "Không phải Owner" --> S5 --> U7
  S1 -- "Là Owner" --> U2

  U2 -- "Xóa" --> U3 --> S2 --> D1 --> U5
  U2 -- "Chỉnh sửa" --> U4 --> S3 --> S4 --> D2 --> U6

  %% UC-ID: UC09
  %% Business Function: Chỉnh sửa/Xóa bài viết
```

## Assumptions
- Quyền Update / Delete đối với Post được giới hạn ở PayloadCMS Access Control `(req, id) => req.user.id === post.author`. Admin có thể có quyền cao hơn (kế thừa) nhưng UC09 áp dụng chính cho User (Member).
