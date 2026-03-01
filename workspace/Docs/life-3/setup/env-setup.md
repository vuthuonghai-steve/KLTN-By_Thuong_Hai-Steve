# Environment Setup

> **Mục đích:** Biến môi trường, secrets, hướng dẫn config  
> **Lưu ý:** Không commit .env vào Git  

---

## Required Environment Variables

| Variable           | Mô tả                    | Example                    |
|--------------------|--------------------------|----------------------------|
| `MONGODB_URI`      | MongoDB connection string| `mongodb+srv://...`        |
| `PAYLOAD_SECRET`   | Payload CMS secret       | random string              |
| `NEXT_PUBLIC_SERVER_URL` | Base URL app       | `http://localhost:3000`    |
| `VERCEL_BLOB_*`    | Vercel Blob (nếu dùng)   | từ Vercel dashboard        |

## Setup steps

1. Copy `.env.example` → `.env`
2. Điền các giá trị
3. Verify với `npm run dev`
