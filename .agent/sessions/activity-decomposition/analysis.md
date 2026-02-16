# Phân Tích Rã Nhỏ Sơ Đồ Activity - Session: activity-decomposition

## 1. Phân Tách Vấn Đề (DECOMPOSE)
Yêu thương muốn chia nhỏ 7 luồng lớn thành các "Sơ đồ module con" (Grainy diagrams) để dễ dàng triển khai theo từng bước nhỏ.

## 2. Nghiên Cứu & Xác Định (RESEARCH)
Dựa trên Use Case M1-M6, Tít đã phân rã thành các cụm nhỏ hơn:

### M1: Auth & Profile
1. **M1-A1: Website Registration (Email)**: Quy trình từ nhập form -> Validate -> Gửi mail xác nhận -> Kích hoạt.
2. **M1-A2: Login Protocol (Internal)**: Kiểm tra thông tin -> Tạo session/JWT -> Redirect.
3. **M1-A3: OAuth Third-party Handshake**: Chuyển hướng Provider -> Nhận Token -> Đồng bộ User Profile.
4. **M1-A4: Password Recovery Cycle**: Gửi link reset -> Nhập Pass mới -> Cập nhật bảo mật.
5. **M1-A5: Profile Onboarding**: Luồng thiết lập Avatar, Bio lần đầu sau khi đăng ký.

### M2: Content Engine
1. **M2-A1: Rich-text Editor Pipeline**: Xử lý Input -> Encode Rich text -> Preview.
2. **M2-A2: Media Attachment Handler**: Upload -> Cắt ảnh -> Gắn link vào Content.
3. **M2-A3: Post Integrity & Tagging**: Kiểm tra tính hợp lệ -> Xử lý Hashtags -> Persistence.
4. **M2-A4: Visibility & Access Control**: Thiết lập Public/Private -> Update ACL.

### M3: Discovery & Feed
1. **M3-A1: Feed Retrieval (Following)**: Lấy bài viết từ danh sách Following -> Sắp xếp theo Time.
2. **M3-A2: Trending Ranking Computation**: Tính toán Engagement score -> Áp dụng Time-decay -> Trộn vào Feed.
3. **M3-A3: Full-text Search Engine**: Tokenize -> Query Atlas Search -> Hiển thị Highlight kết quả.
4. **M3-A4: Autocomplete Suggestion**: Prefix matching -> Trả về danh sách gợi ý nhanh.

### M4: Engagement
1. **M4-A1: Reaction Toggle**: Like -> Cập nhật counter -> Đồng bộ trạng thái UI.
2. **M4-A2: Threaded Commenting**: Lưu Comment -> Xử lý cấp bậc (Parent/Child) -> Trigger Notify.
3. **M4-A3: Connection Management**: Follow/Unfollow -> Cập nhật quan hệ -> Điều chỉnh Feed Cache.

### M5: Bookmarking
1. **M5-A1: Bookmark Persistence**: Lưu ID bài viết -> Phân loại vào Thư mục mặc định.
2. **M5-A2: Collection Orchestration**: Tạo/Sửa/Xóa thư mục -> Di chuyển Bookmark giữa các thư mục.

### M6: Notifications & Moderation
1. **M6-A1: Real-time Event Dispatcher**: Lắng nghe Trigger -> Tạo bản ghi Notify -> Đẩy qua SSE.
2. **M6-A2: Moderation Report Workflow**: User gửi Report -> Vào hàng chờ Admin -> Kiểm duyệt.
3. **M6-A3: Administrative Enforcement**: Ban user/Delete nội dung -> Gửi thông báo lý do.

## 3. Phân Tích Rủi Ro (ANALYZE)
- **Risk 1: Fragmented Logic**: Chia quá nhỏ có thể làm mất cái nhìn tổng thể về luồng dữ liệu (Data flow).
- **Risk 2: Interaction Overhead**: Các sub-activity cần các "Join points" rõ ràng để không bị rời rạc.
- **Risk 3: Concurrency**: Luồng Real-time Notify (M6-A1) dễ bị xung đột với các tiến trình Engagement nhanh (M4-A1).

## 4. Giải Pháp Cải Tiến
Tít sẽ trình bày danh sách dưới dạng một **Master Checklist** trong `index.md`, chia theo Module và phân cấp rõ rệt.
