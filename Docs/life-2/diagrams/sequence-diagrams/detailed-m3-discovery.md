# Sequence Diagram: M3 - Discovery & Feed

> **Module:** Distribution
> **Mục tiêu:** Mô tả luồng tổng hợp dữ liệu, tìm kiếm và thuật toán xếp hạng bài viết.

---

## 🏗️ 1. Kịch bản: Tổng hợp News Feed (M3-A1)

Mô tả luồng tính toán điểm số (Ranking) dựa trên Time-decay và Engagement để hiển thị cho người dùng.

```mermaid
sequenceDiagram
    actor User
    participant Page as FeedPage
    participant Service as FeedService
    participant Payload
    participant DB as MongoDB (Agg Pipeline)

    User->>Page: Mở trang chủ
    Page->>Service: getHomeFeed(userId, page)
    activate Service
    
    Service->>Payload: payload.find({ collection: 'follows', follower: userId })
    Payload-->>Service: friendIds[]
    
    Service->>DB: aggregatePosts(friendIds, algorithmParams)
    activate DB
    Note right of DB: Logic: (Likes + Comments*2) / (Age + 1)^1.5
    DB->>DB: Sort by engagement score & createdAt
    DB-->>Service: sortedPosts[]
    deactivate DB
    
    Service-->>Page: FeedDTO[]
    deactivate Service
    Page-->>User: Render bài viết theo thứ tự "Hot"
```

---

## 🔍 2. Kịch bản: Truy vấn Search Engine (M3-A2)

Mô tả luồng sử dụng MongoDB Atlas Search để tìm kiếm Full-text.

```mermaid
sequenceDiagram
    actor User
    participant UI as SearchBar
    participant Service as SearchService
    participant Atlas as MongoDB Atlas Search
    participant Payload

    User->>UI: Nhập từ khóa "Next.js 15"
    UI->>UI: Throttling / Debounce
    UI->>Service: search(query, type: 'posts')
    activate Service
    
    Service->>Atlas: $search { text: { query, path: ['title', 'content'] } }
    activate Atlas
    Atlas-->>Service: matchedResults (scored)
    deactivate Atlas
    
    Service->>Payload: payload.find({ id__in: ids })
    Payload-->>Service: posts[]
    
    Service-->>UI: ResultList
    deactivate Service
    UI-->>User: Hiển thị kết quả tìm kiếm với Highlighting
```

---

## 💡 3. Kịch bản: Gợi ý bài viết Hot (Discovery - M3-A3)

Mô tả luồng hiển thị nội dung cho người dùng mới hoặc khám phá nội dung ngoài danh sách bạn bè.

```mermaid
sequenceDiagram
    actor Guest
    participant Page as DiscoveryPage
    participant Service as RecommendService
    participant Payload
    participant Cache as Redis (Optional)

    Guest->>Page: Mở tab "Khám phá"
    Page->>Service: getGlobalTrending()
    activate Service
    
    Service->>Cache: get('trending_posts')
    alt Cache Hit
        Cache-->>Service: trendingIds[]
    else Cache Miss
        Service->>Payload: payload.find({ sort: '-engagementScore', limit: 20 })
        Payload-->>Service: posts[]
        Service->>Cache: set('trending_posts', posts, ttl: 1h)
    end
    
    Service-->>Page: TrendingDTO[]
    deactivate Service
    Page-->>Guest: Render các bài viết đang viral
```

---
*Fidelity Note: Thuật toán Ranking được tích hợp trực tiếp vào Aggregation Pipeline của MongoDB để đảm bảo hiệu năng tối ưu cho MVP.* 🥰
