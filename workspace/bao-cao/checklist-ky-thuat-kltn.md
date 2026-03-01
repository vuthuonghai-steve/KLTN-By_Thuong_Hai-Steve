# CHECKLIST KỸ THUẬT KIỂM TRA BÁO CÁO KHÓA LUẬN TỐT NGHIỆP
> **Nguồn tham chiếu:** Phụ lục 07 – "Hướng dẫn trình bày báo cáo Khóa luận tốt nghiệp"  
> **Trường:** Đại học Tài nguyên và Môi trường Hà Nội  
> **File cần đối chiếu:** `KLTN-template.tex`  
> **Mục đích:** Cung cấp cho AI kiểm tra tự động, đánh dấu tuân thủ/vi phạm từng điều khoản hướng dẫn

---

## HƯỚNG DẪN SỬ DỤNG CHECKLIST NÀY

Khi sử dụng checklist này để kiểm tra file `KLTN-template.tex`, AI cần:
1. Đọc lần lượt từng mục
2. Tìm kiếm bằng chứng trong file LaTeX để xác nhận tuân thủ
3. Đánh dấu kết quả: `✅ Đạt` | `❌ Vi phạm` | `⚠️ Cần xem xét` | `🔍 Không xác định được`
4. Ghi chú chi tiết dòng code LaTeX liên quan

---

## PHẦN A: BỐ CỤC BÁO CÁO
**Nguồn:** Mục 1 – Bố cục (trang 20 PDF)

### A.1 – Các phần bắt buộc có mặt theo đúng thứ tự

| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| A.1.1 | **Trang phụ bìa** (theo mẫu) | | |
| A.1.2 | **Lời cam đoan** | | |
| A.1.3 | **Mục lục** | | |
| A.1.4 | **Danh mục các ký hiệu, chữ viết tắt** | | |
| A.1.5 | **Danh mục các bảng biểu** | | |
| A.1.6 | **Danh mục các hình vẽ, đồ thị** | | |
| A.1.7 | **Phần Mở đầu** với đủ các nội dung: (a) Tổng quan cơ sở thực tập, (b) Lý do chọn đề tài, (c) Nội dung, phương pháp, cấu trúc khóa luận | | |
| A.1.8 | **Các chương nội dung** (từ Chương 1 đến Chương n) | | |
| A.1.9 | **Kết luận và Kiến nghị** | | |
| A.1.10 | **Danh mục Tài liệu tham khảo** (chỉ chứa tài liệu được trích dẫn) | | |
| A.1.11 | **Phụ lục** (nếu có) | | |

### A.2 – Mục lục
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| A.2.1 | Mục lục nên gọn trong **một trang giấy** | | |

---

## PHẦN B: ĐỊNH DẠNG VĂN BẢN (SOẠN THẢO)
**Nguồn:** Mục 2.1 – Soạn thảo văn bản (trang 20-21 PDF)

### B.1 – Font chữ
| # | Yêu cầu | Giá trị yêu cầu | Kết quả | Ghi chú |
|---|---------|----------------|---------|---------|
| B.1.1 | Sử dụng font **Times New Roman** (hoặc tương đương) | Times New Roman | | LaTeX: kiểm tra `\setmainfont{Times New Roman}` |
| B.1.2 | Cỡ chữ chính văn bản | **13pt hoặc 14pt** | | LaTeX: kiểm tra `\documentclass[14pt,...]` |
| B.1.3 | Bộ mã **Unicode** (UTF-8) | Unicode/UTF-8 | | |
| B.1.4 | Mật độ chữ bình thường – **không nén, không kéo dãn** khoảng cách giữa các chữ | Không có `\textls`, `\letterspace` bất thường | | |

### B.2 – Dãn dòng
| # | Yêu cầu | Giá trị yêu cầu | Kết quả | Ghi chú |
|---|---------|----------------|---------|---------|
| B.2.1 | Dãn dòng toàn văn bản | **1.5 lines** | | LaTeX: `\onehalfspacing` hoặc `\baselinestretch{1.5}` |

