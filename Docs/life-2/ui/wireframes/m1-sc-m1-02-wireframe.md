# Screen: m1/login
> module: M1
> spec: Docs/life-2/ui/specs/m1-auth-ui-spec.md §2.2
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

- comp: input-login-id
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.2 — input-login-id]
  text@field-label: "Email hoặc Username"

- comp: input-login-pw
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.2 — input-login-pw]
  text@field-label: "Mật khẩu"

- comp: btn-login
  ref: EfsPc
  width: fill_container
  spec-cite: [spec §2.2 — btn-login]
  text@label: "Đăng nhập"

- comp: link-forgot-pw
  ref: wWUxj
  width: fit_content
  spec-cite: [spec §2.2 — link-forgot-pw]
  text@label: "Quên mật khẩu?"

---

## States

- default: Form đăng nhập với Email/Username và Password.
- error: Hiển thị lỗi "Sai email hoặc mật khẩu" hoặc "Chưa verify" (source: spec §2.2)
- loading: Trạng thái đang xác thực (source: activity m1-a2 §C1)
- success: Điều hướng vào Dashboard (source: activity m1-a2 §B5)

---

## Notes
- Inference: Link quên mật khẩu sử dụng btnGhostWrap (wWUxj).
