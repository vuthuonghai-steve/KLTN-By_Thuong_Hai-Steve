# M5-A2: Collection Orchestrator - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng quản lý và phân loại bài viết vào các bộ sưu tập (Collections) tùy chỉnh.
> **Kiến trúc:** **MVC** (View - Controller/Service - Model).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Truy cập màn hình Bộ sưu tập"]
        A2["Tạo thư mục mới (VD: Học tập)"]
        A3["Chọn bài viết & 'Di chuyển vào thư mục'"]
        A10["Thấy bài viết đã nằm trong mục mới"]
    end

    subgraph View["🖥️ Frontend (View)"]
        B1["Hiển thị danh sách thư mục"]
        B2["Mở Modal chọn thư mục đích"]
        B3["Gửi Request PATCH /api/bookmarks/move"]
    end

    subgraph ControllerService["⚙️ Backend (Controller/Service)"]
        C1["Tiếp nhận yêu cầu di chuyển"]
        C2{"Thư mục đích tồn tại?"}
        C3["Cập nhật collectionId cho Bookmark record"]
        C4["Cập nhật số lượng bài viết trong mỗi mục"]
        C5["Trả về danh sách Bookmark đã cập nhật"]
    end

    subgraph Model["🗄️ Database (Model)"]
        D1["(Collection: Bookmarks)"]
        D2["(Collection: BookmarkCollections)"]
    end

    %% Connections
    A1 --> B1
    A2 --> C1
    A3 --> B2
    B2 --> B3
    B3 --> C1
    C1 --> C2
    C2 -- "Có" --> C3
    C3 <--> D1
    C3 --> C4
    C4 <--> D2
    C4 --> C5
    C5 --> B1
    B1 --> A10

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
| **Khởi tạo** | **User** | Người dùng có thể cá nhân hóa kho tri thức bằng cách tạo ra các thư mục có tên riêng. |
| **Phân loại** | **View** | Cung cấp giao diện kéo-thả (Drag & Drop) hoặc menu "Di chuyển" để thay đổi thư mục đích cho bài viết đã lưu. |
| **Gắn kết lại** | **Controller/Service** | Thay vì xóa và tạo mới, hệ thống chỉ cập nhật trường `collectionId` của bản ghi Bookmark hiện tại để giữ nguyên metadata. |
| **Thư mục hệ thống** | **Model** | Thư mục "Tất cả" là thư mục hệ thống không thể xóa, đóng vai trò là nơi lưu trữ mặc định. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **CO-01** | **Collection Deletion** | Xóa bộ sưu tập đang chứa hàng trăm bài viết. | **Controller** sẽ gán lại toàn bộ bài viết trong thư mục bị xóa về lại thư mục "Tất cả" (Default) thay vì xóa hẳn bookmark. |
| **CO-02** | **Duplicate Name** | Tạo nhiều thư mục trùng tên. | Sử dụng logic kiểm tra `slug` hoặc tên duy nhất cho mỗi `userId` trong Model. |
| **CO-03** | **Unauthorized Move** | Di chuyển bài viết vào một thư mục không thuộc sở hữu của mình. | Controller bắt buộc kiểm tra `ownerId` của `collectionId` trước khi thực hiện cập nhật. |

---
*Tài liệu được cập nhật dựa trên tiếp cận **MVC & Local-First** bởi **Tít dễ thương**.*
