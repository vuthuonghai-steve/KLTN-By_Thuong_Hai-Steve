# M5-A1: Bookmark Persistence - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng lưu và bỏ lưu bài viết, đảm bảo tính nhất quán giữa View và Model.
> **Kiến trúc:** **MVC** (View - Controller/Service - Model).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Nhấp biểu tượng Bookmark 🔖 trên bài viết"]
        A10["Thấy biểu tượng chuyển màu (Active)"]
    end

    subgraph View["🖥️ Frontend (View)"]
        B1["Nhận sự kiện Click"]
        B2["Gửi Request POST /api/bookmarks/toggle"]
        B3["Cập nhật UI cục bộ (Optimistic UI)"]
        B4["Hiển thị thông báo: 'Đã lưu vào bộ sưu tập'"]
    end

    subgraph ControllerService["⚙️ Backend (Controller/Service)"]
        C1["Tiếp nhận yêu cầu Toggle Bookmark"]
        C2{"Đã Bookmark bài này chưa?"}
        C3["Xóa bản ghi Bookmark cũ"]
        C4["Tạo bản ghi Bookmark mới"]
        C5["Gán vào Collection mặc định: 'Tất cả'"]
        C6["Trả về trạng thái mới cho Client"]
    end

    subgraph Model["🗄️ Database (Model)"]
        D1["(Collection: Bookmarks)"]
        D2["(Collection: BookmarkCollections)"]
    end

    %% Connections
    A1 --> B1
    B1 --> B3
    B1 --> B2
    B2 --> C1
    C1 --> C2
    C2 -- "Rồi (Bỏ lưu)" --> C3
    C3 <--> D1
    C2 -- "Chưa (Lưu)" --> C4
    C4 --> C5
    C5 <--> D2
    C4 <--> D1
    C3 --> C6
    C5 --> C6
    C6 --> B4
    B4 --> A10

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
| **Toggle Logic** | **Controller/Service** | Hệ thống không dùng hai API riêng biệt cho Save/Unsave mà dùng chung một endpoint Toggle để đơn giản hóa logic cho View. |
| **Mặc định** | **Controller/Service** | Khi lưu lần đầu, hệ thống luôn gán bài viết vào bộ sưu tập hệ thống có tên là "Tất cả" (Uncategorized) để đảm bảo không có bookmark nào bị mồ côi. |
| **Phản hồi nhanh** | **View** | Sử dụng **Optimistic UI** để icon đổi màu ngay khi click, mang lại cảm giác ứng dụng phản hồi tức thì. |
| **Lưu trữ** | **Model** | Mỗi record trong `bookmarks` chứa bộ ba: `userId` - `postId` - `collectionId`. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **BP-01** | **Redundant Records** | Click quá nhanh tạo ra nhiều bản ghi trùng lặp cho cùng một bài viết. | Sử dụng **Compound Index** duy nhất (Unique) trên `userId` + `postId` trong Model để DB tự chặn rác. |
| **BP-02** | **Post Deletion** | Bài viết gốc bị xóa nhưng Bookmark vẫn còn gây lỗi 404. | Sử dụng **Cascade Delete** hoặc Service của Post (M2) phải gửi tín hiệu xóa toàn bộ Bookmark liên quan khi Post bị gỡ. |
| **BP-03** | **Access Denied** | Lưu bài viết từ một tài khoản vừa chuyển sang chế độ Private/Blocked. | Controller kiểm tra lại quyền xem bài viết (`visibility`) ngay tại thời điểm thực hiện lưu. |

---
*Tài liệu được cập nhật dựa trên tiếp cận **MVC & Local-First** bởi **Tít dễ thương**.*
