# Knowledge Item: AI Agent Limitations & Mitigations

> **Mô tả**: Bản đồ nhận diện 8 nhược điểm chí mạng của AI Agent và bộ giải pháp "pháp khí" để khắc phục trong dự án Antigravity.
> **Trạng thái**: Đã phê duyệt bởi Steve
> **Phân loại**: Agent Governance / Best Practices

---

## 🚩 8 Nhược Điểm Chí Mạng (The AI Pitfalls)

| # | Nhược điểm                  | Mô tả chi tiết                                                    | Hậu quả                                                 |
| - | ------------------------------- | -------------------------------------------------------------------- | --------------------------------------------------------- |
| 1 | **Summarization Bias**    | AI ưu tiên súc tích để tiết kiệm token và tăng tốc độ.  | Mất chi tiết kỹ thuật, mất edge cases.               |
| 2 | **Knowledge Erosion**     | Tri thức bị "rơi rụng" khi chuyển từ Resource sang Code/Skill. | Sản phẩm bị ngây ngô, thiếu chiều sâu.            |
| 3 | **Instruction Ambiguity** | Hiểu nhầm các từ "Dựa trên", "Dẫn xuất" thành "Tóm tắt".  | Kết quả bị loãng, thiếu mật độ thông tin.        |
| 4 | **Validation Illusion**   | Script báo PASS chỉ vì file tồn tại, không check nội dung.    | Hệ thống rỗng tuếch nhưng AI vẫn tự tin.           |
| 5 | **Planning Disconnect**   | Planner giao task quá ngắn, Builder làm lười biếng.            | Kết quả hời hợt, không đạt độ phân giải cao.   |
| 6 | **Blind Spots**           | AI tự giả định thay vì hỏi lại khi gặp thông tin mơ hồ.   | Sai lệch logic nghiêm trọng ngay từ đầu.            |
| 7 | **State Drift**           | AI mất trung khi làm việc với file dài hoặc session cũ.       | Quyết định trước và sau mâu thuẫn nhau.           |
| 8 | **Comm. Overhead**        | Đứt gãy luồng tin giữa các Agent trong hệ thống Multi-agent. | Cha chung không ai khóc, task giao thoa bị bỏ trống. |

---

## 🛠 Bộ "Pháp Khí" Khắc Phục (Mitigation Framework)

### 1. Chiến thuật "Double-Pass" (Trị Summarization Bias)

- **Bước 1**: Tạo cấu trúc và khung sườn.
- **Bước 2**: Thực hiện lượt quét thứ hai để điền chi tiết, đảm bảo mật độ thông tin cao nhất.

- Bắt buộc đính kèm nguồn gốc tri thức: `File A (Line 10-20) -> Code B`.
- Sử dụng động từ mạnh: `Transform 100%`, `Exhaustive Implementation`.

### 2. Mandatory Resource Mapping (Trị Knowledge Erosion)

### 3. Confidence Score Rule 70% (Trị Blind Spots)

- **Luật bất biến**: Nếu độ tự tin < 70% hoặc có > 2 cách hiểu → **DỪNG LẠI VÀ HỎI STEVE**.
- Cấm tuyệt đối việc giả định trong giai đoạn Research và Design.

### 4. Semantic Audit (Trị Validation Illusion)

- Nâng cấp validator để kiểm tra dung lượng, mật độ từ khóa và tính nhất quán logic thay vì chỉ kiểm tra sự tồn tại của file.

### 5. Granular DoD (Trị Planning Disconnect)

- Mỗi task trong `todo.md` phải kèm theo tiêu chí nghiệm thu (Definition of Done) cực kỳ chi tiết.

### 6. Standalone 7-Zone Architecture (Trị State Drift & Comm. Overhead)

- Mỗi Skill phải tự chủ trong 7 phân vùng (Core, Knowledge, Scripts, Templates, Data, Loop, Assets).
- Sử dụng Session-based runtime để đóng gói và bảo toàn ngữ cảnh.

---

## 💡 Cách Steve tận dụng KI này

Khi nhận thấy Agent có dấu hiệu "lười biếng" hoặc làm sai lệch ý đồ, Steve chỉ cần nhắc nhở:

> *"Tít ơi, hãy soi lại KI về AI Agent Limitations, đặc biệt là phần [Tên nhược điểm] và thực hiện lại cho đúng chuẩn nhé!"*

---

**Cập nhật lần cuối**: 2026-02-17
**Tác giả**: Tít dễ thương (đã thông qua yêu cầu của Steve)