### B.3 – Căn lề trang
| # | Yêu cầu | Giá trị yêu cầu | Kết quả | Ghi chú |
|---|---------|----------------|---------|---------|
| B.3.1 | Lề trên | **3.0 cm** | | LaTeX: `top=3.0cm` (hoặc `3cm`) |
| B.3.2 | Lề dưới | **3.0 cm** | | LaTeX: `bottom=3.0cm` (hoặc `3cm`) |
| B.3.3 | Lề trái | **3.5 cm** | | LaTeX: `left=3.5cm` |
| B.3.4 | Lề phải | **2.0 cm** | | LaTeX: `right=2.0cm` |

### B.4 – Khổ giấy
| # | Yêu cầu | Giá trị yêu cầu | Kết quả | Ghi chú |
|---|---------|----------------|---------|---------|
| B.4.1 | Khổ giấy | **A4 (210 x 297 mm)** | | LaTeX: `a4paper` trong `\documentclass` hoặc `geometry` |
| B.4.2 | In **một mặt** | Một mặt | | LaTeX: `oneside` trong `\documentclass` |

### B.5 – Số trang
| # | Yêu cầu | Giá trị yêu cầu | Kết quả | Ghi chú |
|---|---------|----------------|---------|---------|
| B.5.1 | Số trang đặt ở **giữa, phía dưới** mỗi trang | Giữa – dưới | | LaTeX: kiểm tra `\pagestyle` hoặc `fancyhdr` |
| B.5.2 | Các trang từ nội dung (sau phần đầu) phải có đánh số trang | Có số trang | | |

### B.6 – Độ dài tối thiểu
| # | Yêu cầu | Giá trị yêu cầu | Kết quả | Ghi chú |
|---|---------|----------------|---------|---------|
| B.6.1 | Tối thiểu **50 trang** (không kể phụ lục) | ≥ 50 trang | | Chỉ ước tính được khi biên dịch thực tế |

---

## PHẦN C: TIỂU MỤC (ĐÁNH SỐ CHƯƠNG – MỤC)
**Nguồn:** Mục 2.2 – Tiểu mục (trang 21 PDF)

| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| C.1 | Hệ thống đánh số dạng **chữ số nhóm** (VD: 1.1.1) | | |
| C.2 | Tối đa **3 cấp chữ số** (ví dụ: 1.1.1 là giới hạn sâu nhất) | | LaTeX: chỉ dùng `\chapter`, `\section`, `\subsection` |
| C.3 | **Không dùng** mục chỉ có 1 tiểu mục: nếu có 1.1.1 phải có 1.1.2 | | Kiểm tra logic mục lục |
| C.4 | Số thứ nhất trong nhóm chỉ **số chương** | | Ví dụ: 1.1.1 → chương 1 |

---

## PHẦN D: BẢNG BIỂU, HÌNH VẼ, PHƯƠNG TRÌNH
**Nguồn:** Mục 2.3 – Bảng biểu, hình vẽ, phương trình (trang 21-22 PDF)

### D.1 – Đánh số bảng và hình
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| D.1.1 | Số bảng/hình **gắn với số chương** (VD: Hình 3.4 = hình thứ 4 chương 3) | | LaTeX: `\numberwithin{figure}{chapter}`, `\numberwithin{table}{chapter}` |
| D.1.2 | Phương trình cũng đánh số theo chương (VD: (3.1)) và đặt trong **ngoặc đơn ở lề phải** | | LaTeX: `\numberwithin{equation}{chapter}` |

### D.2 – Trích dẫn nguồn bảng/hình
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| D.2.1 | Mọi bảng/hình/đồ thị lấy từ nguồn khác **phải có trích dẫn** (VD: "Nguồn: ...") | | |
| D.2.2 | Nguồn trích dẫn trong bảng/hình phải **khớp với danh mục TLTK** | | |

### D.3 – Vị trí đầu đề
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| D.3.1 | Đầu đề **bảng biểu** ghi **phía trên** bảng | | LaTeX: `\captionsetup[table]{position=top}` |
| D.3.2 | Đầu đề **hình vẽ** ghi **phía dưới** hình | | LaTeX: `\captionsetup[figure]{position=bottom}` (mặc định) |

