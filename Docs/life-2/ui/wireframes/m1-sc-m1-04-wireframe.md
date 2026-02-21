# Screen: m1/onboarding
> module: M1
> spec: Docs/life-2/ui/specs/m1-auth-ui-spec.md §2.3
> layout: vertical
> width: 375
> height: fit_content
> state: default

---

## Section: onboarding-form
> composition: stacked
> styling: neo-brutalism
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 24
> padding: 24

- comp: upload-avatar
  ref: npWuL
  width: fill_container
  spec-cite: [spec §2.3 — upload-avatar]
  text@label: "Tải lên ảnh đại diện"

- comp: input-display-name
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.3 — input-display-name]
  text@field-label: "Tên hiển thị"

- comp: textarea-bio
  ref: PbbBW
  width: fill_container
  spec-cite: [spec §2.3 — textarea-bio]
  text@field-label: "Giới thiệu bản thân"

- comp: btn-submit-setup
  ref: EfsPc
  width: fill_container
  spec-cite: [spec §2.3 — btn-submit-setup]
  text@label: "Hoàn tất thiết lập"

---

## States

- default: Form cập nhật thông tin ban đầu sau khi đăng ký.
- loading: Đang lưu thông tin hồ sơ (source: activity m1-a5 §C4)
- success: Redirect to Home Feed (source: activity m1-a5 §B5)

---

## Notes
- Inference: Sử dụng Image Upload Neo cho Avatar và Textarea Neo cho Bio.
