# Flow Diagram: Kiểm duyệt / Xem xét báo cáo vi phạm (UC24)

```mermaid
flowchart TD
  subgraph User ["🛡️ Admin"]
    direction TB
    A1(["Bắt đầu: Đăng nhập Payload Admin Panel"])
    A2("Mở danh sách 'Reports' Pending")
    A3("Xem chi tiết Report và Nội dung gốc (Entity)")
    A4{"Quyết định mức độ vi phạm"}
    A5("Đánh dấu Resolve / Dismissed")
    A6(["Tiến hành Khóa User (Ban)"])
    A7(["Tiến hành Xóa / Ẩn bài viết"])
    A8(["Kết thúc: Hoàn tất Review"])
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("CMS Payload tự động list Entities")
    S2("Cập nhật `status` của Report")
    S3("Phát hành Notification (Nếu cần) cho người bị khóa/xóa bài")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Update Posts / Users Collection")
    D2("Update Status Report")
  end

  A1 --> S1 --> A2
  A2 --> A3 --> A4
  
  A4 -- "Không vi phạm" --> A5 --> S2 --> D2
  
  A4 -- "Vi phạm nhẹ" --> A7 --> D1 --> S2 --> D2
  A4 -- "Vi phạm nặng" --> A6 --> D1 --> S2 --> D2
  
  D1 --> S3
  D2 --> A8

  %% UC-ID: UC24
  %% Business Function: Trình Kiểm Duyệt Nội Dung & Giải Quyết Report bằng PayloadCMS Panel
```

## Assumptions
- Tiến trình quản trị kiểm duyệt diễn ra ngay trên Panel admin được cấp sẵn bởi PayloadCMS, nơi mọi collection được bày sẵn mà không cần custom Code Logic Dashboard riêng. Việc update thực thi qua Payload UI.
- Có thẻ xử lý Notification trả về người dùng nếu họ bị báo cáo thành công.
