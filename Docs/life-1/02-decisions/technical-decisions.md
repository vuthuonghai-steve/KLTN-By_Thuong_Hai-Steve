# Technical Decisions

> **Mục đích:** Tổng hợp các quyết định kỹ thuật đã xác định  
> **Nguồn:** Từ research (artkitacture.md, arhitacture-V2.md)  

---

## Tech Stack

| Layer    | Choice                | Notes                         |
|----------|-----------------------|-------------------------------|
| Frontend | Next.js 15/16 + React 19 | App Router, RSC              |
| Backend  | Payload CMS 3.x       | Headless, collections, auth   |
| Database | MongoDB Atlas         | Free tier 512MB               |
| Styling  | Tailwind + Shadcn UI  | Accessible components         |
| Storage  | Local Server Storage  | Disk storage (public/media)   |
| Realtime | SSE                   | Notifications                 |
| Search   | MongoDB Atlas Search  | Full-text, autocomplete       |
| Hosting  | Vercel                | Auto-deploy                   |
| CI/CD    | Vercel Auto-Deploy    | Push to main                  |
| Queue    | Không (đồng bộ)       | Đơn giản hóa MVP              |

## Realtime

**Quyết định: SSE (Server-Sent Events)**

- Đơn giản hơn WebSocket cho one-way push (server → client)
- Route Handler Next.js + ReadableStream
- Client: EventSource API
- Đủ cho notifications, live updates
- Fallback: Polling nếu cần

## Storage

**Quyết định: Vercel Blob**

- Tích hợp sẵn với Vercel
- Không cần setup S3/Cloudinary
- Đủ cho MVP (avatars, post images)

## Search

**Quyết định: MongoDB Atlas Search**

- Native với MongoDB
- Full-text search, autocomplete
- Không cần thêm service (Meilisearch, Algolia)

## Queue System

**Quyết định: Không dùng queue trong MVP**

- Xử lý đồng bộ (sync)
- Bull/BullMQ có thể thêm sau khi cần background jobs (email, notifications batch)
