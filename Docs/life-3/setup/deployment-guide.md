# Deployment Guide

> **Mục đích:** Hướng dẫn deploy lên Vercel  
> **Stack:** Next.js + Payload + MongoDB Atlas + Vercel  

---

## Prerequisites

- Vercel account
- MongoDB Atlas cluster
- GitHub repo connected

## Steps

1. **MongoDB Atlas:** Tạo cluster, whitelist IP, lấy connection string
2. **Vercel:** Import project từ GitHub
3. **Environment variables:** Thêm MONGODB_URI, PAYLOAD_SECRET, etc.
4. **Deploy:** Push to main → auto deploy

## Post-deploy

- Verify admin panel: `/admin`
- Test API endpoints
