# Tài liệu Product UI Module

Tài nguyên triển khai và lưu ý khi làm việc với giao diện sản phẩm (Bouquet, Accessory, SingleFlower).

## Cấu trúc tài liệu

| File | Mô tả |
|------|-------|
| **architecture.md** | Cấu trúc thư mục, data flow, form mode pattern, component responsibilities |
| **implementation-logic.md** | Logic hoạt động chi tiết (category scope, metadata, API, ProductFilters) |
| **notes-product-workflow.md** | Lưu ý khi làm việc với product (config, design decisions, pitfalls) |
| **template-guide.md** | Hướng dẫn áp dụng pattern cho collection mới |
| **checklist.md** | Checklist triển khai từng bước |
| **errors.md** | Lỗi thường gặp và cách xử lý |

## Modules áp dụng

- **BouquetScreen** — Bó hoa: full-page, 7 tabs
- **AccessoryScreen** — Phụ kiện: full-page, inline sections, danh mục scoped
- **SingleFlowerScreen** — Hoa lẻ: (tham chiếu BouquetScreen)

## Nguồn tài liệu

Được tổng hợp từ các OpenSpec changes đã archive:

- `2026-01-30-bouquet-ui-module` — Bouquet full-page pattern
- `2026-02-02-refactor-accessory-screen` — AccessoryScreen refactor
- `2026-02-02-scope-accessory-categories` — Scope danh mục phụ kiện
