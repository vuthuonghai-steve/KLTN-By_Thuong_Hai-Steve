# Wireframe Blueprint Format — DOM Tree Standard

> Resource for: `knowledge/wireframe-format.md` + `templates/wireframe.md.template`
> Author: Skill Planner (Phase 0 preparation)
> Date: 2026-02-21

---

## 1. Tổng quan

Wireframe Blueprint là file markdown mô tả cấu trúc DOM của **1 màn hình** theo dạng cây phân cấp (DOM Tree). Mỗi file blueprint = 1 màn hình. AI dùng file này như bản vẽ kỹ thuật để thực thi lệnh `batch_design` trong Phase 3.

**Nguyên tắc cốt lõi:**
- Mỗi node trong DOM Tree ánh xạ **1:1** với 1 operation trong `batch_design`
- Mọi component phải có `ref` dẫn về node ID thực trong Lib-Component (không được hardcode hay bịa)
- Mọi component phải có `spec-cite` trỏ về section cụ thể trong spec file
- Không được thêm component nếu spec không đề cập

---

## 2. Phân Cấp DOM Tree (4 Levels)

```
Level 0 — Screen Root Frame
  └── Level 1 — Layout Section (chia vùng ngang/dọc)
        └── Level 2 — Component Slot (instance từ Lib-Component)
              └── Level 3 — Text/Override (giá trị nội dung cụ thể)
```

### Level 0 — Screen Root Frame

Là frame bao ngoài cùng của toàn màn hình. Tương ứng với 1 lệnh `I(document, {...})` tạo frame màn hình mới.

**Ký pháp:**
```
# Screen: {screen-name}
> module: {M1|M2|M3|M4|M5|M6}
> spec: {spec-file-path} §{section-number}
> layout: vertical | horizontal
> width: 375 | 768 | 1440
> height: fit_content | {số cụ thể}
> state: default | loading | error | empty
```

### Level 1 — Layout Section

Là frame con chia màn hình thành các vùng chức năng (header, body, footer, sidebar...). Tương ứng với lệnh `I(screenFrame, {type: "frame", layout: ...})`.

**Ký pháp:**
```
## Section: {section-name}
> layout: vertical | horizontal
> width: fill_container | {px} | fit_content
> height: fit_content | fill_container
> gap: {số} | (default từ layout-rules.yaml)
> padding: {số} | {top right bottom left}
> background: $--background | $--surface | transparent
```

### Level 2 — Component Slot

Là instance của component từ Lib-Component. Tương ứng với lệnh `C(nodeId, sectionFrame, {...})` hoặc `I(sectionFrame, {type: "ref", ref: nodeId, ...})`.

**Ký pháp:**
```
- comp: {human-readable-name}
  ref: {NODE_ID}          # ID thực từ Lib-Component — LẤY TỪ batch_get, KHÔNG hardcode
  width: fill_container | {px} | fit_content
  height: fit_content | {px}
  spec-cite: [spec §{N}.{M}]    # Trích dẫn bắt buộc
  zone: strict | fluid           # strict = lấy từ Lib, fluid = cho phép override sáng tạo
  overrides:                     # Override descendants (dùng trong C() với descendants param)
    {child-field-id}: {value}    # Chỉ override field thực tế có trong component
```

### Level 3 — Text Override Notation

Override nội dung text cụ thể trong component. Dùng cú pháp đặc biệt để phân biệt với thuộc tính layout.

**Ký pháp:**
```
  text@{field-id}: "Nội dung hiển thị"
```

**Ví dụ:**
```
- comp: primary-button
  ref: BTN_PRIMARY_ID
  width: fill_container
  spec-cite: [spec §2.1]
  zone: strict
  text@label: "Đăng nhập"
  text@sublabel: ""
```

---

## 3. Source Citation Format

Mỗi component slot **BẮT BUỘC** có `spec-cite`. Không có spec-cite = component bị coi là hallucination.

**Format:**
```
spec-cite: [spec §{section}]           # Reference đến section trong spec file
spec-cite: [spec §{section}.{sub}]    # Reference đến subsection
spec-cite: [spec §{section} — {mô tả ngắn}]   # Kèm mô tả để dễ trace
```

**Ví dụ:**
```
spec-cite: [spec §3.1 — Login form fields]
spec-cite: [spec §5.2.1]
spec-cite: [spec §7 — Navigation bar]
```

---

## 4. States

Mỗi màn hình có thể có nhiều states. **Mặc định chỉ vẽ `default` state.** Chỉ vẽ thêm states khác khi spec đề cập.

```
## States
- default: Trạng thái hiển thị thông thường (luôn vẽ)
- loading?: Đang tải dữ liệu (chỉ vẽ nếu spec §N nêu)
- error?: Có lỗi validation/network (chỉ vẽ nếu spec §N nêu)
- empty?: Không có dữ liệu (chỉ vẽ nếu spec §N nêu)
```

