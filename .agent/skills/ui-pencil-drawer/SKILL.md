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

**Goal**: Parse spec file + activity diagrams → extract screens[], full states[], component mapping. Autonomous.

**Actions**:

1. Read spec file at provided path (e.g., `Docs/life-2/ui/specs/m1-auth-ui-spec.md`)
2. **Read activity diagrams** for the same module (see [`knowledge/project-context.md`](knowledge/project-context.md) §7 for paths):
   - Pattern: `Docs/life-2/diagrams/activity-diagrams/m{N}-a*.md` (read all files for the module)
   - If module is M1 → read `m1-a1-registration.md`, `m1-a2-login.md`, ... etc.
   - If diagrams not found at path → continue with spec only, log "activity diagrams not found" in blueprint notes
3. Extract from **both** sources:
   - `screens[]`: list of screen names with layout direction and width (from spec)
   - `component_map`: spec elements → Lib-Component names (match against Phase 0 component_map)
   - `states[]`: **full states per screen** — merge spec states + activity diagram states:
     - `default` — always included
     - `error` — from activity diagram error branches (e.g., "Hiển thị lỗi Validation", "Email đã tồn tại")
     - `loading` — from activity diagram processing nodes
     - `success` — from activity diagram success/redirect nodes
     - `empty` — from activity diagram "danh sách trống" or equivalent nodes
4. For ambiguous entries: infer from `project_context`. Log inference in blueprint notes. Do NOT escalate.

**State source citation rule**: Every state entry must cite its source:
- `state: error | source: spec §3.2` or `state: error | source: activity m1-a1 B3`

**Self-verify ([loop/checklist.md](loop/checklist.md) §P1)**:
- `screens[]` non-empty? Activity diagrams read? states[] includes error/loading from diagrams? No invented fields?

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

**Goal**: Draw each screen in STi.pen balancing Creative Composition with Semantic Strictness. Self-correcting loop. Autonomous.

**Read before this phase**:
- [`knowledge/animation-tokens.md`](knowledge/animation-tokens.md) — Token dict (fade-up, hover-lift, etc.) + how to set `context.animation` on nodes

**Actions per screen** (repeat for each screen in screens[]):

1. `find_empty_space_on_canvas(width, height, padding: 80, direction: "right")` → get safe position
2. `snapshot_layout()` → confirm no overlap with existing content
3. `batch_design` — draw 1 screen (max 25 ops/call). Use binding pattern for all child references. Split into multiple batches if needed.
   * **Immersive Creativity**: Apply background images `G()`, adjust contrast, and build bold layouts based on the `composition` pattern (e.g., 50/50 split screen, Neo-brutalism cards floating on images).
   * **Tagging Injection (CRITICAL)**: You MUST inject the `spec-cite` reference into the drawn component's `name` or `context` metadata to ensure traceability. Example: `name: "input_email [spec §2.1]"`
4. `get_screenshot(nodeId: screenFrameId)` → visual verify
5. **Reverse Verification**: Use `batch_get` or inspect the output to compare the drawn node tree against the Blueprint. Verify EVERY `spec-cite` from the blueprint is successfully tagged in the logical nodes.
6. Run **[loop/checklist.md](loop/checklist.md) §P3** self-verify

**Pass** (All spec-cites exist + No layout overlapping): auto-proceed to next screen.
**Fail fixable** (Missing tag, hallucinated field, layout break): fix and retry (max 2 retries).
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
| G-Determinism | Dual-Layer Contract Verification | Every semantic field (spec-cite) from Level 1 MUST be injected into the Level 2 visual composition (Tagging Injection). AI must verify presence of all spec-cites after drawing. |
| G-Visual-Freedom | Component Assembly over Rigid Components | If standard Lib-Component doesn't fit the composition, you may build inline (frames with borders/shadows) but must maintain mapping to the Spec via Tagging Injection. |
| G-Spec-Strict | No UI elements without spec citation | Every comp slot in blueprint has `spec-cite: [spec §N.M]`. Extraneous form fields or buttons are forbidden. |
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
