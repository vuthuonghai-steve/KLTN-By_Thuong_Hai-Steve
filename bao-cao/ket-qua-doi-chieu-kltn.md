# BÁO CÁO ĐỐI CHIẾU CHECKLIST KLTN
> **File kiểm tra:** `KLTN-template.tex`  
> **Checklist nguồn:** Phụ lục 07 – "Hướng dẫn trình bày báo cáo KLTN" – Trường ĐH Tài nguyên và Môi trường HN  
> **Thời gian kiểm tra:** 2026-02-28  
> **Người thực hiện:** Tít dễ thương (AI Technical Reviewer)

---

## PHẦN B: ĐỊNH DẠNG VĂN BẢN – KẾT QUẢ ĐỐI CHIẾU

### B.1 – Font chữ

| # | Yêu cầu | Giá trị hướng dẫn | Giá trị trong LaTeX | Dòng code | Kết quả |
|---|---------|-------------------|---------------------|-----------|---------|
| B.1.1 | Font chữ | Times New Roman | `Times New Roman` (fallback: `TeX Gyre Termes`) | Dòng 8–10 | ✅ **Đạt** |
| B.1.2 | Cỡ chữ | 13pt hoặc 14pt | `14pt` | Dòng 3 | ✅ **Đạt** |
| B.1.3 | Bộ mã Unicode | UTF-8 | XeLaTeX tự xử lý UTF-8 | — | ✅ **Đạt** |
| B.1.4 | Không nén/kéo dãn chữ | Bình thường | Không có lệnh nén chữ bất thường | — | ✅ **Đạt** |

### B.2 – Dãn dòng

| # | Yêu cầu | Giá trị hướng dẫn | Giá trị trong LaTeX | Dòng code | Kết quả |
|---|---------|-------------------|---------------------|-----------|---------|
| B.2.1 | Dãn dòng | 1.5 lines | `\onehalfspacing` (dòng 13) VÀ `\baselinestretch{1.5}` (dòng 33) | Dòng 13, 33 | ⚠️ **Cần xem xét** – có 2 cách khai báo, có thể dư thừa nhưng kết quả đúng |

### B.3 – Căn lề trang

| # | Yêu cầu | Giá trị hướng dẫn | Giá trị trong LaTeX | Dòng code | Kết quả |
|---|---------|-------------------|---------------------|-----------|---------|
| B.3.1 | Lề trên | 3.0 cm | `top=3.0cm` | Dòng 6 | ✅ **Đạt** |
| B.3.2 | Lề dưới | 3.0 cm | `bottom=3.0cm` | Dòng 6 | ✅ **Đạt** |
| B.3.3 | Lề trái | 3.5 cm | `left=3.5cm` | Dòng 6 | ✅ **Đạt** |
| B.3.4 | Lề phải | 2.0 cm | `right=2.0cm` | Dòng 6 | ✅ **Đạt** |

### B.4 – Khổ giấy

| # | Yêu cầu | Giá trị hướng dẫn | Giá trị trong LaTeX | Dòng code | Kết quả |
|---|---------|-------------------|---------------------|-----------|---------|
| B.4.1 | Khổ giấy A4 | A4 (210×297 mm) | `a4paper` (geometry dòng 6 + documentclass dòng 3) | Dòng 3, 6 | ✅ **Đạt** |
| B.4.2 | In một mặt | oneside | `oneside` | Dòng 3 | ✅ **Đạt** |

### B.5 – Số trang

| # | Yêu cầu | Giá trị hướng dẫn | Giá trị trong LaTeX | Dòng code | Kết quả |
|---|---------|-------------------|---------------------|-----------|---------|
| B.5.1 | Vị trí số trang: giữa, phía dưới | Giữa – dưới | Không có cấu hình `fancyhdr` rõ ràng. Default LaTeX `extreport` đặt số trang ở giữa-dưới | — | ⚠️ **Cần xem xét** – confirm sau khi biên dịch |
| B.5.2 | Phân vùng đánh số | Roman (phần đầu) → Arabic (nội dung) | `\pagenumbering{gobble}` (bìa) → `\pagenumbering{roman}` (dòng 149) → `\pagenumbering{arabic}` (dòng 279) | Dòng 91, 149, 279 | ✅ **Đạt** |

---

## PHẦN C: TIỂU MỤC

| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| C.1 | Đánh số dạng nhóm chữ số (1.1.1) | ✅ **Đạt** | LaTeX dùng `\chapter`, `\section`, `\subsection` tự động sinh 1.1.1 |
| C.2 | Tối đa 3 cấp (chapter/section/subsection) | ✅ **Đạt** | Không dùng `\subsubsection` |
| C.3 | Mỗi nhóm mục có tối thiểu 2 tiểu mục | 🔍 **Không xác định** | Cần đọc toàn bộ nội dung để kiểm tra logic |
| C.4 | Số đầu chỉ số chương | ✅ **Đạt** | Chuẩn LaTeX |

---

## PHẦN D: BẢNG BIỂU, HÌNH VẼ, PHƯƠNG TRÌNH

| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| D.1.1 | Đánh số hình gắn với chương | 🔍 **Không xác định** | Không tìm thấy `\numberwithin{figure}{chapter}` trong phần preamble. **Cần thêm!** |
| D.1.2 | Đánh số bảng gắn với chương | 🔍 **Không xác định** | Không tìm thấy `\numberwithin{table}{chapter}`. **Cần thêm!** |
| D.1.3 | Đánh số phương trình gắn với chương | ✅ **Đạt** | `\numberwithin{equation}{chapter}` – dòng 21 |
| D.3.1 | Caption bảng ở phía trên | ✅ **Đạt** | `\captionsetup[table]{position=top}` – dòng 87 |
| D.3.2 | Caption hình ở phía dưới | ✅ **Đạt** | LaTeX mặc định, không cần khai báo thêm |

> ❌ **VI PHẠM TIỀM ẨN – D.1.1 và D.1.2:**  
> Không tìm thấy `\numberwithin{figure}{chapter}` và `\numberwithin{table}{chapter}` trong preamble.  
> Hướng dẫn quy định: "Đánh số bảng biểu, hình vẽ phải gắn với số chương; ví dụ Hình 3.4 có nghĩa là hình thứ 4 trong Chương 3"  
> **→ Cần bổ sung 2 dòng này vào preamble sau dòng 21**

---

## PHẦN I: TRANG BÌA VÀ TRANG PHỤ BÌA

### I.1 – Trang bìa chính (dòng 93–113)

| # | Yêu cầu | Giá trị trong LaTeX | Kết quả |
|---|---------|---------------------|---------|
| I.1.1 | Tên trường | "TRƯỜNG ĐẠI HỌC TÀI NGUYÊN VÀ MÔI TRƯỜNG HÀ NỘI" | ✅ **Đạt** |
| I.1.2 | Tên khoa | "KHOA CÔNG NGHỆ THÔNG TIN" | ✅ **Đạt** |
| I.1.3 | Tên khóa luận | "NGHIÊN CỨU VÀ ỨNG DỤNG CHATBOT AI TRONG PHÁT TRIỂN WEBSITE MẠNG XÃ HỘI" | ✅ **Đạt** |
| I.1.4 | Họ tên sinh viên | "VŨ THƯỢNG HẢI" | ✅ **Đạt** |
| I.1.5 | Hà Nội – Năm... | "Hà Nội -- Năm 2026" | ✅ **Đạt** |

### I.2 – Trang phụ bìa (dòng 116–145)

| # | Yêu cầu | Giá trị trong LaTeX | Kết quả |
|---|---------|---------------------|---------|
| I.2.1 | Tên trường | ✅ Có | ✅ **Đạt** |
| I.2.2 | Tên khoa | ✅ Có | ✅ **Đạt** |
| I.2.3 | Tên khóa luận | ✅ Có | ✅ **Đạt** |
| I.2.4 | Họ và tên sinh viên | "Vũ Thượng Hải" | ✅ **Đạt** |
| I.2.5 | Ngành đào tạo | "Công Nghệ Thông Tin" | ✅ **Đạt** |
| I.2.6 | Người hướng dẫn | "ThS. TRƯƠNG MẠNH ĐẠT" | ✅ **Đạt** |
| I.2.7 | Hà Nội – Năm | "Hà Nội -- Năm 2026" | ✅ **Đạt** |
| I.2.8 | Mã sinh viên | "22111060108" | ✅ Có thêm (không bắt buộc nhưng tốt) |
| I.2.9 | Lớp | "ĐH12C1" | ✅ Có thêm (không bắt buộc nhưng tốt) |

---

