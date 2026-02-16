# M2-A3: Post Integrity & Tagging - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Kiểm soát chất lượng nội dung bài viết, tự động phân loại thông qua Hashtag và đảm bảo tính nhất quán của dữ liệu trước khi xuất bản.
> **Kiến trúc:** B-U-E (Boundary-UseCase-Entity).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    subgraph User["👤 Người dùng (Member)"]
        A1["Hoàn tất nội dung & Nhấp 'Đăng'"]
        A2["Nhận kết quả: Thành công / Thất bại"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Gửi Request POST /api/posts/publish"]
        B2["Hiển thị thông báo Validation lỗi"]
        B3["Điều hướng sang News Feed"]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Tiếp nhận dữ liệu xuất bản"]
        C2{"Nội dung trống?"}
        C3["Bóc tách #Hashtag bằng Regex"]
        C4["Kiểm tra từ cấm<br/>(Sanity Check)"]
        C5["Đồng bộ hóa Tags trong DB"]
        C6["Xác lập liên kết Post <-> Tags"]
        C7["Đổi trạng thái bài viết: 'published'"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1["(Collection: Posts)"]
        D2["(Collection: Tags)"]
    end

    %% Connections
    A1 --> B1
    B1 --> C1
    C1 --> C2
    C2 -- "Trống" --> B2
    C2 -- "Hợp lệ" --> C3
    C3 --> C4
    C4 -- "Vi phạm" --> B2
    C4 -- "Sạch" --> C5
    C5 <--> D2
    C5 --> C6
    C6 --> C7
    C7 <--> D1
    C7 --> B3
    B3 --> A2
    B2 --> A1

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style Boundary fill:#e8f4fd,stroke:#2196f3
    style UseCase fill:#f9f9f9,stroke:#333
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Kích hoạt** | **Boundary** | Gửi toàn bộ dữ liệu bài viết (Văn bản, Media IDs, Metadata) lên Server để thẩm định lần cuối. |
| **Bóc tách** | **UseCase** | Hệ thống tự động quét nội dung để tìm các ký tự bắt đầu bằng `#`. Ví dụ: `#kienthuc` sẽ được bóc tách làm Metadata. |
| **Phân loại** | **Entity** | Nếu Hashtag chưa tồn tại trong hệ thống, UseCase sẽ yêu cầu Entity tạo bản ghi mới trong collection `tags`. |
| **Cam kết** | **UseCase** | Chỉ khi vượt qua khâu kiểm tra từ cấm (Profanity filter), trạng thái bài viết mới được chuyển từ `draft` sang `published`. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **PI-01** | **Tag Flooding** | User gắn hàng trăm hashtag vào bài viết để spam. | Giới hạn số lượng hashtag tối đa trên mỗi bài viết (ví dụ: max 10 tags). |
| **PI-02** | **Bypass Filter** | Người dùng viết lách để né bộ lọc từ cấm (VD: dùng d.ấ.u c.ấ.m). | Sử dụng thuật toán Fuzzy Match hoặc NLP đơn giản để nhận diện biến thể của từ cấm. |
| **PI-03** | **Dead Links** | Gắn tag vào bài viết nhưng tag đó sau này bị xóa. | Sử dụng liên kết quan hệ (Relationship) và tự động xóa ID tag khỏi Post khi Tag bị xóa (Cascade deletion). |

---
*Tài liệu được biên soạn bởi **Tít dễ thương**.*
