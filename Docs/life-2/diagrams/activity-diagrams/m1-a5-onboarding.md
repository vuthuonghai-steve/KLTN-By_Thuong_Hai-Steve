# M1-A5: Profile Onboarding Setup - Detailed Design

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Luồng thiết lập thông tin cơ bản ngay sau khi người dùng đăng nhập lần đầu tiên.
> **Kiến trúc:** B-U-E (Boundary-UseCase-Entity).

---

## 1. Sơ đồ Activity Diagram (Mermaid)

```mermaid
flowchart TD
    %% Swimlanes
    subgraph User["👤 Người dùng (Member)"]
        A1["Đăng nhập lần đầu"]
        A2["Thấy giao diện Onboarding"]
        A3["Upload Avatar & Nhập Bio"]
        A4["Chọn sở thích (Tags)"]
        A5["Nhấp 'Hoàn tất'"]
        A10["Truy cập News Feed"]
    end

    subgraph Boundary["🖥️ Giao diện (Frontend)"]
        B1["Check trạng thái user:<br/>isOnboarded?"]
        B2["Hiển thị Form Welcome"]
        B3["Xử lý Preview ảnh tại chỗ"]
        B4["Gửi Request PATCH /api/users/me"]
        B5["Điều hướng sang Trang chủ"]
    end

    subgraph UseCase["⚙️ Xử lý nghiệp vụ (Backend)"]
        C1["Nhận dữ liệu Profile"]
        C2["Xử lý lưu File Media (Local Storage)"]
        C3["Sanitize văn bản (Bio)"]
        C4["Cập nhật User Document"]
        C5["Đánh dấu isOnboarded = true"]
    end

    subgraph Entity["🗄️ Dữ liệu (Database)"]
        D1[(Collection: Users)]
        D2[(Collection: Media/Images)]
    end

    %% Connections
    A1 --> B1
    B1 -- "Chưa (false)" --> B2
    B2 --> A2
    A2 --> A3
    A3 --> A4
    A4 --> A5
    A5 --> B4
    
    B4 --> C1
    C1 --> C2
    C2 <--> D2
    C1 --> C3
    C3 --> C4
    C4 <--> D1
    C4 --> C5
    C5 --> B5
    
    B5 --> A10
    B1 -- "Rồi (true)" --> A10

    %% Styling
    style User fill:#fff5f8,stroke:#ff8caf
    style Boundary fill:#e8f4fd,stroke:#2196f3
    style UseCase fill:#f9f9f9,stroke:#333
```

---

## 2. Giải thích luồng hoạt động (Flow Explanation)

| Bước | Thành phần | Mô tả chi tiết |
|:---:|---|---|
| **Kích hoạt** | **Boundary** | Ngay sau Login, Frontend kiểm tra một Flag (ví dụ: `isOnboarded`). Nếu chưa, sẽ chặn người dùng vào News Feed cho đến khi xong Profile cơ bản. |
| **Xử lý Ảnh** | **UseCase/Entity** | Ảnh được upload lên server. Tên file được hash và lưu đường dẫn vào database. |
| **Sở thích** | **UseCase** | Việc chọn Tag lúc đầu giúp hệ thống gợi ý nội dung phù hợp ngay từ phiên làm việc đầu tiên (Mô hình Discovery). |
| **Kết thúc** | **UseCase** | Khi Flag `isOnboarded` chuyển sang `true`, người dùng sẽ không bao giờ thấy lại màn hình này nữa. |

---

## 3. Phân tích rủi ro (Risk Audit)

| ID | Rủi ro | Giải thích | Giải pháp |
|:---:|---|---|---|
| **OB-01** | **Bad Content** | Avatar hoặc Bio chứa nội dung nhạy cảm. | Gắn kết với M6 (Moderation) để admin kiểm duyệt sau đó. |
| **OB-02** | **File Bombing** | Upload ảnh dung lượng quá lớn làm treo server. | Frontend & Backend giới hạn dung lượng file (ví dụ: max 2MB). |
| **OB-03** | **UX Friction** | User cảm thấy phiền và muốn bỏ qua. | Thêm nút "Bỏ qua/Thiết lập sau" nếu mục tiêu là giữ chân người dùng thay vì bắt buộc 100%. |

---
*Tài liệu được biên soạn bởi **Tít dễ thương**.*
