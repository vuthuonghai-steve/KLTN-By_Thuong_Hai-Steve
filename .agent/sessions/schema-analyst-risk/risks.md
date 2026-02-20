# Risk Analysis: payload-mongodb-patterns-raw.md (AI Agent Vulnerabilities)

## Summary
Tài liệu `payload-mongodb-patterns-raw.md` hiện tại là một "con dao hai lưỡi". Nó cung cấp tư duy kiến trúc tuyệt vời (Code-First, Embed vs Reference, Polymorphic, Computed) giúp Schema Architect tạo ra DB xịn. Tuy nhiên, nếu cung cấp nguyên xi (raw) cho Agent kỹ sư đọc, nó sẽ kích hoạt những điểm yếu trầm trọng nhất của LLM: **Context Tunneling** (Chỉ bám vào ví dụ trong file mà quên Hợp đồng YAML), **Logical Conflicts** (Bối rối giữa 2 luật đá nhau), và **Hallucination/Over-engineering** (Tự đẻ ra field/luật vì "sợ sai" hoặc muốn "làm quá tốt" như tài liệu mẫu).

---

## TỔNG HỢP RỦI RO CHI TIẾT (Risks Table)

| # | Risk | Loại Lỗi | Severity | Probability | Impact | Mitigation (Xử lý lỗ hổng) |
|---|------|----------|----------|-------------|--------|--------------------------|
| 1 | **Tự bịa Computed Fields (Ảo giác)**: Agent thấy "ví dụ tính sẵn likes_count, comments_count" ở mục 3.2 nên tự động chèn thêm các field này vào mọi Schema (Post, Product) dù Contract YAML không hề có. | Bịa nội dung (Fabrication) | P0 | Cao (High) | Sập Data Contract do sai lệch field | Thêm nhãn bọc thẻ `[WARNING: NO INVENTING]` ở Mục 3, ra lệnh rõ: "CHỈ tạo Computed field nếu Flow/Use-Case yêu cầu. Ví dụ chỉ là cú pháp." |
| 2 | **Xung Đột Logic - Map vs Embed/Reference**: Mục 4 (Map Type) bắt `array` -> `array` (trong Mongo). Mục 2.1 lại dạy "Data mọc vô hạn -> Reference". Vậy nếu Contract YAML ghi `tags: array`, AI phải nghe theo Mục 2 hay Mục 4? | Xung đột luật (Logical Conflict) | P0 | Cao (High) | Kết quả random mỗi lần sinh code | Bổ sung luật ưu tiên (Hierarchy Rule): "YAML nói `array` -> Ưu tiên 4. Trừ khi Flow diagram ám chỉ Mọc vô hạn -> Báo Interaction Point (Gate)." |
| 3 | **Context Tunneling - Access Control (Bịa quyền bừa bãi)**: Đọc Mục 5.2, LLM sẽ chìm đắm (tunnel) vào input này và áp bừa Access Rule `user?.role === 'admin'` cho mọi thứ (VD: user tự lấy profile mình cũng bị bắt admin) thay vì tôn trọng Activity Diagram/YAML. | Mất Context Session | P1 | Rất Cao (Very High) | Chết toàn bộ luồng Fetch Data sau này | Cấm AI tự thiết kế Quyền. Rule: "Chỉ chuyển ngữ (syntax) Access Control từ tiếng Người của Hợp đồng sang JavaScript Payload. Không được tự suy diễn chức năng." |
| 4 | **Over-Engineering (Bệnh làm quá)**: Hiểu biết về Bucket/Outlier / Polymorphic (Mục 3) quá quyền lực. Agent có thể biến 1 mảng Address tĩnh trong User thành 1 Polymorphic Relationship rườm rà "đề phòng tương lai 16MB". AI đang chống chế bằng tư duy over-engineer. | Ảo giác Kiến trúc | P1 | Trung bình (Medium) | Code và DB trở nên quá phức tạp không cần thiết | Định lượng ranh giới cụ thể: Polymorphic/Bucket CHỈ kích hoạt khi có từ khóa đặc thù (e.g. Activity Log, Notification) từ YAML. Không dùng trước. |
| 5 | **Câu chữ định tính, mơ hồ (Ambiguity)**: "Số lượng nhỏ" (Mục 2.2) so với "Data mọc vô hạn" (Mục 2.1). AI không có ngữ cảnh Business để đoán 1 mảng `history` thuộc loại nào. AI sẽ phải đồn đoán (guess) => Hệ quả là lúc Embed, lúc Reference. | Bịa nội dung (Guessing) | P2 | Rất Cao (Very High) | Schema không đồng nhất giữa các module | Quy định luật: "Mặc định Mọi Array là EMBED (Giới hạn). Nếu phát hiện keyword như Limitles, History, Logs -> Mới đẩy thành REFERENCE". |

