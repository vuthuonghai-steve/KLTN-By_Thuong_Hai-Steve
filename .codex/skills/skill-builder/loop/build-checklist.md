# Build Checklist: Skill Builder Self-Verification

## 1. Structure Check (Vùng Kiến trúc)
- [ ] Sự hiện diện của 4 Zone bắt buộc (Core, Knowledge, Scripts, Loop).
- [ ] Tuân thủ quy tắc đặt tên file: kebab-case cho resources/knowledge/scripts.
- [ ] File `SKILL.md` nằm đúng vị trí tại root của skill.

## 2. Source & Design Check (Đối chiếu Nguồn)
- [ ] Nội dung bám sát 100% bản thiết kế `design.md`.
- [ ] Mọi mục `[CẦN LÀM RÕ]` trong `todo.md` đã được giải quyết hoặc trả lời tại `design.md §9`.
- [ ] Mọi Task trong `todo.md` đồng bộ với thực tế file đã tạo.
- [ ] Đã tạo `Resource Inventory` trong `.skill-context/{skill-name}/build-log.md`.
- [ ] Đã tạo `Resource Usage Matrix` trong `.skill-context/{skill-name}/build-log.md`.
- [ ] 100% file `Critical` (`design.md`, `todo.md`, `resources/*`, `data/*`) có evidence được dùng.

## 3. Progressive Disclosure Check (Phân tầng thông tin)
- [ ] Mọi file Tier 2 đều được dẫn link từ `SKILL.md`.
- [ ] Không có file mồ côi (Orphan files) không được sử dụng.
- [ ] `SKILL.md` < 500 dòng.

## 4. Completeness & Performance (Hoàn thiện & Chất lượng)
- [ ] Mật độ Placeholder `[MISSING_DOMAIN_DATA]` < 5 (Normal).
- [ ] **Zero-Summarization Verification**: Đã đối soát 1:1 với resources; không có hiện tượng tóm tắt hay lược bỏ chi tiết kỹ thuật.
- [ ] Script `validate_skill.py` trả về Exit Code 0 (PASS).
- [ ] Nhật ký `build-log.md` phản ánh trung thực trạng thái validation.

## 5. Engineer Stance (Thẩm định Kỹ sư)
- [ ] Đã thực hiện phản biện bản thiết kế (nếu có phi logic).
- [ ] Quy trình xử lý lỗi tuân thủ Log-Notify-Stop (Dừng ngay khi có lỗi hệ thống).
- [ ] Không có kết luận nào không truy vết được về resource hoặc design/todo.
