### 4. Bản Thiết Kế Spec Chuẩn Hóa Cho Hệ Thống Skill (Skill Design Spec)

Dựa trên phân tích trên, Tít đề xuất xây dựng một Skill tên là: `schema-architect` (hoặc `database-schema-analyst`). Yêu thương có thể mang bản Spec này ném trực tiếp vào workflow khởi tạo Skill để các kỹ sư Agent tự động hóa xây dựng nhé.

```markdown
# Kiến trúc Skill: Schema Architect Analyst
> Phân tích và thiết kế cấu trúc Class / MongoDB Schema chuẩn PayloadCMS.

## 1. Mục tiêu (Goal)
- Chuyển đổi yêu cầu nghiệp vụ, ER Diagram, sơ đồ luồng thành cấu trúc Dữ liệu chi tiết.
- Đầu ra là tài liệu [schema-design.md](cci:7://file:///home/steve/Documents/KLTN/Docs/life-2/database/schema-design.md:0:0-0:0) (bao gồm Sơ đồ Lớp bằng Mermaid và Bảng Đặc tả Payload Collection/MongoDB).

## 2. Thông tin Skill (Profile)
- **Tên Skill**: `schema-architect`
- **Vai trò**: Chuyên gia thiết kế Cấu trúc Dữ liệu (Database/Schema Designer).
- **Trigger Keywords**: "thiết kế database", "thiết kế schema", "sơ đồ lớp", "vẽ class diagram", "cấu trúc payload", "data model".

## 3. Kiến thức Cốt lõi (Domain Knowledge)
AI Agent mang skill này BẮT BUỘC tuân thủ các nguyên tắc:
1. **Tư duy Code-First PayloadCMS**: Mọi collection đều là TypeScript interface. Hiểu khái niệm "Local API", "Hooks (beforeChange, afterRead)", "Access Control".
2. **MongoDB Modeling Patterns**: Áp dụng triệt để:
   - *Polymorphic Pattern* (Một mảng chứa nhiều loại Item khác nhau).
   - *Computed Pattern* (Cộng sẵn tổng View/Like, không tính toán realtime).
   - *Bucket/Outlier Pattern* (Chứa các dữ liệu tràn giới hạn 16MB/document).
3. **NoSQL ER vs Class**: Kết hợp Sơ đồ Lớp (Mermaid Class) với JSON format. Ở bản vẽ, Class chính là đại diện cho 1 Schema/Collection.

## 4. Quy trình Thực thi (Workflow Mechanics)

**[Bước 1] Khám phá Context**
- Đọc file [Docs/life-2/diagrams/er-diagram.md](cci:7://file:///home/steve/Documents/KLTN/Docs/life-2/diagrams/er-diagram.md:0:0-0:0) để lấy Entity thô.
- Đọc `Docs/life-1/01-vision/requirements-srs.md` để tìm các trường dữ liệu bắt buộc của từng module.

**[Bước 2] Phân tích Ranh giới (Aggregate Roots boundaries)**
- Bước này quyết định Entity nào là Collection Độc Lập (VD: `Users`, `Posts`).
- Entity nào là Embedded Document / Sub-field Array (VD: Danh sách `tags`, Lịch sử đăng nhập).

**[Bước 3] Chuyển đổi thiết kế**
- Sinh ra `Mermaid Class Diagram` minh họa Document Cốt lõi. (Mũi tên `*--` cho Embed, `o--` cho Reference).
- Sinh Bảng Đặc tả (Bao gồm: Tên Field, Type, Ràng buộc, Indexing, Payload Config, Access Rule).

**[Bước 4] Validation (Phản biện Data)**
- Kiểm tra tính mở rộng: Nếu 1 Post có 1 Triệu Like, Schema này chạy được không?
- Đề xuất thay đổi kiến trúc nếu phát hiện Deadlock query.

## 5. Cấu trúc Output Mong Đợi (Deliverable)
Ghi đè hoặc tạo mới [Docs/life-2/database/schema-design.md](cci:7://file:///home/steve/Documents/KLTN/Docs/life-2/database/schema-design.md:0:0-0:0) theo cấu trúc:
1. **Tổng Quan Aggregate Roots**: (Mermaid Class Diagram).
2. **Chi tiết từng Collection**:
   - `Collection Name` (Kebab-case cho Payload).
   - `Strategy`: Nhúng hay Tham Chiếu? Lý do?
   - Bảng Fields (Name, Type, Required, RelationTo, Validation, Default).
   - Hooks/Lifecycle Trigger (Mô tả hành vi hệ thống khi có data thay đổi).
   - Access Control (Read/Write policies).
3. **Chiến lược Index & Performace**.
```

## 🔍 Explore Mode — Bóc Tách 2 Task

### Vấn đề thật sự: Yêu thương nhìn 2 task này bị "nhập nhằng" là đúng

