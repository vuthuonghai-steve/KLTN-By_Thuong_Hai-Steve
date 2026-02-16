# M6-A3: Enforcement Action - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng xử lý và thực thi quyết định kiểm duyệt từ phía Quản trị viên (Admin), bảo vệ sự trong sạch của cộng đồng.
> **Kiến trúc:** **MVC** (View - Controller/Service - Model).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph Admin_User["🛡️ Quản trị viên (Admin)"]
        A1["Truy cập hàng chờ kiểm duyệt (Moderation Queue)"]
        A2["Xem chi tiết nội dung bị báo cáo"]
        A3["Ra quyết định: Phê duyệt / Bác bỏ"]
        A10["Thấy trạng thái: Đã xử lý"]
    end

    subgraph View["🖥️ Dashboard (View)"]
        B1["Hiển thị danh sách Reports (status: pending)"]
        B2["Mở giao diện Action: Delete Post / Ban User / Dismiss"]
        B3["Gửi Request PATCH /api/moderation/resolve"]
    end

    subgraph ControllerService["⚙️ Backend (Controller/Service)"]
        C1["Tiếp nhận quyết định từ Admin"]
        C2{"Loại quyết định?"}
        C3["Thực thi: Xóa/Ẩn bài viết<br/>(Update status: 'banned')"]
        C4["Thực thi: Khóa tài khoản User<br/>(Update status: 'inactive')"]
        C5["Thực thi: Bác bỏ báo cáo<br/>(Update status: 'dismissed')"]
        C6["Gửi thông báo kết quả cho các bên liên quan"]
    end

    subgraph Model["🗄️ Database (Model)"]
        D1["(Collection: Reports)"]
        D2["(Collection: Posts)"]
        D3["(Collection: Users)"]
        D4["(Collection: AuditLogs)"]
    end

    %% Connections
    A1 --> B1
    B1 --> A2
    A2 --> B2
    B2 --> A3
    A3 --> B3
    B3 --> C1
    C1 --> C2
    C2 -- "Vi phạm POST" --> C3
    C3 <--> D2
    C2 -- "Vi phạm USER" --> C4
    C4 <--> D3
    C2 -- "Vô tội" --> C5
    C3 --> C6
    C4 --> C6
    C5 --> C6
    C6 <--> D1
    C6 <--> D4
    C6 --> A10

    %% Styling
    style Admin_User fill:#fffde7,stroke:#fbc02d
    style View fill:#e8f4fd,stroke:#2196f3
    style ControllerService fill:#f9f9f9,stroke:#333
    style Model fill:#fffde7,stroke:#fbc02d
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Công tâm** | **Admin** | Admin có cái nhìn khách quan về báo cáo, có thể đối soát nội dung gốc (Snapshot) và lý do báo cáo. |
| **Phân vùng** | **Controller/Service** | Tùy mức độ vi phạm, hệ thống hỗ trợ 3 mức xử lý: Nhắc nhở (Dismiss), Xử lý nội dung (Ban Post) hoặc Xử lý chủ thể (Ban User). |
| **Xác lập quyền** | **Controller/Service** | Kiểm duyệt là hành động nhạy cảm, chỉ những User có Role `Admin` mới được phép truy cập vào Controller này. |
| **Lưu vết** | **Model** | Mọi quyết định kiểm duyệt bắt buộc phải ghi lại `adminId`, `reason` và `timestamp` vào `AuditLogs` để quản lý cấp cao có thể kiểm tra chéo (Auditing). |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **EA-01** | **Abuse of Power** | Admin lạm quyền để xóa bài hoặc khóa tài khoản cá nhân. | Mọi quyết định đều được lưu log không thể xóa. Hệ thống cần cơ chế Reviewer cho các quyết định khóa vĩnh viễn tài khoản. |
| **EA-02** | **Accidental Deletion** | Admin bấm nhầm nút xóa bài. | Sử dụng **Soft Delete** (Chỉ đổi status, không xóa database ngay lập tức) để có thể khôi phục trong vòng 30 ngày. |
| **EA-03** | **Retaliation** | Người bị khóa tài khoản tìm cách trả đũa hệ thống. | Khi khóa tài khoản, hệ thống tự động đăng xuất User khỏi mọi thiết bị và vô hiệu hóa Token ngay lập tức. |

---
*Tài liệu được cập nhật dựa trên tiếp cận **MVC & Local-First** bởi **Tít dễ thương**.*
