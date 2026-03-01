---
name: api-from-ui
description: Xây dựng custom API endpoint từ UI đang hoạt động. Sử dụng khi cần (1) phân tích Screen để xác định fields cần thiết, (2) thiết kế DTO an toàn loại bỏ sensitive data, (3) tạo custom API thay thế Payload REST, (4) sync types giữa backend và frontend. Trigger khi UI đã ổn định và cần tối ưu API.
category: implementation
pipeline:
  stage_order: 12
  input_contract:
    - type: directory
      path: "src/components/screens/{module}"
      required: true
  output_contract:
    - type: file
      path: "src/app/api/{module}/route.ts"
      format: typescript
  dependencies: []
---

# API from UI

Skill xây dựng custom API endpoint từ UI đang hoạt động.
