# Ý tưởng xây dựng Skill: Sequence Diagram Architect

Tài liệu này ghi chép lại các quyết định, kiến trúc và lộ trình xây dựng Agent Skill hỗ trợ vẽ Sequence Diagram theo chuẩn Meta-Skill Framework.

---

## 1. Thông tin cốt lõi (Core Information)

- **Tên Skill mục tiêu:** `sequence-diagram-architect`
- **Persona:** **Senior Architect** (Kiến trúc sư trưởng). Không chỉ vẽ hình, mà còn có khả năng tư vấn, phát hiện lỗi logic và gợi ý các kịch bản ngoại lệ (alt/opt).
- **Định dạng Output:** Markdown file chứa mã **Mermaid code**.

---

## 2. Chiến lược tiếp cận Input (Input Strategy)

Skill sẽ tiếp cận một cách **chủ động (Proactive)** thông qua 2 luồng:

### Luồng A: Người dùng cung cấp Input ngắn gọn (e.g. "Vẽ sơ đồ đăng nhập")
1. **Phản hồi ngay lập tức:** Không vẽ ngay mà gửi cho người dùng một **Checklist thông tin đang thiếu** dựa trên tiêu chuẩn tại `context1.md`.
2. **Phỏng vấn (Interactive Interview):** Đặt các câu hỏi cụ thể để lấy thêm context (Actor là ai? Hệ thống gồm những lớp nào? Có lỗi gì thường gặp không?).
3. **Nạp dữ liệu:** Sau khi người dùng trả lời, cập nhật vào file tóm tắt context.

### Luồng B: Người dùng cung cấp tài liệu/file/code
1. **Phân tích (Research):** Skill thực hiện quét và trích xuất thông tin (Extract) các thành phần tham gia và quy trình tương tác.
2. **Xác nhận (Validation):** Đối chiếu với bộ tiêu chuẩn UML, liệt kê các điểm mờ hoặc thiếu sót.
3. **Yêu cầu bổ sung:** Gửi yêu cầu làm rõ cho người dùng trước khi tiến hành vẽ.

**Output trung gian (Intermediate Outputs):**
- `input-checklist.md`: Thể hiện thông tin đã có và thông tin còn thiếu.
- `context-summary.md`: Bản tóm tắt luồng nghiệp vụ cuối cùng trước khi chuyển sang sơ đồ.

---

## 3. Kiến trúc hệ thống (Skill Architecture)

Dựa trên `architect.md`, skill sẽ được phân vùng như sau:

### 3.1. Thư mục: `.agent/skills/sequence-diagram-architect/`

- **`SKILL.md` (Core Control):**
    - Điều phối 4 giai đoạn: **Phát hiện (Discovery) -> Phân tích (Analysis) -> Duyệt (Review) -> Thực thi (Render)**.
    - Chứa các Guardrails để đảm bảo Persona "Senior Architect" luôn đặt câu hỏi đúng lúc.

- **`knowledge/` (Tri thức):**
    - `uml-standards.md`: Các quy tắc UML từ `context1.md` và tiêu chuẩn ngành.
    - `design-patterns.md`: Gợi ý các cách phân lớp (Controller-Service-Repository) để sơ đồ chuyên nghiệp hơn.

- **`templates/` (Mẫu đầu ra):**
    - `checklist-template.md`: Mẫu file kiểm tra thông tin đầu vào.
    - `mermaid-base.mmd`: Các đoạn mã Mermaid mẫu (autonumber, participants, box...).

- **`loop/` (Kiểm soát chất lượng):**
    - `checklist.md`: Các tiêu chí verify (Sơ đồ không được quá 20 messages, phải có return arrow, phải đặt tên cụ thể cho message...).

---

## 4. Xác định "Điểm mù" (AI Blind Spots) - Dự thảo

Mục này sẽ được cập nhật liên tục khi xây dựng:
1. **God Object:** AI vẽ tất cả logic dồn vào một Lifeline duy nhất thay vì phân tách.
2. **Missing Returns:** Quên vẽ các mũi tên trả về dữ liệu (dashed lines).
3. **Vague Titles:** Đặt tên message chung chung như "handle()", "process()" thay vì "validateUser()", "saveOrder()".
4. **Infinite Loops:** Vẽ các tương tác quay vòng không có điểm kết thúc hoặc điều kiện dừng.

---

## 5. Kế hoạch triển khai (Action Plan)

1. [ ] Khởi tạo cấu trúc thư mục skill.
2. [ ] Viết nội dung `SKILL.md` với các câu lệnh điều phối (Imperative commands).
3. [ ] Xây dựng bộ `knowledge/uml-standards.md` từ `context1.md`.
4. [ ] Tạo các templates output cho người dùng.
5. [ ] Viết kịch bản test case đầu tiên (Dòng đăng nhập).
