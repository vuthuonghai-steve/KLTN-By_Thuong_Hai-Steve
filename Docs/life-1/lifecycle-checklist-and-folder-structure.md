# 📋 Checklist Vòng Đời Phát Triển Website

> **Tài liệu:** `Docs/life-1/lifecycle-checklist-and-folder-structure.md`  
> **Mục đích:** Kim chỉ nam định hướng phát triển, nắm bắt đường đi cần triển khai  
> **Tham chiếu:** arhitacture-V2.md, artkitacture.md  

---

## 🔗 Nguồn Tham Khảo: NotebookLM

| Notebook | URL | Nội dung tập trung |
|----------|-----|--------------------|
| Tài nguyên tổng quát | [46ddeb54...](https://notebooklm.google.com/notebook/46ddeb54-c391-43df-95f2-53c820428ada) | SDLC, AI trong phát triển, thiết kế kiến trúc |
| Template Next.js | [54c93705...](https://notebooklm.google.com/notebook/54c93705-0398-4ded-b698-61c44ce692f8) | Kiến trúc dự án Next.js, folder structure, conventions |

**Cách query:** `python3 scripts/run.py ask_question.py --question "..." --notebook-url "[URL]"`  
*(Skill: ~/.cursor/skills/notebooklm/)*

---

## 📊 Tổng Quan 4 Giai Đoạn

| Giai đoạn | Tên | Mục tiêu chính | Thư mục Docs |
|-----------|-----|----------------|--------------|
| **1** | Định hướng | Tài liệu kỹ thuật cơ bản, kim chỉ nam phát triển | `Docs/life-1/` |
| **2** | Phân tích & Thiết kế | Xác định tính năng, sơ đồ thiết kế, spec kỹ thuật | `Docs/life-2/` |
| **3** | Triển khai | Setup, xây dựng, spec-driven, test ⇄ AI agent | `Docs/life-3/` |
| **4** | Verify | Kiểm chứng kết quả, chất lượng | `Docs/life-4/` |

---

## 🎯 GIAI ĐOẠN 1 — ĐỊNH HƯỚNG

### Mục tiêu
Định hình dự án, thống nhất scope, tạo nền tảng tài liệu kỹ thuật đóng vai trò kim chỉ nam.

### Checklist công việc

```
□ 1.1 Nghiên cứu & Phân tích (bỏ qua nếu demo)
□ 1.2 Xác định người dùng mục tiêu
   □ Tạo 2-3 User Personas
   □ Xác định pain points
□ 1.3 Xây dựng User Stories (Focus MVP)
   □ Epic 1–10 (Auth, Profile, Posts, Feed, Bookmarking, Search, …)
□ 1.4 Nghiên cứu kỹ thuật
   □ News Feed Ranking Algorithm
   □ SSE với Next.js
   □ MongoDB Atlas Search
□ 1.5 Đặc tả yêu cầu chi tiết
   □ Functional Requirements
   □ Non-functional Requirements
   □ Database Schema sơ bộ
   □ API Endpoints specification
□ 1.6 Setup môi trường phát triển (optional, có thể sang giai đoạn 3)
```

### Deliverables & Kiến trúc thư mục

```
Docs/life-1/
├── arhitacture-V2.md          # Roadmap điều chỉnh, checklist giai đoạn 1
├── artkitacture.md            # Kiến trúc tổng thể, MVP matrix, schema
├── lifecycle-checklist-and-folder-structure.md   # ← File này
├── 01-vision/
│   ├── product-vision.md      # Tầm nhìn, USP, target market
│   ├── user-personas.md       # 3-5 User Personas
│   ├── user-stories.md        # Epic + User Stories
│   ├── requirements-srs.md    # FR + NFR
│   └── competitor-analysis.md # Phân tích đối thủ (nếu có)
├── 02-decisions/
│   └── technical-decisions.md # Các quyết định kỹ thuật đã xác định
└── 03-research/
    ├── news-feed-algorithm.md
    ├── sse-nextjs.md
    └── mongodb-search.md
```

---

## 🎯 GIAI ĐOẠN 2 — PHÂN TÍCH & THIẾT KẾ

### Mục tiêu
Dựa trên tài liệu giai đoạn 1, phân tích thiết kế chi tiết với các sơ đồ điển hình.

### Checklist công việc

```
□ 2.1 Sơ đồ quan hệ thực thể (ER)
□ 2.2 Sơ đồ Use Case
□ 2.3 Sơ đồ tuần tự (Sequence)
□ 2.4 Sơ đồ luồng (Flow)
□ 2.5 Sơ đồ lớp (Class)
□ 2.6 Thiết kế Database chi tiết
□ 2.7 Thiết kế khung giao diện UI (wireframe/frame)
□ 2.8 Thiết kế API
```

### Deliverables & Kiến trúc thư mục

```
Docs/life-2/
├── diagrams/
│   ├── er-diagram.md          # hoặc .drawio, .mermaid
│   ├── use-case-diagram.md
│   ├── sequence-diagram.md
│   ├── flow-diagram.md
│   └── class-diagram.md
├── database/
│   ├── schema-design.md       # Chi tiết collections, indexes
│   └── migrations/            # (nếu cần lưu migration plan)
├── ui/
│   ├── wireframes/            # Khung giao diện từng màn hình
│   │   ├── auth.md
│   │   ├── feed.md
│   │   ├── profile.md
│   │   └── ...
│   └── ui-frame-design.md     # Tổng hợp frame layout
├── api/
│   ├── api-spec.md            # REST/GraphQL endpoints
│   └── api-design.md          # Request/Response, auth
└── specs/                     # Spec chi tiết phục vụ AI code generation
    ├── auth-spec.md
    ├── posts-spec.md
    ├── feed-spec.md
    └── ...
```

### Mapping sơ đồ → file

| Loại sơ đồ | File | Ghi chú |
|------------|------|---------|
| ER | `diagrams/er-diagram.md` | Entities, relationships |
| Use Case | `diagrams/use-case-diagram.md` | Actors, use cases |
| Sequence | `diagrams/sequence-diagram.md` | Luồng tương tác |
| Flow | `diagrams/flow-diagram.md` | Luồng xử lý |
| Class | `diagrams/class-diagram.md` | Cấu trúc class |
| Database | `database/schema-design.md` | Collections, indexes |
| UI Frame | `ui/wireframes/`, `ui/ui-frame-design.md` | Layout màn hình |
| API | `api/api-spec.md`, `api/api-design.md` | Endpoints, contract |

---

## 🎯 GIAI ĐOẠN 3 — TRIỂN KHAI

### Mục tiêu
Lấy thành quả giai đoạn 2 để xây dựng thực tế. Spec-driven, tích hợp AI code generation.

### Checklist công việc

```
□ 3.1 Setup môi trường
   □ Init Next.js + Payload
   □ Configure MongoDB Atlas
   □ Setup Vercel project
   □ TypeScript, ESLint, Prettier
□ 3.2 Xây dựng kiến trúc dự án
   □ Cấu trúc thư mục theo template Next.js
   □ App Router, layouts, route groups
□ 3.3 Xác định thư viện & dependencies
   □ package.json, lockfile
   □ Shadcn UI, Tailwind, …
□ 3.4 Xây dựng theo spec
   □ Tham chiếu Docs/life-2/specs/
   □ AI agent đọc spec → tạo sinh code
□ 3.5 Test ⇄ AI agent
   □ Unit tests, integration tests
   □ AI hỗ trợ viết test, debug
```

### Deliverables & Kiến trúc thư mục

```
Docs/life-3/
├── setup/
│   ├── env-setup.md           # Biến môi trường, secrets
│   └── deployment-guide.md
├── architecture/
│   ├── folder-structure.md    # Cấu trúc thư mục dự án thực tế
│   └── tech-choices.md        # Lý do chọn thư viện
├── sprint-logs/               # Ghi chú từng sprint (optional)
│   ├── sprint-1.md
│   └── sprint-2.md
└── ai-prompt-refs/            # Prompt tham chiếu cho AI agent
    ├── auth-implementation.md
    ├── post-crud.md
    └── ...
```

### Spec-driven flow (cho AI agent)

```
Docs/life-2/specs/*.md  →  Đọc bởi AI  →  Sinh code  →  src/
                                                ↓
                                          Test ←→ Fix
```

---

## 🎯 GIAI ĐOẠN 4 — VERIFY

### Mục tiêu
Kiểm chứng kết quả, chất lượng, đối chiếu với yêu cầu ban đầu.

### Checklist công việc

```
□ 4.1 Đối chiếu với spec
   □ Tất cả requirements đã implement?
   □ Database schema khớp thiết kế?
□ 4.2 Kiểm thử chức năng
   □ E2E, smoke tests
   □ Performance benchmarks
□ 4.3 Tài liệu vận hành
   □ README, hướng dẫn deploy
   □ Runbook (nếu cần)
□ 4.4 Sign-off & Archive
   □ Lưu quyết định, lessons learned
```

### Deliverables & Kiến trúc thư mục

```
Docs/life-4/
├── verification/
│   ├── spec-coverage.md       # Đối chiếu spec vs implementation
│   └── test-report.md
├── release/
│   ├── release-notes.md
│   └── deployment-checklist.md
└── archive/
    ├── lessons-learned.md
    └── decisions-log.md       # Lịch sử quyết định
```

---

## 🌲 CÂY THƯ MỤC TỔNG THỂ DỰ KIẾN

```
Docs/
├── life-1/                    # Giai đoạn 1: Định hướng
│   ├── 01-vision/
│   ├── 02-decisions/
│   └── 03-research/
├── life-2/                    # Giai đoạn 2: Phân tích Thiết kế
│   ├── diagrams/
│   ├── database/
│   ├── ui/
│   ├── api/
│   └── specs/
├── life-3/                    # Giai đoạn 3: Triển khai
│   ├── setup/
│   ├── architecture/
│   ├── sprint-logs/
│   └── ai-prompt-refs/
└── life-4/                    # Giai đoạn 4: Verify
    ├── verification/
    ├── release/
    └── archive/
```

---

## ✅ Success Criteria

- [x] Mỗi giai đoạn có checklist có thể tick
- [x] Mỗi loại tài liệu có đường dẫn file rõ ràng
- [x] AI agent có thể đọc spec từ `Docs/life-2/specs/` để sinh code
- [x] NotebookLM được dùng khi cần tham khảo SDLC, kiến trúc Next.js

### Verification (2026-02-01)

| Kiểm tra | Trạng thái |
|----------|------------|
| Thư mục life-1/01-vision, 02-decisions, 03-research | ✓ |
| Thư mục life-2/diagrams, database, ui, api, specs | ✓ |
| Thư mục life-3/setup, architecture, sprint-logs, ai-prompt-refs | ✓ |
| Thư mục life-4/verification, release, archive | ✓ |
| Template files có header và instructions | ✓ |
| Cross-check với artkitacture.md, arhitacture-V2.md | ✓ |

### Consistency với artkitacture & arhitacture-V2

- **Tech stack:** Next.js 15/16, Payload, MongoDB, Tailwind, Shadcn, Local Storage, SSE, Atlas Search — khớp
- **User personas:** Developer, Student, Tech learner — khớp
- **10 MVP features:** Auth, Profile, Posts, Feed, Interactions, Bookmark, Search, Notifications, Moderation, Privacy — khớp
- **News Feed algorithm:** Time-decay + Engagement (Option C) — khớp arhitacture-V2
- **Technical decisions:** Realtime=SSE, Storage=Vercel Blob, Queue=Không — khớp

---

*Cập nhật: 2026-02-01*
