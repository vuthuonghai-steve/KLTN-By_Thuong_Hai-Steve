# Screen: m6/notifications
> module: M6
> spec: Docs/life-2/ui/specs/m6-notifications-ui-spec.md §2.1
> layout: vertical
> width: 375
> height: 800
> state: default

---

## Section: header-sticky
> composition: split-screen
> styling: neo-brutalism
> layout: horizontal
> width: fill_container
> height: 60
> gap: 12
> padding: 16

- comp: title-noti
  ref: Y0oCp
  width: fit_content
  spec-cite: [spec §2.1 — sc-m6-01]
  text@3zqwf: "Thông báo"

- comp: btn-read-all
  ref: wWUxj
  width: fit_content
  spec-cite: [spec §2.1 — btn-mark-all-read]
  text@Njux9: "Đã đọc hết"

---

## Section: notification-list
> composition: stacked
> styling: minimal
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 1
> padding: 0

- comp: noti-item-1
  ref: ZcXeH
  width: fill_container
  spec-cite: [spec §2.1 — noti-item]
  text@bGGQg: "Steve Void đã thích bài viết của bạn"
  text@P1FCr: "2 phút trước"

- comp: noti-item-2
  ref: ZcXeH
  width: fill_container
  spec-cite: [spec §2.1 — noti-item]
  text@bGGQg: "Có 5 bình luận mới trong bài viết 'AI Skill'"
  text@P1FCr: "1 giờ trước"

---

## States

- default: Hiển thị danh sách các thông báo realtime và lịch sử.
- active: Thấy thông báo Pop-up xuất hiện (source: activity m6-a1 §A10)

---

## Notes
- Inference: Sử dụng sc2 (ZcXeH) làm template cho Notification Item.
