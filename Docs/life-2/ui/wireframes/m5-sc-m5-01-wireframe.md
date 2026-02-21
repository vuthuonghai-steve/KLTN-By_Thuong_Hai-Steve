# Screen: m5/my-bookmarks
> module: M5
> spec: Docs/life-2/ui/specs/m5-bookmarking-ui-spec.md §2.1
> layout: vertical
> width: 375
> height: 800
> state: default

---

## Section: header-area
> composition: split-screen
> styling: neo-brutalism
> layout: horizontal
> width: fill_container
> height: fit_content
> gap: 12
> padding: 16

- comp: title-bookmarks
  ref: Y0oCp
  width: fit_content
  spec-cite: [spec §2.1 — sc-m5-01]
  text@3zqwf: "Bookmarks"

- comp: btn-create-col
  ref: EfsPc
  width: fit_content
  spec-cite: [spec §2.1 — btn-create-col]
  text@9Hwh0: "Thêm mục"

---

## Section: list-collections
> composition: immersive-card
> styling: minimal
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 16

- comp: col-default
  ref: ZcXeH
  width: fill_container
  spec-cite: [spec §2.1 — card-collection]
  text@bGGQg: "Tất cả bài viết"
  text@P1FCr: "128 saved"

- comp: col-tech
  ref: ZcXeH
  width: fill_container
  spec-cite: [spec §2.1 — card-collection]
  text@bGGQg: "AI & Machine Learning"
  text@P1FCr: "42 saved"

---

## States

- default: Danh sách các bộ sưu tập bài viết đã lưu.

---

## Notes
- Inference: Sử dụng sc1 (Y0oCp) cho tiêu đề và sc2 (ZcXeH) cho các mục collection.
