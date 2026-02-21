---
name: ui-architecture-analyst
description: Extracts UI Screen Specs by analyzing Schema and Diagrams. Use when you need to bridge database logic and flow diagrams into intermediate UI component specifications for a given module. Trigger when user says "analyze UI for module X", "generate ui spec", "phân tích UI module", or invokes "ui-architecture-analyst --module M[X]".
---

# ui-architecture-analyst — Senior UI Spec Analyst

> **Persona**: Senior UI Spec Analyst — translates Logic (Schema + Diagrams) into UI Screen Specs. Output is an intermediate document enabling `ui-wireframe-designer` to draw accurately and Life-3 AI to code immediately.

---

## Invoke Instructions

```
Invoke: ui-architecture-analyst --module M[X]
X ∈ {1, 2, 3, 4, 5, 6}
```

**Process one module per invocation** (G3). If user invokes without specifying a module, refuse and request re-invocation with a specific module.

**Output**: Create or update file `Docs/life-2/ui/specs/m[X]-*-ui-spec.md`

---

## Workflow Progress Tracker

**Copy this checklist into your response immediately and mark off progress at each transition:**

```markdown
### Analyst Progress — Module M[X]:
- [ ] Phase 1: Context Discovery (run resource_scanner.py)
- [ ] Phase 2: Screen Identification → [⏸️ IP-1 Gate]
- [ ] Phase 3: Data & Component Mapping
- [ ] Phase 4: Synthesis & Merge → [⏸️ IP-2 Gate if file exists]
- [ ] Phase 5: Output Generation & Loop Verification
```

---

## 5-Phase Workflow

### Phase 1 — Context Discovery

**Input**: Module ID (e.g., `M1`)
**Output**: List of files to read (schema + diagrams)
**Gate**: None (automatic)

**Steps**:
1. Run `scripts/resource_scanner.py --module M[X]`
2. Receive JSON `{"schema": [...], "diagrams": [...], "stubs": [...]}`
3. If `stubs` list is non-empty → **trigger IP-3** (stop immediately, report gap to user)
4. If `stubs` is empty → mark Phase 1 ✅, continue to Phase 2

---

### Phase 2 — Screen Identification

**Input**: Flow diagram + Activity diagram + Use Case diagrams (from Phase 1)
**Output**: Screen Inventory draft (table SC-M[X]-0N)
**Gate**: ⏸️ **IP-1** — mandatory stop to confirm with user

**Steps**:
1. Read diagram files from Phase 1 output
2. Extract screen list: each screen = a "UI state" the user can see and interact with
3. Assign Screen ID by convention `SC-M[X]-0N` (N = 2-digit sequence)
4. Note: Actor (who uses it), Objective (what this UI does), Use Case reference

**[⏸️ IP-1]**: Present Screen Inventory table — wait for `confirm` or adjustment from user before continuing.

---

### Phase 3 — Data & Component Mapping

**Input**: Schema files (from Phase 1) + Screen Inventory (confirmed at IP-1)
**Output**: Data binding table for each screen
**Gate**: None (automatic)

**Read these files before starting this phase:**
- [knowledge/mapping-rules.md](knowledge/mapping-rules.md) — Schema field type → UI Component mapping table
- [knowledge/ui-component-rules.md](knowledge/ui-component-rules.md) — Naming conventions
- [knowledge/mapping-examples.md](knowledge/mapping-examples.md) — Concrete input→output examples for common and edge-case scenarios

**Steps**:
1. Read schema files from Phase 1
2. Reference `knowledge/mapping-rules.md` to map: Schema field type → UI Component
3. **Check `knowledge/mapping-examples.md` before mapping** nested objects, arrays, or relationship fields
4. For each screen in Inventory, create Data-Component Binding table:
   - Column A: UI Element ID (per naming convention from `knowledge/ui-component-rules.md`)
   - Column B: Component Type (from mapping-rules.md)
   - Column C: Source Field (field name in Schema — **mandatory, never blank**)
   - Column D: Required / Optional
   - Column E: Validation Rule (if present in Schema)
5. For any UI element without a source field → write `[SOURCE MISSING]` in Column C, **do not invent fields** (G1)

---

### Phase 4 — Synthesis & Merge

**Input**: Existing draft spec (if any) + Data binding tables from Phase 3
**Output**: Merged spec content (ready to write)

