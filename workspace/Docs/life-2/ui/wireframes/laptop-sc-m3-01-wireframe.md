# Screen: laptop/home-feed
> module: M3
> spec: Docs/life-2/ui/specs/m3-discovery-ui-spec.md §2.1
> layout: sidebar-layout
> width: 1440
> height: 900
> state: default

---

## Section: sidebar-left
> composition: stacked
> styling: neo-brutalism
> layout: vertical
> width: 280
> height: 900
> gap: 16
> padding: 32
> fill: #FFFFFF

- comp: logo
  ref: t3
  text@MMvvb: "STEVE VOID"

- comp: nav-home
  ref: wWUxj
  text@Njux9: "🏠 Trang chủ"
  fill: #FFD1DF

- comp: nav-explore
  ref: wWUxj
  text@Njux9: "🔍 Khám phá"

- comp: nav-notif
  ref: wWUxj
  text@Njux9: "🔔 Thông báo"

- comp: btn-create
  ref: EfsPc
  width: fill_container
  text@9Hwh0: "Đăng bài mới"
  fill: #FF8CAF

---

## Section: main-feed
> composition: stacked
> styling: minimal
> layout: vertical
> width: 700
> height: 900
> gap: 24
> padding: 40
> fill: #FFF5F8

- comp: feed-tabs
  ref: techBarSection
  layout: horizontal
  gap: 32
  
- comp: post-1
  ref: cardFront
  width: fill_container
  
- comp: post-2
  ref: cardFront
  width: fill_container

---

## Section: right-rail
> composition: stacked
> styling: minimal
> layout: vertical
> width: 460
> height: 900
> gap: 24
> padding: 40
> fill: #FFF5F8

- comp: search-box
  ref: eOHea
  width: fill_container
  text@wclkG: "Tìm kiếm bài viết..."

- comp: trending-card
  ref: ZF1KR
  width: fill_container
  text@Gljni: "Trending Tags"

---

## States
- default: Trang chủ Dashboard Laptop với Sidebar.

---

## Notes
- Sidebar layout cố định, main content cuộn vô hạn.
