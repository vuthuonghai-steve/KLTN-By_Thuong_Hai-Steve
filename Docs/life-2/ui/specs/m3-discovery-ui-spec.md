# UI Screen Specification: M3 - Discovery & Feed

> **Mục đích:** Đặc tả thành phần UI và logic tương tác cho việc phân phối nội dung, tìm kiếm và khám phá bài viết.  
> **Traceability:** [Use Case M3], [detailed-m3-discovery.md], [m3-discovery-schema.yaml]

---

## 1. Screen Inventory (Danh sách màn hình)

| Screen ID | Tên màn hình | Mục tiêu | Actor |
|---|---|---|---|
| SC-M3-01 | Home Feed | Hiển thị bài viết từ bạn bè (Ranking) | Member |
| SC-M3-02 | Discovery Page | Khám phá bài viết Trending toàn cầu | Guest, Member |
| SC-M3-03 | Search Results | Hiển thị kết quả tìm kiếm Full-text | Guest, Member |

---

## 2. Detailed Screen Logic (Chi tiết từng màn hình)

### SC-M3-01 - Home Feed

#### A. UI Components & Data Mapping
Dựa trên **FeedDTO** và **Ranking Algorithm**

| UI Element ID | Type | Source | Required | Validation/Constraint |
|---|---|---|---|---|
| `feed-container` | List | `FeedService.getHomeFeed` | Yes | Infinite scroll |
| `post-card` | Component | `sc-m2-04` | Yes | Render theo rank score |
| `tab-switch-feed` | Tabs | N/A | Yes | "For You", "Following" |

#### B. Interaction Flow (M3-A1)
- **Ranking**: Bài viết được sắp xếp theo công thức `(Likes + Comments*2) / (Age + 1)^1.5`.
- **Pre-condition**: Phải login để xem "Following".

---

### SC-M3-03 - Search Results

#### A. UI Components & Data Mapping
Dựa trên **Atlas Search Results**

| UI Element ID | Type | Source | Required | Validation/Constraint |
|---|---|---|---|---|
| `search-input-global`| Input | `SearchService.search` | Yes | Debounce 300ms |
| `filter-type` | Select | `feedQuery.feedType` | No | posts, users, tags |
| `result-list` | List | `Atlas Search MatchedDocs`| Yes | Highlight matching text |

#### B. Interaction Flow (M3-A2)
- **Highlighing**: Các từ khóa khớp trong `title` và `content` được bao bọc bởi tag `<mark>`.

---

## 3. Mapping ID for Automation (UI Contract)

| UI ID | Semantic Name | Technical Binding |
|---|---|---|
| `feed-container` | Main News Feed | `data-testid="home-feed"` |
| `search-input-global`| Global Search | `id="global-search-input"` |
| `sc-m3-01` | Home Feed Page | `data-testid="sc-m3-01"` |
