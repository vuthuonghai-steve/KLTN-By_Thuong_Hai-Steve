# Screen: m1/verify-email
> module: M1
> spec: Docs/life-2/ui/specs/m1-auth-ui-spec.md §1
> layout: vertical
> width: 375
> height: 500
> state: default

---

## Section: message-area
> composition: immersive-card
> styling: glassmorphism
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 24
> padding: 32

- comp: icon-email
  ref: VXAL9
  width: 80
  spec-cite: [spec §1 — sc-m1-03]

- comp: title-verify
  ref: Y0oCp
  width: fill_container
  spec-cite: [spec §1 — sc-m1-03]
  text@content: "Xác thực Email"

- comp: desc-verify
  ref: ZcXeH
  width: fill_container
  spec-cite: [spec §1 — sc-m1-03]
  text@content: "Chúng tôi đã gửi một thư xác thực đến email của bạn. Vui lòng kiểm tra hộp thư."

- comp: btn-resend
  ref: A8RvY
  width: fill_container
  spec-cite: [spec §1 — sc-m1-03]
  text@label: "Gửi lại email xác thực"

---

## States

- default: Thông báo yêu cầu xác thực email sau khi đăng ký thành công.
- success: Hiển thị toast thông báo "Đã gửi lại email" (source: activity m1-a1 §SM-03)

---

## Notes
- Inference: Sử dụng card sc1 (Y0oCp) cho tiêu đề và sc2 (ZcXeH) cho mô tả. Icon email lấy từ sc3 (VXAL9).
