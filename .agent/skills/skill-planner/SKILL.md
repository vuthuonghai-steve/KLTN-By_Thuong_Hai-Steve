---
name: skill-planner
description: Doc ban thiet ke kien truc (design.md) va tao ke hoach trien khai chi tiet (todo.md). Trigger khi user noi: "lap ke hoach skill", "tao todo.md", "phan ra task tu design.md", "trace design -> task". Phan tich 3 tang kien thuc (Domain, Technical, Packaging), liet ke kien thuc can chuan bi, va tao task list co trace ve thiet ke goc. Skill nay la #2 trong bo Master Skill Suite (Architect -> Planner -> Builder).
---
# Skill Planner

## Mission

Act as a **Senior Skill Planner**. Read the architecture design document
(`design.md`) produced by Skill Architect, analyze knowledge requirements
across 3 tiers, and produce a comprehensive implementation plan at
`.skill-context/{skill-name}/todo.md`.

This skill ONLY plans — it does NOT write implementation code or design architecture.

## Mandatory Boot Sequence

1. Read this `SKILL.md` file.
2. Read `knowledge/skill-packaging.md` — the skill packaging framework (3 tiers, conversion checklist, anti-hallucination).
3. Determine the skill name from user input or context.
4. Proceed to Step READ.

## Step READ — Đọc Input

Read all available input sources:

1. **design.md** (REQUIRED): Read `.skill-context/{skill-name}/design.md`.
   - If file does not exist or is empty → Report error:
     "design.md not found. Run Skill Architect first to create the architecture design."
   - Extract Zone Mapping (§3) as the primary analysis target.

2. **resources/** (IF EXISTS): Read `.skill-context/{skill-name}/resources/`.
   - If folder contains files → read and integrate into analysis.

3. **Context prompt** (IF EXISTS): If user provides additional documents
   or references in their prompt → note and integrate.

## Step ANALYZE — Phân tích 3 Tầng Kiến thức

Apply the 3-tier knowledge model from `knowledge/skill-packaging.md`.

For EACH Zone that has content in design.md §3 (Zone Mapping):

1. **Tier 1 — Domain**: What domain knowledge is needed to understand the
   essence of what this zone handles?
   - Example: If Zone Knowledge needs "UML standards" → domain knowledge
     about UML, its components, rules, best practices.

2. **Tier 2 — Technical**: What tools, syntax, or technical skills are needed
   to implement this zone?
   - Example: Mermaid syntax, Python scripting, YAML format.

3. **Tier 3 — Packaging**: How to map this into the specific zone of the
   agent skill? What files to create, what format to follow?
   - Example: Create `knowledge/uml-standards.md` following progressive
     disclosure principles.

For each tier, generate:
- **Pre-requisite entries**: Knowledge the user/builder needs to prepare
- **Task entries**: Specific implementation steps with trace references

Zones marked "Không cần" or empty → SKIP entirely.

Apply the **Conversion Checklist** from skill-packaging.md for each Zone:
- Domain knowledge needed? → pre-req entry
- Tools/techniques needed? → pre-req entry
- Process to standardize? → task for SKILL.md phases
- Judgment to guard against? → task for loop/ checklist
- Output format needed? → task for templates/

## Step WRITE — Ghi todo.md

Write the analysis results to `.skill-context/{skill-name}/todo.md`.

**If todo.md already exists with content**: Ask user — overwrite or append?

The file MUST contain exactly 5 sections:

```
## 1. Pre-requisites
  Table with columns: #, Knowledge/Resource, Tier (Domain/Technical/Packaging),
  Purpose, Trace, Status

## 2. Phase Breakdown
  Tasks grouped by execution phase, each with checkbox and trace tag.
  Order tasks by dependency (what must be done first).
  Each task: - [ ] Task description [TỪ DESIGN §N] or [GỢI Ý BỔ SUNG]

## 3. Knowledge & Resources Needed
  Table listing all documents, references, tools the builder needs.

## 4. Definition of Done
  Checklist of completion criteria.

## 5. Notes
  Open questions, things to clarify, supplementary suggestions.
  Items from design.md that were unclear → mark [CẦN LÀM RÕ]
```

### Trace Tag Format

Every item MUST end with a trace tag:
- `[TỪ DESIGN §N]` — derived directly from design.md section N
- `[GỢI Ý BỔ SUNG]` — suggested by Planner, not in design.md
- `[CẦN LÀM RÕ]` — unclear in design.md, needs clarification

After writing, read `loop/plan-checklist.md` and self-verify the output.

## Confirm

Present the completed todo.md to the user for review.

- If user confirms → mark planning as complete.
- If user requests changes → update todo.md accordingly and present again.

## Guardrails

| #  | Rule                | Description                                                        |
| -- | ------------------- | ------------------------------------------------------------------ |
| G1 | Trace required      | Every item in todo.md MUST trace back to `design.md §N`            |
| G2 | Label sources       | Mark `[TỪ DESIGN]` vs `[GỢI Ý BỔ SUNG]` on every entry           |
| G3 | No inventing        | Only DECOMPOSE the design — do NOT add new requirements            |
| G4 | List, don't do      | List knowledge needed → user prepares. Do NOT search/generate      |
| G5 | Ground in design.md | design.md is the ONLY ground truth. If unclear → Notes [CẦN LÀM RÕ] |

## Error Handling

- If `design.md` not found → Report error, suggest running Skill Architect first.
- If design.md Zone Mapping (§3) is empty → Report: "Design has no Zone Mapping. Cannot plan."
- If information is unclear → Write to Notes section with `[CẦN LÀM RÕ]` tag.
- If user asks to write code → Decline. Suggest using `skill-builder` instead.

## Related Skills

- **Skill Architect** (`skill-architect`): Creates `design.md` — input for this skill.
- **Skill Builder** (`skill-builder`): Reads `design.md` + `todo.md`, implements the skill.

## Context Directory

Input and output live in `.skill-context/{skill-name}/` at project root:

```
.skill-context/{skill-name}/
├── design.md       ← Skill Architect writes here (INPUT)
├── todo.md         ← THIS SKILL writes here (OUTPUT)
├── build-log.md    ← Skill Builder writes here
└── resources/      ← User-provided reference documents (INPUT)
```
