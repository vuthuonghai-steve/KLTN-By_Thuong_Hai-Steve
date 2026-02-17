
Để vẽ được **Sequence Diagram** (sơ đồ tuần tự) cho một chức năng, cần chuẩn bị đủ các thông tin sau (theo đúng cách làm chuẩn trong UML và các hướng dẫn thực hành).[](https://creately.com/guides/sequence-diagram-tutorial/)

---

## 1. Xác định rõ kịch bản (scenario) / use case

Sequence Diagram luôn vẽ **cho một kịch bản cụ thể** (main flow hoặc 1 nhánh ngoại lệ) chứ không vẽ chung chung.

Cần có:

* Tên use case hoặc chức năng: ví dụ “Đăng nhập hệ thống”, “Đặt hàng online”, “Rút tiền ATM”…
* Mục tiêu của use case: người dùng / hệ thống muốn đạt được điều gì sau khi kết thúc kịch bản.
* Kịch bản mô tả bằng lời (text) từng bước:
  * Ví dụ:
    1. Người dùng nhập username/password.
    2. Hệ thống kiểm tra thông tin đăng nhập.
    3. Nếu đúng, hệ thống chuyển sang màn hình chính; nếu sai, báo lỗi…

Nếu chưa có **use case description** hoặc luồng bước rõ ràng, rất khó vẽ sequence diagram chính xác.[](https://www.geeksforgeeks.org/system-design/unified-modeling-language-uml-sequence-diagrams/)

---

## 2. Danh sách các “người chơi”: Actor và đối tượng / lớp tham gia

Trước khi vẽ, phải liệt kê được **những thành phần nào tương tác với nhau** trong kịch bản:

* Các **actor** (tác nhân bên ngoài):
  * Người dùng (User, Admin, Nhân viên, Khách hàng…), hệ thống bên ngoài (Payment Gateway, Email Service, API bên thứ 3…).
* Các  **đối tượng / lớp / thành phần hệ thống** :
  * Màn hình / UI (LoginForm, CheckoutPage…),
  * Controller (AuthController, OrderController…),
  * Service (UserService, OrderService…),
  * Repository/DAO (UserRepository, OrderRepository…),
  * CSDL hoặc hệ thống lưu trữ (Database, FileStorage…).

Thông tin cần có:

* Tên rõ ràng cho từng actor và đối tượng.
* Vai trò / trách nhiệm chính của từng thành phần trong kịch bản.

Từ đây, khi vẽ sẽ tương ứng với **các lifeline** của sequence diagram.[](https://www.visual-paradigm.com/learning/handbooks/software-design-handbook/sequence-diagram.jsp)

---

## 3. Thứ tự các bước tương tác (message flow) giữa các thành phần

Đây là phần quan trọng nhất:  **ai gọi ai, gọi cái gì, theo thứ tự nào** .

Cần làm rõ:

* Bắt đầu từ actor nào gửi request đầu tiên cho hệ thống?
* Hệ thống (thành phần A) sau đó gọi thành phần B, rồi B gọi C… theo thứ tự ra sao?
* Ở mỗi bước, **nội dung message** là gì:
  * Tên hàm / phương thức (login(), validateCredentials(), saveOrder(), sendEmail()…)
  * Tham số quan trọng (username, password, orderId, amount, …) – không nhất thiết phải ghi hết chi tiết, nhưng nên có tên dễ hiểu.
* Những bước nào là  **gửi request** , bước nào là  **trả về kết quả (return)** .

Nếu có mô tả use case dạng từng bước (Step 1, Step 2, …) thì có thể chuyển từng bước đó thành một hoặc vài message trong Sequence Diagram.[](https://creately.com/guides/sequence-diagram-tutorial/)

---

## 4. Điều kiện rẽ nhánh, lặp, luồng thay thế

Sequence Diagram không chỉ có flow thẳng, mà còn mô tả **if/else, loop, luồng ngoại lệ** bằng các *interaction fragments* (alt, opt, loop, …).

Cần chuẩn bị:

* Các **điều kiện** có thể xảy ra trong kịch bản:
  * Ví dụ: “Nếu mật khẩu sai”, “Nếu số dư không đủ”, “Nếu validate thất bại”…
* Các  **nhánh xử lý tương ứng** :
  * Với mỗi điều kiện, hệ thống sẽ gửi/nhận những message khác gì so với luồng chính.
* Các **vòng lặp** (loop):
  * Ví dụ: lặp qua danh sách sản phẩm trong giỏ hàng, lặp gửi thông báo cho nhiều người…

Thông tin này giúp sử dụng đúng các khung `alt`, `opt`, `loop`… trong Sequence Diagram.[](https://www.drawio.com/blog/sequence-diagrams)

---

## 5. Thời điểm tạo / hủy đối tượng (nếu có)

Trong một số kịch bản:

* Có đối tượng được **tạo mới** trong quá trình xử lý (ví dụ tạo đối tượng `Order`, `Session`, `Cart`…).
* Có đối tượng bị  **hủy / kết thúc** .

Cần biết:

* Ở bước nào đối tượng được tạo ra (ai tạo nó, bằng message nào).
* Khi nào đối tượng không còn tồn tại / bị hủy.

Thông tin này sẽ thể hiện bằng mũi tên tạo đối tượng và dấu “X” hủy lifeline trong sơ đồ.[](https://www.visual-paradigm.com/learning/handbooks/software-design-handbook/sequence-diagram.jsp)

---

## 6. Ranh giới hệ thống và mức độ chi tiết

Trước khi vẽ, nên xác định:

* **Đang vẽ Sequence Diagram cho mức nào?**
  * System Sequence Diagram (SSD): chỉ giữa  **Actor ↔ Hệ thống như một khối** .
  * Design-level Sequence Diagram: chi tiết đến **UI, Controller, Service, Repository…**
* Mức chi tiết này quyết định:
  * Có cần vẽ message tới từng lớp bên trong, hay chỉ tới “System”?
  * Có cần ghi đầy đủ tham số, kiểu trả về không, hay chỉ ghi tên action đơn giản?

Nếu không quyết định rõ, sơ đồ rất dễ bị  **quá rối hoặc quá sơ sài** .

---

## 7. Tóm tắt: cần những gì để vẽ được Sequence Diagram?

Tóm gọn lại, trước khi cầm bút (hoặc tool) vẽ Sequence Diagram, nên đảm bảo có:

1. **Use case / kịch bản cụ thể** (main flow hoặc 1 luồng phụ), mô tả bằng lời.
2. **Danh sách actor và các đối tượng/lớp tham gia** , với vai trò rõ ràng.
3. **Thứ tự các bước tương tác** giữa các thành phần (ai gọi ai, gọi phương thức gì).
4. **Điều kiện rẽ nhánh, lặp, luồng ngoại lệ** nếu muốn mô tả không chỉ happy path.
5. (Tùy mức chi tiết) Thông tin về  **tạo / hủy đối tượng** , và mức độ chi tiết mong muốn (SSD hay chi tiết ở mức thiết kế).

Khi có đủ các thông tin này, việc vẽ Sequence Diagram chỉ còn là  **chuyển từ chữ sang hình** :

* Mỗi actor/đối tượng → một lifeline ở trên.
* Mỗi bước trong kịch bản → một hoặc vài message theo thứ tự từ trên xuống.
* Các điều kiện / lặp → khung alt/opt/loop tương ứng.
