# VALIDATION LOGIC SPECIFICATION: ĐẶC TẢ KỸ THUẬT KIỂM TRA TỰ ĐỘNG

Tài liệu này định nghĩa logic nghiệp vụ chi tiết, các hàm kiểm tra và mã lỗi (Error Codes) cho script `scripts/validate_skill.py`. Script này hoạt động như một "Gatekeeper" tự động cuối cùng trước khi bàn giao sản phẩm.

## 1. TỔNG QUAN HỆ THỐNG
*   **Target:** Thư mục gốc của gói Agent Skill vừa được xây dựng.  
*   **Input:** Đường dẫn (Path) đến thư mục skill.  
*   **Output:** Báo cáo (Report) in ra console và ghi vào `build-log.md`.  
*   **Exit Codes:**  
    *   `0`: Success (Tất cả kiểm tra đều PASS).  
    *   `1`: Validation Error (Có ít nhất 1 lỗi Critical/Major).

## 2. CÁC MODULE KIỂM TRA (MANDATORY CHECKS)

Script cần triển khai 4 hàm kiểm tra cốt lõi sau:

### 2.1. Module: Check Structural Integrity (`check_structure`)  
*   **Mục tiêu:** Đảm bảo khung xương sống của kỹ năng tồn tại đầy đủ.  
*   **Logic:**  
    1. Quét thư mục gốc của skill.  
    2. Kiểm tra sự tồn tại (File Existence Check) của các thành phần bắt buộc:  
        *   File: `SKILL.md`  
        *   Directory: `knowledge/`  
        *   Directory: `scripts/`  
        *   Directory: `loop/`  
    3. **Pass Condition:** Tìm thấy đủ 4 thành phần trên.  
    4. **Fail Condition:** Thiếu bất kỳ thành phần nào.  
    5. **Error Message:** `[E01] CRITICAL: Missing mandatory zone: {missing_zone}`.

### 2.2. Module: Check Progressive Disclosure (`check_pd_links`)  
*   **Mục tiêu:** Đảm bảo tính liên kết chặt chẽ giữa Tầng 1 (Core) và Tầng 2 (Resources).  
*   **Logic:**  
    1. Đọc nội dung file `SKILL.md` vào bộ nhớ.  
    2. Quét đệ quy các thư mục Tier 2 (`knowledge/`, `scripts/`, `loop/`) để lấy danh sách tất cả các file con (Actual Files).  
    3. Với mỗi file trong danh sách Actual Files:  
        *   Sử dụng Regex để tìm kiếm tên file hoặc đường dẫn tương đối của nó trong nội dung `SKILL.md`.  
        *   Regex Pattern: `r"\[.*\]\(.*{filename}.*\)"` (Tìm kiếm cú pháp Markdown link).  
    4. **Pass Condition:** Tên file hoặc đường dẫn xuất hiện trong `SKILL.md`.  
    5. **Fail Condition:** File tồn tại trong thư mục nhưng không được tham chiếu trong `SKILL.md`.  
    6. **Warning Message:** ` WARNING: Orphan file detected. '{filename}' exists but is not linked in SKILL.md`.

### 2.3. Module: Check File Consistency (`check_file_mapping`)  
*   **Mục tiêu:** Đảm bảo sản phẩm thực tế khớp 100% với bản thiết kế.  
*   **Input:**  
    *   `expected_list`: Danh sách file được parse từ section "Zone Mapping" của `design.md`.  
    *   `actual_list`: Danh sách file thực tế quét được từ ổ đĩa.  
*   **Logic:**  
    1. Thực hiện so sánh tập hợp (Set Comparison).  
    2. Xác định `Missing Files` = `expected_list` - `actual_list`.  
    3. Xác định `Extra Files` = `actual_list` - `expected_list`.  
    4. **Pass Condition:** Cả hai danh sách Missing và Extra đều rỗng.  
    5. **Fail Condition:** `Missing Files` không rỗng.  
    6. **Error Message:** `[E02] ERROR: Deviation from Design. Missing files: {missing_files}`.

### 2.5. Module: Check Placeholder Density (`check_placeholders`)
*   **Mục tiêu:** Kiểm soát mức độ hoàn thiện về nội dung.
*   **Logic:**
    1. Đếm chuỗi `[MISSING_DOMAIN_DATA]` trên toàn bộ gói skill.
    2. Phân loại mức độ:
       - **0 - 4**: PASS (Normal).
       - **5 - 9**: WARNING (Medium - Cần bổ sung tài nguyên).
       - **10+**: FAIL (High - Build thất bại do thiếu dữ liệu trầm trọng).

### 2.6. Module: Error Policy Check (`check_error_handling`)
*   **Mục tiêu:** Đảm bảo Builder đã dừng lại khi có lỗi hệ thống.
*   **Logic:** 
    1. Kiểm tra ghi chú trong `build-log.md`.
    2. Nếu có lỗi hệ thống nhưng Builder vẫn tiếp tục tạo file sau đó -> FAIL.

## 3. CƠ CHẾ BÁO CÁO (REPORTING)

### 3.1. Console Output Template  
Kết quả cần được in ra màn hình theo định dạng bảng dễ đọc:
```text
==================================================  
   AGENT SKILL VALIDATION REPORT  
   Target: {skill_name}  
   Time: {timestamp}  
==================================================  
1. Checking 4 Zones.........  
2. SKILL.md Length......... (340 lines)  
3. [MAPPING] File Consistency.........  
4. Progressive Disclosure... [FAIL]  
   -> Orphan file: loop/extra_check.md  
==================================================  
FINAL STATUS: FAIL (Due to Warnings/Errors)  
See build-log.md for details.
```

### 3.2. Log Integration
* Script phải có chế độ --log để ghi (append) toàn bộ nội dung báo cáo trên vào cuối file loop/build-log.md. Điều này đảm bảo tính truy vết (Traceability) cho bước DELIVER.
