# Bản Đặc Tả Kỹ Thuật: Tích hợp Pencil MCP Component vào AI Agent Skill

Dành cho Agent chuyên trách UI/UX (vd: ui-pencil-drawer) - Tối ưu hóa khác biệt so với Figma

Tài liệu này không chỉ hướng dẫn dùng Pencil, mà là **bộ nguyên tắc sinh tồn (Survival Rules) và tư duy Hệ thống (Systematic Thinking)** dành cho AI Agent khi chuyển đổi Prompts/Specs thành UI trong môi trường `.pen`. Nền tảng `.pen` mạnh hơn Figma ở điểm: **Nó là Code-driven và AI Context-aware trực tiếp**.

---

## I. MÔ THỨC LÀM VIỆC CỦA AI VỚI PENCIL (Khác biệt với Figma)

| Đặc điểm | Cách Figma làm việc | Cách Pencil + AI Agent làm việc |
| :--- | :--- | :--- |
| **Bối cảnh (Context)** | Phụ thuộc vào tên Layer/Group (thường mơ hồ). | Tích hợp thẳng vào property `context` của Node. AI tự đọc hiểu logic và chức năng nghiệp vụ của component. |
| **Cấu trúc dữ liệu** | Phức tạp, nhiều metadata độc quyền. | JSON/Schema thuần túy. AI dùng CRUD (I, U, R, M, D, C) qua `batch_design` như query Database. |
| **Tái sử dụng (Reusable)** | Main Component -> Instance. Overrides khó query. | Node có cờ `reusable: true`. Dùng kiểu `ref` với hệ thống `descendants` mapping override cực chuẩn xác. |
| **Layout Engine** | Auto Layout (Frame). | Thuần Flexbox (vertical/horizontal, gap, padding, justifyContent). Dễ dàng suy luận bằng logic code frontend. |

---

## II. BỘ QUY TẮC TIẾP CẬN YÊU CẦU (AGENT WORKFLOW RULES)

Khi AI Agent nhận được một Prompt thiết kế UI từ User (hoặc từ UI Spec), bắt buộc phải tuân thủ luồng sau:

### 1. The "Discover Before Draw" Rule (Khám phá trước khi vẽ)

Tuyệt đối KHÔNG tự ý tạo mới component nếu chưa khảo sát `Lib-Component`.

* Action 1: Gọi `get_editor_state(include_schema: false)` để lấy danh sách "Reusable Components".
* Action 2: Trích xuất ID của các component cần thiết.
* Action 3: Gọi `batch_get(nodeIds, readDepth: 3)` để hiểu rõ cấu trúc của component (nhất là các thuộc tính `id` con để biết đường *override*).
* Action 4: Nếu UI cần vẽ không có trong thư viện -> Xin phép user tạo component mới, HOẶC tự tạo mới với cờ `reusable: true` và ghi chú `context` rõ ràng.

### 2. The "Slot Replacement" Rule (Quy tắc điền vào chỗ trống)

Thay vì tạo cụm giao diện rời rạc, hãy sử dụng tính năng **Slot** của hệ thống component.

* Thực hiện chèn (Insert - `I`) component cha.
* Dùng lệnh thay thế (Replace - `R`) để thay toàn bộ một nút con (`childId`) bằng một cụm Frame/Components mới, thông qua cú pháp: `R(instance+"/slotId", { type: "frame", ... })`.

### 3. The "25-Ops Safety" Rule (Giới hạn tải)

* **Giới hạn:** Tối đa **25 operations** cho mỗi lệnh `batch_design`.
* **Xử lý:** Đối với một Screen lớn (Dashboard), AI phải chia thành nhiều đợt:
  * Batch 1: Vẽ bộ khung Container, Layout chia cột, Background, Navbar.
  * Batch 2: Populate nội dung Sidebar và Header.
  * Batch 3: Populate nội dung Main Content (Cards, Tables).

---

## III. BỘ NGUYÊN TẮC HÌNH THÁI GIAO DIỆN (STRUCTURAL & LAYOUT RULES)

Để AI không sinh ra thiết kế bị "chồng chéo" hay vỡ layout, tuân thủ các hằng số sau:

### 1. Luật Flexbox Tuyệt Đối

