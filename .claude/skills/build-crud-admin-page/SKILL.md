---
name: build-crud-admin-page
description: Xây dựng trang quản lý CRUD cho PayloadCMS collection. List view với filter, pagination. Form view với create, view, edit modes. Triggers: tạo trang admin, build CRUD page, tạo màn hình quản lý, new admin screen.
category: implementation
pipeline:
  stage_order: 10
  input_contract:
    - type: file
      path: "src/collections/{collection}.ts"
      required: false
  output_contract:
    - type: directory
      path: "src/components/screens/{collection}"
      format: directory
  dependencies: []
---

# Build CRUD Admin Page

Skill xây dựng trang quản lý CRUD cho PayloadCMS collection theo pattern BouquetScreen.

## Features

- List view với filter, pagination
- Form view với create, view, edit modes
- Tự động generate từ Payload collection config
