# Deployment Checklist

> **Mục đích:** Checklist trước khi deploy  
> **Tham chiếu:** setup/deployment-guide.md  

---

## Pre-deploy

- [ ] Environment variables đã config trên Vercel
- [ ] MongoDB Atlas IP whitelist (0.0.0.0/0 cho Vercel)
- [ ] Build thành công locally: `npm run build`
- [ ] Không có lỗi TypeScript/ESLint

## Post-deploy

- [ ] Admin panel accessible: `/admin`
- [ ] API health check
- [ ] Smoke test: login, create post, view feed
