# 📋 Plan Checklist — Website Mạng Xã Hội Chia Sẻ Kiến Thức

> **File:** `Docs/check.list.md`
> **Nguồn:** `Docs/life-1/lifecycle-checklist-and-folder-structure.md`, `Docs/life-1/01-vision/product-vision.md`
> **Mục đích:** Giúp bạn biết đang ở giai đoạn nào, đang làm gì và cần làm gì tiếp theo.

---

## 1. Giai đoạn hiện tại

**Cách xác định:** Đối chiếu trạng thái file trong `Docs/life-1` → `Docs/life-4` với bảng dưới.

| Giai đoạn      | Điều kiện (đã có đủ tài liệu then chốt)                                                                  |
| ---------------- | ------------------------------------------------------------------------------------------------------------------- |
| **Life-1** | `01-vision/`, `02-decisions/`, `03-research/` — vision, personas, stories, requirements, technical decisions |
| **Life-2** | `diagrams/`, `database/`, `ui/`, `api/`, `specs/` — sơ đồ, schema, wireframe, API spec                |
| **Life-3** | `setup/`, `architecture/` — env, deployment, folder-structure, đang code theo `life-2/specs/`               |
| **Life-4** | `verification/`, `release/`, `archive/` — spec coverage, test report, release notes                          |

**Ghi vào đây (cập nhật khi chuyển phase):**

- **Giai đoạn hiện tại:** _Life-2_ (Đã hoàn thành phần lớn Specs, Wireframes và Sequence Diagrams chính).
- **Ngày cập nhật:** _2026-02-18_

---

## 2. Đang làm

**Đang làm:** _Hoàn thiện nốt Spec/Wireframe cho các module Engagement (M4) và Notifications (M6). Rà soát và fix lỗi trình bày tài liệu._

---

## 3. Cần làm tiếp

**Cần làm tiếp:** _1) Hoàn thiện Spec & Wireframe cho Module M4, M6. 2) Cập nhật Sơ đồ Luồng (Flow Diagram) tổng quát. 3) Chuẩn bị bước sang Giai đoạn 3: Triển khai (Phát triển theo Spec)._

---

## 4. Checklist theo giai đoạn

Mọi mục map với tài liệu trong `Docs/` theo `lifecycle-checklist-and-folder-structure.md`.

---

### Life-1 — Định hướng

*Thư mục: `Docs/life-1/`*

- [X] **1.1** Nghiên cứu & Phân tích (bỏ qua nếu demo)
- [X] **1.2** Xác định người dùng mục tiêu
  - [X] Tạo 2–3 User Personas → `Docs/life-1/01-vision/user-personas.md`
  - [X] Xác định pain points (có thể gộp trong user-personas hoặc product-vision)
- [X] **1.3** Xây dựng User Stories (Focus MVP)
  - [X] Epic 1–10 (Auth, Profile, Posts, Feed, Bookmarking, Search, …) → `Docs/life-1/01-vision/user-stories.md`
- [X] **1.4** Nghiên cứu kỹ thuật
  - [X] News Feed Ranking Algorithm → `Docs/life-1/03-research/news-feed-algorithm.md`
  - [X] SSE với Next.js → `Docs/life-1/03-research/sse-nextjs.md`
  - [X] MongoDB Atlas Search → `Docs/life-1/03-research/mongodb-search.md`
- [X] **1.5** Đặc tả yêu cầu chi tiết
  - [X] Functional + Non-functional Requirements → `Docs/life-1/01-vision/requirements-srs.md`
  - [X] Database Schema sơ bộ (có thể trong requirements hoặc artkitacture)
  - [X] API Endpoints specification (sơ bộ)
  - [X] Tầm nhìn, USP, target market → `Docs/life-1/01-vision/product-vision.md`
- [X] **1.6** Quyết định kỹ thuật → `Docs/life-1/02-decisions/technical-decisions.md`

---

### Life-2 — Phân tích & Thiết kế

*Thư mục: `Docs/life-2/` — **Chỉ [x] khi tài liệu có nội dung đầy đủ, không chỉ khung/placeholder.***

-  **2.1** Sơ đồ quan hệ thực thể (ER) → `Docs/life-2/diagrams/er-diagram.md`
-  **2.2** Sơ đồ Use Case → `Docs/life-2/diagrams/use-case-diagram.md`
-  **2.3** Sơ đồ tuần tự (Sequence) → `Docs/life-2/diagrams/sequence-diagram.md` (Đã có M1, M2, M3, M5)
-  **2.4** Sơ đồ luồng (Flow) → `Docs/life-2/diagrams/flow-diagram.md`
-  **2.5** Sơ đồ lớp (Class) → `Docs/life-2/diagrams/class-diagram.md` (Gộp trong database/schema-design.md)
-  **2.6** Thiết kế Database chi tiết → `Docs/life-2/database/schema-design.md`
-  **2.7** Thiết kế khung giao diện UI
  -  Wireframe từng màn hình (M1, M2, M3, M5) → `Docs/life-2/ui/wireframes/`
  -  Tổng hợp frame layout → `Docs/life-2/ui/ui-frame-design.md`
-  **2.8** Thiết kế API
  -  REST/GraphQL endpoints → `Docs/life-2/api/api-spec.md`
  -  Request/Response, auth → `Docs/life-2/api/api-design.md`