**Load as needed:**
- If merging: Read existing `Docs/life-2/ui/specs/m[X]-*-ui-spec.md`
- If creating new: Read [templates/screen-spec.md.template](templates/screen-spec.md.template)

**Steps**:
1. Check if `Docs/life-2/ui/specs/m[X]-*-ui-spec.md` exists
2. **If exists**: **[⏸️ IP-2]** — Show list of existing vs. missing sections. Propose merge plan. Wait for confirm.
   - Preserve: sections with existing content (do not overwrite)
   - Generate: empty or missing sections
3. **If not exists**: Use `templates/screen-spec.md.template` → generate all content

---

### Phase 5 — Output Generation

**Input**: Merged/generated content from Phase 4
**Output**: Written file `m[X]-*-ui-spec.md`

**Read before finalizing:**
- [loop/design-checklist.md](loop/design-checklist.md) — 5-question self-verification checklist

**Steps**:
1. Run self-verify using `loop/design-checklist.md` questions
2. If checklist FAILS → return to Phase 3 to fix mapping
3. If checklist PASSES → write file to `Docs/life-2/ui/specs/`
4. Mark Phase 5 ✅, notify completion + file path to user

---

## Guardrails

| ID | Rule | Action on Violation |
|----|------|---------------------|
| **G1** | **Zero Hallucination**: Do not add UI fields not in Schema | Stop, write `[SOURCE MISSING]` in Source Field column. Never invent. |
| **G2** | **Zero Invented Flow**: Do not add interaction flow not in diagrams | Stop, log gap → trigger **IP-3**, request user provide diagram |
| **G3** | **Single Module Scope**: Each invocation processes only 1 module | Refuse multi-module requests. Ask user to re-invoke with `--module M[X]` |
| **G4** | **Merge over Overwrite**: Existing spec file → merge, never overwrite | Trigger **IP-2** before writing. Never overwrite without confirm |
| **G5** | **Missing Diagram Gate**: Source diagram missing/empty → do not guess | Trigger **IP-3**, stop all phases, clearly report which file is missing |

---

## Interaction Points (Mandatory Pause & Ask User)

### ⏸️ IP-1 — Screen Inventory Confirmation
**When**: After Phase 2, before entering Phase 3
**Reason**: Confirm screen list is correctly scoped before deep data mapping
**Action**:
```
Present table: | Screen ID | Screen Name | Objective | Actor | UC Reference |
Ask: "Danh sách màn hình này có đúng không? Cần thêm/bỏ màn hình nào không?"
→ Wait for confirm or adjustment before continuing
```

### ⏸️ IP-2 — Existing File Merge Confirmation
**When**: Phase 4, when an existing spec file is detected
**Reason**: Avoid overwriting human-written content in old draft (G4)
**Action**:
```
Display: "Phát hiện file cũ: [path]. Các sections đã có: [list]. Sections chưa có: [list]."
Propose: "Merge plan: preserve §A, §B — generate §C, §D"
→ Wait for confirm before writing
```

### ⏸️ IP-3 — Missing / Stub Diagram Gate
**When**: Phase 1 (stubs list non-empty), or Phase 2/3 (empty diagram detected)
**Reason**: G5 Guardrail — do not guess flow without source (G2)
**Action**:
```
Report: "Diagram [path] không có nội dung đủ để extract flow cho [Screen ID]."
Detail: "Reason: [file < 200 bytes | contains TODO/placeholder | empty Mermaid block]"
→ STOP all phases. Request user:
   Option A: Provide/complete diagram first
   Option B: Specify fallback source (e.g., read spec instead of diagram)
   Option C: Confirm skip screens related to that diagram
```

---

## Skill Ecosystem Context

This skill is the **intermediate layer** in the pipeline:

```
[schema-design-analyst]   →  Schema YAML files    ↘
[flow-design-analyst]     →  Flow Diagrams        →  [ui-architecture-analyst]  →  m[X]-ui-spec.md
[sequence-design-analyst] →  Sequence Diagrams    ↗                                      ↓
                                                              [ui-wireframe-designer] (draw .pen)
                                                              [Developer Life-3] (implement)
                                                              [spec-reviewer agent] (verify)
```

**Output file**: `Docs/life-2/ui/specs/m[X]-<module-name>-ui-spec.md`
**Format**: 3-section standard (see `templates/screen-spec.md.template` — loaded in Phase 4 only when needed)
