# M2-A1: Rich-text Editor Pipeline - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Mô tả luồng xử lý soạn thảo văn bản phong phú, đảm bảo an toàn (XSS) và trải nghiệm soạn thảo mượt mà.
> **Kiến trúc:** B-U-E (Boundary-UseCase-Entity).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Nhập nội dung vào Editor"]
        A2["Sử dụng công cụ chọn format<br/>(Bold, Italic, Link...)"]
        A10["Thấy trạng thái: Đã lưu nháp"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Editor (Lexical/TipTap)<br/>bắt sự kiện thay đổi"]
        B2["Xử lý biến đổi Rich-text sang JSON<br/>(Lexical Nodes)"]
        B3{"Debounce (3s)?"}
        B4["Gửi Request PATCH /api/posts/draft"]
        B5["Hiển thị Spinner: Đang lưu..."]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Nhận Request lưu nháp"]
        C2["Xử lý Sanitize HTML/JSON<br/>(Chống XSS)"]
        C3["Phân tách nội dung & Metadata"]
        C4["Ghi đè bản nháp cũ của User"]
        C5["Trả về Success Response"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1["(Collection: Posts - status: draft)"]
    end

    %% Connections
    A1 --> B1
    A2 --> B1
    B1 --> B2
    B2 --> B3
    B3 -- "Chưa đủ" --> B1
    B3 -- "Đủ (3s)" --> B4
    B4 --> B5
    B4 --> C1
    C1 --> C2
    C2 --> C3
    C3 --> C4
    C4 <--> D1
    C4 --> C5
    C5 --> B5
    B5 --> A10

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
| **Soạn thảo** | **User** | Người dùng gõ văn bản và chèn các định dạng. Editor hoạt động ở chế độ thời gian thực. |
| **Xử lý ngầm** | **Boundary** | Hệ thống không gửi request mỗi lần gõ phím. Kỹ thuật **Debounce** được dùng để gộp các thay đổi trong 3 giây thành 1 lượt gửi duy nhất. |
| **Bảo mật** | **UseCase** | Backend bắt buộc phải chạy bộ lọc (Sanitizer) để loại bỏ các thẻ `<script>` hoặc thuộc tính nguy hiểm có thể gây lỗi XSS. |
| **Lưu trữ** | **Entity** | Bản nháp được lưu vào collection `posts` với trạng thái `draft` để người dùng có thể quay lại viết tiếp bất cứ lúc nào. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **CE-01** | **XSS Attack** | Hacker chèn mã độc vào nội dung rich-text. | Sử dụng thư viện `dompurify` hoặc validator của TipTap/Lexical ở cả Client và Server. |
| **CE-02** | **Conflict Draft** | Hai thiết bị cùng sửa 1 bản nháp. | Sử dụng timestamp hoặc cơ chế "Locking" (chỉ cho phép thiết bị mới nhất ghi đè). |
| **CE-03** | **Network Failure** | Đang lưu nháp thì mất mạng. | Tích hợp **LocalStorage** để lưu bản sao lưu dự phòng tạm thời tại máy người dùng. |

---
*Tài liệu được biên soạn bởi **Tít dễ thương**.*
