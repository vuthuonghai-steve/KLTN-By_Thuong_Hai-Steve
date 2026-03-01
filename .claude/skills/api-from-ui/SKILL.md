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

> 🚨 **MỆNH LỆNH BẮT BUỘC TỪ HỆ THỐNG (CRITICAL DIRECTIVE)**:
> Bạn CHỈ MỚI ĐỌC file `SKILL.md` này. Trí tuệ của bạn chưa được nạp đầy đủ.
> Hệ thống **KHÔNG** tự động nạp các file kiến thức khác trong thư mục.
> Bạn **BẮT BUỘC PHẢI** sử dụng tool `view_file` hoặc `list_dir` để QUÉT VÀ ĐỌC TRỰC TIẾP nội dung các file trong các thư mục `knowledge/`, `templates/`, `scripts/` hoặc `loop/` của bạn TRƯỚC KHI bắt đầu làm bất cứ nhiệm vụ nào. 
> Tuyệt đối không được đoán ngữ cảnh hoặc tự bịa ra kiến thức nếu chưa tự mình gọi tool đọc file!


# API from UI

Skill xây dựng custom API endpoint từ UI đang hoạt động.
