# Module M3: Discovery & Feed - General Activity Diagrams (Level 1)

> **Persona:** Senior System Architect (Tít dễ thương)
> **Phạm vi:** Mô tả cách hệ thống phân phối nội dung và hỗ trợ người dùng khám phá (Search/Discovery).
> **Kiến trúc:** Tuân thủ Boundary-UseCase-Entity (B-U-E).

---

## 1. Sơ đồ hoạt động tổng quát (High-Level Flow)

Sơ đồ này mô tả hai luồng chính: Nhận tin (Feed) và Tìm kiếm (Discovery).

```mermaid
flowchart TD
    %% Nodes
    Start(["Truy cập trang chủ / Discovery"])
    
    A1{"Người dùng muốn gì?"}
    
    %% Feed Branch
    B1["M3-A1: Tổng hợp News Feed<br/>(Feed Assembler)"]
    B2["Lọc nội dung theo quan hệ & sở thích"]
    
    %% Discovery Branch
    C1["M3-A2: Truy vấn tìm kiếm<br/>(Search Engine Query)"]
    C2["M3-A3: Gợi ý nội dung mới<br/>(Discovery Recommendation)"]
    
    Display["Hiển thị danh sách kết quả"]
    End(["Kết thúc / Tương tác với nội dung"])

    %% Flow
    Start --> A1
    A1 -- "Xem tin" --> B1
    B1 --> B2
    B2 --> Display
    
    A1 -- "Tìm kiếm" --> C1
    C1 --> Display
    
    A1 -- "Khám phá mới" --> C2
    C2 --> Display
    
    Display --> End

    %% Styling
    style Start fill:#fff5f8,stroke:#ff8caf
    style End fill:#fff5f8,stroke:#ff8caf
    style B1 fill:#e8f4fd,stroke:#2196f3
    style C1 fill:#e8f4fd,stroke:#2196f3
    style C2 fill:#e8f4fd,stroke:#2196f3
```

---

## 2. Giải thích các giai đoạn chính (Stages Explanation)

| Giai đoạn | Vai trò | Trách nhiệm chính |
|:---:|---|---|
| **Feed Assembly** | `M3-A1` | Thu thập bài viết từ những người User đang theo dõi và các bài viết công khai có liên quan. |
| **Search Engine** | `M3-A2` | Sử dụng Atlas Search (Fuzzy search) để tìm kiếm Post, User hoặc Tag theo từ khóa. |
| **Recommendation** | `M3-A3` | Đề xuất những nội dung đang "Trending" hoặc phù hợp với sở thích trong Profile của người dùng. |

---

---

## 3. Thành phần Hạ tầng (Local Technical Stack)

Dựa trên kiến trúc **MVC**, hệ thống ưu tiên sử dụng tài nguyên nội tại (Local) để giải quyết các bài toán kỹ thuật:

1.  **Local Search Logic (Regex/Query)**: Sử dụng sức mạnh truy vấn của MongoDB và Regex để tìm kiếm nội dung, không phụ thuộc vào dịch vụ bên thứ 3.
2.  **Local Image Processor (Sharp)**: Tận dụng thư viện xử lý ảnh tại Backend để tạo thumbnail và nén ảnh ngay khi upload, lưu trữ trực tiếp trên Local Storage.
3.  **Local Database Indexing**: Tối ưu hóa hiệu năng bằng các bộ Index (Single/Compound) được thiết lập trực tiếp trong các Collection.

---
*Tài liệu được cập nhật dựa trên tiếp cận **MVC & Local-First** theo yêu cầu của yêu thương.*
