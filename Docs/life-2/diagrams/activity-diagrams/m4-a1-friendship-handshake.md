# M4-A1: Friendship Handshake - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng thiết lập và hủy bỏ mối quan hệ theo dõi (Follow/Unfollow) giữa các thành viên.
> **Kiến trúc:** **MVC** (View - Controller/Service - Model).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Truy cập Hồ sơ người dùng khác"]
        A2["Nhấp nút 'Follow' hoặc 'Unfollow'"]
        A10["Thấy trạng thái: Đang theo dõi / Theo dõi"]
    end

    subgraph View["🖥️ Frontend (View)"]
        B1["Nhận sự kiện Click"]
        B2["Gửi Request POST /api/connections/follow"]
        B3["Cập nhật UI nút bấm tức thì (Optimistic UI)"]
        B4["Hiển thị lỗi nếu Request thất bại"]
    end

    subgraph ControllerService["⚙️ Backend (Controller/Service)"]
        C1["Tiếp nhận yêu cầu Follow"]
        C2{"Đã tồn tại quan hệ?"}
        C3["Tạo bản ghi Connection mới"]
        C4["Xóa bản ghi Connection cũ"]
        C5["Cập nhật số Follower/Following của 2 User"]
        C6["Trả về kết quả thành công"]
    end

    subgraph Model["🗄️ Database (Model)"]
        D1["(Collection: Connections)"]
        D2["(Collection: Users)"]
    end

    %% Connections
    A1 --> A2
    A2 --> B1
    B1 --> B3
    B1 --> B2
    B2 --> C1
    C1 --> C2
    C2 -- "Chưa (Follow)" --> C3
    C3 <--> D1
    C2 -- "Rồi (Unfollow)" --> C4
    C4 <--> D1
    C3 --> C5
    C4 --> C5
    C5 <--> D2
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
| **Optimistic UI** | **View** | Để mang lại cảm giác mượt mà, Frontend sẽ đổi trạng thái nút Follow ngay lập tức trước khi nhận phản hồi từ Server. |
| **Logic đối xứng** | **Controller/Service** | Nếu đã Follow, hành động tiếp theo sẽ là Unfollow (Xóa record). Nếu chưa, sẽ là tạo mới record kết nối. |
| **Đồng bộ hóa số liệu** | **Controller/Service** | Backend chịu trách nhiệm tăng/giảm số lượng `followerCount` và `followingCount` trong document `User` tương ứng. |
| **Lưu trữ** | **Model** | Quan hệ được lưu trong collection `connections` với hai trường `followerId` và `followingId`. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **FH-01** | **Self-Follow** | Người dùng tìm cách tự theo dõi chính mình. | Controller kiểm tra `if (followerId === followingId)` và từ chối yêu cầu. |
| **FH-02** | **Race Condition** | Click liên tục nút Follow/Unfollow gây sai lệch số đếm. | Sử dụng các toán tử nguyên tử (Atomic operators) như `$inc` trong MongoDB thay vì ghi đè giá trị. |
| **FH-03** | **Connection Loop** | (Không áp dụng vì đây là quan hệ 1 chiều). | Hệ thống hỗ trợ quan hệ đơn phương (A follow B, B không nhất thiết follow A). |

---
*Tài liệu được cập nhật dựa trên tiếp cận **MVC & Local-First** bởi **Tít dễ thương**.*
