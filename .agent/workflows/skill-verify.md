---
description: Quy trình xác nhận và đối chiếu kết quả thực thi của Agent Skill để chống ảo giác và lãng quên chi tiết.
---

# ✅ WORKFLOW: SKILL VERIFY

> **Mục đích**: Đảm bảo sự trùng khớp giữa "Ý tưởng/Yêu cầu gốc" của Steve và "Kết quả thực thi" của AI Agent.

---

## 🔍 GIAI ĐOẠN 1: ĐỐI CHIẾU NGUỒN (Source Comparison)

**Hành động của AI**: Đọc lại tin nhắn đầu tiên của session hoặc file `INPUT_CONTEXT.md` (nếu có).

1. **Khớp mục tiêu**: Kết quả cuối cùng có giải quyết được vấn đề gốc không?
2. **Kiểm kê số lượng**: Nếu yêu cầu có 6 mục, kết quả hiện tại có đúng 6 mục không? (Tránh việc chỉ trả lời mục mới nhất).
3. **Giữ nguyên chi tiết**: Các chi tiết đã chốt ở lượt chat #1 có bị lược bỏ hoặc "tóm tắt hóa" quá mức ở lượt chat #N không?

---

## ⚡ GIAI ĐOẠN 2: PHÁT HIỆN MƠ HỒ (Ambiguity Detection)

**Hành động của AI**: Tự phản biện nội dung vừa tạo ra.

1. **Xác định từ ngữ trung gian**: Có dùng những từ như "tương tự", "vân vân...", "có thể là..." ở những chỗ cần cấu hình chính xác không?
2. **Lỗ hổng logic**: Có bước nào trong Workflow bị "nhảy cóc" mà không có dữ liệu chứng minh không?
3. **Thiếu Context**: Có tham chiếu đến biến hoặc file nào mà chưa được định nghĩa hoặc chưa được đọc không?

---

## 🛠️ GIAI ĐOẠN 3: KIỂM CHỨNG KỸ THUẬT (Technical Verification)

1. **DoD Compliance**: Đối chiếu với phần "Definition of Done" trong file `AGENT_SKILL_DESIGN.md`.
2. **Integrity Check**: Các file liên quan (types, services, components) có thực sự đồng bộ về mặt đặt tên và tham chiếu không?
3. **Linter/Test**: (Nếu là code) Đã chạy lệnh kiểm tra lỗi cú pháp chưa?

---

## 🔄 QUY TRÌNH SỬA LỖI (Adjustment Loop)

1. **Nếu phát hiện thiếu sót**: AI KHÔNG được thông báo là đã xong. AI phải tự động liệt kê danh sách các điểm còn thiếu: *"Dựa trên đối chiếu, tôi nhận thấy còn thiếu mục X và chi tiết Y. Tôi sẽ bổ sung ngay..."*.
2. **Nếu phát hiện ảo giác**: AI phải xin lỗi, trích dẫn lại yêu cầu gốc của Steve và thực hiện lại phần đó.
3. **Nếu phát hiện thông tin mâu thuẫn**: Dừng lại và hỏi Steve: *"Trong lượt chat #2 bạn nói A, nhưng file thiết kế hiện tại đang là B. Tôi nên ưu tiên phương án nào?"*.

---

## 🚩 PHÁT NGÔN XÁC NHẬN (Confirmation)
*Trước khi hoàn tất, AI phải tự báo cáo:*
> "Tôi đã thực hiện xong. Bây giờ tôi sẽ tiến hành đối chiếu kết quả này với mục tiêu ban đầu của Steve dựa trên quy trình `/skill-verify`. Báo cáo đối chiếu sẽ được gửi kèm bên dưới."
