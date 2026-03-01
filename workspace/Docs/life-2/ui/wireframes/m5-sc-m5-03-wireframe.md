# Screen: m5/save-modal
> module: M5
> spec: Docs/life-2/ui/specs/m5-bookmarking-ui-spec.md §2.2
> layout: vertical
> width: 375
> height: 400
> state: default

---

## Section: modal-container
> composition: immersive-card
> styling: glassmorphism
> layout: vertical
> width: 340
> height: fit_content
> gap: 20
> padding: 24

- comp: title-save
  ref: Y0oCp
  width: fill_container
  spec-cite: [spec §2.2 — modal-save-post]
  text@3zqwf: "Lưu bài viết"

- comp: select-collection
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.2 — select-collection]
  text@wclkG: "Chọn bộ sưu tập"
  text@tRNCq: "Tất cả bài viết"

- comp: btn-confirm-save
  ref: EfsPc
  width: fill_container
  spec-cite: [spec §2.2 — btn-confirm-save]
  text@9Hwh0: "Lưu ngay"

---

## States

- default: Modal chọn bộ sưu tập để lưu bài viết.
- success: Hiển thị thông báo: 'Đã lưu vào bộ sưu tập' (source: activity m5-a1 §B4)

---

## Notes
- Inference: Sử dụng Input Text Neo (eOHea) làm placeholder cho dropdown Select.
