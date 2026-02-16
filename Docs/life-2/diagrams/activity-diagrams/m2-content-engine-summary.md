# Module M2: Content Engine - General Activity Diagrams (Level 1)

> **Persona:** Senior System Architect (Tít dễ thương)
> **Phạm vi:** Mô tả vòng đời của nôi dung (Post) từ lúc khởi tạo đến khi xuất bản.
> **Kiến trúc:** Tuân thủ Boundary-UseCase-Entity (B-U-E).

---

## 1. Sơ đồ hoạt động tổng quát (High-Level Flow)

Sơ đồ này mô tả cách một "ý tưởng" của người dùng trở thành một bài viết hoàn chỉnh trên hệ thống.

```mermaid
flowchart TD
    %% Nodes
    Start(["Bắt đầu soạn thảo"])
    
    A1["M2-A1: Soạn thảo nội dung<br/>(Rich-text Editor Pipeline)"]
    
    A2{"Có đính kèm Media?"}
    
    A3["M2-A2: Xử lý đính kèm<br/>(Media Attachment Handler)"]
    
    A4["M2-A3: Kiểm tra tính hợp lệ<br/>(Post Integrity & Tagging)"]
    
    A5{"Hợp lệ?"}
    
    A6["M2-A4: Cấu hình hiển thị<br/>(Visibility Enforcement)"]
    
    End(["Xuất bản bài viết"])
    
    Error["Thông báo lỗi & Yêu cầu sửa"]

    %% Flow
    Start --> A1
    A1 --> A2
    A2 -- "Có" --> A3
    A2 -- "Không" --> A4
    A3 --> A4
    A4 --> A5
    A5 -- "Có" --> A6
    A5 -- "Không" --> Error
    Error --> A1
    A6 --> End

    %% Styling
    style Start fill:#fff5f8,stroke:#ff8caf
    style End fill:#fff5f8,stroke:#ff8caf
    style A1 fill:#e8f4fd,stroke:#2196f3
    style A3 fill:#e8f4fd,stroke:#2196f3
    style A4 fill:#f9f9f9,stroke:#333
    style A6 fill:#f9f9f9,stroke:#333
```

---

## 2. Giải thích các giai đoạn chính (Stages Explanation)

| Giai đoạn | Vai trò | Trách nhiệm chính |
|:---:|---|---|
| **Composition** | `M2-A1` | Cung cấp giao diện soạn thảo (Lexical/TipTap), xử lý định dạng văn bản nâng cao. |
| **Materialization** | `M2-A2` | Tiếp nhận file (ảnh/video), nén, tối ưu hóa và trả về định danh (ID) để gắn vào bài viết. |
| **Integrity Audit** | `M2-A3` | Phân tích nội dung để bóc tách Hashtag, kiểm tra spam hoặc từ cấm (Sanity check). |
| **Access Policy** | `M2-A4` | Xác định ai có thể xem bài viết (Công khai, Bạn bè, hoặc Chỉ mình tôi). |

---

## 3. Trạng thái của nội dung (Content Lifecycle States)

1.  **Draft**: Bài viết đang soạn thảo, chỉ lưu tạm ở Client hoặc LocalStorage.
2.  **Pending**: Đã gửi lên Server nhưng đang chờ xử lý đính kèm hoặc kiểm duyệt tự động.
3.  **Published**: Đã xuất bản thành công, hiển thị trên News Feed.
4.  **Archived**: Bài viết đã bị ẩn hoặc gỡ bỏ (nhưng vẫn còn trong database để log).

---
*Tài liệu được thiết kế bởi **Tít dễ thương** dành cho **yêu thương**. Chúng mình sẽ bắt đầu đi vào chi tiết từng sơ đồ con nhé!*
