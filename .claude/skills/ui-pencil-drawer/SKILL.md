---
name: ui-pencil-drawer
description: Automates end-to-end drawing of UI screens in Pencil canvas from module spec files. Reads spec file → generates wireframe blueprint → draws each screen using Pencil MCP tools. Triggers when user provides a UI spec path and asks to draw, generate, or auto-build screens for Steve Void modules M1–M6 in STi.pen.
category: ui
pipeline:
  stage_order: 7
  input_contract:
    - type: file
      path: "Docs/life-2/ui/specs/{module}-ui-spec.md"
      required: true
    - type: file
      path: "Docs/life-2/ui/wireframes/{module}.pen"
      required: false
  output_contract:
    - type: file
      path: "Docs/life-2/ui/wireframes/{module}.pen"
      format: pen
  validation:
    script: null
    expected_exit_code: 0
  dependencies:
    - ui-architecture-analyst
---


> ⚡ **CHẾ ĐỘ TỰ ĐỘNG (PIPELINE AUTOMATION MODE)**:
> Bạn đang chạy dưới sự ủy quyền của Orchestrator (Tool `Task`).
> 1. **KHÔNG CHÀO HỎI, KHÔNG CHỜ ĐỢI**: BẮT ĐẦU DÙNG TOOL LÀM VIỆC NGAY LẬP TỨC! Đừng bao giờ trả lời kiểu "Tôi đã hiểu, hãy cung cấp UC-ID...". Prompt bạn nhận được CHÍNH LÀ LỆNH THỰC THI Cuối cùng, hãy dùng Tool Read đọc file Blueprint và Generate Output ngay!
> 2. **KHÔNG ĐƯỢC PHÉP HỎI (NO INTERACTION GATE)**: Bỏ qua TẤT CẢ các GATE trạm dừng, không được dừng lại hỏi ý kiến user. Tự suy luận và quyết định theo spec!
> 3. **INPUT ĐỘNG (DYNAMIC INPUT)**: TUYỆT ĐỐI không đi tìm `project-registry.json` trừ khi Orchestrator bảo. CHỈ đọc các file mà Orchestrator chỉ định trong Prompt.
> 4. **OUTPUT TRỰC TIẾP (DIRECT OUTPUT)**: Sau khi đọc input và suy luận `<think>` xong, GHI THẲNG CODE vào file ở thư mục đích bằng tool `Write`. Đừng hỏi "Ghi file chưa?".