### D.4 – Tham chiếu trong văn bản
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| D.4.1 | Khi đề cập đến bảng/hình phải **nêu rõ số** (VD: "Bảng 1.1", "Hình 2.3") – **không** được viết "bảng dưới đây", "đồ thị sau" | | |

### D.5 – Hình vẽ kỹ thuật
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| D.5.1 | Trong hình vẽ, **cỡ chữ phải bằng cỡ chữ** sử dụng trong văn bản | | |

### D.6 – Phương trình toán học
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| D.6.1 | Ký hiệu **xuất hiện lần đầu** phải được giải thích kèm đơn vị | | |
| D.6.2 | Trình bày phương trình (một dòng đơn hoặc kép) phải **thống nhất** trong toàn bài | | |
| D.6.3 | Các phương trình cùng nhóm có thể đánh số (5.1.1), (5.1.2)... | | |

---

## PHẦN E: CHỮ VIẾT TẮT
**Nguồn:** Mục 2.4 – Viết tắt (trang 22 PDF)

| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| E.1 | **Không lạm dụng** viết tắt – chỉ viết tắt từ được dùng nhiều lần | | |
| E.2 | **Không viết tắt** cụm từ dài, mệnh đề | | |
| E.3 | **Không viết tắt** cụm từ ít xuất hiện | | |
| E.4 | Lần **viết đầu tiên** phải viết đầy đủ kèm chữ viết tắt trong ngoặc đơn | | VD: "Trí tuệ nhân tạo (AI)" |
| E.5 | Nếu có **nhiều chữ viết tắt** → phải có **bảng danh mục** ở phần đầu, sắp xếp theo **thứ tự ABC** | | |

---

## PHẦN F: PHỤ LỤC
**Nguồn:** Mục 2.5 – Phụ lục (trang 22 PDF)

| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| F.1 | Phụ lục chứa nội dung **minh họa/bổ sung** (số liệu, biểu mẫu, ảnh...) | | |
| F.2 | Bảng câu hỏi dùng điều tra phải **in nguyên bản**, không tóm tắt hoặc sửa đổi | | |
| F.3 | Phụ lục **không được dày hơn** phần chính của khóa luận | | |

---

## PHẦN G: TRÍCH DẪN TÀI LIỆU THAM KHẢO
**Nguồn:** Hướng dẫn trích dẫn TLTK (trang 26-28 PDF)

### G.1 – Nguyên tắc trích dẫn
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| G.1.1 | TLTK dùng trong: đặt vấn đề, tổng quan, phương pháp, bàn luận | | |
| G.1.2 | **Không dùng** TLTK trong phần: giả thiết, kết quả, kết luận, kiến nghị | | |
| G.1.3 | Cách ghi trích dẫn **thống nhất** toàn bộ khóa luận | | |
| G.1.4 | Trích dẫn theo **số thứ tự** đặt trong **ngoặc vuông** `[n]` | | VD: `[15]` hoặc `[15, 314-315]` |
| G.1.5 | Khi trích từ nhiều tài liệu: mỗi số đặt **riêng trong ngoặc vuông, tăng dần, không cách**: `[19],[25],[41]` | | |
| G.1.6 | Sử dụng bảng/biểu/công thức/đồ thị của người khác **phải chú dẫn đầy đủ** – nếu thiếu → **không được duyệt** | | |
| G.1.7 | **Không ghi** học hàm, học vị, địa vị xã hội vào thông tin trích dẫn | | |
| G.1.8 | Tài liệu trích dẫn trong bài **phải có trong danh mục TLTK** | | |
| G.1.9 | Tài liệu trong danh mục TLTK **phải được trích dẫn trong bài** | | |
| G.1.10 | **Không trích dẫn tài liệu chưa đọc** | | Kiểm tra tính hợp lý |

