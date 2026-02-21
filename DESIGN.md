### 1. 🎯 Xác định Skill: "UI Wireframe Designer"

Skill này không chỉ là "vẽ", mà là  **"Dịch thuật từ Logic sang Interface"** .

* **Làm gì?** : Phân tích Use Case, Activity Diagram và Class Diagram để xác định các thành phần UI cần thiết (Inputs, Actions, Data Display) và sắp xếp chúng vào các khung hình (Layout/Wireframe).
* **Làm như thế nào?** : Sử dụng tool `pencil` MCP để tác động trực tiếp lên canvas, kết hợp với bộ quy tắc thiết kế (Design System) của dự án.
* **Kết quả đạt được** :

1. Các bản **Wireframe thực tế** trên file `.pen`.
2. Tài liệu **UI Spec** (Markdown) mô tả chi tiết logic của từng màn hình để AI ở Life-3 có thể code được ngay.

### 2. 🧠 Chuẩn bị Kiến thức & Nguyên tắc (The Brain)

Để tránh "ảo giác", Skill này cần được nạp các "vốn liếng" sau:

* **Input đầu vào** :
* `Docs/life-2/specs/`: Nắm rõ nghiệp vụ màn hình đó làm gì.
* `Activity/Sequence Diagrams`: Để biết thứ tự các nút bấm và phản hồi.
* `Class Diagram/Schema`: Để biết các field dữ liệu cần hiển thị (tránh thiếu/thừa field).
* **Style Guide** : Các mẫu Neobrutalism hoặc hệ màu Primary (Pink) đã định nghĩa.
* **Nguyên tắc** : "Atomic Design" (đi từ component nhỏ đến page lớn) và "Mobile First" (nếu cần).
* **Format đầu ra** :
* **Visual** : Frame trong file `.pen` có cấu trúc lớp (layers) rõ ràng.
* **Doc** : Metadata mô tả các `data-testid`, `interaction flow` cho AI Agent tiếp theo hiểu.

### 3. 🛠️ Kết nối với MCP Pencil

Skill này **hoàn toàn có thể và bắt buộc** phải kết nối với `mcp pencil`.

* Nó sẽ dùng `batch_design` để "đặt" các component từ thư viện (Buttons, Inputs, Cards) lên canvas.
* Nó sẽ dùng `find_empty_space` để tự tìm chỗ trống trên canvas để vẽ màn hình mới, không đè lên cái cũ.

### 4. 🤖 Làm sao để AI hiểu được Output?

Một Wireframe "đẹp" với người chưa chắc đã "tốt" với AI Agent code. Skill này sẽ giải quyết bằng cách:

* **Đặt tên ID logic** : Mỗi node trong Pencil phải có ID hoặc Name gắn với mã Use Case hoặc Field Name (ví dụ: `input-username`, `btn-submit-m1`).
* **UI Contract** : Sinh ra một file Markdown phụ trợ (vào `Docs/life-2/ui/`) giải thích: "Màn hình M1 này có nút X, khi bấm sẽ gọi service Y đã định nghĩa trong spec".

### 5. 🔄 Tận dụng tài nguyên hiện có (Context Synchronization)

Để đảm bảo tính "đồng bộ chặt chẽ", Skill sẽ chạy qua quy trình:

1. **Traceability** : Trước khi vẽ, nó phải liệt kê: "Màn hình này phục vụ UC-01, hiển thị dữ liệu từ Table User, luồng đi theo Activity Diagram A".
2. **Consistency Check** : Nếu Class Diagram nói có 5 field, mà Wireframe chỉ vẽ 4, Skill phải tự cảnh báo hoặc giải trình lý do.
