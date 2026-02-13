# Plan Checklist — Kiểm tra Chất lượng todo.md

> Planner PHẢI đọc checklist này SAU khi ghi todo.md
> và tự verify TRƯỚC khi trình bày cho user.

---

## Trace Check
- [ ] Mọi task trong Phase Breakdown có trace tag (`[TỪ DESIGN §N]` hoặc `[GỢI Ý BỔ SUNG]`)
- [ ] Mọi pre-requisite trong bảng có cột Trace
- [ ] Không có entry nào thiếu trace tag
- [ ] Các entry `[GỢI Ý BỔ SUNG]` chiếm tỷ lệ hợp lý (< 30% tổng entries)

## Completeness Check
- [ ] Mọi Zone có nội dung trong design.md §3 đều được phân tích
- [ ] Không có Zone nào bị bỏ sót (đối chiếu 1-1 với design §3)
- [ ] Mỗi Zone phân tích đều có cả 3 tầng (Domain, Technical, Packaging)
- [ ] Checklist chuyển đổi 5 câu hỏi đã áp dụng cho mỗi Zone

## Actionability Check
- [ ] Mỗi task có cấu trúc: verb + object cụ thể (ví dụ: "Tạo file X", "Viết section Y")
- [ ] Không có task mơ hồ kiểu "Xử lý phần Z" hay "Làm việc với T"
- [ ] Mỗi task đủ nhỏ để thực hiện trong 1 session

## Dependencies Check
- [ ] Tasks xếp theo thứ tự dependency (việc nào cần làm trước xếp trước)
- [ ] Nếu task B phụ thuộc task A → A đứng trước B trong danh sách
- [ ] Các phases chia nhóm logic (không gộp tasks không liên quan)

## 3 Tầng Check
- [ ] Pre-requisites có phân loại theo Tier (Domain / Technical / Packaging)
- [ ] Tầng Domain: liệt kê kiến thức miền cần hiểu
- [ ] Tầng Technical: liệt kê công cụ/kỹ thuật cần biết
- [ ] Tầng Packaging: liệt kê cách map vào agent skill zones

## Final Check
- [ ] todo.md có đủ 5 sections (Pre-reqs, Phases, Resources, DoD, Notes)
- [ ] Definition of Done có tiêu chí kiểm tra rõ ràng
- [ ] Notes section ghi lại mọi điểm `[CẦN LÀM RÕ]` (nếu có)
