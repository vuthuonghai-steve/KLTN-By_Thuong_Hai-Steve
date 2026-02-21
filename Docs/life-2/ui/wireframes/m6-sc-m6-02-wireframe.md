# Screen: m6/report-modal
> module: M6
> spec: Docs/life-2/ui/specs/m6-notifications-ui-spec.md §2.2
> layout: vertical
> width: 375
> height: 500
> state: default

---

## Section: report-form
> composition: immersive-card
> styling: neo-brutalism
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 24

- comp: title-report
  ref: Y0oCp
  width: fill_container
  spec-cite: [spec §2.2 — sc-m6-02]
  text@3zqwf: "Báo cáo nội dung"

- comp: select-reason
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.2 — select-reason]
  text@wclkG: "Lý do báo cáo"
  text@tRNCq: "Spam / Quấy rối / Khác..."

- comp: input-description
  ref: PbbBW
  width: fill_container
  spec-cite: [spec §2.2 — input-report-desc]
  text@S26FJ: "Mô tả chi tiết"
  text@NHh8E: "Nhập thêm thông tin để Admin xử lý nhanh hơn..."

- comp: btn-confirm-report
  ref: EfsPc
  width: fill_container
  spec-cite: [spec §2.2 — btn-submit-report]
  text@9Hwh0: "Gửi báo cáo"
  text@FHtBI: "fill: #EF4444"

---

## States

- default: Form báo cáo nội dung vi phạm.
- success: Nhận thông báo: 'Đã tiếp nhận báo cáo' (source: activity m6-a2 §A10)

---

## Notes
- Inference: Sử dụng màu Đỏ (#EF4444) cho nút Báo cáo để nhấn mạnh tính nghiêm trọng.
