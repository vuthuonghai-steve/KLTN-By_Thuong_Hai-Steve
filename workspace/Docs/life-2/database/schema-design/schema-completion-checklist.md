# Checklist: Hoàn thiện Schema Design cho từng Module

> Mục tiêu: Theo dõi tiến độ chuyển đổi từ Class Diagram YAML (Contract) sang Database Schema (PayloadCMS & MongoDB).
> Cập nhật lần cuối: 2026-02-21

---

## 🚦 Tổng quan Tiến độ
- **Tổng số Module**: 6
- **Đã hoàn thành**: 1/6 (M1)
- **Đang chờ xử lý**: 5/6 (M2, M3, M4, M5, M6)

---

## 🛠 Chi tiết từng Module

### 🔐 M1: Auth & Profile
- [x] **Contract YAML**: `Docs/life-2/diagrams/class-diagrams/m1-auth-profile/class-m1-auth-profile.yaml`
- [x] **Schema Markdown**: `Docs/life-2/database/schema-design/m1-auth-schema.md`
- [x] **Schema YAML**: `Docs/life-2/database/schema-design/m1-auth-schema.yaml`
- [x] **Validation**: Đã chạy `validate_schema.py` và PASS.

### 📝 M2: Content Engine
- [x] **Contract YAML**: `Docs/life-2/diagrams/class-diagrams/m2-content-engine/class-m2-content-engine.yaml` (Sẵn sàng)
- [x] **Schema Markdown**: `Docs/life-2/database/schema-design/m2-content-schema.md`
- [x] **Schema YAML**: `Docs/life-2/database/schema-design/m2-content-schema.yaml`
- [x] **Validation**: Đã chạy `validate_schema.py` và PASS.

### 🌍 M3: Discovery & Feed
- [x] **Contract YAML**: `Docs/life-2/diagrams/class-diagrams/m3-discovery-feed/class-m3-discovery-feed.yaml` (Sẵn sàng)
- [x] **Schema Markdown**: `Docs/life-2/database/schema-design/m3-discovery-schema.md`
- [x] **Schema YAML**: `Docs/life-2/database/schema-design/m3-discovery-schema.yaml`
- [x] **Validation**: Đã chạy `validate_schema.py` và PASS.

### 🤝 M4: Social Engagement
- [x] **Contract YAML**: `Docs/life-2/diagrams/class-diagrams/m4-engagement/class-m4-engagement.yaml` (Sẵn sàng)
- [x] **Schema Markdown**: `Docs/life-2/database/schema-design/m4-engagement-schema.md`
- [x] **Schema YAML**: `Docs/life-2/database/schema-design/m4-engagement-schema.yaml`
- [x] **Validation**: Đã chạy `validate_schema.py` và PASS.

### 🔖 M5: Bookmarking
- [x] **Contract YAML**: `Docs/life-2/diagrams/class-diagrams/m5-bookmarking/class-m5-bookmarking.yaml` (Sẵn sàng)
- [x] **Schema Markdown**: `Docs/life-2/database/schema-design/m5-bookmarking-schema.md`
- [x] **Schema YAML**: `Docs/life-2/database/schema-design/m5-bookmarking-schema.yaml`
- [x] **Validation**: Đã chạy `validate_schema.py` và PASS.

### 🔔 M6: Notifications & Moderation
- [x] **Contract YAML**: `Docs/life-2/diagrams/class-diagrams/m6-notifications-moderation/class-m6-notifications.yaml` (Sẵn sàng)
- [x] **Schema Markdown**: `Docs/life-2/database/schema-design/m6-notifications-schema.md`
- [x] **Schema YAML**: `Docs/life-2/database/schema-design/m6-notifications-schema.yaml`
- [x] **Validation**: Đã chạy `validate_schema.py` và PASS.

---

## 📋 Quy tắc thực hiện (Reminder cho Agent)
1. **IP0**: Xác nhận đúng file Contract YAML trước khi bắt đầu.
2. **Phase 1**: Phân tích Metadata & Behaviors (Hooks) để thiết kế Strategy (Embed vs Ref).
3. **Phase 2**: Sinh file MD và YAML đồng thời vào thư mục `Docs/life-2/database/schema-design/`.
4. **Phase 3**: Chạy script `validate_schema.py` để đảm bảo 0 ảo giác về field name.
5. **Update**: Sau khi xong mỗi module, cập nhật lại checklist này.

---
*Tít dễ thương hứa sẽ bám sát checklist này để hoàn thiện dự án cho yêu thương! 💖*
