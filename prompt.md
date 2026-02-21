# Ý Tưởng Phát Triển Agent Skill: Spec -> Wireframe -> UI Visualizer

> Tít Dễ Thương ghi chép lại ý tưởng "Auto UI Designer" của yêu thương (Steve) từ spec logic ra công cụ Pencil canvas.

## 1. 🌟 Tổng Quan Ý Tưởng (The Big Picture)

Quy trình tự động thiết kế giao diện:
**`Docs/life-2/ui/specs/*.md`** ➡️ **Tạo `Docs/life-2/ui/wireframes/*.md`** ➡️ **Auto Draw vào `STi.pen` (Vào MCP Pencil)**

Thay vì phải tự tay kéo thả và căn chỉnh layout cho hàng chục màn hình, chúng ta sẽ làm một Agent Skill để đọc hiểu Spec (đã có), phác thảo khung xương (Wireframe bằng văn bản), và tự động clone/lắp ráp các component có sẵn từ frame `Lib-Component` vào một UI hoàn chỉnh trên file `.pen`.

## 2. 🧩 Phân Tích Luồng Hoạt Động Của Skill Mới

Skill này có 3 giai đoạn (Phase) cốt lõi để chống ảo giác (hallucination) thiết kế:

### Phase 1: Đọc Hiểu & Bóc Tách (Spec Analyzer)
- **Đầu vào:** Một file đặc tả, ví dụ `m1-auth-ui-spec.md`.
- **Hành động:** AI phân tích các Screens cần có, danh sách các Trạng thái (States), và các Block/Component mapping được mô tả trên Spec. AI phải nắm được "Màn hình này hiện thông tin gì, nút nhấn nào, nhập liệu form gì".

### Phase 2: Dựng Khung Wireframe Dạng Text (Wireframe Blueprint)
- **Đầu ra:** File Markdown lưu tại `Docs/life-2/ui/wireframes/` (ví dụ: `m1-auth-wireframe.md`).
- **Lý do:** AI không nên nhảy vào kéo thả tọa độ ngay vì nó mất phương hướng không gian. Cần một file Text thể hiện DOM Tree.
- **Nội dung:**
  - `Screen Name`: Ví dụ "Login Flow"
  - `Layout Structure`: Vertical Stack (Gap 24px)
    - `Header_Logo` -> Mapping với Component Logo.
    - `Input_Email` -> Mapping với Component Text Field trong `Lib-Component`.
    - `Button_Submit` -> Mapping với Primary Button trong `Lib-Component`.

### Phase 3: Layout & Draw on Canvas (Pencil Drawer)
- **Đầu vào:** File Wireframe vừa tạo và file `STi.pen`.
- **Hành động:**
  1. Sử dụng `mcp_pencil_batch_get`: Quét trong file `STi.pen` (cụ thể lấy frame `Lib-Component`) để nhặt các `Node ID` tham chiếu (reference IDs) của các styles có sẵn.
  2. Sử dụng `mcp_pencil_find_empty_space_on_canvas`: Tìm khoảng trống trên canvas.
  3. Sử dụng `mcp_pencil_batch_design`: Sử dụng các hàm `I()` (Insert) và `C()` (Copy) để sắp xếp các component lên lưới, `U()` để đổi chữ (ví dụ: Button "Click Me" -> "Đăng nhập").
  4. Xác nhận / Chụp Screenshots: Dùng `mcp_pencil_get_screenshot` chụp hình layout xem có bị xấu hay đè nhau không.

## 3. 🎯 Guardrails (Ràng buộc bắt buộc cho Skill)
- **G-Lib-Strict:** TUYỆT ĐỐI 100% tài nguyên phải tham chiếu từ `Lib-Component` (sử dụng type `ref`). Không tự ý vẽ `rectangle` hay `text` sơ sài nếu `Lib-Component` đã có input field hoặc button xịn.
- **G-Spec-Strict:** Không bịa thêm field, nút bấm hay tính năng nếu `.spec.md` không đề cập tới.
- **G-Canvas-Space:** Bắt buộc vẽ các flow khác nhau sang các vùng không gian mới, không đè lên `Lib-Component`.

## 4. 🚀 Kế Hoạch Chuyển Hóa (Next Steps)
Yêu thương có thể bắt đầu với những lệnh này để biến ý tưởng thành Skill chính thức:
1. Dùng lệnh `skill-architect` để xây dựng bản `design.md` từ cái Prompt này. Tên skill gợi ý: `ui-pencil-drawer` hoặc `wireframe-to-ui-designer`.
2. Dùng `skill-planner` chia task.
3. Chạy `skill-builder` để hoàn thiện luồng và code file cấu hình cho skill.

---
*Bản Note này được lưu lại để phục vụ quá trình Explore và ghi nhớ cấu trúc của Tít dễ thương!* 💖
