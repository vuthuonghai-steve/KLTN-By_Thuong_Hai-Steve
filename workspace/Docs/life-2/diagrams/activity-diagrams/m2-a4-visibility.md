# M2-A4: Visibility Enforcement - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Quản lý quyền riêng tư của bài viết, đảm bảo chỉ những đối tượng được phép mới có thể tiếp cận nội dung.
> **Kiến trúc:** B-U-E (Boundary-UseCase-Entity).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Chọn đối tượng xem bài viết"]
        A2["Nhấp 'Cập nhật Quyền'"]
        A10["Thấy biểu tượng Quyền (🔒/🌐)"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Hiển thị Dropdown:<br/>Public, Friends, Private"]
        B2["Gửi Request PATCH /api/posts/{id}/visibility"]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Tiếp nhận Payload Visibility"]
        C2{"Loại quyền?"}
        C3["Thanh lọc danh sách Bạn bè"]
        C4["Gán cờ 'is_private' hoặc 'visibility_level'"]
        C5["Cập nhật ACL (Access Control List) cho bài viết"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1["(Collection: Posts)"]
        D2["(Collection: Connections/Friends)"]
    end

    %% Connections
    A1 --> B1
    B1 --> A2
    A2 --> B2
    B2 --> C1
    C1 --> C2
    C2 -- "Friends Only" --> C3
    C3 <--> D2
    C3 --> C4
    C2 -- "Public/Private" --> C4
    C4 --> C5
    C5 <--> D1
    C5 --> A10

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style Boundary fill:#e8f4fd,stroke:#2196f3
    style UseCase fill:#f9f9f9,stroke:#333
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Lựa chọn** | **User** | Người dùng quyết định phạm vi lan tỏa của kiến thức. |
| **Phân loại** | **UseCase** | Có 3 mức cơ bản: **Public** (Ai cũng thấy), **Friends** (Chỉ bạn bè thấy), **Private** (Chỉ mình tôi). |
| **Kiểm tra chéo** | **UseCase** | Với tùy chọn 'Friends', hệ thống phải truy vấn collection `connections` để xác định danh sách UID hợp lệ. |
| **Thực thi** | **Entity** | Khi một người dùng khác truy vấn News Feed, DB sẽ thực hiện Filter dựa trên thuộc tính này (Gắn kết với M3). |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **VE-01** | **Privacy Leak** | Bài viết 'Private' nhưng vẫn hiện trong kết quả tìm kiếm (Search). | Tích hợp Check Visibility vào pipeline Search và Indexing. |
| **VE-02** | **Relationship Latency** | Hủy kết bạn nhưng vẫn thấy bài viết 'Friends Only' do cache. | Invalidate cache ngay khi có sự thay đổi trong trạng thái quan hệ (Connection change). |
| **VE-03** | **Unintended Access** | Truy cập trực tiếp qua Direct Link của bài viết Private. | UseCase kiểm tra quyền sở hữu và quan hệ ngay tại layer Fetching bằng Middleware. |

---
*Tài liệu được biên soạn bởi **Tít dễ thương**.*
