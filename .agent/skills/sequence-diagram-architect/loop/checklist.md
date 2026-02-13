# Quality Control Checklist for Sequence Diagram

Dùng để hậu kiểm (verify) sau khi AI render xong file Mermaid.

## 1. Tính đúng đắn của UML
- [ ] Có đầy đủ Title cho sơ đồ?
- [ ] Có `autonumber` để dễ theo dõi?
- [ ] Các Actor có dùng icon `actor`?
- [ ] Có mũi tên phản hồi (`-->>`) cho các request quan trọng?
- [ ] Các logic rẽ nhánh có nằm trong khung `alt` hoặc `opt`?

## 2. Tính kiến trúc (Senior Level)
- [ ] Tên các message có mang ý nghĩa nghiệp vụ (không dùng process1, process2)?
- [ ] Có xử lý kịch bản lỗi (Exception flow) không?
- [ ] Khoảng cách giữa các Lifeline có hợp lý (không bị chồng chéo)?

## 3. Khả năng hiển thị
- [ ] Mã Mermaid không chứa ký tự đặc biệt gây lỗi render.
- [ ] Có sử dụng `box` để nhóm các thành phần liên quan (ví dụ: Backend, Database)?

---
**Kết luận**: 
- Nếu Pass > 90% -> Gửi kết quả cho người dùng.
- Nếu Fail -> Quay lại Phase 2 để sửa logic.