---

## Edge Cases Cần Phải Rào (Handling Guide)

| # | Edge Case (Tình huống) | Expected Behavior (Hành vi mong muốn) | Handling Strategy (Cách bắt lỗi trong tài liệu) |
|---|----------------------|---------------------------------------|-----------------------------------------------|
| 1 | Contract (YAML) nói `comments` là thuộc tính bên trong Post (`array`). Nhưng AI nghĩ Comments sẽ "mọc dài / vô hạn". | AI muốn đổi từ Embed `array` (đang có trong YAML) sang Reference Collection mới (`relationship hasMany`). | **[STRICT RULE]**: Tuyệt đối không tự ý đẻ Collection nếu nó không là Root Class trong YAML. Nếu sợ >16MB, **MUST Báo Cáo Gate [IP] chờ lệnh User**, không tự chia tách. |
| 2 | Đầu vào là 1 Module thiên về Content (Blog/Post) nhưng AI tham lam nhồi luôn "Bucket Pattern" (Mục 3.3). | AI chỉ sinh các Schema đơn giản theo YAML. Bucket Pattern không được áp dụng. | Ghi rõ trong Mục 3: "Các mẫu nâng cao (Polymorphic, Bucket) hiện đang khóa, chỉ được cân nhắc khi được User gợi ý thẳng tại Prompt." |
| 3 | AI đọc dòng Hook (Mục 5.1): "mọi logic behavior..." => AI tự tạo file hook `syncCategory.ts` dù hệ thống ko có yêu cầu. | AI KHÔNG tạo custom hook trừ khi Behavior đó có mặt trong `Behaviors` của YAML Class. | Thêm cờ chặn: "Chỉ sinh template Hook placeholder nếu YAML định danh nó là Hành vi (Action) rõ rệt." |

---

## Hướng Giải Quyết (Implementation Resolution)

Để cung cấp tài liệu này cho AI (Làm file `knowledge/payload-mongodb-patterns.md`), cần chèn 3 Layer bảo vệ vào đầu trang (File Raw):

1. **[Quyền Tối Cao] Khóa Context (Anti-Tunneling)**: Phải ghi đỏ *"Bất cứ quy tắc nào trong file này nếu mâu thuẫn với Data Contract YAML của Skill 2.5, phải lấy YAML làm Nguồn Sự Thật. Bạn (AI) là Cỗ Máy Biên Dịch (Translator), KHÔNG phải người tạo ra Business (Creator)."*
2. **[Chặn Ảo Giác] Giới Hạn Ví Dụ (Anti-Fabrication)**: Các snippet code hay schema field (`likes_count`, `targetEntity`) trong này CHỈ LÀ CÚ PHÁP. Bị nghiêm cấm việc rải chúng vào Output nếu YAML không có.
3. **[Định Lượng Rõ] Giải pháp cho Embed/Ref (Anti-Ambiguity)**: Đặt luật: `array` là Default Embed. Chỉ Reference khi `relationTo` 1 Class khác (Root Aggregate) trong YAML.

*Sẵn sàng cập nhật file `/home/steve/Documents/KLTN/.skill-context/schema-design-analyst/resources/payload-mongodb-patterns-raw.md` để đóng băng các lỗ hổng này.*
