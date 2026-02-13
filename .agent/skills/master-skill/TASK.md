# TASK.md

## 1. Execution Phases

- Phase 1: Refactor core contract (`SKILL.md`, standalone routing, output contract, session model).
- Phase 2: Refactor lifecycle docs (`DESIGN.md`, `TASK.md`, `VERIFY_REPORT.md`) to standalone semantics.
- Phase 3: Refactor loop tracking (`loop/tasks.md`, `loop/checklist.md`, `loop/roadmap.md`) with session state.
- Phase 4: Refactor deterministic helpers (`templates/*`, `scripts/init_skill.py`, `scripts/quick_validate.py`).
- Phase 5: Validate migration (legacy residue scan + validator + initializer smoke test).

## 2. Task Checklist

- [x] Replace old router section with standalone NL-first intent router in `SKILL.md`.
- [x] Add optional `/ss:*` command namespace.
- [x] Replace output contract field with `Using Session`.
- [x] Replace output contract field with `Next Step`.
- [x] Update `knowledge/standards.md` to standalone routing standards.
- [x] Update `DESIGN.md` capability map and migration decisions.
- [x] Update `TASK.md` and DoD wording to session model.
- [x] Update `VERIFY_REPORT.md` conclusions to standalone model.
- [x] Update `loop/roadmap.md` with hard-cut migration decision log.
- [x] Update `loop/tasks.md` from old state labels to session state.
- [x] Update `loop/checklist.md` with mandatory residue check.
- [x] Update `scripts/init_skill.py` templates to generate standalone router + session contract.
- [x] Update `scripts/quick_validate.py` section checks and residue fail rules.
- [x] Run legacy residue scan and ensure no result.
- [x] Run validator and ensure pass.
- [x] Run initializer smoke test for standalone skeleton output.
- [x] Update `VERIFY_REPORT.md` with final evidence from all checks.

## 3. Input/Output per Task Group

- Group A Input: Refactor plan and current skill artifacts.
- Group A Output: Standalone routing and session semantics across core docs.
- Group B Input: Updated docs and loop artifacts.
- Group B Output: Updated scripts/templates with deterministic checks.
- Group C Input: Refactored files and executable scripts.
- Group C Output: Validation evidence and final verification report.

## 4. Definition of Done

- No legacy router keywords or old output labels remain in skill package.
- `SKILL.md` and `knowledge/standards.md` define NL-first + optional `/ss:*` routing.
- Loop state uses session fields instead of old change fields.
- `scripts/quick_validate.py` passes and enforces migration rules.
- `scripts/init_skill.py` generates standalone skeleton using `/ss:*`, `Using Session`, and `Next Step`.

## 5. Dependency & Blocker Log

- Dependency: Read `knowledge/architect.md`, `knowledge/standards.md`, and `loop/roadmap.md` before edits.
- Blocker: Archive remains blocked while verify output contains any CRITICAL issue.

## 6. Progress Summary

- Total tasks: 17
- Completed: 17
- Remaining: 0
- Status: Apply complete, verify complete, archive-ready when CRITICAL=0
