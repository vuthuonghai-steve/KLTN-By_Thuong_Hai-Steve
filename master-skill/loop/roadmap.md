# MASTER SKILL ROADMAP & EXECUTION STATE

## 0. Core Intent
Build `master-skill` as an independent agent skill with deterministic lifecycle control and no external router dependency.

## 1. Baseline Constraints
- Preserve 7-zone structure.
- Preserve lifecycle artifacts: `DESIGN.md`, `TASK.md`, `VERIFY_REPORT.md`.
- Use imperative instructions and traceable loop state.

## 2. Standalone Routing Model (2026-02-11)
- Primary trigger: natural language intent.
- Secondary trigger: optional `/ss:*` commands.
- Command namespace:
  - `/ss:explore`
  - `/ss:new-session`
  - `/ss:ff`
  - `/ss:continue`
  - `/ss:apply`
  - `/ss:verify`
  - `/ss:archive`
- Legacy policy: hard-cut removed external command namespace and require migration to `/ss:*`.

## 3. Session State Model
- Replace old change-based tracking with session-based tracking.
- Required runtime fields:
  - `session-name`
  - `session-mode`
  - `trigger-strategy`

## 4. Design Decisions
- Enforce NL-first routing with command fallback.
- Enforce output contract keys `Using Session` and `Next Step`.
- Enforce dedicated legacy residue checks.
- Block archive while any CRITICAL issue exists.

## 5. Gate Tracking
- Gate A (Idea -> Design): PASS
- Gate B (Design -> Task): PASS
- Gate C (Task -> Apply): PASS
- Gate D (Apply -> Verify): PASS
- Gate E (Verify -> Archive): PASS (CRITICAL=0)

## 6. Verification Plan
- Run legacy residue scan.
- Run `scripts/quick_validate.py`.
- Run `scripts/init_skill.py` smoke test.
- Update `VERIFY_REPORT.md` and `loop/checklist.md` with evidence.

## 7. Current Status
- Standalone refactor applied to docs, loop files, templates, and scripts.
- Verification evidence captured for residue scan, validator, and initializer smoke test.
- Gate D and Gate E closed under hard-block archive policy.

## 8. Next Action
Run `/ss:archive` only when closure action is requested.
