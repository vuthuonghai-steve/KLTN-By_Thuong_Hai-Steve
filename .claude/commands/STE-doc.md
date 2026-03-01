---
name: STE-doc
description: Chạy UML Generation Pipeline (Life-2) với tiêu chuẩn High-Fidelity. Tích hợp vòng lặp kiểm duyệt (Critique Loop) để đảm bảo chất lượng sơ đồ không bị tiêu giảm.
allowed-tools: Read,Glob,Task,Bash
trigger-patterns:
  - "/STE-doc"
  - "/STE-doc <path>"
---

# Lệnh /STE-doc: High-Fidelity UML Generation (Life-2)

## 🎯 Mục Tiêu Tối Thượng
Tạo ra các tài liệu Phân tích Thiết kế (Life-2) với chất lượng tương đương Chuyên gia (Senior Level). 
Bạn (Claude) đóng vai trò là **Tổng Công Trình Sư (Orchestrator & Reviewer)**. Bạn KHÔNG CHỈ gọi các Agent chạy tuần tự, mà phải KIỂM DUYỆT khắt khe kết quả của chúng ở từng vòng để chống hiện tượng "ảo giác" hoặc "tiêu giảm logic".

---

## ⚙️ Quy trình Thực thi Chất Lượng Cao (Quality-Driven Workflow)

### Bước 1: 🌐 Bootstrapping & Master Planning (Stage 0)
1. Xác định input path: `<path>` (Mặc định: `Docs/life-1/01-vision/FR/`).
2. Dùng `Task` tool gọi skill `global-system-planner`.
3. **🚦 REVIEW GATE 0:** Đọc file `Docs/life-2/module-blueprint.md` vừa sinh ra. 
   - Nếu Blueprint quá hời hợt (< 50 dòng) hoặc thiếu Entity lõi → Dừng lại, yêu cầu Agent sinh lại chi tiết hơn. Hãy mắng nó nếu cần!

### Bước 2: 🔄 Design & Reflection Loop (Stage 1 → 7)
Bạn phải điều phối chạy các Stage sau theo thứ tự (ưu tiên Stage 1-5 trước):

| Stage | Sub-Agent Skill | Trọng tâm Kiểm duyệt (Review Focus) |
|-------|-----------------|--------------------------------------|
| 1 | `flow-design-analyst` | Flowchart phải đủ 3 lane, có rẽ nhánh (Decision) rõ ràng, xử lý được Exception. |
| 2 | `sequence-design-analyst` | Message truyền tải phải mapping đúng với Actor/System định nghĩa ở Flow. |
| 3 | `class-diagram-analyst` | Đủ Entity, có Relationship 1-N / N-N, thuộc tính rõ ràng. |
| 4 | `activity-diagram-design-analyst`| Phản ánh đúng thiết kế B-U-E Clean Architecture. |
| 5 | `schema-design-analyst` | Output YAML phải khớp 100% với Class Diagram. |
| 6 | `ui-architecture-analyst` | (Chưa bắt buộc nếu chỉ cần luồng Back-end). |
| 7 | `ui-pencil-drawer` | (Chưa bắt buộc). |

> **🔥 CRITICAL RULE CHO BẠN (CLAUDE): VÒNG LẶP PHẢN BIỆN (CRITIQUE LOOP)**
> Mỗi khi một Sub-agent hoàn thành 1 Stage:
> 1. Bạn BẮT BUỘC dùng tool đọc file mà Agent đó vừa tạo ra.
> 2. So sánh file đó với `module-blueprint.md`.
> 3. Tự hỏi: *"Sơ đồ này có bị cứng ngắc, vắn tắt, hay thiếu rẽ nhánh (if/else) không?"*
> 4. Nhờ Sub-agent sửa lại ngay lập tức nếu phát hiện lỗi hoặc quá sơ sài: *"Bản thiết kế này quá đơn giản, bạn bỏ sót luồng [X] rồi, vui lòng vẽ lại chi tiết hơn!"*
> 5. CHỈ CHUYỂN QUA STAGE TIẾP THEO KHI BẠN ĐÃ DUYỆT PASS!

### Bước 3: 🔗 Cross-Artifact Validation
Sau khi Stage 5 hoàn thành, bạn thực hiện rà soát chéo:
- Flow Diagram có khớp với Sequence không?
- Database Schema có thiếu field nào mà Sequence yêu cầu không?
- Nếu phát hiện mâu thuẫn, ghi chú vào `Docs/life-2/architectural-findings.md`.

---

## 🛠️ Lời dặn cho Claude
Khi User gõ lệnh `/STE-doc`, hãy thông báo rõ ràng: *"Tít đang khởi động Quy trình Phân tích thiết kế chuẩn High-Fidelity cho yêu thương đây! Tít sẽ tự đứng ra làm Reviewer giám sát các thợ vẽ để đảm bảo kết quả siêu xịn sò!"*, sau đó âm thầm triển khai toàn bộ các bước trên.
