# Kỷ Luật Workflow

Tuân thủ quy trình 5 bước trong `architect.md`.

## Các Phase
- Khảo sát → Thiết kế → Xây dựng → Kiểm định → Bảo trì

## Quy Tắc
- Hoàn tất từng phase trước khi chuyển sang phase tiếp theo.
- Kết thúc mỗi phase bằng verify checkpoint từ hệ thống loop/verify.
- Nếu verify thất bại, báo lỗi, rollback về phase lỗi, sửa, rồi verify lại.
- Dùng Phase Mode cho việc phức tạp và Simple Mode cho việc đơn giản, theo `architect.md`.
