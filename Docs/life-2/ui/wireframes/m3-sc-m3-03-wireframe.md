# Screen: m3/search-results
> module: M3
> spec: Docs/life-2/ui/specs/m3-discovery-ui-spec.md §2.2
> layout: vertical
> width: 375
> height: 800
> state: default

---

## Section: search-header
> composition: immersive-card
> styling: neo-brutalism
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 16

- comp: search-input-global
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.2 — search-input-global]
  text@wclkG: "Tìm kiếm trên Steve Void"
  text@tRNCq: "Nhập từ khóa..."

---

## Section: search-tabs
> composition: horizontal
> styling: minimal
> layout: horizontal
> width: fill_container
> height: 50
> gap: 8
> padding: 8

- comp: tab-all
  ref: GYilx
  width: fit_content
  spec-cite: [spec §2.2 — filter-type]
  text@XQWHb: "Tất cả"

- comp: tab-users
  ref: wWUxj
  width: fit_content
  spec-cite: [spec §2.2 — filter-type]
  text@Njux9: "Người dùng"

- comp: tab-posts
  ref: wWUxj
  width: fit_content
  spec-cite: [spec §2.2 — filter-type]
  text@Njux9: "Bài viết"

---

## Section: result-list
> composition: stacked
> styling: minimal
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 12
> padding: 16

- comp: result-item-1
  ref: ZcXeH
  width: fill_container
  spec-cite: [spec §2.2 — result-list]
  text@3zqwf: "Steve Void"
  text@MPe9u: "@steve_void • Senior Architect"

- comp: result-item-2
  ref: ZcXeH
  width: fill_container
  spec-cite: [spec §2.2 — result-list]
  text@3zqwf: "#AI Architecture"
  text@MPe9u: "2.4k posts tagged"

---

## States

- default: Hiển thị kết quả tìm kiếm theo từ khóa.
- loading: Hiển thị gợi ý nhanh (source: activity m3-a2 §B2)

---

## Notes
- Inference: Sử dụng sc2 (ZcXeH) làm template cho Result Item.
