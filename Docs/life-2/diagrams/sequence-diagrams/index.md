# Sequence Diagrams - Index & Navigation

> **Persona:** Senior UML Architect (Tít dễ thương)
> **Mục tiêu:** Cung cấp lộ trình chi tiết về các luồng tương tác trong hệ thống, từ tổng quan đến chi tiết kỹ thuật cho từng Module (M1-M6).

---

## 🗺️ I. Danh mục sơ đồ (Diagram Catalog)

### 1. Luồng khái quát (Global Flows)
Nhấn mạnh sự tương tác giữa các Actor và các thành phần kiến trúc lớn (UI, Service, Payload, DB).
- [ ] [**Global Architecture Flows**](./global-flows.md) - Tổng quan cách các thành phần "nói chuyện" với nhau.

### 2. Chi tiết theo Module (Detailed Sub-Flows)
Phân rã sâu vào logic xử lý của từng chức năng cụ thể dựa trên Spec và Activity Diagrams.

| Module | Tên file tài liệu | Các luồng trọng tâm |
|:---:|---|---|
| **M1** | [Auth & Profile](./detailed-m1-auth.md) | Login, Register, OAuth, Recovery, Onboarding |
| **M2** | [Content Engine](./detailed-m2-content.md) | Editor Pipeline, Media Upload, Visibility |
| **M3** | [Discovery & Feed](./detailed-m3-discovery.md) | Feed Ranking, Search Engine, Recommendation |
| **M4** | [Engagement](./detailed-m4-engagement.md) | Follow Handshake, Like/Comment Logic |
| **M5** | [Bookmarking](./detailed-m5-bookmarking.md) | Collection Orchestrator, Folder Management |
| **M6** | [Safety](./detailed-m6-safety.md) | SSE Dispatcher, Report & Moderation |

---

## 🏗️ II. Quy ước thiết kế (Design Conventions)

Để đảm bảo tính nhất quán, các sơ đồ tuân thủ các quy tắc sau:

1. **Lifelines (Thành phần hệ thống):**
   - `actor User`: Người dùng đầu cuối.
   - `participant UI`: Component React / Next.js Page.
   - `participant Service`: Lớp xử lý nghiệp vụ (Domain Logic).
   - `participant Payload`: Payload Local API (`getPayload`).
   - `participant DB`: MongoDB Atlas.
   - `participant SSE`: Server-Sent Events broker.

2. **Message Styles:**
   - `->>`: Gọi đồng bộ (Synchronous).
   - `-->>`: Trả về (Return) hoặc gọi bất đồng bộ (Async).
   - `activate/deactivate`: Biểu diễn thời gian xử lý.

3. **Logic Fragments:**
   - `alt`: Xử lý If/Else (ví dụ: Success/Fail).
   - `loop`: Vòng lặp (ví dụ: duyệt danh sách bài viết).
   - `opt`: Hành động tùy chọn (ví dụ: gửi thông báo).

---

## 🔗 III. Tài liệu tham chiếu (Traceability)

- **Kiến trúc tổng thể:** `Docs/life-1/arhitacture-V2.md`
- **Use Cases:** `Docs/life-2/diagrams/UseCase/index.md`
- **Activity Diagrams:** `Docs/life-2/diagrams/activity-diagrams/index.md`

---
*Ghi chú từ Tít dễ thương: Mỗi sơ đồ đều được thiết kế để chuẩn bị cho giai đoạn 3 (Triển khai), giúp yêu thương dễ dàng theo dõi logic khi code nhé!* 🥰