## PHẦN A: BỐ CỤC – KIỂM TRA CÁC PHẦN BẮT BUỘC

| # | Phần bắt buộc | Có trong file? | Dòng tham chiếu | Kết quả |
|---|--------------|----------------|-----------------|---------|
| A.1.1 | Trang phụ bìa | ✅ Có | Dòng 116–145 | ✅ **Đạt** |
| A.1.2 | Lời cam đoan | ✅ Có | `\chapter*{BẢN CAM ĐOAN}` (implicit) dòng 152 | ✅ **Đạt** |
| A.1.3 | Mục lục | ✅ Có | `\tableofcontents` dòng 220 | ✅ **Đạt** |
| A.1.4 | Danh mục ký hiệu, chữ viết tắt | ✅ Có | `\chapter*{DANH MỤC KÝ HIỆU, CHỮ VIẾT TẮT}` dòng 223 | ✅ **Đạt** |
| A.1.5 | Danh mục bảng biểu | ✅ Có | `\listoftables` dòng 270 | ✅ **Đạt** |
| A.1.6 | Danh mục hình vẽ | ✅ Có | `\listoffigures` dòng 275 | ✅ **Đạt** |
| A.1.7 | Phần Mở đầu | ✅ Có | `\chapter*{MỞ ĐẦU}` dòng 282 | ✅ **Đạt** |
| A.1.7a | Giới thiệu cơ sở thực tập | ✅ Có | "Giới thiệu đơn vị thực tập" dòng 285 (Công ty Innotech) | ✅ **Đạt** |
| A.1.7b | Lý do chọn đề tài | ✅ Có | Mục "Lý do chọn đề tài" dòng 308 | ✅ **Đạt** |
| A.1.7c | Nội dung/phương pháp/cấu trúc | ✅ Có | "Phương pháp nghiên cứu", "Bố cục của báo cáo" | ✅ **Đạt** |
| A.1.8 | Các chương nội dung | ✅ Có | `\chapter{CƠ SỞ LÝ THUYẾT}` dòng 711 + các chương sau | ✅ **Đạt** |
| A.1.9 | Kết luận và Kiến nghị | 🔍 Cần kiểm tra cuối file | — | 🔍 **Cần xem file cuối** |
| A.1.10 | Danh mục TLTK | 🔍 Cần kiểm tra cuối file | — | 🔍 **Cần xem file cuối** |
| A.1.11 | Phụ lục | 🔍 Cần kiểm tra cuối file | — | 🔍 **Cần xem file cuối** |

---

## PHẦN E: CHỮ VIẾT TẮT

| # | Yêu cầu | Kết quả | Ghi chú |
|---|---------|---------|---------|
| E.5 | Có bảng danh mục viết tắt ở phần đầu | ✅ **Đạt** | Dòng 223 – `DANH MỤC KÝ HIỆU, CHỮ VIẾT TẮT` |
| E.5.a | Sắp xếp theo ABC | ⚠️ **Cần xem xét** | Bảng hiện tại: UC, US, SRS, AI, LLM, API... – **Chưa theo ABC** |

> ⚠️ **VẤN ĐỀ E.5.a:**  
> Danh mục viết tắt (dòng 237–265) hiện sắp xếp theo thứ tự: UC, US, SRS, AI, LLM, API, REST, CSDL, CMS, UML, ERD, UI/UX, CRUD, DTO, YAML, JSON, CLI, SSR, CSR, SEO, RSC, SSE, ASF, MSF, IP, Schema, Wireframe, Guardrail  
> **Hướng dẫn yêu cầu:** "xếp theo thứ tự ABC"  
> **→ Cần sắp xếp lại theo thứ tự bảng chữ cái!**

---

## TỔNG HỢP VẤN ĐỀ CẦN SỬA

### 🔴 Vi phạm rõ ràng (CRITICAL)

| # | Vấn đề | Vị trí | Yêu cầu |
|---|--------|--------|---------|
| 1 | **Thiếu `\numberwithin{figure}{chapter}`** | Preamble (sau dòng 21) | Hình vẽ phải đánh số theo chương (Hình 1.1, Hình 2.3...) |
| 2 | **Thiếu `\numberwithin{table}{chapter}`** | Preamble (sau dòng 21) | Bảng biểu phải đánh số theo chương (Bảng 1.1, Bảng 2.3...) |
| 3 | **Danh mục viết tắt chưa theo ABC** | Dòng 237–265 | Phải sắp xếp theo thứ tự ABC |

