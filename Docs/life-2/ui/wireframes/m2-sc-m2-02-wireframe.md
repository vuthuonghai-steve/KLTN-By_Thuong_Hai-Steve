# Screen: m2/post-detail
> module: M2
> spec: Docs/life-2/ui/specs/m2-content-ui-spec.md §2.2
> layout: vertical
> width: 375
> height: fit_content
> state: default

---

## Section: post-header
> composition: split-screen
> styling: minimal
> layout: horizontal
> width: fill_container
> height: fit_content
> gap: 12
> padding: 16

- comp: display-author
  ref: npWuL
  width: 40
  spec-cite: [spec §2.2 — display-author]

- comp: author-name
  ref: Y0oCp
  width: fit_content
  spec-cite: [spec §2.2 — display-author]
  text@3zqwf: "Steve Void"

---

## Section: content-view
> composition: stacked
> styling: glassmorphism
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 24

- comp: display-content
  ref: ZcXeH
  width: fill_container
  spec-cite: [spec §2.2 — display-content]
  text@3zqwf: "Exploring the depths of AI Architecture..."

- comp: media-gallery
  ref: npWuL
  width: fill_container
  height: 200
  spec-cite: [spec §2.2 — media-gallery]

---

## Section: engagement-bar
> composition: horizontal
> styling: minimal
> layout: horizontal
> width: fill_container
> height: fit_content
> gap: 12
> padding: 16

- comp: btn-like
  ref: VXAL9
  width: fit_content
  spec-cite: [spec §2.2 — btn-like]
  text@M0YwB: "128"

- comp: display-stats
  ref: BCbnD
  width: fit_content
  spec-cite: [spec §2.2 — display-stats]
  text@F2jb7: "12 Comments • 5 Shares"

---

## Section: comment-input-sticky
> composition: sticky
> styling: neo-brutalism
> layout: horizontal
> width: 375
> height: fit_content
> gap: 8
> padding: 16

- comp: comment-input
  ref: R7IjY
  width: fill_container
  spec-cite: [spec §2.2 — comment-input]

---

## States

- default: Hiển thị chi tiết bài viết với tác giả, nội dung và các tương tác.

---

## Notes
- Inference: Sử dụng commentInput (R7IjY) từ Lib-Component.
