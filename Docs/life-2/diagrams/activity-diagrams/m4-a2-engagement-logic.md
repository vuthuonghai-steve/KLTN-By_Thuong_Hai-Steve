# M4-A2: Engagement Logic (Like/Comment) - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng xử lý tương tác trực tiếp của người dùng lên bài viết, đảm bảo tính realtime và nhất quán dữ liệu.
> **Kiến trúc:** **MVC** (View - Controller/Service - Model).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Xem bài viết trên Feed"]
        A2["Nhấp Like hoặc Gõ Comment"]
        A10["Thấy tương tác của mình đã hiện lên"]
    end

    subgraph View["🖥️ Frontend (View)"]
        B1["Nhận sự kiện Like/Comment"]
        B2["Gửi Request POST /api/engagement"]
        B3["Hiển thị Comment tạm thời<br/>(Optimistic UI)"]
        B4["Báo lỗi nếu không thể tương tác"]
    end

    subgraph ControllerService["⚙️ Backend (Controller/Service)"]
        C1["Tiếp nhận tương tác"]
        C2{"Loại tương tác?"}
        C3["Xử lý Like: Tăng/Giảm Like Count"]
        C4["Xử lý Comment: Lưu nội dung & Cấp bậc"]
        C5["Kiểm tra từ cấm trong Comment"]
        C6["Gửi thông báo Local (Triggers M6)"]
        C7["Trả về dữ liệu đã cập nhật"]
    end

    subgraph Model["🗄️ Database (Model)"]
        D1["(Collection: Posts)"]
        D2["(Collection: Comments)"]
        D3["(Collection: Likes)"]
    end

    %% Connections
    A1 --> A2
    A2 --> B1
    B1 --> B3
    B1 --> B2
    B2 --> C1
    C1 --> C2
    C2 -- "Like" --> C3
    C3 <--> D3
    C3 --> D1
    C2 -- "Comment" --> C4
    C4 <--> D2
    C4 --> C5
    C5 --> D1
    D1 --> C6
    C6 --> C7
    C7 --> B3
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
| **Optimistic UX** | **View** | Đối với Like và Comment, hệ thống ưu tiên hiển thị ngay lập tức để tạo cảm giác "Realtime" cho người dùng. |
| **Phân loại** | **Controller/Service** | Backend phân tách logic giữa Like (Toggle trạng thái) và Comment (Lưu trữ nội dung văn bản). |
| **Bảo mật nội dung** | **Controller/Service** | Các comment cũng được chạy qua bộ lọc Sanity check (giống bài viết) để đảm bảo không chứa từ ngữ độc hại. |
| **Gắn kết** | **Model** | Mọi tương tác đều tham chiếu đến `postId` gốc để sau này có thể truy vấn: "Ai đã Like bài này?" hoặc "Các bình luận của bài này là gì?". |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **EL-01** | **Spam Engagement** | User/Bot thực hiện Like/Comment liên tục với tần suất cao. | Áp dụng **Rate Limiting** (ví dụ: tối đa 60 tương tác/phút trên mỗi tài khoản). |
| **EL-02** | **Comment Ghosting** | Comment được lưu nhưng không hiện lên do lỗi Index. | Controller trả về Full Document của Comment sau khi lưu để Frontend render chính xác. |
| **EL-03** | **Deleted Post Interaction** | Tương tác vào một bài viết vừa bị xóa. | Backend kiểm tra trạng thái bài viết `status: 'published'` trước khi chấp nhận Like/Comment. |

---
*Tài liệu được cập nhật dựa trên tiếp cận **MVC & Local-First** bởi **Tít dễ thương**.*
