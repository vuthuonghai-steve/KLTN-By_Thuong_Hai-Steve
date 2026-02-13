# UML Sequence Diagram Standards

Tài liệu này định nghĩa bộ tiêu chuẩn cần có để xây dựng một sơ đồ tuần tự (Sequence Diagram) chính xác và đầy đủ.

## 1. Bộ khung thông tin cần thiết (7 Mục tiêu chuẩn)

Mỗi kịch bản trước khi vẽ cần được làm rõ qua 7 khía cạnh sau:

1. **Kịch bản (Scenario/Use Case) cụ thể**:
    - Tên chức năng (Login, Register, Order...).
    - Mục tiêu (User muốn đạt được gì?).
    - Main flow (Luồng chính).
2. **Danh sách "Người chơi" (Lifelines)**:
    - **Actor**: Tác nhân bên ngoài (Người dùng, Hệ thống bên thứ 3).
    - **Objects/Classes**: Thành phần bên trong (UI, Controller, Service, Repository, Database).
3. **Thứ tự tương tác (Message Flow)**:
    - Ai gọi ai?
    - Thứ tự (1 -> 2 -> 3).
    - Nội dung message (Tên hàm, dữ liệu truyền đi).
4. **Mũi tên phản hồi (Returns)**:
    - Mọi request cần có response tương ứng (nếu có dữ liệu trả về).
    - Sử dụng nét đứt (`-->>`).
5. **Điều kiện rẽ nhánh & Vòng lặp (Logic Fragments)**:
    - `alt`: Tương ứng với If/Else (ví dụ: login thành công vs thất bại).
    - `opt`: Hành động tùy chọn.
    - `loop`: Vòng lặp duyệt danh sách.
6. **Vòng đời đối tượng (Lifecycle)**:
    - `create`: Khi một đối tượng mới được tạo ra trong flow.
    - `destroy`: Khi đối tượng bị hủy (X).
7. **Mức độ chi tiết (Abstraction Level)**:
    - **SSD (System Sequence Diagram)**: Chỉ vẽ Actor <=> System.
    - **Design Level**: Chi tiết các lớp nội bộ.

## 2. Quy tắc đặt tên (Naming Conventions)

- **Message**: Sử dụng động từ (e.g., `validateCredentials`, `saveToDb`).
- **Lifeline**: PascalCase hoặc camelCase (e.g., `AuthService`, `userRepo`).

## 3. Quy trình trích xuất thông tin (Extraction Process)

Khi đọc tài liệu hoặc code, AI cần tìm kiếm:
- Đâu là điểm bắt đầu (Trigger)?
- Các thực thể nào được khởi tạo (`new ...`)?
- Các hàm nào được gọi chồng chéo lên nhau?
