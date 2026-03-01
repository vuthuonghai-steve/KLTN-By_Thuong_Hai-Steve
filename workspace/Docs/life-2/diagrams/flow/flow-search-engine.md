# Flow Diagram: Tìm kiếm nội dung/người dùng/tag (UC12)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Gõ phím Enter trên Search Bar"])
    U2("Chọn tab: Posts / Users / Tags")
    U3(["Kết thúc: Hiện danh sách kết quả"])
    U4(["Kết thúc: Hiển thị Empty State<br/>(Không tìm thấy)"])
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1("Nhận URL params (q=..., type=...)")
    S2("Gọi /api/v1/search (Atlas Search Svc)")
    S3{"Phân loại Search (type)?"}
    S4("Full-text tìm Content")
    S5("Full-text tìm DisplayName/Username")
    S6("Tìm chính xác Tag name")
    S7{"Có kết quả?"}
    S8("Trả danh sách JSON array")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("MongoDB Atlas Search Engine (Fuzzy: max 2 chars)")
  end

  U1 --> S1
  U2 --> S1
  S1 --> S2 --> S3

  S3 -- "type=posts" --> S4 --> D1
  S3 -- "type=users" --> S5 --> D1
  S3 -- "type=tags"  --> S6 --> D1

  D1 --> S7
  S7 -- "Không" --> U4
  S7 -- "Có" --> S8 --> U3

  %% UC-ID: UC12
  %% Business Function: Tìm kiếm tổng hợp
```

## Assumptions
- Sử dụng trực tiếp MongoDB Atlas Search hoặc text index. Lớp API đóng vai trò định tuyến loại (type) content để route query Atlas cho chính xác.
