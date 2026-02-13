# Standards

## 1. Core Principles
- Use imperative voice in all procedural instructions.
- Apply progressive disclosure: load only necessary references.
- Keep every conclusion traceable to requirement, design, task, or code.
- Prefer deterministic scripts for repetitive or high-accuracy operations.
- Stop and ask up to three short questions only when blocked by missing context.

## 2. Standalone Routing Standards
- Use natural language intent as the primary router.
- Resolve intent precedence in this order: `explore -> plan -> apply -> verify -> archive`.
- Support optional command shortcuts under `/ss:*` namespace:
  - `/ss:explore`
  - `/ss:new-session`
  - `/ss:ff`
  - `/ss:continue`
  - `/ss:apply`
  - `/ss:verify`
  - `/ss:archive`
- Reject unsupported external command namespaces and return migration hint to `/ss:*`.
- Use `session` terms for runtime state (`session-id`, `session-name`, `session-mode`).

## 3. Artifact Standards
- `DESIGN.md` must include 9 required sections:
  1. Problem Statement
  2. Goals / Non-Goals
  3. User Scenarios
  4. Capability Map
  5. Workflow & Gates
  6. 7-Zone File Plan
  7. Risks & Mitigations
  8. Open Questions
  9. Changelog
- `TASK.md` must include 6 required sections:
  1. Execution Phases
  2. Task Checklist
  3. Input/Output per Task Group
  4. Definition of Done
  5. Dependency & Blocker Log
  6. Progress Summary
- `VERIFY_REPORT.md` must include 5 required sections:
  1. Completeness
  2. Correctness
  3. Coherence
  4. Issues by severity
  5. Final Assessment

## 4. Loop Synchronization Rules
- Sync `TASK.md` checklist state with `loop/tasks.md` in the same execution pass.
- Sync verify outcomes with `loop/checklist.md` immediately after validation.
- Sync gate decisions and major design decisions into `loop/roadmap.md`.
- Record active runtime state with `session` fields, not legacy change fields.

## 5. Gate and Severity Rules
- Gate A: Confirm scope and capabilities.
- Gate B: Freeze design.
- Gate C: Approve executable tasks with DoD.
- Gate D: Complete implementation and validation.
- Gate E: Block archive while any CRITICAL issue exists.
- Classify issues strictly as `CRITICAL`, `WARNING`, or `SUGGESTION`.

## 6. Output Contract
Return exactly eight sections in every execution response:
1. Mode
2. Using Session
3. Phase Focus
4. Action Taken
5. Files Created/Updated
6. Remaining Gaps
7. Risks / Blockers
8. Next Step

Last updated: 2026-02-11