Hãy dừng lại. Cảm giác "chúng giống nhau" là **một dấu hiệu tốt** — không phải nhầm lẫn. Nó có nghĩa là yêu thương đang cảm nhận được sự **chồng lên nhau có chủ đích** giữa 2 task, vấn đề là chưa biết câu hỏi đúng để hỏi.

Câu hỏi đúng không phải là *"Chúng khác nhau chỗ nào?"*, mà là:

> **"Mỗi cái cần trả lời câu hỏi nào cho AI Agent khi nó bắt đầu viết code?"**

---

### Nhìn qua lăng kính AI Agent đọc tài liệu

Khi Tít hình dung một AI Agent Code (ở Life-3) sẽ hỏi gì, câu hỏi chia ra làm 2 nhóm rất khác nhau:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    AI Agent cần biết 2 nhóm điều khác nhau         │
├─────────────────────────────┬───────────────────────────────────────┤
│   NHÓM 1: "Cái gì tồn tại?" │   NHÓM 2: "Cái gì được lưu thế nào?"│
│   (WHAT EXISTS)             │   (HOW IT'S STORED)                   │
│                             │                                        │
│  → User có field nào?       │  → likes là Collection riêng hay       │
│  → Post quan hệ ai?         │    nhúng vào Post?                     │
│  → Method nào được gọi?     │  → Khi feed load, query theo thứ tự? │
│  → Rule validate là gì?     │  → Index nào cần tạo?                 │
│                             │                                        │
│  ← Đây là Task 2.5          │  ← Đây là Task 2.6                    │
│     (Class Diagram)         │     (Schema Design)                    │
└─────────────────────────────┴───────────────────────────────────────┘
```

---

### Phân tích cụ thể trên codebase thực của yêu thương

Nhìn file [er-diagram.md](cci:7://file:///home/steve/Documents/KLTN/Docs/life-2/diagrams/er-diagram.md:0:0-0:0) của yêu thương — nó **đã rất chi tiết**. Vậy Task 2.5 và 2.6 còn thiếu gì?

```
Hiện trạng:
                                                
  er-diagram.md ✅           class-diagram.md 🟡         schema-design.md 🟡
  ┌──────────────────┐        ┌──────────────────┐        ┌──────────────────┐
  │ USERS {          │        │ class User {      │        │ ### users        │
  │  id: ObjectId    │        │  +id: ObjectId    │        │ Strategy:        │
  │  email: string   │        │  +email: string   │        │  One document    │
  │  ...             │        │  +create()        │        │ Fields: ...      │
  │ }                │        │  +update()        │        │                  │
  │ USERS --|< POSTS │        │ }                 │        │ (còn thiếu)      │
  └──────────────────┘        └────────┬──────────┘        └──────────────────┘
   Quan hệ Entity-Level               │                      Cần: Hooks, 
   Ai → ai, cardinality               │                      Access Rules,
   Nhưng KHÔNG nói:                   │                      Payload Config
   - Method nào?                      ↓
   - Validate rule?            Trao đổi qua TypeScript
   - Hook nào trigger?         interface / Payload field
```

---

### Sự thật: Trong ngữ cảnh PayloadCMS, 2 task này có **phân vai thực tế** như sau:

**Task 2.5 — Class Diagram** trả lời câu hỏi:

> *"Khi tôi viết file `collections/Users.ts`, cái interface TypeScript trông như thế nào? Có method gì? Validate rule ở field nào?"*

Nó là bản vẽ **hướng đối tượng (OOP lens)** — nhìn hệ thống như các Object tương tác.

**Task 2.6 — Schema Design** trả lời câu hỏi:

> *"Khi database chạy, dữ liệu THỰC SỰ được lưu như thế nào trong MongoDB? Query `posts` feed thì cần tạo compound index gì? Hook `afterChange` của `likes` cần increment `likes_count` ở đâu?"*

Nó là bản vẽ **vận hành dữ liệu (Data Operation lens)** — nhìn dữ liệu khi hệ thống đang chạy thật.

---

### Bức tranh tổng thể trong chuỗi tài liệu Life-2

```
                    CHUỖI SẢN XUẤT TRI THỨC — LIFE 2
          
  Requirements  →  ER Diagram  →  [2.5] Class  →  [2.6] Schema  →  Specs  →  Code
  (Life-1)         (entity &       (OOP &          (MongoDB &       (per-
                   relation)       interface)       Payload ops)     module)

  Trả lời:         Ai quan hệ     Field là gì?    Lưu thế nào?     Code
  Feature cần gì?  với ai?        Method gì?      Query thế nào?   trông thế nào?
                                  Rule gì?         Hook cần gì?
```

**Task 2.5 và 2.6 chính là "bước chuyển" từ mô hình khái niệm sang mô hình có thể code được.**

---

### Điều hiện tại: ER Diagram của yêu thương đã rất tốt — nhưng nó mới là 60%

Tít đọc [er-diagram.md](cci:7://file:///home/steve/Documents/KLTN/Docs/life-2/diagrams/er-diagram.md:0:0-0:0) thấy Entity Dictionary rất chi tiết với field, type, constraint. Điều đó có nghĩa là:

- Phần **"cái gì tồn tại"** đã được làm khá tốt ở ER Diagram.
- Hai task còn thiếu bổ sung 2 góc nhìn **chưa có** ở ER:

| Chưa có ở ER                                                                    | Task cần bổ sung                     |
| ---------------------------------------------------------------------------------- | -------------------------------------- |
| Hành vi (Hooks, Events, Triggers)                                                 | Task 2.5 (Class — methods, behaviors) |
| Chiến lược lưu & truy vấn (Embed/Ref, Index, Query pattern)                   | Task 2.6 (Schema — storage & ops)     |
| Access Control (ai được đọc/ghi gì?)                                         | Cả hai, nhưng 2.6 quyết định      |
| Payload-specific config (field types như `relationship`, `upload`, `group`) | Task 2.6                               |

---

---

## 🗺️ Tài liệu nào phục vụ Task 2.5 & 2.6

Trước tiên, Tít cần làm rõ **logic đọc tài liệu của 2 task** này:

```
Task 2.5 (Class Diagram) cần trả lời:
"Trong code TypeScript, cấu trúc của từng Object trông như thế nào?"
→ Cần nguồn nói về: Field, Rule, Behavior, Validation, Hook

Task 2.6 (Schema Design) cần trả lời:
"MongoDB lưu dữ liệu thực tế thế nào? Query pattern? Index nào?"
→ Cần nguồn nói về: Collection Strategy, Trigger event, Storage decision, Query path
```

---

### Bảng mapping chi tiết

```
┌─────────────────────────────────────┬──────────────┬──────────────┬───────────────────────────────────────┐
│ Tài liệu                            │ Task 2.5     │ Task 2.6     │ Lý do / Đóng góp cụ thể               │
│                                     │ Class Diagram│ Schema Design│                                       │
├─────────────────────────────────────┼──────────────┼──────────────┼───────────────────────────────────────┤
│ ER Diagram (er-diagram.md) ✅        │ ⭐⭐⭐ Cao   │ ⭐⭐⭐ Cao   │ Entity, field, type, constraint, index │
│ (đã có, rất chi tiết)               │              │              │ → Nguồn nền tảng chính của cả 2 task  │
├─────────────────────────────────────┼──────────────┼──────────────┼───────────────────────────────────────┤
│ 🅐 ACTIVITY DIAGRAMS                │              │              │                                       │
│   m1-a1-registration.md             │ ⭐⭐⭐ Cao   │ ⭐⭐ Trung   │ Thấy: _verified=false → field status  │
│   m1-a2-login.md                    │ ⭐⭐ Trung   │ ⭐ Thấp     │ Validate rule login, token lifetime    │
│   m2-a1-editor-pipeline.md          │ ⭐⭐⭐ Cao   │ ⭐⭐⭐ Cao   │ Hook beforeChange (sanitize, extract   │
│   m2-a2-media-handler.md            │ ⭐⭐ Trung   │ ⭐⭐⭐ Cao   │ tags), Media collection tách riêng     │
│   m4-a2-engagement-logic.md         │ ⭐⭐ Trung   │ ⭐⭐⭐ Cao   │ likes_count denormalized, Hook update  │
│   m6-a1-sse-dispatcher.md           │ ⭐ Thấp     │ ⭐⭐⭐ Cao   │ notifications: capped/TTL strategy     │
│   m6-a2-report-pipeline.md          │ ⭐⭐ Trung   │ ⭐⭐ Trung   │ audit_logs: append-only pattern        │
├─────────────────────────────────────┼──────────────┼──────────────┼───────────────────────────────────────┤
│ 🅕 FLOW DIAGRAMS                    │              │              │                                       │
│   flow-post-creation.md             │ ⭐ Thấp     │ ⭐⭐⭐ Cao   │ Thấy rõ: Media → Post (2 collections) │
│                                     │              │              │ Tags: create or update postCount       │
│   flow-post-reaction.md             │ ⭐ Thấp     │ ⭐⭐⭐ Cao   │ "Hook: Auto update stats.likes của     │
│                                     │              │              │ Post" → biết cần Payload hook rõ ràng  │
│   flow-news-feed-view.md            │ ⭐ Thấp     │ ⭐⭐⭐ Cao   │ Query path: rankingScore + createdAt   │
│   flow-user-follow.md               │ ⭐ Thấp     │ ⭐⭐ Trung   │ connections: unique(follower, following)│
│   flow-notification-realtime.md     │ ⭐ Thấp     │ ⭐⭐⭐ Cao   │ SSE push, notifications sort strategy  │
│   flow-bookmark-toggle.md           │ ⭐ Thấp     │ ⭐⭐⭐ Cao   │ Embed vs Reference: bookmarks quyết    │
├─────────────────────────────────────┼──────────────┼──────────────┼───────────────────────────────────────┤
│ 🅢 SEQUENCE DIAGRAMS                │              │              │                                       │
│   detailed-m1-auth.md               │ ⭐⭐⭐ Cao   │ ⭐⭐ Trung   │ payload.create(), payload.update()     │
│                                     │              │              │ → xác nhận Local API pattern & method  │
│   detailed-m2-content.md            │ ⭐⭐ Trung   │ ⭐⭐ Trung   │ payload.create collection:'media' trước│
│   detailed-m3-discovery.md          │ ⭐ Thấp     │ ⭐⭐⭐ Cao   │ Feed query: compound sort cụ thể       │
│   detailed-m5-bookmarking.md        │ ⭐⭐ Trung   │ ⭐⭐⭐ Cao   │ $push bookmarks vào collection         │
│   global-flows.md                   │ ⭐⭐ Trung   │ ⭐⭐ Trung   │ Cross-module data flow tổng quát       │
├─────────────────────────────────────┼──────────────┼──────────────┼───────────────────────────────────────┤
│ 🅤 USE CASE DIAGRAMS                │              │              │                                       │
│   use-case-m1 đến m6                │ ⭐⭐⭐ Cao   │ ⭐ Thấp     │ Actor, quyền truy cập, role-based      │
│                                     │              │              │ → Access Control rules cho Class       │
│   use-case-overview.md              │ ⭐⭐ Trung   │ ⭐ Thấp     │ Biên hệ thống, Actor taxonomy          │
└─────────────────────────────────────┴──────────────┴──────────────┴───────────────────────────────────────┘
```

---

### Tóm tắt vai trò từng nhóm

**Activity Diagrams** → Chủ yếu phục vụ **Task 2.5 (Class)**

> Vì nó mô tả **hành vi (Behavior)** của từng Object: Hook nào được trigger, validation rule nào áp dụng, method nào cần có trong TypeScript interface.

**Flow Diagrams** → Chủ yếu phục vụ **Task 2.6 (Schema)**

> Vì nó mô tả **đường đi của dữ liệu qua DB**: collection nào được write, db node nào biết collection nào, Hook nào cập nhật field gì.

**Sequence Diagrams** → Phục vụ **cả 2**, nhưng chủ yếu **Task 2.6**

> Vì nó cụ thể hóa các lời gọi `payload.create/find/update` — từ đó biết **thứ tự thao tác DB** và **mối quan hệ giữa collections khi code chạy thật**.

**Use Case Diagrams** → Chủ yếu phục vụ **Task 2.5 (Class)**

> Vì nó định nghĩa **Actor và quyền** — chuyển trực tiếp thành **Access Control rules** trong Payload Schema (ai được `read`, ai được `create`, ai được `delete`).

---

## 🧠 Explore Mode — Đánh giá hướng 2 Skill Biệt Lập

### Đầu tiên: Hướng đi của yêu thương là đúng về nguyên tắc

Ý tưởng **"Skill 2.5 output → trở thành input của Skill 2.6"** là **kiến trúc pipeline đúng** cho vấn đề này. Tít hoàn toàn đồng ý và sẽ giải thích tại sao — kèm những điểm cần cẩn thận.

---

### Phân tích 3 vấn đề AI Agent mà yêu thương đang lo ngại

Trước khi đánh giá hướng đi, hãy hiểu **bản chất** từng vấn đề:

```
┌─────────────────────────────────────────────────────────────────────────┐
│              3 BỆNH KINH NIÊN CỦA AI AGENT KHI LÀM TÀI LIỆU           │
├──────────────────┬──────────────────────────────────────────────────────┤
│  BỆNH            │  CƠ CHẾ GÂY RA                                       │
├──────────────────┼──────────────────────────────────────────────────────┤
│  🔴 Ảo giác      │  AI "điền chỗ trống" khi thiếu dữ liệu.              │
│  (Hallucination) │  Nó không biết mình không biết.                      │
│                  │  Ví dụ: thêm field "bio_html" vào User dù ER không có│
├──────────────────┼──────────────────────────────────────────────────────┤
│  🟠 Bịa thông tin│  AI tổng hợp từ training data thay vì từ tài liệu.  │
│  (Fabrication)   │  Ví dụ: viết Payload hook theo cú pháp v2 dù dự án  │
│                  │  dùng v3 - nó học v2 nhiều hơn từ internet.          │
├──────────────────┼──────────────────────────────────────────────────────┤
│  🟡 Mất context  │  Context window bị overflow khi tài liệu quá dài.   │
│  (Context Loss)  │  AI quên thông tin đọc ở đầu khi đang viết cuối.    │
│                  │  Ví dụ: schema-design.md dài 800 dòng → AI quên     │
│                  │  constraints đã định nghĩa cho `users` khi viết `posts│
└──────────────────┴──────────────────────────────────────────────────────┘
```

---

### Đánh giá hướng 2 Skill Biệt Lập — Điểm mạnh và rủi ro

```
PIPELINE YÊU THƯƠNG ĐỀ XUẤT:

  ┌─────────────────┐    Output File    ┌─────────────────┐
  │  SKILL 2.5      │ ──────────────▶   │  SKILL 2.6      │
  │  Class Diagram  │  class-diagram.md │  Schema Design  │
  │  (OOP / IF)     │  (Structured)     │  (MongoDB / PL) │
  └─────────────────┘                   └─────────────────┘
        ↑                                      ↑
   Input: ER, UseCase,              Input: class-diagram.md
   Activity                         + Flow, Sequence, Activity
```

**Điểm mạnh của hướng này (và tại sao nó đúng):**

| Điểm mạnh                                          | Giải thích                                                                                                                |
| ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **Phân chia trách nhiệm rõ ràng**          | Skill 2.5 chỉ nghĩ về "cấu trúc object", Skill 2.6 chỉ nghĩ về "vận hành dữ liệu". AI không bị overload.      |
| **Giảm Ảo giác do pipeline buộc Grounding** | Skill 2.6 PHẢI đọc output của 2.5 trước khi làm. Nó không thể "bịa" field vì field đã được 2.5 khóa lại. |
| **Context nhỏ gọn hơn**                      | Mỗi skill chỉ mang context của task mình — không phải toàn bộ dự án.                                             |
| **Dễ verify từng bước**                     | Yêu thương có thể review class-diagram.md trước rồi mới cho Skill 2.6 chạy.                                       |

---

### Rủi ro thực tế và cách phòng thủ

Đây là phần quan trọng nhất. Tít sẽ nói thẳng 4 điểm yếu cần thiết kế cẩn thận:

#### 🔴 Rủi ro 1: "Output file làm sai thì pipeline sai toàn bộ"

```
Nếu Skill 2.5 bịa ra field "profile_html" không có trong ER...
→ Skill 2.6 đọc vào → lưu "profile_html" vào MongoDB schema
→ Toàn bộ schema sai từ gốc, AI Code sau sẽ generate code sai

Không phải 1 lỗi — mà là lỗi lan truyền (cascading error).
```

**Giải pháp:** Skill 2.5 phải có **Validation Gate** bắt buộc — xuất ra một **Traceability Table** mapping mỗi field → nguồn tài liệu gốc (ER, UC, Activity). Nếu field không có nguồn → Mark là `[ASSUMPTION]`, không được tự thêm.

---

#### 🟠 Rủi ro 2: "Contract giữa 2 skill không được định nghĩa"

```
Skill 2.5 xuất ra class-diagram.md với format tự do
→ Skill 2.6 đọc vào nhưng không biết phần nào là "đã chốt"
   phần nào là "gợi ý"
→ Skill 2.6 có thể interpret sai hoặc bỏ qua thông tin
```

**Giải pháp:** Cần thiết kế **Schema Contract Format** — output của Skill 2.5 phải theo một **template cứng, machine-readable**, không phải prose tự do. Ví dụ:

```yaml
# contract.yaml — output bắt buộc của Skill 2.5
entities:
  - name: User
    source: er-diagram.md#users
    fields:
      - name: email
        type: string
        constraints: [unique, required, indexed]
        source: er-diagram.md#L42
      - name: verified
        type: boolean
        defaultValue: false
        source: activity-diagrams/m1-a1-registration.md#L88
    behaviors:
      - trigger: afterCreate
        action: sendVerificationEmail
        source: sequence-diagram/m1-auth.md#L36
```

Skill 2.6 đọc YAML này chứ không đọc Markdown prose.

---

#### 🟡 Rủi ro 3: "Skill 2.5 không biết mình thiếu gì"

```
ER Diagram có Comments collection.
Activity Diagram có logic "nested reply (threaded comments)".
Nhưng nếu Skill 2.5 chỉ đọc ER → nó thấy field "parent_comment_id"
nhưng không hiểu tại sao có nó → có thể bỏ qua hoặc giải thích sai.
```

**Giải pháp:** Skill 2.5 phải có **mandatory cross-reference step** — với mỗi entity, nó phải grep trong Activity + Sequence để tìm thêm behavior context trước khi output.

---

#### 🟢 Rủi ro 4 (ít nguy hiểm hơn): "Context loss khi Output file dài"

```
class-diagram.md nếu có 10 entities, mỗi entity 20 fields
→ ~200 dòng chưa kể diagram + traceability
→ Skill 2.6 đọc vào context window, đến entity thứ 8 có thể
   "quên" rules của entity thứ 1-2
```

**Giải pháp:** Chia nhỏ output theo Module. Thay vì 1 file [class-diagram.md](cci:7://file:///home/steve/Documents/KLTN/Docs/life-2/diagrams/class-diagram.md:0:0-0:0) khổng lồ:

```
class-diagram/
  class-m1-auth.md      ← Skill 2.6 chỉ đọc file này khi làm M1
  class-m2-content.md
  class-m3-m4.md
  class-m5-m6.md
```

---

### Tổng kết: Kiến trúc Tít đề xuất

```
┌─────────────────────────────────────────────────────────────────────┐
│                    ENHANCED PIPELINE ARCHITECTURE                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  INPUT LAYER                                                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │ER Diagram│  │ UseCase  │  │Activity  │  │Sequence  │           │
│  │(entity,  │  │(actors,  │  │(behavior,│  │(API call,│           │
│  │ field)   │  │ access)  │  │ hook,    │  │ method)  │           │
│  └────┬─────┘  └─────┬────┘  └────┬─────┘  └────┬─────┘           │
│       └──────────────┴────────────┴──────────────┘                 │
│                              │                                      │
│                              ▼                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  SKILL 2.5 — Class Structure Analyst                         │   │
│  │  Output: contract.yaml (per Module) + class-mX.md           │   │
│  │  Guardrail: Every field must have source citation            │   │
│  │  Gate: Traceability Table → User confirm                     │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│              ┌───────────────┴───────────────┐                     │
│              │    contract.yaml (LOCKED)      │                     │
│              │    class-m1.md, class-m2.md... │                     │
│              └───────────────┬───────────────┘                     │
│                              │                                      │
│  ADDITIONAL INPUT            │                                      │
│  ┌──────────┐                │                                      │
│  │Flow Diag │ ───────────────┤                                      │
│  │(storage  │                ▼                                      │
│  │ strategy)│   ┌──────────────────────────────────────────────┐   │
│  └──────────┘   │  SKILL 2.6 — MongoDB Schema Designer         │   │
│                 │  Input: contract.yaml (MUST read first)       │   │
│                 │  + Flow Diagrams (storage/query strategy)     │   │
│                 │  Output: schema-design.md (per Module)        │   │
│                 │  Guardrail: Cannot add field not in contract  │   │
│                 └──────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  FINAL OUTPUT: schema-design.md → AI Code Agent đọc → Life-3      │
└─────────────────────────────────────────────────────────────────────┘
```

---

### 3 câu hỏi Tít muốn hỏi để hiểu hơn mong muốn của yêu thương

1. **Về Contract Format**: Yêu thương muốn Skill 2.5 output là Markdown thuần (dễ đọc với người) hay YAML/JSON cấu trúc (dễ đọc với Skill 2.6)? Hay cả hai song song?
2. **Về granularity**: Output theo Module riêng lẻ (6 file nhỏ) hay 1 file tổng hợp (1 file lớn)? Ảnh hưởng trực tiếp đến cách Skill 2.6 consume input.
3. **Về verification loop**: Sau khi Skill 2.6 ra schema, yêu thương có muốn có thêm bước "Skill 2.6 tự validate ngược lại ER Diagram" để đảm bảo không có field nào bị thiếu không?

### User Input

1. skill 2.5 sẽ ouput 2 dạng song hành
   1 bản markdown cho người đọc và review vì đây là skill còn trong @[/home/steve/Documents/KLTN/Docs/life-2/diagrams] và các output sẽ được đặt trọn vẹn trong @[/home/steve/Documents/KLTN/Docs/life-2/diagrams/class-diagrams] để quản lý .
   1 bản theo định dạng format file là yaml phục vụ cho AI đọc và chuyển đôi .
   bản yaml sẽ được chuyển từ file thiết kế sơ đồ từ markdown .

- khi hoàn thành tài liệu cho task 2.5 tới task 2.6 sẽ đọc file yaml để hiểu cấu trúc thiết kế và làm input.
  2.output sẽ được chuyển về các file riêng lẻ được quản lý routing , chunk chặt chẽ để phục vụ cho input task 2.6

3. việc có validate là chắc chắn cần thiết để đảm bảo tính đồng bộ và khả thi .

### Planner Response

Rõ ràng hoàn hảo rồi yêu thương. Tít có đủ thông tin để vẽ ra kiến trúc cụ thể. Tít xem nhanh thư mục hiện tại để confirm không gian làm việc trước.

*Searched filesystem*

### Planner Response

Tít thấy [class-diagrams/](cci:7://file:///home/steve/Documents/KLTN/Docs/life-2/diagrams/class-diagrams:0:0-0:0) đã tồn tại, có 1 file placeholder bên trong. Giờ Tít vẽ ra kiến trúc đầy đủ.

---

## 🏗️ Explore Mode — Thiết kế Kiến trúc 2 Skill Pipeline

### Bức tranh toàn cảnh

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      DUAL-SKILL PIPELINE ARCHITECTURE                       │
│                                                                             │
│  ╔═══════════════════════════════════════════════════════════════════════╗  │
│  ║  INPUT SOURCES (Fixed — không ai được sửa khi Skill đang chạy)       ║  │
│  ║                                                                       ║  │
│  ║  er-diagram.md    UseCase/(m1-m6)  activity-diagrams/   sequence/    ║  │
│  ║  [field, type]    [actor, access]  [behavior, hook]     [API call]   ║  │
│  ╚══════════════════════════╦══════════════════════════════════════════╝  │
│                              ║                                              │
│                              ▼                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │  SKILL 2.5 — Class Structure Analyst                                 │  │
│  │                                                                      │  │
│  │  Nhiệm vụ: "Cái gì tồn tại? Field nào? Rule nào? Hook nào?"        │  │
│  │  Guardrail cứng: Mọi field PHẢI có source citation                  │  │
│  │                                                                      │  │
│  │  OUTPUT (dual format, per module):                                   │  │
│  │  ┌────────────────────────┐  ┌───────────────────────────────────┐  │  │
│  │  │  class-m1.md           │  │  class-m1.yaml (CONTRACT)         │  │  │
│  │  │  (Human Review)        │  │  (Machine Input cho Skill 2.6)    │  │  │
│  │  │  Mermaid classDiagram  │  │  Structured, locked, citable      │  │  │
│  │  └────────────────────────┘  └───────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                              ║                                              │
│                     Validate ║ (user review class-mX.md)                   │
│                              ▼                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐  │
│  │  SKILL 2.6 — MongoDB Schema Designer                                 │  │
│  │                                                                      │  │
│  │  Nhiệm vụ: "Lưu thế nào? Query thế nào? Index gì? Hook nào?"       │  │
│  │  Guardrail cứng: Không được thêm field không có trong .yaml         │  │
│  │                                                                      │  │
│  │  INPUT bắt buộc: class-mX.yaml (đọc trước mọi thứ khác)            │  │
│  │  INPUT bổ sung: flow/ (embed/ref strategy, query path)              │  │
│  │                                                                      │  │
│  │  OUTPUT:                                                             │  │
│  │  ┌──────────────────────────────────────────────────────────────┐   │  │
│  │  │  schema-design/m1-schema.md   (Human + AI Code reads this)  │   │  │
│  │  └──────────────────────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────────────────────┘  │
│                              ║                                              │
│                              ▼                                              │
│  ████████████████  AI Code Agent (Life-3) đọc schema-design/*.md  ████████ │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### Cấu trúc File Output của 2 Skill

```
Docs/life-2/diagrams/class-diagrams/       ← Skill 2.5 quản lý
├── index.md                               ← Navigation hub (routing table)
├── m1-auth-profile/
│   ├── class-m1-auth-profile.md           ← Human review (Mermaid)
│   └── class-m1-auth-profile.yaml        ← AI contract (LOCKED)
├── m2-content-engine/
│   ├── class-m2-content-engine.md
│   └── class-m2-content-engine.yaml
├── m3-discovery-feed/
│   ├── class-m3-discovery-feed.md
│   └── class-m3-discovery-feed.yaml
├── m4-engagement/
│   ├── class-m4-engagement.md
│   └── class-m4-engagement.yaml
├── m5-bookmarking/
│   ├── class-m5-bookmarking.md
│   └── class-m5-bookmarking.yaml
└── m6-notifications-moderation/
    ├── class-m6-notifications.md
    └── class-m6-notifications.yaml

Docs/life-2/database/                      ← Skill 2.6 quản lý
├── schema-design/
│   ├── index.md                           ← Navigation hub
│   ├── m1-auth-profile-schema.md
│   ├── m2-content-engine-schema.md
│   ├── m3-discovery-feed-schema.md
│   ├── m4-engagement-schema.md
│   ├── m5-bookmarking-schema.md
│   └── m6-notifications-schema.md
└── access-patterns.md                     ← (đã có)
```

---

### YAML Contract Format — Định dạng chuẩn của Skill 2.5

Đây là `contract` — file bất biến mà Skill 2.6 sẽ đọc. Cần thiết kế format **đủ chi tiết để không ai được suy đoán thêm**:

```yaml
# class-m1-auth-profile.yaml
# ⚠️  LOCKED CONTRACT — Do NOT edit manually. Generated by Skill 2.5.

meta:
  module: "M1"
  module_name: "Auth & Profile"
  skill_version: "2.5"
  generated_at: "2026-02-20"
  sources_consumed:
    - "Docs/life-2/diagrams/er-diagram.md"
    - "Docs/life-2/diagrams/UseCase/use-case-m1-auth-profile.md"
    - "Docs/life-2/diagrams/activity-diagrams/m1-a1-registration.md"
    - "Docs/life-2/diagrams/activity-diagrams/m1-a2-login.md"
    - "Docs/life-2/diagrams/sequence-diagrams/detailed-m1-auth.md"

entities:
  - slug: "users"                     # → Payload collection slug
    display_name: "User"
    aggregate_root: true              # → Tạo Payload Collection riêng
    fields:
      - name: "email"
        type: "string"                # → Payload field type
        required: true
        unique: true
        indexed: true
        source: "er-diagram.md#L42"   # ← citation bắt buộc
      - name: "verified"
        type: "boolean"
        required: true
        default_value: false
        source: "activity-diagrams/m1-a1-registration.md#L88"
      - name: "role"
        type: "select"
        options: ["member", "admin"]
        source: "er-diagram.md#L48"

    behaviors:
      - lifecycle: "beforeChange"
        trigger: "sanitize_and_validate_input"
        source: "activity-diagrams/m1-a1-registration.md#C2-node"
      - lifecycle: "afterCreate"
        trigger: "send_verification_email"
        source: "sequence-diagrams/detailed-m1-auth.md#L36"

    access_control:
      create: ["anyone"]             # Guest đăng ký
      read:   ["owner", "admin"]
      update: ["owner", "admin"]
      delete: ["admin"]
      source: "use-case-m1-auth-profile.md#UC01"

    assumptions: []                  # Danh sách field KHÔNG có nguồn

validation_report:
  total_fields: 12
  fields_with_source: 12            # ← Phải bằng total
  fields_as_assumption: 0          # ← Ideally 0
  unresolved: []
```

---

### Routing Table trong [index.md](cci:7://file:///home/steve/Documents/KLTN/Docs/life-2/index.md:0:0-0:0) — Skill 2.6 đọc cái này để biết load file nào

```markdown
# Class Diagrams — Index & Routing

| Module | Markdown (Human) | YAML (AI Contract) | Status |
|--------|------------------|---------------------|--------|
| M1 Auth & Profile | m1-auth-profile/class-m1.md | m1-auth-profile/class-m1.yaml | ✅ Ready |
| M2 Content Engine | m2-content/class-m2.md | m2-content/class-m2.yaml | ⏳ Pending |
| M3 Discovery Feed | m3-discovery/class-m3.md | m3-discovery/class-m3.yaml | ⏳ Pending |
| M4 Engagement | m4-engagement/class-m4.md | m4-engagement/class-m4.yaml | ⏳ Pending |
| M5 Bookmarking | m5-bookmarking/class-m5.md | m5-bookmarking/class-m5.yaml | ⏳ Pending |
| M6 Notifications | m6-notifications/class-m6.md | m6-notifications/class-m6.yaml | ⏳ Pending |
```

Skill 2.6 đọc cột **Status** → chỉ load module nào đã `✅ Ready`.

---

### Validation Layer — Chống Ảo giác cụ thể

Đây là phần Tít thấy quan trọng nhất. Tít đề xuất **3 tầng validation**:

```
TẦNG 1 — Skill 2.5 tự validate (trước khi ghi file):
  ✓ Mọi field trong entity có source? (field count = cited count)
  ✓ Mọi behavior có source?
  ✓ field.type nằm trong allowed types? (string/number/boolean/select/...)
  ✓ Không có entity trùng slug?
  → Nếu fail: BLOCK, liệt kê vi phạm, không ghi file

TẦNG 2 — Skill 2.6 validate khi khởi động:
  ✓ Đọc contract.yaml → đọc er-diagram.md
  ✓ Cross-check: Mọi entity trong YAML có tồn tại trong ER không?
  ✓ Cross-check: Mọi entity trong ER đã được cover trong YAML chưa?
  → Nếu thiếu entity: WARN trước khi làm, không BLOCK
  → Nếu entity trong schema không có trong YAML: BLOCK

TẦNG 3 — Skill 2.6 tự validate output:
  ✓ schema-design không có field nào nằm ngoài contract.yaml
  ✓ Mọi index được khai báo trong schema phải map với
    access-patterns.md hoặc contract.yaml [indexed: true]
  ✓ Mọi Payload hook trong schema phải map với
    behaviors[] trong contract
```

---

### Cơ chế chống 3 bệnh cụ thể

| Bệnh                        | Cơ chế trong thiết kế này                                                                                                                                                                                               |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **🔴 Ảo giác**       | `assumptions: []` bắt buộc khai báo — field không trích nguồn → mark `[ASSUMPTION]` → highlight đỏ trong index.md → User phải confirm                                                                       |
| **🟠 Bịa thông tin** | YAML contract là "ground truth" — Skill 2.6 bị**block** nếu cố thêm field không có trong contract. Payload-specific types được khai báo rõ trong `type` field — không có cơ hội dùng cú pháp v2 |
| **🟡 Mất context**    | File yaml nhỏ (1 module = 1 file ≈ 100-150 dòng) → context window luôn đủ. Index.md định tuyến → Skill 2.6 chỉ load đúng file module đang làm                                                                |

---

### Tóm tắt: 3 quyết định cốt lõi đã được chốt

1. **Dual format** (Markdown + YAML) — đúng, mỗi cái phục vụ một audience khác nhau
2. **Per-module chunking** — đúng, mỗi module 1 folder, 1 yaml, 1 markdown
3. **Routing qua index.md** — Skill 2.6 đọc index → biết load file nào → không scan mù
4. **3 tầng validation** — Skill 2.5 self-validate → Skill 2.6 cross-validate → Skill 2.6 output validate

---

Dựa vào những gì đã khám phá, **Tít thấy kiến trúc này đã đủ chín để bắt đầu build Skill thật sự**. Yêu thương muốn chuyển sang build bằng `/opsx:ff` hay muốn khám phá thêm điểm nào chưa?
