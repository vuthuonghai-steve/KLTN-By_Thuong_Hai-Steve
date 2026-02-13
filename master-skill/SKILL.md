---
name: master-skill
description: Orchestrate end-to-end Agent Skill delivery as a standalone workflow with natural-language intent routing, optional /ss commands, session tracking, and deterministic verification.
---

# Master Skill

## Mission
Convert user intent into a complete standalone skill package with traceable lifecycle artifacts:
`IDEA -> DESIGN.md -> TASK.md -> IMPLEMENTATION -> VERIFY_REPORT.md -> ARCHIVE`.

## Mandatory Boot Sequence
1. Read `knowledge/architect.md`.
2. Read `knowledge/standards.md`.
3. Read `loop/roadmap.md`.
4. Resolve intent using natural language first, then optional `/ss:*` command hints.
5. Refuse ambiguous session context and ask at most three short clarifying questions.

## Standalone Intent Router
- Natural language intent (primary):
  - Explore intent -> `explore`
  - Plan artifacts -> `ff` or `continue`
  - Execute tasks -> `apply`
  - Validate coherence -> `verify`
  - Finalize lifecycle -> `archive`
- Optional command triggers (secondary):
  - `/ss:explore`: Discover scope and constraints. Do not implement code.
  - `/ss:new-session`: Start a new standalone session context.
  - `/ss:ff`: Generate artifacts quickly until apply-ready.
  - `/ss:continue`: Create exactly one missing artifact per turn.
  - `/ss:apply`: Execute tasks and update checklist state immediately.
  - `/ss:verify`: Evaluate spec-task-code coherence.
  - `/ss:archive`: Close lifecycle after verification gates pass.
- Unsupported external command namespaces:
  - Reject unsupported namespace usage.
  - Return migration hint: `Use /ss:* commands instead.`

## Ana-Skill Phase (Design)
1. Build or update `DESIGN.md`.
2. Capture strengths, weaknesses, information gaps, and risks.
3. Mirror design decisions into `loop/roadmap.md`.
4. Enforce Gate A and Gate B before moving forward.

## Task-Skill Phase (Planning)
1. Build or update `TASK.md`.
2. Decompose work into phases, tasks, and checklist items.
3. Track task IO and Definition of Done per task group.
4. Mirror execution plan into `loop/tasks.md`.
5. Enforce Gate C before implementation.

## Implementation Phase
1. Execute tasks in priority order.
2. Update `- [ ]` to `- [x]` as soon as a task is completed.
3. Keep changes inside required structure and conventions.
4. Stop and ask up to three short questions when blocked by missing context.

## Moni-Skill Phase (Verification)
1. Build or update `VERIFY_REPORT.md`.
2. Evaluate `Completeness`, `Correctness`, and `Coherence`.
3. Classify issues by `CRITICAL`, `WARNING`, `SUGGESTION`.
4. Write pass/fail evidence into `loop/checklist.md`.
5. Enforce Gate D and Gate E before archive.

## Phase Gates
- Gate A: Confirm scope and capabilities.
- Gate B: Freeze `DESIGN.md`.
- Gate C: Approve `TASK.md` with DoD.
- Gate D: Complete implementation tasks and validation.
- Gate E: Block archive while any CRITICAL issue exists.

## Required Files
Maintain the following files at all times:
1. `SKILL.md`
2. `knowledge/architect.md`
3. `knowledge/standards.md`
4. `loop/roadmap.md`
5. `loop/checklist.md`
6. `loop/tasks.md`
7. `scripts/init_skill.py`
8. `scripts/quick_validate.py`
9. `templates/DESIGN.md.template`
10. `templates/TASK.md.template`
11. `templates/VERIFY_REPORT.md.template`

## Response Contract
Return exactly eight sections in every execution response:
1. Mode
2. Using Session
3. Phase Focus
4. Action Taken
5. Files Created/Updated
6. Remaining Gaps
7. Risks / Blockers
8. Next Step

## Operational Rules
1. Use imperative voice.
2. Apply progressive disclosure.
3. Trace every conclusion to requirement, spec, task, or code.
4. Deliver actionable outputs only.
5. Block archive whenever `VERIFY_REPORT.md` contains any CRITICAL issue.

## Done Definition
Mark the skill complete only when all conditions pass:
1. Keep the structure compliant with required zones.
2. Describe Ana/Task/Moni workflow clearly in `SKILL.md`.
3. Ship required knowledge, loop, scripts, and templates.
4. Produce `VERIFY_REPORT.md` proving design-task-implementation coherence.
5. Obtain explicit user confirmation for final version closure.