-  **2.9** Spec chi tiết phục vụ AI code generation → `Docs/life-2/specs/`
  -  m1-auth-profile-spec.md, m2-content-engine-spec.md, m3-discovery-feed-spec.md, m5-bookmarking-spec.md

---

### Life-3 — Triển khai

*Thư mục: `Docs/life-3/`*

- [ ] **3.1** Setup môi trường (tài liệu)
  - [ ] Init Next.js + Payload
  - [ ] Configure MongoDB Atlas
  - [ ] Setup Vercel project
  - [ ] TypeScript, ESLint, Prettier
  - [ ] Biến môi trường, secrets → `Docs/life-3/setup/env-setup.md`
  - [ ] Hướng dẫn deploy → `Docs/life-3/setup/deployment-guide.md`
- [ ] **3.2** Xây dựng kiến trúc dự án (tài liệu)
  - [ ] Cấu trúc thư mục theo template Next.js → `Docs/life-3/architecture/folder-structure.md`
  - [ ] App Router, layouts, route groups (khi code)
- [ ] **3.3** Xác định thư viện & dependencies (tài liệu)
  - [ ] package.json, lockfile
  - [ ] Shadcn UI, Tailwind, … → `Docs/life-3/architecture/tech-choices.md`
- [ ] **3.4** Xây dựng theo spec
  - [ ] Tham chiếu `Docs/life-2/specs/`
  - [ ] AI agent đọc spec → tạo sinh code
  - [ ] (Tùy chọn) Prompt tham chiếu → `Docs/life-3/ai-prompt-refs/`
- [ ] **3.5** Test ⇄ AI agent
  - [ ] Unit tests, integration tests
  - [ ] AI hỗ trợ viết test, debug
- [ ] (Tùy chọn) Ghi chú sprint → `Docs/life-3/sprint-logs/`

---

### Life-4 — Verify

*Thư mục: `Docs/life-4/`*

- [ ] **4.1** Đối chiếu với spec (file đã có, nội dung chưa điền)
  - [ ] Tất cả requirements đã implement?
  - [ ] Database schema khớp thiết kế?
  - [ ] Ghi nhận → `Docs/life-4/verification/spec-coverage.md`
- [ ] **4.2** Kiểm thử chức năng (file đã có, chưa chạy test)
  - [ ] E2E, smoke tests
  - [ ] Performance benchmarks
  - [ ] Báo cáo → `Docs/life-4/verification/test-report.md`
- [ ] **4.3** Tài liệu vận hành (file đã có)
  - [ ] README, hướng dẫn deploy
  - [ ] Runbook (nếu cần)
  - [ ] Release notes → `Docs/life-4/release/release-notes.md`
  - [ ] Deployment checklist → `Docs/life-4/release/deployment-checklist.md`
- [ ] **4.4** Sign-off & Archive (file đã có)
  - [ ] Lessons learned → `Docs/life-4/archive/lessons-learned.md`
  - [ ] Lịch sử quyết định → `Docs/life-4/archive/decisions-log.md`

---

## 📌 Ghi chú nhanh

- **Tiêu chí đánh dấu [x]:** Chỉ khi tài liệu **có nội dung đầy đủ tính năng**, không chỉ file tồn tại hay khung/placeholder. Rà soát bằng cách đọc nội dung thực tế trong Docs.
- **MVP Scope** (theo product-vision): Auth, Profile, Posts (text+image+link), News Feed (ranking), Interactions (like/comment/share), Bookmarking (collections), Search, Notifications (SSE), Moderation (report), Privacy & Connections.
- **Spec-driven flow:** `Docs/life-2/specs/*.md` → AI đọc → sinh code → `src/` → Test ⇄ Fix.
- Cập nhật **Giai đoạn hiện tại**, **Đang làm**, **Cần làm tiếp** mỗi khi chuyển task hoặc chuyển phase.

---

---

## 📌 Kết quả rà soát (docs-driven)

*Rà soát bằng cách **đọc nội dung thực tế** trong `Docs/`, không chỉ "file tồn tại". Chỉ đánh [x] khi tài liệu có nội dung đầy đủ tính năng, không chỉ khung/placeholder/null. Cập nhật: 2026-02-01.*

| Giai đoạn      | Đã xong (nội dung đủ)                                            | Chưa / chỉ khung sườn                                                                                                                                                           |
| ---------------- | --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Life-1** | 1.2, 1.3, 1.5, 1.6; 1.4 chỉ có news-feed-algorithm                  | 1.4:`sse-nextjs.md`, `mongodb-search.md`; 1.7: competitor-analysis (tùy chọn)                                                                                                 |
| **Life-2** | *(không mục nào)*                                                | Toàn bộ 2.1–2.9: file có nhưng**chỉ khung sườn** — diagrams có comment "Thêm/Cập nhật", schema chỉ users+posts, wireframes trống, api tổng quan, specs trống |
| **Life-3** | 3.1–3.3 (tài liệu setup, architecture, tech-choices có nội dung) | 3.1 thực tế: init project, MongoDB, Vercel; 3.4, 3.5 khi có specs                                                                                                                |
| **Life-4** | File verification, release, archive đã tạo                         | Nội dung đối chiếu spec, test, release điền khi triển khai xong                                                                                                              |

*Cập nhật: 2026-02-01*
