# Flow Diagram: Báo cáo vi phạm (UC23)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Nhấn 'Report' trên bài viết/người dùng"])
    U2("Chọn thẻ lý do<br/>(Spam, Toxic, Khác)")
    U3("Thêm mô tả chi tiết (Optional)")
    U4("Nhấn Gửi Báo Cáo")
    U5(["Kết thúc: Hiện Popup 'Cảm ơn đã báo cáo'"])
    U6("Báo lỗi (Đã báo cáo rồi / Hệ thống nghẽn)")
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("Gọi POST /api/reports")
    S2{"Kiểm tra trùng lặp<br/>(User đã report Entity này?)"}
    S3("Gửi lỗi Blocked/Duplicate")
    S4("Ghi Record Report")
    S5{"Tổng số Report<br/>>= Ngưỡng 10?"}
    S6("Tự động Ẩn (Hide) Entity chờ duyệt")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Lưu thông tin bảng `reports`")
    D2("Cập nhật field `status: hidden` tạm thời trên bảng `Posts`")
  end

  U1 --> U2 --> U3 --> U4 --> S1
  S1 --> S2
  S2 -- "Trùng" --> S3 --> U6
  S2 -- "Lần đầu" --> S4 --> D1
  
  D1 --> S5
  S5 -- "Chưa tới ngưỡng" --> U5
  S5 -- ">= 10 lần" --> S6 --> D2 --> U5

  %% UC-ID: UC23
  %% Business Function: Report Vi phạm Auto-Action
```

## Assumptions
- Có Auto-action ẩn bài viết nếu có 10 người trở lên báo cáo cùng một ID theo Spec M6 (Optional Features).
- Tích hợp cảnh báo trùng lặp Report để chống Spam click report.
