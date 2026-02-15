# Tech Choices

> **Mục đích:** Lý do chọn thư viện, stack  
> **Tham chiếu:** technical-decisions.md  

---

## Stack Summary

| Layer    | Choice           | Rationale                    |
|----------|------------------|------------------------------|
| Frontend | Next.js 15 + React 19 | App Router, RSC, Vercel integration |
| CMS      | Payload 3.x      | Headless, MongoDB, Auth built-in |
| Database | MongoDB Atlas    | Document model, Atlas Search |
| Styling  | Tailwind + Shadcn| Rapid UI, accessible components |
| Storage  | Vercel Blob      | Simple, no S3 setup          |
| Realtime | SSE              | Simpler than WebSocket       |

## Alternatives considered

- **Payload vs Strapi:** Payload native TypeScript, MongoDB
- **Vercel Blob vs Cloudinary:** Vercel đơn giản cho demo
