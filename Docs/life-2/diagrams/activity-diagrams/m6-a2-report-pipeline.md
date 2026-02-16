# M6-A2: Content Report Pipeline - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng tiếp nhận báo cáo từ người dùng về các nội dung vi phạm, đảm bảo quy trình xử lý minh bạch và công bằng.
> **Kiến trúc:** **MVC** (View - Controller/Service - Model).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Phát hiện nội dung nhạy cảm / vi phạm"]
        A2["Chọn 'Báo cáo bài viết'"]
        A3["Chọn lý do (Spam, Quấy rối...) & Mô tả"]
        A10["Nhận thông báo: 'Đã tiếp nhận báo cáo'"]
    end

    subgraph View["🖥️ Frontend (View)"]
        B1["Hiển thị Form Báo cáo"]
        B2["Gửi Request POST /api/moderation/reports"]
        B3["Ẩn bài viết tạm thời khỏi View của User đó"]
    end

    subgraph ControllerService["⚙️ Backend (Controller/Service)"]
        C1["Tiếp nhận thông tin báo cáo"]
        C2["Kiểm tra tính hợp lệ của PostID/UserID"]
        C3["Định danh mức độ nghiêm trọng"]
        C4["Tạo bản ghi Report trong hàng chờ"]
        C5["Gửi xác nhận cho người báo cáo"]
    end

    subgraph Model["🗄️ Database (Model)"]
        D1["(Collection: Reports - status: pending)"]
        D2["(Collection: AuditLogs)"]
    end

    %% Connections
    A1 --> A2
    A2 --> B1
    B1 --> A3
    A3 --> B2
    B2 --> B3
    B2 --> C1
    C1 --> C2
    C2 -- "Lỗi" --> B2
    C2 -- "Hợp lệ" --> C3
    C3 --> C4
    C4 <--> D1
    C4 --> D2
    C4 --> C5
    C5 --> A10

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style View fill:#e8f4fd,stroke:#2196f3
    style ControllerService fill:#f9f9f9,stroke:#333
    style Model fill:#fffde7,stroke:#fbc02d
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Lọc nhanh** | **View** | Ngay khi báo cáo thành công, Frontend chủ động ẩn bài viết đó đi (Local hide) để bảo vệ trải nghiệm của người dùng ngay lập tức. |
| **Phân loại** | **Controller/Service** | Backend không chỉ lưu báo cáo mà còn phải phân loại mức độ ưu tiên dựa trên lý do (Ví dụ: 'Nội dung nguy hiểm' sẽ có mức ưu tiên cao hơn 'Spam'). |
| **Hàng chờ** | **Model** | Báo cáo được lưu vào collection `reports` với trạng thái ban đầu là `pending`, chờ Admin vào xử lý ở Phase M6-A3. |
| **Vết tích** | **Model** | Mọi báo cáo đều được ghi lại trong `AuditLogs` để tránh tình trạng Admin hoặc User xóa dấu vết báo cáo. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **RP-01** | **Mass Reporting** | Một nhóm người dùng cùng lúc báo cáo 1 bài viết để tìm cách gỡ bài đó. | Controller kiểm tra số lượng báo cáo từ cùng một dải IP hoặc cùng một nhóm User trong thời gian ngắn để cảnh báo sự tấn công. |
| **RP-02** | **Reporting Spam** | User gửi hàng loạt báo cáo vô căn cứ để gây nhiễu Admin. | Áp dụng giới hạn số lượng báo cáo (Quota) trên mỗi tài khoản trong ngày. Tài khoản báo cáo sai nhiều lần sẽ bị giảm độ tin cậy. |
| **RP-03** | **Deleted Target** | Nội dung bị báo cáo bị User xóa trước khi Admin kịp xem. | Backend sẽ lưu lại một bản Snapshot (chụp lại nội dung) tại thời điểm báo cáo để phục vụ công tác đối soát sau này. |

---
*Tài liệu được cập nhật dựa trên tiếp cận **MVC & Local-First** bởi **Tít dễ thương**.*
