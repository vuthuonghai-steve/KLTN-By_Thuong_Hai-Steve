# Wireframe Blueprint Format Standard

> **Usage**: Load in Phase 0 boot. Required before Phase 2 (generate blueprints) and Phase 3 (interpret blueprints for drawing). Defines the DOM Tree format for single-screen wireframe files.
> **Source**: `resources/wireframe-format-draft.md` (100% transform — Parity: 8 sections → 8 sections)

---

## Table of Contents
- [1. Overview](#1-overview)
- [2. DOM Tree Hierarchy — 4 Levels](#2-dom-tree-hierarchy--4-levels)
- [3. Source Citation Format](#3-source-citation-format)
- [4. States](#4-states)
- [5. Strict Zone vs Fluid Zone](#5-strict-zone-vs-fluid-zone)
- [6. Notation Summary Table](#6-notation-summary-table)
- [7. Complete Example — Login Screen (M1)](#7-complete-example--login-screen-m1)
- [8. Blueprint Validation Rules](#8-blueprint-validation-rules)

---

## 1. Overview

A Wireframe Blueprint is a markdown file describing the **DOM structure of 1 screen** as a hierarchical tree. One file = one screen. AI uses this file as a technical drawing spec to execute `batch_design` operations in Phase 3.

**Core Principles**:
- Each DOM Tree node maps **1:1** to one operation in `batch_design`
- Every component must have a `ref` pointing to a real node ID from Lib-Component (obtained in Phase 0 via `batch_get`). Never hardcode or invent IDs.
- Every component must have `spec-cite` tracing back to a specific spec file section
- Never add components not mentioned in the spec file

---

## 2. DOM Tree Hierarchy — 4 Levels

```
Level 0 — Screen Root Frame
  └── Level 1 — Layout Section (partitions screen into functional areas)
        └── Level 2 — Component Slot (instance from Lib-Component)
              └── Level 3 — Text/Override (specific content values)
```

### Level 0 — Screen Root Frame

Outermost frame for the entire screen. Maps to: `I(document, {type: "frame", name: "...", layout: "...", ...})`

```
# Screen: {screen-name}
> module: {M1|M2|M3|M4|M5|M6}
> spec: {spec-file-path} §{section-number}
> layout: vertical | horizontal
> width: 375 | 768 | 1440
> height: fit_content | {number}
> state: default | loading | error | empty
```

### Level 1 — Layout Section

Child frames dividing the screen into functional areas (header, body, footer, sidebar...).
Maps to: `I(screenFrame, {type: "frame", layout: "...", ...})`

```
## Section: {section-name}
> layout: vertical | horizontal
> width: fill_container | {px} | fit_content
> height: fit_content | fill_container
> gap: {number}          (default from layout-rules.yaml if omitted)
> padding: {number}      (or: {top} {right} {bottom} {left})
> background: $--background | $--surface | transparent
```

### Level 2 — Component Slot

Instance of a Lib-Component component. Maps to: `I(sectionFrame, {type: "ref", ref: nodeId, ...})` or `C(nodeId, sectionFrame, {...})`

```
- comp: {human-readable-name}
  ref: {NODE_ID}              # Real ID from Phase 0 component_map — NEVER hardcode or guess
  width: fill_container | {px} | fit_content
  height: fit_content | {px}
  spec-cite: [spec §{N}.{M}]  # MANDATORY — every component slot
  zone: strict | fluid         # strict = Lib only; fluid = creative allowed
  overrides:                   # Descendant property overrides (passed via C() descendants param)
    {child-field-id}: {value}  # Only real field IDs from component structure
```

### Level 3 — Text Override Notation

Override specific text content within a component. Uses special syntax to distinguish from layout properties:

```
  text@{field-id}: "Display content here"
```

**Example**:
```
- comp: primary-button
  ref: BTN_PRIMARY_ID
  width: fill_container
  spec-cite: [spec §2.1]
  zone: strict
  text@label: "Đăng nhập"
```

---

## 3. Source Citation Format

Every component slot **MUST** have `spec-cite`. Missing citation = component treated as hallucination by self-verify.

```
spec-cite: [spec §{section}]
spec-cite: [spec §{section}.{subsection}]
spec-cite: [spec §{section} — {short description}]
```

**Examples**:
```
spec-cite: [spec §3.1 — Login form fields]
spec-cite: [spec §5.2.1]
spec-cite: [spec §7 — Navigation bar]
```

---

## 4. States

Each screen can have multiple states. **Default: draw only `default` state.** Draw additional states only when spec explicitly mentions them.

```
## States
- default: Standard visible state (always draw)
- loading?: Loading/fetching data state (draw only if spec §N mentions it)
- error?: Validation or network error state (draw only if spec §N mentions it)
- empty?: No data / empty collection state (draw only if spec §N mentions it)
```

The `?` suffix = optional/conditional (depends on spec mention).

---

## 5. Strict Zone vs Fluid Zone

```
zone: strict
  → Use case: Forms, Tables, Navigation, Data Cards
  → Rules:
    - 100% components sourced from Lib-Component
    - No invented UI elements beyond spec
    - No layout/color overrides (only text content overrides allowed)
    - Every field in spec must appear; nothing extra

zone: fluid
  → Use case: Hero banners, Empty states, Onboarding, Marketing sections
  → Rules:
    - Free to define Flexbox sizing (gap, padding, width, height)
    - May use G() for AI-generated images
    - May write persuasive copywriting based on project Persona
    - May adjust whitespace for visual breathing room
```

---

## 6. Notation Summary Table

| Symbol | Meaning | Example |
|--------|---------|---------|
| `# Screen:` | Level 0 — screen root frame | `# Screen: m1/login` |
| `## Section:` | Level 1 — layout area | `## Section: form-area` |
| `- comp:` | Level 2 — component instance | `- comp: input-email` |
| `ref:` | Node ID from Lib-Component | `ref: INP_TEXT_001` |
| `text@{id}:` | Level 3 text override | `text@label: "Email"` |
| `spec-cite:` | Mandatory source citation | `spec-cite: [spec §3.1]` |
| `zone:` | strict or fluid | `zone: strict` |
| `overrides:` | Descendant property map | `overrides: {child_id: value}` |
| `?` after state name | Optional state | `error?:` |
| `CAPS_UNDERSCORE` ID | Placeholder — replace with real ID from batch_get | `ref: BTN_PRIMARY_ID` |
| `FEkTl`-style ID | Real Pencil node ID — use directly | `ref: FEkTl` |

**ID Rule**: Uppercase + underscore IDs (e.g., `BTN_PRIMARY_ID`) are placeholders Phase 0 must resolve. Short alphanumeric IDs (e.g., `FEkTl`, `Njux9`) are real Pencil node IDs obtained from `batch_get`.

---

## 7. Complete Example — Login Screen (M1)

```markdown
# Screen: m1/login
> module: M1
> spec: Docs/life-2/ui/specs/m1-auth-ui-spec.md §3
> layout: vertical
> width: 375
> height: fit_content
> state: default

## Section: top-bar
> layout: horizontal
> width: fill_container
> height: 56
> padding: 0 16

- comp: logo-mark
  ref: LOGO_ID
  width: fit_content
  spec-cite: [spec §3.1 — App header logo]
  zone: strict

## Section: hero-area
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 8
> padding: 32 24

- comp: heading-text
  ref: TEXT_H1_ID
  width: fill_container
  spec-cite: [spec §3.2 — Login heading]
  zone: fluid
  text@content: "Chào mừng trở lại"

- comp: subheading-text
  ref: TEXT_BODY_ID
  width: fill_container
  spec-cite: [spec §3.2 — Login subheading]
  zone: fluid
  text@content: "Đăng nhập để tiếp tục chia sẻ kiến thức"

## Section: form-area
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 16
> padding: 0 24

- comp: input-email
  ref: INPUT_TEXT_ID
  width: fill_container
  spec-cite: [spec §3.3 — Email field]
  zone: strict
  text@label: "Email"
  text@placeholder: "ten@example.com"

- comp: input-password
  ref: INPUT_PASSWORD_ID
  width: fill_container
  spec-cite: [spec §3.3 — Password field]
  zone: strict
  text@label: "Mật khẩu"
  text@placeholder: "Nhập mật khẩu"

## Section: cta-area
> layout: vertical
> width: fill_container
> height: fit_content
> gap: 12
> padding: 0 24 32

- comp: button-primary
  ref: BTN_PRIMARY_ID
  width: fill_container
  spec-cite: [spec §3.4 — Login CTA button]
  zone: strict
  text@label: "Đăng nhập"

- comp: link-forgot-password
  ref: LINK_TEXT_ID
  width: fit_content
  spec-cite: [spec §3.4 — Forgot password link]
  zone: strict
  text@label: "Quên mật khẩu?"

## States
- default: Empty form, button enabled, no error messages
- error?: Inline error below invalid field — spec §3.5
- loading?: Button disabled + spinner while submitting — spec §3.4
```

---

## 8. Blueprint Validation Rules

Before using a blueprint in Phase 3, self-verify:

```
□ Every `# Screen:` has: module, spec, layout, width, state?
□ Every `- comp:` has: ref, spec-cite, zone?
□ No `ref:` is empty, "?", or "undefined"?
□ All text overrides use correct `text@{id}:` notation?
□ States section exists with at least `default`?
□ Total components in 1 screen ≤ 20? (if > 20, split into sub-sections)
□ All CAPS_UNDERSCORE IDs resolved to real nodeIds from Phase 0 component_map?
```
