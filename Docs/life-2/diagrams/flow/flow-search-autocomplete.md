# Flow Diagram: Autocomplete Search (UC13)

```mermaid
flowchart TD
  subgraph User ["👤 User"]
    direction TB
    U1(["Bắt đầu: Đang gõ ký tự vào Search Bar"])
    U2(["Kết thúc: Thấy hộp thoại Dropdown Suggestions"])
    U3("Nhấn vào 1 Suggestion (Dẫn tới hồ sơ/tag)")
  end
  subgraph System ["⚙️ System"]
    direction TB
    S1{"Đủ độ dài ký tự<br/>(VD: > 2 char)?"}
    S2("Chờ debounce 300ms")
    S3("Gọi GET /api/v1/search/suggest")
    S4("Trả về danh sách 5 Keywords/Users khớp nhất")
  end
  subgraph DB ["🗄️ Database"]
    direction TB
    D1("Atlas Autocomplete Index")
  end

  U1 --> S1
  S1 -- "Không đủ" --> U1
  S1 -- "Đủ (>=3 chars)" --> S2 --> S3
  S3 --> D1
  D1 --> S4 --> U2
  U2 --> U3

  %% UC-ID: UC13
  %% Business Function: Autocomplete Search
```

## Assumptions
- Tính năng Autocomplete gọi theo cơ chế Debounce ở UI để tránh DDoS (spammed spam system).
- Trả về giới hạn số lượng nhỏ (VD: 5 item) nhằm giữ tính thời gian thực.