### ⚠️ Cần xem xét thêm (IMPORTANT)

| # | Vấn đề | Ghi chú |
|---|--------|---------|
| 4 | Khai báo dãn dòng **2 lần** (`\onehalfspacing` + `\baselinestretch`) | Dòng 13 và 33 – kết quả có thể đúng nhưng dư thừa |
| 5 | Số trang – vị trí giữa-dưới | Cần biên dịch để confirm, default extreport thường đúng |

### 🔍 Chưa xác định được (cần xem file cuối)

| # | Câu hỏi |
|---|---------|
| 6 | File có phần **Kết luận và Kiến nghị** không? |
| 7 | File có phần **Danh mục Tài liệu tham khảo** không? |
| 8 | File có phần **Phụ lục** không, và có dày hơn nội dung chính không? |
| 9 | Mỗi nhóm mục có tối thiểu **2 tiểu mục** không? |
| 10 | Tổng số trang có **≥ 50 trang** không? |
| 11 | Mọi tài liệu trong TLTK có được **trích dẫn trong bài** không? |
| 12 | Mọi trích dẫn trong bài có **trong danh mục TLTK** không? |

---

## PHẦN J: TỔNG HỢP KỸ THUẬT LATEX

| # | Điểm kiểm tra | Giá trị trong file | Yêu cầu | Kết quả |
|---|--------------|-------------------|---------|---------|
| J.1 | `\documentclass` | `[14pt,a4paper,oneside]{extreport}` | 14pt, a4paper, oneside | ✅ **Đạt** |
| J.2 | Geometry margins | `top=3.0cm,bottom=3.0cm,left=3.5cm,right=2.0cm` | Đúng chuẩn | ✅ **Đạt** |
| J.3 | Font chính | Times New Roman (fallback: TeX Gyre Termes) | Times New Roman | ✅ **Đạt** |
| J.4 | Dãn dòng | `\onehalfspacing` + `\baselinestretch{1.5}` | 1.5 | ✅ **Đạt** (dư thừa) |
| J.5 | Đánh số phương trình | `\numberwithin{equation}{chapter}` | Theo chương | ✅ **Đạt** |
| J.6 | Đánh số hình | **THIẾU** `\numberwithin{figure}{chapter}` | Theo chương | ❌ **Vi phạm** |
| J.7 | Đánh số bảng | **THIẾU** `\numberwithin{table}{chapter}` | Theo chương | ❌ **Vi phạm** |
| J.8 | Caption bảng | `\captionsetup[table]{position=top}` | Phía trên | ✅ **Đạt** |
| J.9 | Số trang | Cần confirm sau biên dịch | Giữa, dưới | ⚠️ **Cần xem xét** |
| J.10 | Thụt đầu dòng | `\setlength{\parindent}{1.27cm}` | Chuẩn | ✅ **Đạt** |
| J.11 | Trang bìa không số | `\pagenumbering{gobble}` | Đúng | ✅ **Đạt** |
| J.12 | Phần đầu Roman | `\pagenumbering{roman}` từ dòng 149 | Đúng | ✅ **Đạt** |
| J.13 | Nội dung Arabic từ 1 | `\pagenumbering{arabic}` + `\setcounter{page}{1}` dòng 279–280 | Đúng | ✅ **Đạt** |

---

## ĐỀ XUẤT SỬA CHỮA CỤ THỂ

### Sửa 1: Bổ sung đánh số hình và bảng theo chương

Thêm vào **sau dòng 21** (`\numberwithin{equation}{chapter}`):

```latex
\numberwithin{equation}{chapter}
\numberwithin{figure}{chapter}   % ← THÊM DÒNG NÀY
\numberwithin{table}{chapter}    % ← THÊM DÒNG NÀY
```

### Sửa 2: Sắp xếp danh mục viết tắt theo ABC

Thứ tự ABC đúng cho danh mục hiện tại:

```
AI, API, ASF, CLI, CMS, CRUD, CSDL, DTO, ERD, Guardrail, IP, JSON, LLM, 
MSF, REST, RSC, Schema, SEO, SRS, SSE, SSR, UC, UI/UX, UML, US, YAML, Wireframe
```

---

*Báo cáo được tạo tự động bởi Tít dễ thương – AI Technical Reviewer dựa trên Checklist Kỹ thuật KLTN*
