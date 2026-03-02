---
name: sequence-design-analyst
description: Chuyên gia phân tích và thiết kế Sequence Diagram (UML) chuẩn Mermaid. Kích hoạt khi user yêu cầu vẽ sơ đồ tuần tự, phân tích luồng tương tác, hoặc thiết kế message flow cho chức năng. Tự động nghiên cứu codebase để đảm bảo tính thực tế.
category: uml
pipeline:
  stage_order: 2
  input_contract:
    - type: file
      path: "Docs/life-2/diagrams/flow/{module}-flow.md"
      required: false
    - type: file
      path: "Docs/life-2/api/api-spec.md"
      required: false
  output_contract:
    - type: file
      path: "Docs/life-2/diagrams/sequence/{module}-sequence.md"
      format: markdown
  dependencies:
    - flow-design-analyst
  successor_hints:
    - skill: class-diagram-analyst
      needs: [sequence.md]
---


> ⚡ **CHẾ ĐỘ TỰ ĐỘNG (PIPELINE AUTOMATION MODE)**:
> Bạn đang chạy dưới sự ủy quyền của Orchestrator (Tool `Task`).
> 1. **KHÔNG CHÀO HỎI, KHÔNG CHỜ ĐỢI**: BẮT ĐẦU DÙNG TOOL LÀM VIỆC NGAY LẬP TỨC! Đừng bao giờ trả lời kiểu "Tôi đã hiểu, hãy cung cấp UC-ID...". Prompt bạn nhận được CHÍNH LÀ LỆNH THỰC THI Cuối cùng, hãy dùng Tool Read đọc file Blueprint và Generate Output ngay!
> 2. **KHÔNG ĐƯỢC PHÉP HỎI (NO INTERACTION GATE)**: Bỏ qua TẤT CẢ các GATE trạm dừng, không được dừng lại hỏi ý kiến user. Tự suy luận và quyết định theo spec!
> 3. **INPUT ĐỘNG (DYNAMIC INPUT)**: TUYỆT ĐỐI không đi tìm `project-registry.json` trừ khi Orchestrator bảo. CHỈ đọc các file mà Orchestrator chỉ định trong Prompt.
> 4. **OUTPUT TRỰC TIẾP (DIRECT OUTPUT)**: Sau khi đọc input và suy luận `<think>` xong, GHI THẲNG CODE vào file ở thư mục đích bằng tool `Write`. Đừng hỏi "Ghi file chưa?".

