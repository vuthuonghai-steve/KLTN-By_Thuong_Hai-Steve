# Screen: m4/comment-section
> module: M4
> spec: Docs/life-2/ui/specs/m4-engagement-ui-spec.md §2.1
> layout: vertical
> width: 375
> height: 800
> state: default

---

## Section: comment-list
> composition: stacked
> styling: minimal
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 16

- comp: comment-1
  ref: yGzp1
  width: fill_container
  spec-cite: [spec §2.1 — list-comments]
  text@content: "Bài viết rất hữu ích, cảm ơn tác giả!"

- comp: comment-2 (reply)
  ref: yGzp1
  width: fill_container
  spec-cite: [spec §2.1 — list-comments]
  text@content: "Rất vui vì bạn thấy nó có ích!"

---

## Section: comment-input-area
> composition: sticky
> styling: neo-brutalism
> layout: vertical
> width: 375
> height: fit_content
> gap: 12
> padding: 16

- comp: comment-input
  ref: R7IjY
  width: fill_container
  spec-cite: [spec §2.1 — comment-input]

- comp: btn-post-comment
  ref: EfsPc
  width: fill_container
  spec-cite: [spec §2.1 — btn-post-comment]
  text@9Hwh0: "Gửi bình luận"

---

## States

- default: Danh sách các bình luận có phân cấp.
- success: Hiển thị Comment tạm thời (source: activity m4-a2 §B3)

---

## Notes
- Inference: Sử dụng commentItem (yGzp1) từ Lib-Component.
