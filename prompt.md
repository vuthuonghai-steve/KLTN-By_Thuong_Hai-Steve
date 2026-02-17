Dưới đây là hai bản nháp hoàn chỉnh cho `resources/uml-rules.md` và `resources/project-patterns.md`, bám đúng khung sườn bạn đưa ra và align với design/todo của skill `sequence-design-analyst`. [ppl-ai-file-upload.s3.amazonaws](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/152950573/538b0178-19f3-4b0b-b8cd-6a894e5ae338/design.md)

***

## 1. Tài liệu `resources/uml-rules.md`

```markdown
# UML Sequence Standards (Mermaid)

> **Mục đích**: Chuẩn hóa cách suy nghĩ và cú pháp khi vẽ Sequence Diagram bằng Mermaid cho toàn bộ dự án. [file:20][file:22]

---

## 1. Syntax Basics

### 1.1 Lifelines (Participants & Actors)

- **Actor (người dùng / hệ thống ngoài)**  
  - Dùng cú pháp Mermaid: `actor User` hoặc `actor Admin` để biểu diễn tác nhân bên ngoài. [file:20][web:35]  
  - Actor thường nằm ngoài cùng bên trái sơ đồ (User) hoặc ngoài cùng bên phải (các hệ thống tích hợp như Payment Gateway). [file:22]

- **Participants (thành phần hệ thống)**  
  - Dùng cú pháp: `participant LoginPage`, `participant AuthController`, `participant UserService`, `participant DB`. [file:20][web:35]  
  - Thứ tự khuyến nghị từ trái sang phải:
    1. Actor (User / External System)
    2. UI / Screen (Next.js page / React component)
    3. Controller / Route handler (Next.js route, server action)
    4. Service layer (TypeScript service / use case)
    5. Repository / Payload Local API
    6. Database / External infra (MongoDB, Redis, 3rd-party API). [file:18][file:22]

### 1.2 Message Types

- **Synchronous call (gọi đồng bộ)**  
  - Cú pháp Mermaid: `A ->> B: methodName(params)` [file:20][web:26]  
  - Dùng cho các lời gọi hàm/ phương thức mà caller **chờ** kết quả (ví dụ: `Controller ->> Service: loginUser(email, password)`). [file:22][web:36]

- **Asynchronous call (gửi event / message)**  
  - Cú pháp Mermaid: `A -->> B: eventName` [file:20][web:26]  
  - Dùng cho các hành động fire-and-forget, ví dụ publish event, gửi message queue, cron job, webhooks. [web:29][web:36]

- **Return message (trả kết quả)**  
  - Cú pháp khuyến nghị: `B -->> A: result / status` trong Mermaid. [file:20][web:32]  
  - Chỉ vẽ return khi:
    - Kết quả quan trọng cho nhánh rẽ (success/fail). [file:22][web:36]  
    - Cần nhấn mạnh data được trả về (ví dụ: `User`, `AccessToken`, `Error`). [file:22]

### 1.3 Notes và Annotation

- Sử dụng cú pháp Mermaid cho ghi chú: [web:26][web:32]  
  - `Note over A: short note`  
  - `Note left of A: ...` hoặc `Note right of A: ...`  
- Dùng note để:
  - Giải thích business rule quan trọng.  
  - Link tới tài liệu khác (SRS, API doc). [file:22]

### 1.4 Activation (Thời gian sống xử lý)

- Mermaid hỗ trợ `activate` / `deactivate` để biểu diễn khoảng thời gian object đang xử lý một lời gọi. [web:32][web:36]  
- Ví dụ:
  ```mermaid
  participant Service
  participant Repo

  Service ->> Repo: findUser()
  activate Repo
  Repo -->> Service: User
  deactivate Repo
  ```  
- Activation nên dùng cho:
  - Thể hiện rõ call chain nhiều tầng (UI → Controller → Service → Repo → DB). [file:18][web:36]  
  - Hiển thị xử lý lồng nhau (nested calls / recursion). [web:30]

---

## 2. Interaction Fragments (Quan trọng nhất)

**Mục tiêu**: Dùng đúng `alt`, `opt`, `loop` để mô tả if/else, luồng tùy chọn và vòng lặp theo đúng chuẩn UML. [file:18][file:22][web:23][web:26][web:29]

### 2.1 `alt` – Rẽ nhánh logic (If / Else / Multi-branch)

- Dùng cho **các nhánh loại trừ lẫn nhau** (mutually exclusive paths). [web:23][web:29]  
- Mỗi nhánh có một guard (điều kiện), tương đương `if / else if / else`. [web:23][web:26]

Ví dụ:
```mermaid
alt login success
    AuthService ->> SessionService: createSession(userId)
    SessionService -->> AuthService: sessionToken
