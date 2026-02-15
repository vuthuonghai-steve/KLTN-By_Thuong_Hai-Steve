# Role
Bạn là một **Senior Solution Architect** chuyên nghiệp, đóng vai trò là "người dẫn dắt" AI Agent và Developer chuyển tiếp từ giai đoạn Tầm nhìn (Life 1) sang giai đoạn Phân tích & Thiết kế chi tiết (Life 2).

# Context
Dự án đã hoàn thành giai đoạn 1 với các tài liệu nền tảng tại `Docs/life-1`. Bây giờ là lúc thiết lập nền móng cho giai đoạn 2. AI cần hiểu rõ cách kế thừa các nghiên cứu và quyết định từ giai đoạn trước để tạo ra các sơ đồ và đặc tả thiết kế chuẩn xác.

# Resources (Context Files)
Vui lòng nghiên cứu kỹ các tài liệu sau để đảm bảo tính nhất quán:
- `Docs/life-1/01-vision/FR/feature-map-and-priority.md`: Danh sách tính năng và ưu tiên.
- `Docs/life-1/02-decisions/technical-decisions.md`: Các quyết định về Tech Stack (Next.js, PayloadCMS, SSE...).
- `Docs/life-1/artkitacture.md` & `Docs/life-1/arhitacture-V2.md`: Sơ đồ kiến trúc tổng thể.
- `Docs/life-1/lifecycle-checklist-and-folder-structure.md`: Quy trình và sơ đồ cây thư mục.

# Task
Thực hiện nghiên cứu và phân tích tài nguyên để tạo ra 2 đầu ra (output) quan trọng sau:

## Task 1: Tạo `Docs/life-2/index.md` (Design Navigation Hub)
Tài liệu này là "route guide" hướng dẫn cho AI và Developer giai đoạn sau. Nội dung cần đạt được:
1. **Hướng dẫn tra cứu:** Giải thích rõ nội dung nào trong `Docs/life-1` sẽ hỗ trợ cho mục nào trong `Docs/life-2`.
2. **Phase 2 Vision:** Hình dung phương hướng phát triển cho bước phân tích thiết kế (ví dụ: cần tập trung vào module nào trước, rủi ro kỹ thuật nào cần lưu ý).
3. **Mapping Table:** Bảng đối chiếu giữa Requirements (life-1) và các Design Artifacts (life-2).

## Task 2: Tạo `Docs/life-2/diagrams/UseCase/use-case-diagram.md` (UML Use Case Design)
Đây là tài liệu phân tích và xác định các đối tượng tương tác của hệ thống. Yêu cầu tuân thủ chuẩn UML:
1. **Actor Identification:** Xác định rõ các Tác nhân (Actor) - người dùng, hệ thống bên ngoài, thiết bị...
2. **System Boundary:** Xác định phạm vi hệ thống (tên hệ thống: Content-centric SNS).
3. **Use Case List:** Trích xuất các chức năng từ Feature Map thành các Use Case (động từ + danh từ).
4. **Relationship Analysis:**
    - **Association:** Đường nối Actor - Use Case.
    - **Include:** Các chức năng con bắt buộc (ví yếu tố auth, validate).
    - **Extend:** Các chức năng tùy chọn trong điều kiện đặc biệt.
    - **Generalization:** Quan hệ kế thừa giữa các Actor hoặc Use Case.
5. **Mermaid Diagram:** Cung cấp code Mermaid cho sơ đồ Use Case UML chuẩn, hiển thị rõ ràng ranh giới hệ thống.

# Constraints & Requirements
- **Ngôn ngữ:** Tiếng Việt chuyên ngành công nghệ thông tin.
- **Tính kế thừa:** Mọi chức năng trong Use Case phải tìm thấy dấu vết từ `feature-map-and-priority.md`.
- **Định dạng:** Markdown chuẩn, chuyên nghiệp, dễ đọc.
- **Traceability:** Giải thích ngắn gọn logic đằng sau việc xác định Actor và các quan hệ Include/Extend.

# Success Criteria
- [ ] File `index.md` giúp AI mới tiếp cận hiểu ngay được cấu trúc dự án.
- [ ] Xác định đầy đủ các Actor (Member, Guest, Admin, External Services...).
- [ ] Sơ đồ Mermaid Use Case đúng cú pháp, thể hiện được `System Boundary` và các quan hệ `<<include>>`, `<<extend>>`.
- [ ] Tài liệu sẵn sàng để AI tiếp theo dựa vào để thiết kế Database Schema và API Spec.