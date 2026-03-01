# Screen: laptop/register
> module: M1
> spec: Docs/life-2/ui/specs/m1-auth-ui-spec.md §2.1
> layout: split-screen
> width: 1440
> height: 900
> state: default

---

## Section: brand-side
> composition: immersive-card
> styling: neo-brutalism
> layout: vertical
> width: 720
> height: 900
> gap: 32
> padding: 80
> fill: #FFD1DF

- comp: logo
  ref: techBarTitle
  text@Qvico: "STEVE VOID_"
  
- comp: brand-title
  ref: typoTitle
  text@PsaVr: "Kiến tạo cộng đồng tri thức số."

---

## Section: form-side
> composition: stacked
> styling: minimal
> layout: vertical
> width: 720
> height: 900
> gap: 24
> padding: 120
> fill: #FFF5F8

- comp: register-card
  ref: cardFront
  width: 480
  layout: vertical
  padding: 40
  gap: 24
  
- comp: title
  ref: t2
  text@CR0Ne: "Đăng ký thành viên"

- comp: input-email
  ref: eOHea
  width: fill_container
  text@wclkG: "Email"

- comp: input-user
  ref: eOHea
  width: fill_container
  text@wclkG: "Tên đăng nhập"

- comp: input-pass
  ref: eOHea
  width: fill_container
  text@wclkG: "Mật khẩu"

- comp: btn-register
  ref: EfsPc
  width: fill_container
  text@9Hwh0: "Gia nhập ngay"
  fill: #FF8CAF

---

## States
- default: Giao diện đăng ký bản máy tính với bố cục chia đôi.

---

## Notes
- Laptop version sử dụng split-screen layout 50/50.
