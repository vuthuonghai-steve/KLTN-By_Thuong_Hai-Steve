# Screen: m4/engagement-buttons
> module: M4
> spec: Docs/life-2/ui/specs/m4-engagement-ui-spec.md §2.2
> layout: horizontal
> width: 375
> height: 60
> state: default

---

## Section: engagement-bar
> composition: horizontal
> styling: minimal
> layout: horizontal
> width: fill_container
> height: 50
> gap: 24
> padding: 12

- comp: btn-like-toggle
  ref: VXAL9
  width: fit_content
  spec-cite: [spec §2.2 — btn-like-toggle]
  text@MPe9u: "LIKE"
  text@3zqwf: "128"

- comp: btn-repost
  ref: ZcXeH
  width: fit_content
  spec-cite: [spec §2.2 — btn-repost]
  text@MPe9u: "REPOST"
  text@bGGQg: "15"

---

## States

- default: Thanh tương tác với Like (Hồng) và Repost (Xanh lá).
- success: Cập nhật UI nút bấm tức thì (source: activity m4-a1 §B3)

---

## Notes
- Inference: Sử dụng sc3 (VXAL9) cho Like và sc2 (ZcXeH) cho Repost để tận dụng màu sắc (Purple/Yellow) và tinh chỉnh sang Hồng/Xanh.
