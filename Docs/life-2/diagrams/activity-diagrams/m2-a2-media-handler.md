# M2-A2: Media Attachment Handler - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng tải lên và xử lý tệp tin đa phương tiện (ảnh/video), đảm bảo tối ưu dung lượng và tính toàn vẹn của dữ liệu.
> **Kiến trúc:** B-U-E (Boundary-UseCase-Entity).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Chọn ảnh/video từ thiết bị"]
        A2["Xem bản xem trước (Preview)"]
        A3["Nhấp 'Tải lên'"]
        A10["Thấy ảnh đã hiện trong bài viết"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Kiểm tra Client-side:<br/>Dung lượng < 5MB, Định dạng cho phép"]
        B2["Hiển thị thanh tiến trình (Progress Bar)"]
        B3["Gửi Multipart Request tới /api/media"]
        B4["Nhận trả về ID của Media"]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Tiếp nhận Multipart Stream"]
        C2["Kiểm tra MIME Type thực tế"]
        C3["Thực hiện Resize & Nén ảnh<br/>(Dùng thư viện Sharp)"]
        C4["Lưu tệp vào thư mục /public/media"]
        C5["Tạo bản ghi Media trong DB"]
        C6["Trả về JSON Doc với Media ID"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1["(Collection: Media)"]
        D2["(Collection: Posts - field mediaIds)"]
    end

    subgraph External["📂 Lưu trữ (File System)"]
        E1["/public/media/{hash-name}.webp"]
    end

    %% Connections
    A1 --> B1
    B1 -- "Không hợp lệ" --> A1
    B1 -- "Hợp lệ" --> A2
    A2 --> A3
    A3 --> B2
    B2 --> B3
    B3 --> C1
    C1 --> C2
    C2 -- "Trái phép" --> B3
    C2 -- "Hợp lệ" --> C3
    C3 --> C4
    C4 <--> E1
    C4 --> C5
    C5 <--> D1
    C5 --> C6
    C6 --> B4
    B4 --> D2
    D2 --> A10

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style Boundary fill:#e8f4fd,stroke:#2196f3
    style UseCase fill:#f9f9f9,stroke:#333
    style External fill:#fffde7,stroke:#fbc02d
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Kiểm tra đầu** | **Boundary** | Client chặn ngay các file quá nặng hoặc sai định dạng để tiết kiệm băng thông Server. |
| **Xử lý ảnh** | **UseCase** | Backend sử dụng `Sharp` để chuyển đổi ảnh sang định dạng `.webp` (tối ưu nhất cho web) và resize về các kích thước chuẩn. |
| **Lưu trữ** | **External** | Tệp tin thực tế được lưu vào hệ thống file cục bộ (Local Storage). Tên tệp được hash (SHA-256) dựa trên nội dung để tránh trùng lặp. |
| **Liên kết** | **Entity** | Sau khi có Media ID, Boundary sẽ thực hiện gắn ID này vào danh sách `attachments` của bài viết đang soạn thảo. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **MA-01** | **Storage Exhaustion** | Upload quá nhiều file rác gây đầy ổ cứng. | Áp dụng Quote giới hạn dung lượng trên mỗi User và tự động dọn dẹp các Media không được gắn vào bài viết nào sau 24h. |
| **MA-02** | **Malware Upload** | Hacker upload file thực thi giả dạng ảnh. | Kiểm tra Magic Numbers của file thay vì chỉ tin vào đuôi mở rộng (Extension). |
| **MA-03** | **Sensitive Data** | Ảnh chứa tọa độ GPS hoặc thông tin cá nhân trong EXIF. | Backend tự động xóa sạch GPS data và EXIF metadata khi xử lý ảnh. |

---
*Tài liệu được biên soạn bởi **Tít dễ thương**.*
