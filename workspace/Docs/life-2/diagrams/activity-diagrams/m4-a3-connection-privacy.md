# M4-A3: Connection Privacy (Blocking) - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng chặn người dùng để bảo vệ không gian cá nhân và an toàn trên mạng xã hội.
> **Kiến trúc:** **MVC** (View - Controller/Service - Model).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Phát hiện hành vi quấy rối"]
        A2["Sử dụng menu 'Chặn người dùng'"]
        A10["Không còn thấy nội dung của người đó"]
    end

    subgraph View["🖥️ Frontend (View)"]
        B1["Nhận lệnh Block"]
        B2["Gửi Request POST /api/connections/block"]
        B3["Ẩn toàn bộ bài viết của người bị chặn khỏi UI"]
        B4["Điều hướng về trang chủ"]
    end

    subgraph ControllerService["⚙️ Backend (Controller/Service)"]
        C1["Tiếp nhận yêu cầu Chặn"]
        C2["Hủy bỏ quan hệ Follow giữa 2 bên (nếu có)"]
        C3["Tạo bản ghi Block List"]
        C4["Ghi log lý do (nếu cần cho Moderation)"]
        C5["Xóa Cache News Feed của cả 2"]
    end

    subgraph Model["🗄️ Database (Model)"]
        D1["(Collection: Blocks)"]
        D2["(Collection: Connections)"]
    end

    %% Connections
    A2 --> B1
    B1 --> B2
    B2 --> C1
    C1 --> C2
    C2 <--> D2
    C2 --> C3
    C3 <--> D1
    C3 --> C4
    C4 --> C5
    C5 --> B3
    B3 --> A10
    B3 --> B4

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
| **Rào cản** | **Controller/Service** | Khi thực hiện Block, hệ thống tự động thực hiện **"Double Unfollow"** (A ngừng theo dõi B và ngược lại). |
| **Bảo lưu** | **Model** | Danh sách chặn được lưu trong collection `blocks` với các trường `blockerId` và `blockedId`. |
| **Hiệu lực tức thì** | **View** | Frontend sẽ chủ động lọc sạch dữ liệu người bị chặn khỏi bộ nhớ tạm (Cache/State) để người dùng không còn thấy họ ngay lập tức. |
| **Tác động News Feed** | **Controller/Service** | Việc xóa cache giúp luồng tổng hợp tin tức (M3-A1) loại trừ người bị chặn ngay trong phiên làm việc tiếp theo. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **CP-01** | **Circular Blocking** | User A chặn B, đồng thời B cũng chặn A. | Model đảm bảo mỗi cặp (A, B) có bản ghi độc lập, hành động của người này không ảnh hưởng đến trạng thái chặn của người kia. |
| **CP-02** | **One-way Visibility** | Người bị chặn vẫn thấy bài viết qua tag hoặc comment chung. | Tuyệt đối: Logic Fetching ở mọi module (M2, M3, M4) phải lồng thêm điều kiện `blockedIds`. |
| **CP-03** | **Unblocking UX** | Người dùng muốn bỏ chặn sau này. | Cung cấp màn hình "Danh sách đã chặn" trong cài đặt tài khoản để thực hiện Unblock (Xóa record trong `blocks`). |

---
*Tài liệu được cập nhật dựa trên tiếp cận **MVC & Local-First** bởi **Tít dễ thương**.*
