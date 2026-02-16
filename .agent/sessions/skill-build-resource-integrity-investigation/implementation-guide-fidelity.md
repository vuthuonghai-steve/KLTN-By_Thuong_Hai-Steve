# Implementation Guide: High-Fidelity Knowledge Transformation

## 1. Nâng cấp `skill-builder/SKILL.md`

### Bổ sung Guardrail:
```markdown
| ID | Rule | Description |
|---|---|---|
| G9 | **Knowledge Fidelity** | Tuyệt đối không tóm tắt (summarize) tài nguyên Tier-Critical của Zone Knowledge/Data. Phải chuyển hóa (Transform) 100% tri thức kỹ thuật. |
```

### Cập nhật Step 3 (BUILD):
- Thêm bước **Refinement Pass**: Sau khi tạo xong các file trong Phase, hãy dành 1 lượt đọc lại Resource để "bơm" (Infuse) các chi tiết kỹ thuật còn thiếu vào file đích.

## 2. Nâng cấp `skill-builder/knowledge/build-guidelines.md`

### Bổ sung mục: "Quy chuẩn độ sâu nội dung (Fidelity Standard)"
- **Tỷ lệ bảo toàn định danh**: Mọi Rule ID, Error Code, và Technical Term từ Resource phải xuất hiện chính xác trong Result.
- **Cấu trúc liệt kê (Exhaustive List)**: Chuyển đổi các đoạn văn mô tả trong Resource thành các bảng (Table) hoặc danh sách gạch đầu dòng chi tiết trong Result. KHÔNG dùng "Và các bước tương tự...".

## 3. Cải thiện `todo.md` (Cho Planner)
- Sử dụng động từ **"Transform 1:1"** hoặc **"Implement Exhaustively"** thay cho "Tạo/Soạn".
- Phải có cột/ghi chú về **Source Section** (Vd: `Từ resource/X #3.2`).

## 4. Cải thiện `validate_skill.py` (Hướng phát triển)
- (Technical Proposal): Thêm hàm `check_file_length_ratio(source, target)` để cảnh báo nếu target < 30% dung lượng source.
- Thêm hàm `check_mandatory_keywords(source, target)` trích xuất danh từ riêng từ source và kiểm tra độ phủ trong target.

---

## Verification Checklist (Dành cho Steve Review)
- [ ] `SKILL.md` của builder đã có G9 chưa?
- [ ] `build-guidelines.md` đã có định nghĩa Fidelity chưa?
- [ ] Các Task trong `todo.md` có ghi chú nguồn chi tiết chưa?