Dấu `?` sau state name = optional (phụ thuộc spec).

---

## 5. Strict Zone vs Fluid Zone

```
zone: strict   # Forms, Tables, Navigation, Data Cards
               # → 100% component từ Lib-Component
               # → Không tự thêm element ngoài spec
               # → Không override layout/color ngoài text content

zone: fluid    # Hero banners, Empty states, Onboarding, Marketing sections
               # → Được tự do define Flexbox sizing
               # → Được dùng G() cho AI images
               # → Được viết copywriting thuyết phục theo Persona
               # → Được override gap/padding theo thẩm mỹ
```

---

## 6. Ký Hiệu Tổng Hợp

| Ký hiệu | Nghĩa | Ví dụ |
|---------|-------|-------|
| `# Screen:` | Level 0 — screen root | `# Screen: login` |
| `## Section:` | Level 1 — layout area | `## Section: form-area` |
| `- comp:` | Level 2 — component instance | `- comp: input-field` |
| `ref:` | Node ID từ Lib-Component | `ref: INP_001` |
| `text@{id}:` | Text override | `text@label: "Email"` |
| `spec-cite:` | Trích dẫn bắt buộc | `spec-cite: [spec §3.1]` |
| `zone:` | Strict / Fluid | `zone: strict` |
| `overrides:` | Descendant overrides | `overrides: {child_id: value}` |
| `?` sau state | State optional | `error?: ...` |
| `NODE_ID` viết hoa | Placeholder — chưa có real ID | `ref: BTN_PRIMARY_ID` |

**Quy tắc về `ref`:**
- ID viết hoa + gạch dưới (vd: `BTN_PRIMARY_ID`) = placeholder, Builder phải replace bằng ID thực từ `batch_get`
- ID ngắn gồm chữ và số (vd: `FEkTl`, `Njux9`) = real Pencil node ID, dùng ngay được

---

## 7. Ví Dụ Hoàn Chỉnh — Màn Hình Login (M1)

```markdown
# Screen: m1/login
> module: M1
> spec: Docs/life-2/ui/specs/m1-auth-ui-spec.md §3
> layout: vertical
> width: 375
> height: fit_content
> state: default

## Section: top-bar
> layout: horizontal
> width: fill_container
> height: 56
> padding: 0 16

- comp: logo-mark
  ref: LOGO_ID
  width: fit_content
  spec-cite: [spec §3.1 — App header logo]
  zone: strict

## Section: hero-area
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 8
> padding: 32 24

- comp: heading-text
  ref: TEXT_H1_ID
  width: fill_container
  spec-cite: [spec §3.2 — Login heading]
  zone: fluid
  text@content: "Chào mừng trở lại"

- comp: subheading-text
  ref: TEXT_BODY_ID
  width: fill_container
  spec-cite: [spec §3.2 — Login subheading]
  zone: fluid
  text@content: "Đăng nhập để tiếp tục chia sẻ kiến thức"

## Section: form-area
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 0 24

- comp: input-email
  ref: INPUT_TEXT_ID
  width: fill_container
  spec-cite: [spec §3.3 — Email field]
  zone: strict
  text@label: "Email"
  text@placeholder: "ten@example.com"

- comp: input-password
  ref: INPUT_PASSWORD_ID
  width: fill_container
  spec-cite: [spec §3.3 — Password field]
  zone: strict
  text@label: "Mật khẩu"
  text@placeholder: "Nhập mật khẩu"

## Section: cta-area
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 12
> padding: 0 24 32

- comp: button-primary
  ref: BTN_PRIMARY_ID
  width: fill_container
  spec-cite: [spec §3.4 — Login CTA button]
  zone: strict
  text@label: "Đăng nhập"

- comp: link-forgot-password
  ref: LINK_TEXT_ID
  width: fit_content
  spec-cite: [spec §3.4 — Forgot password link]
  zone: strict
  text@label: "Quên mật khẩu?"

## States
- default: Form trống, button enabled, không có error message
- error?: Hiển thị inline error dưới field bị sai — spec §3.5
- loading?: Button disable + spinner khi đang submit — spec §3.4
```

---

## 8. Quy Tắc Validation (AI self-check trước khi dùng blueprint)

Trước khi đưa blueprint vào Phase 3, AI phải tự kiểm tra:

```
□ Mỗi `# Screen:` có đủ: module, spec, layout, width, state?
□ Mỗi `- comp:` có đủ: ref, spec-cite, zone?
□ Không có `ref:` nào bị bỏ trống hoặc là "?"?
□ Mọi text override dùng ký pháp `text@{id}:` đúng format?
□ States section tồn tại và có ít nhất `default`?
□ Tổng số components trong 1 screen ≤ 20 (nếu > 20, cần chia section nhỏ hơn)?
```