else invalid password
    AuthService -->> User: showError("Invalid credentials")
else user locked
    AuthService -->> User: showError("Account locked")
end
```

**Quy tắc:**

- Mọi luồng if/else quan trọng trong nghiệp vụ nên dùng `alt` thay vì vẽ nhiều mũi tên rời rạc. [file:22][web:29]  
- Không nhồi quá nhiều trường hợp hiếm → tách thành sơ đồ khác nếu số nhánh > 3–4. [web:27]

### 2.2 `opt` – Hành động tùy chọn (Optional)

- `opt` dùng cho **một nhánh duy nhất, có thể xảy ra hoặc không** – tương đương `if (condition) { ... }` **không có** else. [web:23][web:29]  
- Thích hợp cho các tính năng “có cũng được, không có cũng được” như:
  - Gửi email thông báo.  
  - Ghi log nâng cao.  
  - Tính reward points nếu user là member. [file:22][web:23]

Ví dụ:
```mermaid
opt send notification
    NotificationService -->> EmailProvider: sendWelcomeEmail(userEmail)
end
```

**Quy tắc:**

- Nếu có cả nhánh “không gửi” với hành vi khác biệt → dùng `alt` thay vì `opt`. [web:23]  
- Không lạm dụng `opt` cho các logic chính của use case (nên dùng `alt`). [web:29]

### 2.3 `loop` – Vòng lặp

- Dùng `loop` cho các thao tác lặp lại nhiều lần trong cùng một scenario:
  - Duyệt từng item trong giỏ hàng.  
  - Gửi thông báo tới danh sách user. [file:22][web:29]  
- Có thể ghi điều kiện hoặc range ngay trên `loop`, ví dụ:
  ```mermaid
  loop for each item in cartItems
      CheckoutService ->> PricingService: calculatePrice(item)
      PricingService -->> CheckoutService: itemPrice
  end
  ```

**Quy tắc:**

- Không vẽ từng lần lặp giống hệt nhau; hãy dùng `loop` với mô tả rõ ràng. [web:29][web:36]  
- Nếu trong vòng lặp còn có if/else → có thể lồng `alt` bên trong `loop`. [web:26][web:29]

---

## 3. Best Practices (Tư duy & Quy ước)

### 3.1 Tư duy từ Use Case → Sequence

Để tránh sơ đồ sai logic, luôn đi theo pipeline sau trước khi vẽ: [file:22][file:18][web:36]

1. **Xác định scenario cụ thể**  
   - Ví dụ: “User đăng nhập thành công”, “User đăng nhập sai mật khẩu 3 lần”. [file:22]  
2. **Liệt kê actor & đối tượng tham gia**  
   - User, UI (page / component), Controller, Service, Repo, DB, external API. [file:22]  
3. **Viết lại luồng bước (Step 1, 2, 3, …)**  
   - Ai gọi ai, gọi hàm gì, dữ liệu quan trọng là gì. [file:22]  
4. **Xác định điều kiện rẽ nhánh & vòng lặp**  
   - Các case thành công / thất bại, điều kiện lỗi, loop qua danh sách. [file:22][web:29]  
5. **Quyết định mức chi tiết (SSD vs Design-level)**  
   - Vẽ Actor ↔ System tổng quát hay xuống tới từng lớp UI / Service / Repo. [file:22]

Sequence Diagram chỉ là bước **chuyển từ chữ sang hình** của 5 nhóm thông tin trên. [file:22][web:36]

### 3.2 Activation Boxes (Thời gian xử lý)

- **Khi nào nên dùng activation**:  
  - Khi muốn nhấn mạnh ai đang “giữ quyền điều khiển” tại mỗi bước trong call chain. [web:27][web:30][web:36]  
  - Khi có nested calls (Service gọi Repo, Repo gọi DB) để người xem dễ theo dõi. [web:30][web:36]  
- **Khi nào có thể lược bớt**:
  - Actor khởi phát (User / Browser) đôi khi không cần vẽ activation nếu lifeline kéo dài toàn bộ sơ đồ. [web:33]  
- **Định dạng**:
  - Dùng `activate Object` ngay sau message vào, và `deactivate Object` khi trả kết quả xong. [web:32][web:36]

Ví dụ:
```mermaid
User ->> UI: submitLoginForm()
activate UI
UI ->> AuthService: login(email, password)
activate AuthService
AuthService ->> Payload: findUserByEmail()
activate Payload
Payload -->> AuthService: User | null
deactivate Payload
AuthService -->> UI: LoginResult
deactivate AuthService
UI -->> User: showResult()
deactivate UI
```

### 3.3 Đặt tên Message (Verb + Object)

- **Quy tắc chung**:  
  - Tên message = **động từ + tân ngữ** (verb + object) bằng tiếng Anh chuẩn. [file:20][file:22]  
  - Ví dụ tốt: `loginUser`, `validateCredentials`, `createOrder`, `sendResetEmail`.  
  - Tránh tên mơ hồ kiểu `doStuff`, `process`, `handle`. [file:22]

- **Khớp với codebase**:
  - Ưu tiên dùng đúng tên hàm / method trong code nếu có. [file:18][file:22]  
  - Với Payload Local API, message có thể là:  
    - `payload.find(posts)`, `payload.findByID(users)`, `payload.create(order)`. [web:25][web:31]

- **Không nhét quá nhiều param vào message label**:
  - Chỉ nêu các tham số quan trọng (userId, orderId, amount…). [file:22]  
  - Chi tiết thêm có thể đưa vào note nếu cần. [web:26][web:32]

### 3.4 Layout & Độ đọc được (Readability)

- **Giới hạn số lifeline**:
  - Nếu > 8 lifeline, cân nhắc tách thành nhiều sơ đồ nhỏ hơn (sub-sequence). [file:18][web:27]  
- **Nhóm các message liên quan**:
  - Các khối có cùng mục đích (validate, persist, notify) nên gom trong cùng một fragment hoặc được “đóng khung” bằng note. [web:27]  
- **Không vẽ “nhảy cóc” tới Database**:
  - Luồng phải luôn đi qua Service/Repository hoặc Payload Local API, không cho UI gọi DB trực tiếp. [file:18][file:21]

---

## 4. Checklist Nhanh Trước Khi Chốt Sơ Đồ

Trước khi coi một Sequence Diagram là “xong”, kiểm tra: [file:18][file:19][file:22]

- [ ] Có **scenario cụ thể** được mô tả bằng lời ở ngoài (hoặc trong note).  
- [ ] Tất cả actor & đối tượng đều có lifeline rõ ràng, tên đúng vai trò.  
- [ ] Không có message “bay” thẳng từ UI tới DB, luôn qua Service/Repo/Payload. [file:21]  
- [ ] Các luồng if/else dùng `alt`, các hành động tùy chọn dùng `opt`, vòng lặp dùng `loop`. [file:20][web:23][web:29]  
- [ ] Message đặt tên theo quy tắc verb + object, ưu tiên khớp code thật. [file:20][file:22]  
- [ ] Activation thể hiện rõ call chain chính (ít nhất cho Service/Repo/DB nếu cần). [web:30][web:36]  
- [ ] Sơ đồ không quá dày đặc; nếu quá dài, tách thành nhiều sơ đồ nhỏ hơn theo use case hoặc subflow. [web:27]
```

