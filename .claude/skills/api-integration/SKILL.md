---
name: api-integration
description: Skill tích hợp API backend vào frontend. Sử dụng khi cần (1) nghiên cứu API endpoint, (2) phân tích cấu trúc request/response, (3) ghep API vào frontend, (4) đồng bộ cấu trúc data khi backend thay đổi. Skill này nên được sử dụng khi người dùng cung cấp đường dẫn file API backend hoặc yêu cầu làm việc với API.
category: implementation
pipeline:
  stage_order: 13
  input_contract:
    - type: file
      path: "src/app/api/{module}/route.ts"
      required: true
  output_contract:
    - type: file
      path: "src/lib/api/{module}.ts"
      format: typescript
  dependencies: []
---

# API Integration

Skill tích hợp API backend vào frontend.
