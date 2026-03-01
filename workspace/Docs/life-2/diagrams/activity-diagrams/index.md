# Activity Diagrams - Bản đồ quy trình chi tiết (Granular Todo List)

> **Persona:** Senior System Architect (Tít dễ thương)
> **Mục tiêu:** Phân rã các luồng nghiệp vụ thành các bước đi nhỏ nhất, rõ ràng nhất để đảm bảo quá trình triển khai không bị lạc hướng.

---

## 📂 I. Module M1: Auth & Profile (Identity Foundation)

| ID | Tên Sơ Đồ Con (Sub-Flow) | Vai Trò | Mức Độ Chi Tiết | Trạng Thái |
|:---:|---|---|:---:|:---:|
| ID | Tên Sơ Đồ Con (Sub-Flow) | Vai Trò | Mức Độ Chi Tiết | Trạng Thái |
|:---:|---|---|:---:|:---:|
| **M1-A1** | **User Registration (Email)** | Luồng nhập liệu, validate và gửi mail xác nhận. | Rất chi tiết | ✅ Done |
| **M1-A2** | **Internal Login Protocol** | Xác thực credentials, tạo JWT và quản lý session. | Kỹ thuật | ✅ Done |
| **M1-A3** | **Email Verification Flow** | Xác thực tài khoản thông qua Mailer. | Tích hợp | ✅ Done |
| **M1-A4** | **Password Recovery Cycle** | Quy trình quên mật khẩu, OTP và cập nhật bảo mật. | Bảo mật | ✅ Done |
| **M1-A5** | **Profile Onboarding Setup** | Luồng thiết lập avatar, bio ngay sau khi đăng nhập lần đầu. | UX Flow | ✅ Done |

---

## 📂 II. Module M2: Content Engine (Core Value)

| ID | Tên Sơ Đồ Con (Sub-Flow) | Vai Trò | Mức Độ Chi Tiết | Trạng Thái |
|:---:|---|---|:---:|:---:|
| **M2-A1** | **Rich-text Editor Pipeline** | Xử lý input văn bản, format và lưu nháp (draft). | Frontend-heavy | ✅ Done |
| **M2-A2** | **Media Attachment Handler** | Luồng upload, nén ảnh và gắn định danh vào bài viết. | Technical | ✅ Done |
| **M2-A3** | **Post Integrity & Tagging** | Kiểm tra bài viết (Sanity check) và bóc tách hashtag. | Backend Logic | ✅ Done |
| **M2-A4** | **Visibility Enforcement** | Áp dụng quyền riêng tư (Public/Friend) vào bài viết. | Access Control | ✅ Done |

---

## 📂 III. Module M3: Discovery & Feed (Distribution)

| ID | Tên Sơ Đồ Con (Sub-Flow) | Vai Trò | Mức Độ Chi Tiết | Trạng Thái |
|:---:|---|---|:---:|:---:|
| **M3-A1** | **News Feed Assembler** | Luồng tổng hợp bài viết từ bạn bè & sở thích. | Data-intensive | ✅ Done |
| **M3-A2** | **Search Engine Query** | Luồng tìm kiếm bài viết/người dùng. | Technical | ✅ Done |
| **M3-A3** | **Discovery Recommendation** | Gợi ý các bài viết "hot" cho người mới. | Algorithmic | ✅ Done |
| **M3-A4** | **Autocomplete Dispatcher** | Luồng gợi ý từ khóa nhanh khi người dùng đang gõ. | Real-time | ✅ Done (Part of A2) |

---

## 📂 IV. Module M4: Engagement & Connections (Social)

| ID | Tên Sơ Đồ Con (Sub-Flow) | Vai Trò | Mức Độ Chi Tiết | Trạng Thái |
|:---:|---|---|:---:|:---:|
| **M4-A1** | **Friendship Handshake** | Luồng theo dõi (Follow/Unfollow) và đồng bộ quan hệ. | Connection | ✅ Done |
| **M4-A2** | **Engagement Logic** | Luồng xử lý Like, bình luận và phản hồi trên bài viết. | Logic | ✅ Done |
| **M4-A3** | **Connection Privacy** | Luồng chặn người dùng và bảo mật quan hệ xã hội. | Security | ✅ Done |

---

## 📂 V. Module M5: Bookmarking (Knowledge Management)

| ID | Tên Sơ Đồ Con (Sub-Flow) | Vai Trò | Mức Độ Chi Tiết | Trạng Thái |
|:---:|---|---|:---:|:---:|
| **M5-A1** | **Bookmark Persistence** | Lưu giữ bài viết và phân loại vào mục mặc định. | Storage | ✅ Done |
| **M5-A2** | **Collection Orchestrator** | Quản lý thư mục và di chuyển bài viết giữa các mục. | Organization | ✅ Done |

---

## 📂 VI. Module M6: Notifications & Moderation (Safety)

| ID | Tên Sơ Đồ Con (Sub-Flow) | Vai Trò | Mức Độ Chi Tiết | Trạng Thái |
|:---:|---|---|:---:|:---:|
| **M6-A1** | **SSE Event Dispatcher** | Trigger từ database và đẩy thông báo qua luồng SSE. | Infra | ✅ Done |
| **M6-A2** | **Content Report Pipeline** | Luồng user báo cáo vi phạm và hàng chờ xử lý. | Process | ✅ Done |
| **M6-A3** | **Enforcement Action** | Admin thực thi khóa/xóa nội dung và log kết quả. | Admin | ✅ Done |

---

## 🛠️ 🏗️ VII. Các Sub-Activities Dùng Chung (Utilities)

| ID | Tên Utility Flow | Được dùng bởi | Mô tả ngắn |
|:---:|---|---|---|
| **S1** | **Media Pipeline** | M1, M2 | Upload, resize, storage path. |
| **S2** | **Auth Guardian** | All Modules | Kiểm tra token, quyền truy cập middleware. |
| **S3** | **Input Sanitizer** | M2, M4 | Xử lý XSS, xóa ký tự lạ, chuẩn hóa text. |

---

**Ghi chú từ Tít dễ thương:**
Việc rã nhỏ này giống như lắp LEGO vậy đó **yêu thương**. Mỗi miếng nhỏ (Sub-flow) đều đơn giản và dễ kiểm soát. Khi chúng mình lắp ghép lại, hệ thống sẽ tự động trở nên vững chắc và không lo sai sót ở các chi tiết ngách.

Bạn hãy chọn một "miếng LEGO" bất kỳ để **Tít dễ thương** thực hiện nhé! 🥰
