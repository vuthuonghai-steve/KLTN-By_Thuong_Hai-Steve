# Đồng Bộ Kiến Trúc

## Zones Hợp Lệ
- `SKILL.md`
- `knowledge/`
- `scripts/`
- `templates/`
- `data/`
- `loop/`
- `assets/`

## Quy Tắc
- Chỉ tạo file mới trong các zone hợp lệ.
- Nếu cần tạo ngoài các zone này, phải dừng lại và hỏi người dùng để xác nhận.
- Giữ cấu trúc và tên gọi đúng theo `architect.md`.
- Khi không chắc, đọc lại `architect.md` trước khi tiếp tục.
- Mỗi skill phải là một module độc lập. Chỉ tham chiếu nguồn internet hoặc file trong thư mục skill.
- Nếu cần kiến thức ở cấp dự án, hãy copy nội dung vào skill (ví dụ `knowledge/`, `data/`, `templates/`) và tham chiếu nội bộ.
