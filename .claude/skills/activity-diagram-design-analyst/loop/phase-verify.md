# Phase Verification (Gate-based Workflow)

## Phase 1: Collect Context & Mode Detection
- [ ] Đã xác định đúng Mode A hay Mode B?
- [ ] Đã bóc tách đủ danh sách Actors và Triggers?
- [ ] **Gate 1**: Người dùng đã xác nhận phạm viUse Case?

## Phase 2: Analyze Business Logic (Logical Baseline)
- [ ] Đã liệt kê đủ 3 loại luồng: Basic, Alternative, Exception?
- [ ] Đã phân loại được các Business Rules chính vào lane Domain?
- [ ] **Gate 2**: Người dùng đã xác nhận các giả định (Assumptions) và điểm mơ hồ?

## Phase 3: High-Fidelity Design & Findings Report
- [ ] Mermaid syntax đã được validate qua script?
- [ ] Sơ đồ đã bao quát 100% logic kỹ thuật từ resources?
- [ ] Báo cáo Findings đã liệt kê đủ mã lỗi (CF-0x, DL-0x...)?
- [ ] **Gate 3**: Người dùng đã đồng ý với các đề xuất Refactor?

## Phase 4: Guidance & Validation
- [ ] Đã cung cấp giải thích theo lens Clean Architecture?
- [ ] Checkbox trong `loop/checklist.md` đã được tích đủ?
- [ ] Kết quả cuối cùng đã đạt chuẩn High-Fidelity (không tóm tắt)?