***

## 2. Tài liệu `resources/project-patterns.md`

```markdown
# Project Architecture & Patterns

> **Mục đích**: Giúp AI hiểu “bản đồ” kiến trúc và luồng logic của dự án Next.js + PayloadCMS để vẽ Sequence Diagram đúng lớp, đúng hướng call. [file:18][file:21]

---

## 1. Core Architecture

### 1.1 Tech Stack & Runtime

- **Frontend / SSR**: Next.js 15 (App Router) chạy trên Node runtime.  
  - Sử dụng Server Components, Route Handlers và/hoặc Server Actions cho các luồng cần truy cập Payload Local API. [web:25][web:28][web:34]  
- **Backend / CMS**: PayloadCMS 3.0 chạy cùng process với Next.js như một monolith. [web:25][web:31]  
- **Database**: MongoDB (theo quyết định kiến trúc chung của dự án). [file:10][file:15]

### 1.2 API Style – Local API First

- **Local API** (Primary):  
  - Sử dụng helper `getPayload` để lấy instance Payload trong môi trường Node. [web:25][web:28]  
  - Chỉ được sử dụng **trên server** (Route Handler, Server Component, Server Action), không dùng trực tiếp trên client component. [web:25][web:31][web:34]  
  - Các phương thức chính:
    - `payload.find({ collection, where, limit, sort })`
    - `payload.findByID({ collection, id })`
    - `payload.create({ collection, data })`
    - `payload.update({ collection, id, data })` [web:25][web:31]

- **REST API** (Fallback / Integration):  
  - Khi cần gọi từ client-side hoặc từ hệ thống bên ngoài, sử dụng REST endpoints chuẩn của Payload thay vì Local API. [web:25][web:37]

**Guardrail cho Sequence**: Khi vẽ sơ đồ, luôn thể hiện luồng Data Access đi qua **Payload Local API hoặc REST API**, không bao giờ cho UI/Service nói chuyện trực tiếp với Database. [file:21][file:18]

---

## 2. Sequence Layers (Thứ tự tham gia của các lớp)

### 2.1 Chuỗi lớp chuẩn

Thứ tự tham gia chuẩn trong các Sequence Diagram của dự án: [file:18][file:21]

1. **Actor (User / External System)**  
   - Người dùng web, mobile, hoặc hệ thống tích hợp (Payment Gateway, OAuth Provider). [file:22]

2. **UI Component / Screen (Next.js App Router)**  
   - Page / Layout / Client Component chịu trách nhiệm:
     - Nhận input từ user.  
     - Gửi request tới Route Handler / Server Action / Service. [file:18]

3. **Service Layer (Domain / Application Services)**  
   - Viết bằng TypeScript, nằm trong thư mục kiểu `src/services/` hoặc `src/features/**/services`.  
   - Đảm nhiệm:
     - Ánh xạ input từ UI thành lệnh domain.  
     - Gọi Payload Local API thông qua các hàm helper (ví dụ: `postService.findMany`, `authService.login`). [file:18][web:28]

4. **Payload Local API (Data Access via getPayload)**  
   - Hàm helper kiểu:
     ```ts
     import { getPayload } from 'payload';
     import config from '@/payload.config';

     export const getPayloadClient = async () => {
       // caching instance để tránh tạo lại nhiều lần
       // ...
     };
     ```
     [web:25][web:28]  
   - Service layer gọi `payload.find`, `payload.findByID`, `payload.create`, v.v. tại đây. [web:25][web:31]

5. **Database / External Systems**  
   - MongoDB đứng phía sau Payload.  
   - Các hệ thống khác (Redis, 3rd-party API) nếu có sẽ luôn được wrap bởi một service/adapter phía Payload hoặc service layer. [file:15][web:25]

### 2.2 Quy tắc khi vẽ Sequence

- Không vẽ Actor / UI gọi Database trực tiếp; luôn chèn Service layer và Payload Local API. [file:21]  
- Tên lifeline nên phản ánh đúng layer, ví dụ:
  - `actor User`  
  - `participant PostPage`  
  - `participant PostService`  
  - `participant Payload`  
  - `participant MongoDB` [file:18][file:21]

---

## 3. Common Logic Flows

### 3.1 Auth Flow (Login / Token / Session)

**Mục tiêu**: Chuẩn hóa cách thể hiện logic xác thực khi vẽ Sequence Diagram. [file:21][file:22][web:28]

**Luồng tổng quát (login bằng email/password):**

1. `User` nhập credential trên UI (Login Page). [file:22]  
2. `LoginPage` gửi request tới `AuthRoute` hoặc `AuthService` (Route Handler / Server Action). [file:18]  
3. `AuthService` sử dụng `getPayload` để lấy client và gọi:
   ```ts
   payload.login({
     collection: 'users',
     data: { email, password },
   })
   ```
   (hoặc pattern tương đương nếu dùng collection auth của Payload). [web:28]  
4. Payload xác thực user, trả về user + token / session info. [web:28]  
5. `AuthService`:
   - Ghi session (HTTP-only cookie / session store).  
   - Trả kết quả về cho UI (success / error). [web:28][file:22]  
6. UI hiển thị màn hình tiếp theo (dashboard) hoặc thông báo lỗi. [file:22]

**Các điểm cần thể hiện rõ trong Sequence Diagram:**

- Nhánh `alt` cho:
  - `login success`  
  - `invalid credentials`  
  - (tùy chọn) `user locked` / `email not verified` [file:22][web:23][web:29]  
- `opt` block cho các hành động tùy chọn:
  - Ghi audit log login.  
  - Gửi email đăng nhập mới. [file:22][web:23]  
- Không vẽ UI → Database, mà là:
  - `User ->> LoginPage ->> AuthService ->> Payload ->> MongoDB`. [file:18][file:21]

### 3.2 Data Query Flow (Payload find / findByID)

**Pattern chuẩn để truy vấn dữ liệu trong Next.js qua Payload Local API:** [file:21][web:25][web:31]

1. **UI / Route Handler gọi Service:**
   - Ví dụ: `PostPage` gọi `PostService.getFeed({ page, pageSize })`. [file:18]

2. **Service Layer xử lý business logic:**
   - Chuẩn hóa input (phân trang, filter).  
   - Quyết định collection nào, điều kiện `where`, `sort`, `limit`. [file:18][file:22]

3. **Service gọi Payload Local API:**
   ```ts
   const payload = await getPayloadClient();

   const result = await payload.find({
     collection: 'posts',
     where: { published: { equals: true } },
     limit: 20,
     sort: '-publishedAt',
   });
   ```
   [web:25][web:31]

4. **Payload truy vấn Database và trả về result:**
   - `docs` (mảng record), `totalDocs`, `page`, `hasNextPage`, v.v. [web:25]

5. **Service mapping dữ liệu về DTO:**
   - Chỉ expose field cần thiết cho UI (ẩn field nhạy cảm).  
   - Có thể chuẩn hóa sang TypeScript DTO (Data Transfer Object). [web:28]

6. **UI render kết quả:**
   - Server Component nhận data, render HTML.  
   - Client Component chỉ nhận dữ liệu đã được chuẩn hóa. [web:25][web:31]

**Quy tắc khi vẽ Sequence:**

- Luồng cơ bản:  
  `User ->> UI ->> Service ->> Payload ->> DB -->> Payload -->> Service -->> UI -->> User`. [file:18][file:21]  
- Nếu chỉ cần đọc dữ liệu (read-only), không cần vẽ thêm Repo riêng nếu đã thể hiện Payload đủ rõ. [file:18]  
- Nếu dùng DTO pattern, có thể thêm lifeline `PostMapper` hoặc ghi rõ mapping trong note. [web:28]

### 3.3 Write / Update Flow (Create / Update via Payload)

**Thích hợp cho các use case:** tạo post mới, cập nhật profile, tạo order. [file:21][web:25]

1. `User` submit form tại UI.  
2. UI gọi Service / Route Handler với payload form.  
3. Service validate và chuẩn hóa data.  
4. Service dùng Payload Local API:
   ```ts
   const newPost = await payload.create({
     collection: 'posts',
     data: { title, content, author: userId },
   });
   ```
   hoặc:
   ```ts
   const updatedPost = await payload.update({
     collection: 'posts',
     id,
     data: { title, content },
   });
   ```
   [web:25][web:31]  
5. Payload ghi dữ liệu xuống DB, chạy hooks (beforeValidate, beforeChange, afterChange, v.v.). [web:25]  
6. Service trả kết quả cho UI; UI hiển thị thông báo / redirect. [file:22]

**Sequence nên thể hiện:**

- `alt` cho:
  - `validation success` vs `validation fail`.  
  - `DB error` nếu cần mô tả luồng lỗi. [file:22][web:29]  
- `opt` cho:
  - Gửi notification, index search, background jobs. [web:23][web:29]

---

## 4. Guardrails for Sequence in This Project

Đây là các “luật cứng” khi vẽ Sequence Diagram cho codebase Next.js + Payload này. [file:18][file:21]

- **Không vẽ trực tiếp vào Database**  
  - Mọi thao tác đọc/ghi CSDL phải đi qua **Payload Local API** (hoặc REST API trong trường hợp đặc biệt). [file:21][web:25]

- **Tôn trọng Layer Order**  
  - Actor → UI → Service Layer → Payload Local API → Database.  
  - Không bỏ qua Service Layer để UI gọi Payload trực tiếp, trừ các use case kỹ thuật đơn giản và đã được chấp thuận. [file:18][file:21]

- **Tên Service khớp file `.service.ts`**  
  - Nếu trong code có `post.service.ts`, thì trong sơ đồ nên dùng `PostService` thay vì tên tùy ý khác. [file:21]

- **Auth luôn qua Auth Service / Auth Collection**  
  - Không vẽ UI gọi thẳng `payload.find(users)` để login; phải qua `AuthService` / collection auth của Payload. [web:28]

- **Sequence Diagram bám sát use case thật**  
  - Mỗi sơ đồ phải gắn với một scenario cụ thể (login, load feed, create post…), không vẽ sơ đồ “tổng hợp” quá nhiều use case. [file:22]

- **Không mô tả logic ngoài phạm vi dự án**  
  - Nếu có tích hợp 3rd-party, chỉ mô tả tới mức cần thiết (ví dụ: `PaymentGateway`) mà không đi sâu vào nội bộ hệ thống đó. [file:15]

```

Nếu bạn muốn, có thể yêu cầu thêm: “viết luôn example Sequence Diagram Mermaid cho Auth Flow / Feed Flow theo 2 tài liệu này” để dùng làm template CRUD / Auth trong thư mục `templates/*.mmd`.