* **Mặc định:** Khởi tạo Frame luôn dùng `layout: "vertical"` hoặc `layout: "horizontal"`. Tắt `layout: "none"` trừ khi làm hiệu ứng đồ hoạ đè lên nhau (vd: Button Shadow theo phong cách Neobrutalism).
* **Quy luật X/Y:** Bị **VÔ HIỆU HÓA** hoàn toàn bên trong Flexbox. Đừng cố gán tọa độ `x`, `y` trong cụm Flex. Nếu muốn đẩy khoảng cách, phải dùng `padding`, `gap`, hoặc bọc thêm frame trung gian.
* **Sizing Engine:**
  * Dùng `width: "fill_container"` (Giống *Fill Container* của Figma) để ép component nở hết cỡ theo không gian của cha.
  * Dùng `height: "fit_content"` (Giống *Hug Contents* của Figma) để ép khung cha ô-m trọn lấy nội dung bên trong. (Có thể đặt kèm fallback: `fit_content(200)`).
* **Anti-pattern cần tránh:** Mẹ dùng `fit_content`, tất cả con bên trong dùng `fill_container` -> Sẽ tạo ra **Vòng lặp vô tận (Circular Dependency)** -> Layout sẽ sụp đổ về 0.

### 2. Luật Text & Wrapping

Thiết kế của AI thường bị lỗi Text tràn ra ngoài khung vì không nắm luật TextGrowth của `.pen`:

* Mặc định TextGrowth là `"auto"` -> Không bao giờ quấn dòng (wrap), chiều rộng dài ra vô tận theo chữ. Không phản hồi với thuộc tính width/height.
* **KHI CẦN TEXT XUỐNG DÒNG (Wrapping):** BẮT BUỘC đổi `textGrowth: "fixed-width"` VÀ truyền thêm thuộc tính `width: <giá trị cụ thể hoặc "fill_container">`.
* Thuộc tính căn chỉnh `textAlign` (left/center/right) và `textAlignVertical` chỉ có tác dụng khi dùng `fixed-width` hoặc `fixed-width-height`.

### 3. Luật Kế thừa Variables (Design Tokens)

Cấm AI sử dụng mã màu Hex tĩnh (vd: `#FF4500`) ngoài phạm vi khai báo thư viện.

* AI phải gọi `get_variables()` để biết các Token đang có trong dự án.
* Khi thiết kế, áp dụng biến dưới dạng chuỗi có tiền tố `$`: `fill: "$--primary"`, `fill: "$--background"`, `gap: "$--spacing-md"`.
* Giúp dễ dàng đổi Theme toàn hệ thống mà không cần sửa từng Component.

---

## IV. BỘ NGUYÊN TẮC VIẾT SCRIPT THỰC THI (CODE SYNTAX RULES)

Công cụ `batch_design` dùng cú pháp JavaScript giả lập. Để Agent chuẩn hóa, hãy theo rule sau:

### 1. Pattern Khai báo Biến & Tham chiếu (Binding & Reference)

Sau khi thực thi Insert (`I`), Copy (`C`), hoặc Replace (`R`), phải lưu ID vào biến tạm để dùng tiếp trong chain.

```javascript
// ✅ GOOD: Gắn biến và kế thừa (Binding)
card = I(container, { type: "ref", ref: "FEkTl", width: "fill_container" })
U(card+"/xdCvx_n", { content: "Tiêu đề tĩnh mới" }) 
```

### 2. Cạm bẫy của lệnh Copy (The "C" Trap)

Khi Agent dùng lệnh `C` (Copy) để nhân bản một nhóm node:

* **BÀI HỌC XƯƠNG MÁU:** Lệnh `C` tạo ra một bộ ID hoàn toàn mới cho tất cả các node con bên trong.
* **NGHIÊM CẤM:** KHÔNG ĐƯỢC gọi `U(copiedNode+"/oldChildId")`. Nó sẽ thối (fail) ngay lập tức vì `oldChildId` không còn tồn tại ở bản sao.
* **HƯỚNG GIẢI QUYẾT TỐI ƯU:** Đẩy nguyên các cập nhật vào hàm Copy thông qua tham số `descendants`.