### G.2 – Hình thức trích dẫn
| # | Loại | Yêu cầu | Kết quả | Ghi chú |
|---|------|---------|---------|---------|
| G.2.1 | Trực tiếp | Phần trích **trong ngoặc kép** + `[n]` | | |
| G.2.2 | Gián tiếp | Diễn đạt lại nhưng **đúng nội dung gốc**, có `[n]` | | |
| G.2.3 | Thứ cấp | **Không** liệt kê tài liệu gốc trong danh mục TLTK | | |

---

## PHẦN H: DANH MỤC TÀI LIỆU THAM KHẢO
**Nguồn:** Mục 3 – Xây dựng và cách trình bày TLTK (trang 27-28 PDF)

### H.1 – Quy tắc sắp xếp
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| H.1.1 | Sắp xếp theo **ABC** theo thứ tự: tiếng Việt → Anh → Pháp → Nga → Trung | | |
| H.1.2 | Trích dẫn theo **số**, không theo tên tác giả và năm | | |
| H.1.3 | Tài liệu tiếng nước ngoài **giữ nguyên văn**, không phiên âm, không dịch | | |
| H.1.4 | **Không dùng** luận văn, luận án, Website làm TLTK (**nên hạn chế**) | | |
| H.1.5 | **Hạn chế** dùng sách giáo khoa làm TLTK | | |

### H.2 – Định dạng từng loại tài liệu

#### H.2.1 – Bài báo tạp chí / tập san
| # | Thành phần | Yêu cầu | Kết quả |
|---|-----------|---------|---------|
| H.2.1.1 | Tên tác giả | Việt Nam: viết đầy đủ. Nước ngoài: Họ đầy đủ + tên đệm viết tắt | |
| H.2.1.2 | Nhiều tác giả | Ghi 3 tác giả đầu + "et al." | |
| H.2.1.3 | Năm xuất bản | Trong ngoặc đơn | |
| H.2.1.4 | Tên tạp chí | **Ghi nghiêng** | |
| H.2.1.5 | Tập/số | Số đặt trong ngoặc đơn, dấu phẩy sau ngoặc đơn | |
| H.2.1.6 | Trang | Gạch nối giữa hai số, dấu chấm kết thúc | |

#### H.2.2 – Sách
| # | Thành phần | Yêu cầu | Kết quả |
|---|-----------|---------|---------|
| H.2.2.1 | Tên sách | **Ghi nghiêng**, dấu phẩy cuối | |
| H.2.2.2 | Lần xuất bản | Chỉ ghi từ lần thứ 2 trở đi | |
| H.2.2.3 | Nơi xuất bản | Tên **thành phố** (không ghi tên quốc gia) | |
| H.2.2.4 | Nhiều tác giả | 2 tác giả: "và"/"and". ≥3 tác giả: tên đầu + "cộng sự"/"et al." | |

#### H.2.3 – Chương trong sách
| # | Thành phần | Yêu cầu | Kết quả |
|---|-----------|---------|---------|
| H.2.3.1 | Tên sách | Ghi nghiêng, dấu phẩy cuối | |
| H.2.3.2 | Nơi xuất bản | Tên thành phố, không phải quốc gia | |

#### H.2.4 – Luận án / Luận văn / Khóa luận
| # | Thành phần | Yêu cầu | Kết quả |
|---|-----------|---------|---------|
| H.2.4.1 | Tên đề tài | **Ghi nghiêng**, dấu phẩy cuối | |
| H.2.4.2 | Bậc học | Ghi rõ (Tiến sĩ / Thạc sĩ / Cử nhân) | |
| H.2.4.3 | Cơ sở đào tạo | Tên chính thức | |

#### H.2.5 – Bài báo hội nghị / hội thảo
| # | Thành phần | Yêu cầu | Kết quả |
|---|-----------|---------|---------|
| H.2.5.1 | Tên kỷ yếu / hội nghị | Ghi nghiêng | |
| H.2.5.2 | Thông tin | Địa điểm, thời gian tổ chức, cơ quan tổ chức, số trang | |

#### H.2.6 – Giáo trình / bài giảng / tài liệu nội bộ
| # | Thành phần | Yêu cầu | Kết quả |
|---|-----------|---------|---------|
| H.2.6.1 | Thông tin cơ bản | Tên tác giả, năm, tên giáo trình, NXB (nếu có), đơn vị chủ quản | |

