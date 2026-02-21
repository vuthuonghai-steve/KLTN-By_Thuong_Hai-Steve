# Screen: m1/profile
> module: M1
> spec: Docs/life-2/ui/specs/m1-auth-ui-spec.md §1
> layout: vertical
> width: 375
> height: fit_content
> state: default

---

## Section: profile-header
> composition: stacked
> styling: neo-brutalism
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 16

- comp: profile-avatar
  ref: npWuL
  width: 100
  spec-cite: [spec §1 — sc-m1-05]

- comp: display-name
  ref: Y0oCp
  width: fill_container
  spec-cite: [spec §1 — sc-m1-05]
  text@content: "Steve Void"

- comp: user-bio
  ref: ZcXeH
  width: fill_container
  spec-cite: [spec §1 — sc-m1-05]
  text@content: "Học máy, AI và phát triển phần mềm."

- comp: btn-edit-profile
  ref: GYilx
  width: fit_content
  spec-cite: [spec §1 — sc-m1-05]
  text@label: "Chỉnh sửa hồ sơ"

---

## Section: stats-bar
> composition: horizontal
> styling: minimal
> layout: horizontal
> width: fill_container
> height: fit_content
> gap: 24
> padding: 16

- comp: stat-posts
  ref: BCbnD
  width: fit_content
  spec-cite: [spec §1 — sc-m1-05]
  text@label: "Bài viết"
  text@value: "42"

- comp: stat-followers
  ref: BCbnD
  width: fit_content
  spec-cite: [spec §1 — sc-m1-05]
  text@label: "Người theo dõi"
  text@value: "1.2k"

---

## States

- default: Trang cá nhân hiển thị thông tin user và các thống kê cơ bản.

---

## Notes
- Inference: Sử dụng updBadge (BCbnD) cho stats.
