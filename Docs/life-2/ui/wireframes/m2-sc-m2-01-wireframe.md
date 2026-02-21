# Screen: m2/editor
> module: M2
> spec: Docs/life-2/ui/specs/m2-content-ui-spec.md §2.1
> layout: vertical
> width: 375
> height: fit_content
> state: default

---

## Section: editor-toolbar
> composition: stacked
> styling: minimal
> layout: horizontal
> width: fill_container
> height: 50
> gap: 12
> padding: 8

- comp: btn-bold
  ref: wWUxj
  width: 40
  spec-cite: [spec §2.1 — rich-editor-content]
  text@btnGhostText: "B"

- comp: btn-italic
  ref: wWUxj
  width: 40
  spec-cite: [spec §2.1 — rich-editor-content]
  text@btnGhostText: "I"

---

## Section: content-area
> composition: immersive-card
> styling: neo-brutalism
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 24

- comp: input-post-title
  ref: eOHea
  width: fill_container
  spec-cite: [spec §2.1 — input-post-title]
  text@wclkG: "Tiêu đề bài viết"

- comp: rich-editor-content
  ref: PbbBW
  width: fill_container
  spec-cite: [spec §2.1 — rich-editor-content]
  text@S26FJ: "Nội dung"
  text@NHh8E: "Chia sẻ kiến thức của bạn tại đây..."

- comp: select-visibility
  ref: eOHea
  width: 200
  spec-cite: [spec §2.1 — select-visibility]
  text@wclkG: "Quyền xem"

- comp: btn-publish
  ref: EfsPc
  width: fill_container
  spec-cite: [spec §2.1 — btn-publish]
  text@9Hwh0: "Đăng bài"

---

## States

- default: Giao diện soạn thảo văn bản phong phú.
- loading: Spinner: Đang lưu... (source: activity m2-a1 §B5)
- success: Hiển thị trạng thái "Đã lưu nháp" (source: activity m2-a1 §A10)

---

## Notes
- Inference: Sử dụng Textarea Neo (PbbBW) làm placeholder cho RichTextEditor vì Lib-Component chưa có editor widget chuyên dụng.