#### H.2.7 – Nguồn Internet (hạn chế tối đa)
| # | Thành phần | Yêu cầu | Kết quả |
|---|-----------|---------|---------|
| H.2.7.1 | Tên tác giả | Nếu có | |
| H.2.7.2 | Năm | Nếu có | |
| H.2.7.3 | Đường dẫn URL | `<đường dẫn>` | |
| H.2.7.4 | Thời gian trích dẫn | Phải ghi thời điểm truy cập | |

---

## PHẦN I: TRANG BÌA VÀ TRANG PHỤ BÌA
**Nguồn:** Mẫu bìa và mẫu trang phụ bìa (trang 24-25 PDF)

### I.1 – Trang bìa chính
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| I.1.1 | Tên trường: **TRƯỜNG ĐẠI HỌC TÀI NGUYÊN VÀ MÔI TRƯỜNG HÀ NỘI** | | |
| I.1.2 | Tên khoa | | |
| I.1.3 | **Tên khóa luận** (in hoa, đậm, nổi bật) | | |
| I.1.4 | **Họ và tên sinh viên** | | |
| I.1.5 | **Hà Nội – Năm...** | | |
| I.1.6 | Khổ bìa: **210 x 297 mm** (A4) | | |
| I.1.7 | Bìa cứng, **in chữ nhũ đủ dấu tiếng Việt** | | |

### I.2 – Trang phụ bìa
| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| I.2.1 | Tên trường | | |
| I.2.2 | Tên khoa | | |
| I.2.3 | Tên khóa luận | | |
| I.2.4 | **Họ và tên sinh viên** | | |
| I.2.5 | **Ngành đào tạo** | | |
| I.2.6 | **Người hướng dẫn** (có thể có 2 người) | | |
| I.2.7 | **Hà Nội – Năm...** | | |

---

## PHẦN J: KIỂM TRA TỔNG THỂ LATEX TEMPLATE
**Mục đích:** Các điểm kỹ thuật LaTeX cụ thể cần đối chiếu với hướng dẫn

| # | Điểm kiểm tra | Giá trị trong file LaTeX | Yêu cầu hướng dẫn | Kết quả |
|---|--------------|------------------------|-------------------|---------|
| J.1 | `\documentclass` | Kiểm tra options | `14pt` hoặc `13pt`, `a4paper`, `oneside` | |
| J.2 | `geometry` margins | Kiểm tra `top`, `bottom`, `left`, `right` | `top=3cm`, `bottom=3cm`, `left=3.5cm`, `right=2cm` | |
| J.3 | Font chính | Kiểm tra `\setmainfont` | Times New Roman (hoặc tương đương) | |
| J.4 | Dãn dòng | Kiểm tra `\onehalfspacing` / `\baselinestretch` | 1.5 | |
| J.5 | Đánh số phương trình | Kiểm tra `\numberwithin{equation}{chapter}` | Phải gắn với chương | |
| J.6 | Đánh số hình | Kiểm tra `\numberwithin{figure}{chapter}` | Phải gắn với chương | |
| J.7 | Đánh số bảng | Kiểm tra `\numberwithin{table}{chapter}` | Phải gắn với chương | |
| J.8 | Caption bảng | Kiểm tra `\captionsetup[table]{position=top}` | Tiêu đề bảng ở phía **trên** | |
| J.9 | Số trang | Kiểm tra `\pagestyle` / cấu hình header-footer | Ở giữa, phía dưới | |
| J.10 | Thụt đầu dòng | Kiểm tra `\parindent` | Theo chuẩn (1.27cm là phổ biến) | |
| J.11 | Phần đầu không đánh số | Kiểm tra `\pagenumbering{gobble}` hoặc tương đương | Trang bìa không có số | |
| J.12 | Phần tiếng La-tinh | Kiểm tra `\pagenumbering{roman}` | Từ cam đoan đến mục lục | |
| J.13 | Phần nội dung | Kiểm tra `\pagenumbering{arabic}` bắt đầu từ 1 | Từ Mở đầu hoặc Chương 1 | |