```javascript
// ✅ CORRECT (Kết hơp Descendants khi Copy)
btn = C("wWUxj", container, { descendants: { "Njux9": { content: "SAVE CHANGES", fill: "$--secondary" } } })
```

### 3. Placeholder là Không gian Thao trường

* Khi bắt tay vào thiết kế theo Prompt, phải Insert một Container tổng và đánh dấu `placeholder: true`.
* Nó giam lỏng sự hiển thị và báo cho user biết rằng "Sản phẩm này đang được dựng".
* Khi Agent hoàn tất các lệnh trong Batch cuối cùng, bắt buộc gọi `U("rootFrameId", { placeholder: false })` để bàn giao.

---

## V. CƠ CHẾ SÁNG TẠO TRONG KHUÔN KHỔ (BOUNDED CREATIVITY)

Đừng để AI Agent trở thành những chiếc máy in khô khan, nhưng cũng đừng để chúng sinh ra ảo giác phá vỡ hệ thống Design System. Hãy vận dụng nguyên tắc sau:

### 1. Phân Lập Strict Zones vs Fluid Zones

* **Strict Zones (Vùng Nghiêm Ngặt):** (Forms, Tables, Navigate, Data Cards).
  * *AI Action:* Lắp ghép khối 100% từ `Lib-Component`. Không được tự bịa ra UI element mới hay bỏ sót spec field.
* **Fluid Zones (Vùng Sáng Tạo):** (Hero Banners, Empty States, Onboarding, Marketing sections).
  * *AI Action:* Tự do định cỡ Flexbox, quyết định khoảng trắng (White space), sinh Text copywriting thuyết phục dựa trên Persona, và sử dụng lệnh G(AI Images).

### 2. Sức Mạnh Hình Ảnh (The "G" Operation)

Tuyệt đối KHÔNG bắt AI tự vẽ Vector/Path phức tạp (sinh rác Node). Thay vào đó, dùng `G()` để biến component hộp khô khan thành nghệ thuật.

* Quy tắc:** Thêm một frame làm vùng chứa ảnh, sau đó gọi `G(frame_id, "ai", "prompt miêu tả hình ảnh")`.
* Ví dụ:** `G(hero_frame, "ai", "3d abstract glassmorphism shapes floating, soft pink colors")`. Result: Layout cực kỳ ấn tượng mà cấu trúc không sập.

### 3. Tự Kiểm Điểm (Self-Critique bằng get_screenshot)

* Sau khi chạy `batch_design`, hãy gài vào checklist để Agent tự soi `get_screenshot`:
  * *"Typography (Visual Hierarchy) đã rõ ràng chưa?"*
  * *"White Space có đủ thoáng không?"*
  * *"Có dính element rác nào không?"*
* Nếu vi phạm, ngầm tự undo và điều chỉnh (ví dụ: kích cỡ gap/padding) rồi mới submit kết quả cho User.

### 4. Animation Meta-Tagging (Chỉ thị chuyển động)

Tuyệt đối KHÔNG bỏ qua trải nghiệm người dùng. Dù Pencil là tĩnh, AI phải "cấy" mã gene chuyển động vào `context`.

* **Quy tắc:** Sử dụng các tokens từ `animation-spec-guide.md` để gán vào `context`.
* **Cấu trúc:** `{ "context": { "animation": "token-name", "delay": ms } }`.
* **Mục tiêu:** Để Phase chuyển đổi sang Code có thể tự động bọc `framer-motion` mà không cần đoán.

---

## VI. CÁC TRIGGERS CHO NGƯỜI DÙNG

(Người dùng có thể chèn các cụm từ này vào Prompt để định hướng AI Agent)

* `--use-lib [id]`: Ép AI dùng duy nhất component từ ID được chỉ định.
* `--wireframe`: AI chỉ tạo các ô xám/placeholder chuẩn kích thước, không chèn graphic hay text thật (Tập trung check flow).
* `--strict-layout`: AI phải kiểm tra chống vỡ layout (`snapshot_layout`) sau từng lượt vẽ.
* `--component-mode`: AI được hiểu ngầm là thiết kế component vào thư viện, tự động bật `reusable: true` và đòi User viết `context`.
* `--creative`: Kích hoạt tối đa quyền "Fluid Zones" và sinh hình AI `G()` cho các mảng trống.
