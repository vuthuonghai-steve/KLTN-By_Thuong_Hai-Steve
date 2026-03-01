# Screen: m1/register
> module: M1
> spec: Docs/life-2/ui/specs/m1-auth-ui-spec.md §2.1
> layout: vertical
> width: 375
> height: fit_content
> state: default

---

## Section: form-area
> composition: immersive-card
> styling: neo-brutalism
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 24

- comp: input-email
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.1 — input-email]
  text@field-label: "Email"

- comp: input-username
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.1 — input-username]
  text@field-label: "Username"

- comp: input-password
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.1 — input-password]
  text@field-label: "Password"

- comp: input-confirm-pw
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.1 — input-confirm-pw]
  text@field-label: "Confirm Password"

- comp: btn-register
  ref: EfsPc
  width: fill_container
  spec-cite: [spec §2.1 — btn-register]
  text@label: "Đăng ký"

---

## States

- default: Form đăng ký với các trường email, username, password.
- error: Hiển thị lỗi Validation (source: activity m1-a1 §B3)
- loading: Trạng thái đang xử lý đăng ký (source: activity m1-a1 §C1)
- success: Hiển thị thông báo yêu cầu check email (source: spec §2.1)

---

## Notes
- Inference: Sử dụng Input Text Neo cho cả Email và Password vì Lib-Component chưa có trường password chuyên dụng (sẽ set type="password" trong implementation).
