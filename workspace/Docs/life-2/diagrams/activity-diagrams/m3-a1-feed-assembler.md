# M3-A1: News Feed Assembler - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng tổng hợp bài viết từ nhiều nguồn để hiển thị lên dòng thời gian của người dùng.
> **Kiến trúc:** B-U-E (Boundary-UseCase-Entity).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Truy cập News Feed"]
        A2["Cuộn trang (Infinite Scroll)"]
        A10["Xem danh sách bài viết mới nhất"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Gửi Request GET /api/posts/feed?page=1"]
        B2["Hiển thị Skeleton Loading"]
        B3["Render danh sách bài viết"]
        B4["Bắt sự kiện cuộn trang để Load More"]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Nhận Request lấy Feed"]
        C2["Lấy danh sách Following IDs của User"]
        C3["Xây dựng Query: (Followings OR Public) AND Active"]
        C4["Thực hiện Phân trang (Pagination)"]
        C5["Populate dữ liệu: Author, Media, Tags"]
        C6["Trả về Paginated Response"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1["(Collection: Posts)"]
        D2["(Collection: Connections)"]
    end

    %% Connections
    A1 --> B1
    B1 --> B2
    B1 --> C1
    C1 --> C2
    C2 <--> D2
    C2 --> C3
    C3 --> C4
    C4 <--> D1
    C4 --> C5
    C5 <--> D1
    C5 --> C6
    C6 --> B3
    B3 --> A10
    A10 --> A2
    A2 --> B4
    B4 --> B1

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style Boundary fill:#e8f4fd,stroke:#2196f3
    style UseCase fill:#f9f9f9,stroke:#333
    style Entity fill:#fffde7,stroke:#fbc02d
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Điều kiện lọc** | **UseCase** | Hệ thống ưu tiên bài viết từ những người mà User đang `Following`. Bài viết phải ở trạng thái `published` và `visibility` là `public` hoặc `friends`. |
| **Tối ưu hóa** | **Boundary** | Sử dụng **Infinite Scroll** để giảm tải dung lượng truyền tải, chỉ tải 10-20 bài mỗi lần cuộn. |
| **Liên kết dữ liệu** | **UseCase** | Việc **Populate** (Join) dữ liệu tác giả và hình ảnh giúp Frontend hiển thị đầy đủ thông tin mà không cần gọi thêm API. |
| **Phân trang** | **Entity** | Sử dụng `skip` và `limit` của MongoDB để quản lý phân trang chính xác. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **FA-01** | **Performance Degradation** | User theo dõi quá nhiều người khiến query chậm. | Sử dụng **Indexing** trên các trường `author`, `createdAt` và `visibility`. |
| **FA-02** | **Duplicate Content** | Bài viết bị lặp lại khi cuộn trang do có bài mới được đăng. | Sử dụng phân trang dựa trên **Cursor** (tùy vào `createdAt`) thay vì trang số (offset). |
| **FA-03** | **Stale Data** | Thông tin tác giả hoặc số Like bị cũ. | Sử dụng **React Query / SWR** ở Frontend để tự động làm mới dữ liệu sau một khoảng thời gian. |

---
*Tài liệu được biên soạn bởi **Tít dễ thương**.*
