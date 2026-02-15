# **MASTER ARCHITECTURE FRAMEWORK (Runtime Version)**

> **Usage**: Dùng làm tiêu chuẩn gốc cho cấu trúc 7 Zones và quy tắc viết SKILL.md. Cần đọc ngay khi boot skill.

---

## 1. MÔ HÌNH 7 ZONES (7 Vùng chức năng)

Mọi bộ kỹ năng (Skill Package) PHẢI được tổ chức theo cấu trúc sau:

1. **Zone 1: Core (Cốt lõi)**  
   - File: `SKILL.md`  
   - Chức năng: Điều phối, persona, workflow, guardrails.
   
2. **Zone 2: Knowledge (Tri thức)**  
   - Thư mục: `knowledge/`  
   - Chức năng: Tài liệu tham chiếu, quy chuẩn, guidelines.
   
3. **Zone 3: Scripts (Kịch bản)**  
   - Thư mục: `scripts/`  
   - Chức năng: Mã thực thi, automation (Python, Bash ).
   
4. **Zone 4: Templates (Biểu mẫu)**  
   - Thư mục: `templates/`  
   - Chức năng: Các mẫu đầu ra chuẩn.
   
5. **Zone 5: Data (Dữ liệu)**  
   - Thư mục: `data/`  
   - Chức năng: Config, static data, schemas.
   
6. **Zone 6: Loop (Vòng lặp)**  
   - Thư mục: `loop/`  
   - Chức năng: Checklist, build-log, test-cases.
   
7. **Zone 7: Assets (Tài sản)**  
   - Thư mục: `assets/`  
   - Chức năng: Hình ảnh, icons, static assets.

---

## 2. QUY TẮC VIẾT SKILL.MD (§9.1)

1. **Thể Mệnh Lệnh (Imperative Form)**:  
   - Dùng "Đọc file X", "Chạy lệnh Y" thay vì "Bạn nên làm X".
2. **Giới hạn Độ dài**:  
   - Không quá 500 dòng.
3. **Progressive Disclosure (§6)**:  
   - SKILL.md (Tier 1) chỉ chứa luồng điều phối.  
   - Chi tiết kỹ thuật đưa vào Knowledge/Scripts (Tier 2) và dẫn link.
4. **Cấu trúc Bắt buộc**:  
   - Frontmatter (name, description)  
   - Mission/Persona  
   - Boot Sequence  
   - Workflow Steps (Phase-driven)  
   - Guardrails  
   - Error Policy

---

## 3. CHỐNG ẢO GIÁC (Anti-Hallucination)

- Không tự bịa domain knowledge.
- Dùng `[MISSING_DOMAIN_DATA]` nếu thiếu resources.
- Luôn báo cáo mật độ Placeholder tại Step VERIFY.
