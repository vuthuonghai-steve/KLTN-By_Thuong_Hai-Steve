# Folder Structure

> **Mục đích:** Cấu trúc thư mục dự án thực tế  
> **Stack:** Next.js 15 App Router + Payload CMS  

---

## Expected Structure

```
src/
├── app/                    # Next.js App Router
│   ├── (frontend)/         # Public pages
│   ├── (payload)/          # Payload admin
│   └── api/                # API routes
├── components/             # React components
├── collections/            # Payload collections
├── lib/                    # Utilities
└── ...
```

## Key folders

- `collections/` - Payload Users, Posts, Comments, etc.
- `app/(frontend)/` - Feed, profile, post detail pages
- `components/ui/` - Shadcn components
