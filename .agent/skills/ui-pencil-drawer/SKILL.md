---
name: drawing-ui-screens
description: Automates end-to-end drawing of UI screens in Pencil canvas from module spec files. Reads spec file → generates wireframe blueprint → draws each screen using Pencil MCP tools. Triggers when user provides a UI spec path and asks to draw, generate, or auto-build screens for Steve Void modules M1–M6 in STi.pen.
---

# UI Pencil Drawer — Autonomous UI Design Agent

Persona: Senior Autonomous UI Design Agent. Execute spec-to-canvas drawing end-to-end without human approval between phases. Escalate only when genuinely blocked (pen file not found, or missing component with no fallback). Never ask for phase confirmations.

**Human input required**: spec file path + `.pen` file path (or open file). Everything else is autonomous.

---

## Workflow Progress Tracker

Copy this into your response at start and mark off progress:

```
### ui-pencil-drawer Progress:
- [ ] Phase 0: Context Boot (read project + scan Lib-Component)
- [ ] Phase 1: Spec Analyzer (extract screens[])
- [ ] Phase 2: Wireframe Blueprint (generate DOM Tree)
- [ ] Phase 3: Pencil Drawer (draw all screens)
- [ ] Done: Summary report
```

---

## Boot Sequence

1. Read this `SKILL.md` (self — auto-loaded).
2. Read [`knowledge/project-context.md`](knowledge/project-context.md) — understand project scope, module map, and design aesthetic before anything else.

---

## Phase 0: Context Boot

**Goal**: Build `project_context` object. Auto-proceed when complete.

**Actions (execute in order)**:

1. Call `get_editor_state(include_schema: false)` — verify STi.pen is open, capture `reusable` components list
2. Read `CLAUDE.md` → extract: module scope, naming conventions, design aesthetic
3. Read `check.list.md` → confirm current Life-2 phase and active modules
4. Call `batch_get` with `{patterns: [{reusable: true}], readDepth: 3}` → build `component_map: {name → nodeId}`
5. If Lib-Component frame exists as named frame: `batch_get({patterns: [{name: "Lib-Component"}]}, readDepth: 3)`
   See [`scripts/scan_lib_components.py`](scripts/scan_lib_components.py) for component_map processing logic and fuzzy matching.

**Read before this phase**:
- [`knowledge/pencil-tools-ref.md`](knowledge/pencil-tools-ref.md) — Pencil MCP tool syntax (needed for all subsequent phases)
- [`knowledge/wireframe-format.md`](knowledge/wireframe-format.md) — blueprint format standard (needed for Phase 2)

**Self-verify ([loop/checklist.md](loop/checklist.md) §P0)**:
- `get_editor_state` returned valid file? `component_map` has ≥ 1 entry? Project scope confirmed?

**Auto-proceed** → Phase 1. Escalate only if: pen file cannot be found via `get_editor_state` AND no pen file path was provided.

---

## Phase 1: Spec Analyzer

**Goal**: Parse spec file → extract screens[], states, component mapping. Autonomous.

**Actions**:

1. Read spec file at provided path (e.g., `Docs/life-2/ui/specs/m1-auth-ui-spec.md`)
2. Extract:
   - `screens[]`: list of screen names with their layout direction and width
   - `component_map`: spec elements → Lib-Component names (match against Phase 0 component_map)
   - `states[]`: per screen — which states to draw (default always; others only if spec mentions)
3. For ambiguous spec entries: infer from `project_context` (module patterns, design aesthetic). Log inference in blueprint notes. Do NOT escalate.

**Self-verify ([loop/checklist.md](loop/checklist.md) §P1)**:
- `screens[]` non-empty? Every component has spec citation? No invented fields?

**Auto-proceed** → Phase 2. Escalate only if: spec file does not exist at path.

---

## Phase 2: Wireframe Blueprint

**Goal**: Generate DOM Tree blueprint per screen. Save. Autonomous.

**Read before this phase**:
- [`templates/wireframe.md.template`](templates/wireframe.md.template) — use as base for each screen
- [`data/layout-rules.yaml`](data/layout-rules.yaml) — default spacing values

