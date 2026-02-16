# M3-A2: Search Engine Query - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng tìm kiếm đa mục tiêu (Post, User, Tag) sử dụng sức mạnh nội tại của Database (Local Search).
> **Kiến trúc:** **MVC** (View - Controller/Service - Model).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Nhập từ khóa tìm kiếm"]
        A2["Chọn tab phân loại<br/>(Tất cả / Người dùng / Bài viết)"]
        A10["Xem kết quả tìm kiếm"]
    end

    subgraph View["🖥️ Frontend (View)"]
        B1["Gửi Request GET /api/search?q=...&type=..."]
        B2["Hiển thị gợi ý nhanh<br/>(Local Autocomplete)"]
        B3["Render danh sách kết quả theo Tab"]
    end

    subgraph ControllerService["⚙️ Backend (Controller/Service)"]
        C1["Tiếp nhận từ khóa và loại tìm kiếm"]
        C2["Sanitize & Escape Query String"]
        C3["Xây duyệt truy vấn Regex<br/>(Case-insensitive, Unicode)"]
        C4["Truy vấn đa Collection (Users, Posts, Tags)"]
        C5["Xếp hạng kết quả theo độ khớp"]
        C6["Đóng gói kết quả tìm kiếm"]
    end

    subgraph Model["🗄️ Database (Model)"]
        D1["(Collection: Users - Index: name/username)"]
        D2["(Collection: Posts - Index: content)"]
        D3["(Collection: Tags - Index: slug)"]
    end

    %% Connections
    A1 --> B2
    B2 --> C1
    A1 --> B1
    A2 --> B1
    B1 --> C1
    C1 --> C2
    C2 --> C3
    C3 --> C4
    C4 <--> D1
    C4 <--> D2
    C4 <--> D3
    C4 --> C5
    C5 --> C6
    C6 --> B3
    B3 --> A10

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
| **Autocomplete** | **View** | Frontend chủ động kích hoạt API tìm kiếm khi người dùng bắt đầu gõ để tăng tính tương tác. |
| **Tìm kiếm Nội tại** | **Controller/Service** | Thay vì Atlas Search, hệ thống sử dụng **Regex** kết hợp với **Case-insensitive** để tìm kiếm linh hoạt trên các trường văn bản. |
| **Phân loại** | **Controller/Service** | Logic Backend tự động phân luồng truy vấn vào đúng các Collections (Users, Posts, Tags) dựa trên tham số `type`. |
| **Tối ưu hóa** | **Model** | Đảm bảo các trường tiêu đề và tên người dùng được **Indexing** để luồng Regex không gây nặng tải cho Database. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **SE-01** | **Query Injection** | Người dùng nhập các ký tự Regex đặc biệt để phá hoại câu query. | Backend thực hiện **Escape** (thoát chuỗi) tất cả các ký tự đặc biệt trước khi đưa vào Regex engine. |
| **SE-02** | **Privacy Breach** | Tìm bài viết riêng tư hoặc của người dùng bị cấm. | Model luôn lồng điều kiện lọc `status: 'active'` và `visibility: 'public'` vào mọi câu truy vấn. |
| **SE-03** | **Regex Performance** | Câu truy vấn Regex quá phức tạp gây tốn tài nguyên CPU. | Giới hạn độ dài từ khóa tìm kiếm (min 3 ký tự) và sử dụng `$and` để giảm bớt tập dữ liệu trước khi chạy Regex. |

---
*Tài liệu được cập nhật bởi **Tít dễ thương** - Tiếp cận **MVC & Local-First**.*
