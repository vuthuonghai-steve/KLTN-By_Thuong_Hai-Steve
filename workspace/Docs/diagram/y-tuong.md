# Use Case Diagram

- Toàn hệ thống + 1–2 sơ đồ con cho nhóm chức năng quan trọng (Feed, Bài viết, Notification).

# Activity Diagram

- Luồng: đăng ký/đăng nhập, đăng bài, tạo kết nối/bạn bè, báo cáo vi phạm.

- Nếu có AI (gợi ý bài viết, xếp hạng feed), vẽ activity cho pipeline xử lý dữ liệu & suy luận.

# Class Diagram

- Domain model: User, Profile, Post, Comment, Reaction, Follow, Notification, RecommendationJob, FeatureVector, v.v.

# Sequence Diagram

- 3–5 use case quan trọng:

+ User xem newsfeed (có gọi AI ranking)

+ User đăng bài (gồm upload media, lưu DB, push notification)

+ User nhận notification (real-time / background job)

# Component Diagram

- Phân rã thành: WebApp, API Gateway, Auth Service, User Service, Post Service, Feed/Ranking Service (AI), Notification Service, Search Service.