---

## PHẦN K: LỖI PHỔ BIẾN CẦN KIỂM TRA ĐẶC BIỆT

| # | Lỗi thường gặp | Kiểm tra | Kết quả |
|---|----------------|---------|---------|
| K.1 | Chỉ có 1 tiểu mục trong một nhóm mục (vi phạm quy tắc tối thiểu 2 tiểu mục) | Duyệt toàn bộ structure chapter/section/subsection | |
| K.2 | Hình/bảng không được tham chiếu trong văn bản | Mọi `\ref{fig:...}` và `\ref{tab:...}` phải được sử dụng | |
| K.3 | TLTK trong danh mục nhưng không được trích dẫn | Kiểm tra chéo `\cite{}` và `\bibitem{}` | |
| K.4 | Trích dẫn trong bài nhưng không có trong TLTK | Tương tự K.3 | |
| K.5 | Tham chiếu hình/bảng bằng "bảng dưới đây" / "hình sau" | Tìm kiếm cụm từ này trong toàn văn | |
| K.6 | Lề trang sai (đặc biệt lề trái và phải) | Đối chiếu giá trị `geometry` | |
| K.7 | Phụ lục dày hơn nội dung chính | So sánh số trang | |
| K.8 | Danh mục viết tắt không sắp xếp ABC | Kiểm tra thứ tự bảng viết tắt | |
| K.9 | Bài báo/hình/bảng lấy từ nguồn ngoài không có "Nguồn: ..." | Kiểm tra các caption | |
| K.10 | Đánh số chương/section không theo quy tắc nhóm 3 chữ số | Kiểm tra cấu trúc phân cấp | |

---

## TÓM TẮT KẾT QUẢ KIỂM TRA

| Phần | Tổng mục | ✅ Đạt | ❌ Vi phạm | ⚠️ Cần xem xét | 🔍 Không xác định |
|------|---------|--------|-----------|----------------|-----------------|
| A – Bố cục | | | | | |
| B – Định dạng văn bản | | | | | |
| C – Tiểu mục | | | | | |
| D – Bảng/Hình/Phương trình | | | | | |
| E – Chữ viết tắt | | | | | |
| F – Phụ lục | | | | | |
| G – Trích dẫn | | | | | |
| H – Danh mục TLTK | | | | | |
| I – Trang bìa | | | | | |
| J – Kỹ thuật LaTeX | | | | | |
| K – Lỗi phổ biến | | | | | |
| **TỔNG** | | | | | |

---

## GHI CHÚ QUAN TRỌNG CHO AI KHI SỬ DỤNG CHECKLIST NÀY

> **1. Phân biệt "Không tuân thủ" vs "Không xác định được":**
> - `❌ Vi phạm` = Có bằng chứng rõ ràng trong file LaTeX là sai
> - `🔍 Không xác định` = Không thể xác định chỉ từ file LaTeX (cần biên dịch hoặc xem PDF thực tế)
>
> **2. Các mục chỉ kiểm tra được khi biên dịch:**
> - Số trang thực tế (B.6.1 – tối thiểu 50 trang)
> - Mục lục gọn trong 1 trang (A.2.1)
> - Phụ lục không dày hơn nội dung chính (F.3)
>
> **3. Ưu tiên kiểm tra:**
> - 🔴 **CRITICAL:** B.3 (Lề trang), B.1.1 (Font), B.2.1 (Dãn dòng), G.1.4–G.1.9 (Trích dẫn)
> - 🟡 **IMPORTANT:** C (Tiểu mục), D.1 (Đánh số hình/bảng), H (Danh mục TLTK)
> - 🟢 **NICE-TO-HAVE:** F (Phụ lục), K (Lỗi phổ biến)

---

*Checklist được tạo bởi Tít dễ thương – dựa trên Phụ lục 07 "Hướng dẫn trình bày báo cáo KLTN" của Trường ĐH Tài nguyên và Môi trường Hà Nội.*