**Actions**:

1. For each screen in `screens[]`:
   - Instantiate `wireframe.md.template`
   - Fill: Level 0 (screen header), Level 1 (layout sections from spec), Level 2 (component slots with `ref` from component_map, `spec-cite`, `zone`)
   - Every `ref:` MUST use real nodeId from Phase 0 `component_map`. If component not found → `ref: MISSING_{NAME}` and mark `zone: blocked`
   - Apply `data/layout-rules.yaml` for gap/padding defaults
2. Save to `Docs/life-2/ui/wireframes/{module}-{screen}-wireframe.md`

**Self-verify ([loop/checklist.md](loop/checklist.md) §P2)**:
- Blueprint for every screen? Every comp slot has `spec-cite`? No `ref: undefined`? No `ref: ?`?

**Auto-proceed** → Phase 3. If `zone: blocked` entries exist → continue drawing, skip blocked slots, note in summary.

---

## Phase 3: Pencil Drawer

**Goal**: Draw each screen in STi.pen. Self-correcting loop. Autonomous.

**Read before this phase** (if screen has Fluid Zones or animated components):
- [`knowledge/animation-tokens.md`](knowledge/animation-tokens.md) — Token dict (fade-up, hover-lift, etc.) + how to set `context.animation` on nodes

**Actions per screen** (repeat for each screen in screens[]):

1. `find_empty_space_on_canvas(width, height, padding: 80, direction: "right")` → get safe position
2. `snapshot_layout()` → confirm no overlap with existing content
3. `batch_design` — draw 1 screen (max 25 ops/call). Use binding pattern for all child references. For large screens (>25 ops), split into multiple batches: frame structure → sections → content.
4. `get_screenshot(nodeId: screenFrameId)` → visual verify
5. Run **[loop/checklist.md](loop/checklist.md) §P3** self-verify

**Pass** (≥ 6/7 checks green): auto-proceed to next screen.
**Fail fixable** (overlap, wrong node, layout break): fix and retry (max 2 retries).
**Fail blocked** (component missing, no fallback found in component_map): → ESCALATE.

**Escalation format** (only when blocked):
```
⚠️ [BLOCKED] Screen: {name}
Component "{component-name}" not found in Lib-Component.
component_map keys available: [list]
Options: (a) skip slot, (b) draw as primitive frame placeholder, (c) add component to Lib-Component then continue
```

**After all screens drawn**:
Output summary report:
```
✅ Done — {N} screens drawn, {M} skipped (blocked), {K} warnings
Screens: [list with frame IDs]
Wireframes saved: Docs/life-2/ui/wireframes/
```

---

## Guardrails

| ID | Rule | Enforcement |
|----|------|------------|
| G-Lib-Strict | 100% components must be `ref` type from Lib-Component | Never use raw rectangle/text if Lib has equivalent. All `ref:` from Phase 0 component_map. |
| G-Spec-Strict | No UI elements without spec citation | Every comp slot in blueprint has `spec-cite: [spec §N.M]`. Fail if missing. |
| G-Canvas-Space | Mandatory space check before every draw | Call `find_empty_space_on_canvas` + `snapshot_layout` before each `batch_design`. |
| G-One-Screen-Per-Call | Max 1 screen logical unit per `batch_design` | Split large screens into structure/content batches but keep within 25-op limit. |
| G-Fail-Fast | Fail 2 consecutive screens → escalate | Track consecutive failures. If 2 in a row fail all retries → escalate instead of continuing. |

---

## Trigger Flags

User may include these in their prompt to adjust behavior:

| Flag | Effect |
|------|--------|
| `--use-lib [nodeId]` | Force use of only this specific Lib-Component node |
| `--wireframe` | Draw placeholder frames only (no real content/images) |
| `--strict-layout` | Call `snapshot_layout` after every `batch_design` call (not just on fail) |
| `--component-mode` | Design mode: set `reusable: true` on drawn nodes, prompt for `context` field |
| `--creative` | Enable Fluid Zone max freedom + `G()` AI images for empty/hero areas |
