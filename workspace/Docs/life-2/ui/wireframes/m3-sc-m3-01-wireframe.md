# Screen: m3/home-feed
> module: M3
> spec: Docs/life-2/ui/specs/m3-discovery-ui-spec.md §2.1
> layout: vertical
> width: 375
> height: 800
> state: default

---

## Section: top-navigation
> composition: horizontal
> styling: minimal
> layout: horizontal
> width: 375
> height: 60
> gap: 0
> padding: 0

- comp: tab-for-you
  ref: wWUxj
  width: 187
  spec-cite: [spec §2.1 — tab-switch-feed]
  text@Njux9: "Dành cho bạn"

- comp: tab-following
  ref: wWUxj
  width: 187
  spec-cite: [spec §2.1 — tab-switch-feed]
  text@Njux9: "Đang theo dõi"

---

## Section: feed-container
> composition: stacked
> styling: minimal
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 16

- comp: post-card-1
  ref: cardFront
  width: fill_container
  spec-cite: [spec §2.1 — post-card]

- comp: post-card-2
  ref: cardFront
  width: fill_container
  spec-cite: [spec §2.1 — post-card]

---

## States

- default: Dòng thời gian hiển thị các bài viết mới nhất và phù hợp.
- loading: Skeleton Loading trong khi tải dữ liệu (source: activity m3-a1 §B2)

---

## Notes
- Inference: Sử dụng cardFront (8UVAG) làm container cho Post Preview.
