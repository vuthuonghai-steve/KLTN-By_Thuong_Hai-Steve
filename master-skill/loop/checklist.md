# Loop Verification Checklist

## Completeness Checks
- [x] Required core artifacts exist: `SKILL.md`, `DESIGN.md`, `TASK.md`, `VERIFY_REPORT.md`.
- [x] Required knowledge files exist: `knowledge/architect.md`, `knowledge/standards.md`.
- [x] Required loop files exist: `loop/roadmap.md`, `loop/tasks.md`, `loop/checklist.md`.
- [x] Required templates exist: `templates/DESIGN.md.template`, `templates/TASK.md.template`, `templates/VERIFY_REPORT.md.template`.
- [x] Required scripts exist: `scripts/init_skill.py`, `scripts/quick_validate.py`.

## Correctness Checks
- [x] Legacy residue scan is clean.
- [x] `quick_validate.py` passes against `.agent/skills/master-skill`.
- [x] `SKILL.md` output contract uses `Using Session` and `Next Step`.
- [x] Gate status is synchronized in roadmap and verify report.

## Coherence Checks
- [x] `DESIGN.md` decisions map to `TASK.md` execution items.
- [x] `TASK.md` completed items map to implementation files.
- [x] `VERIFY_REPORT.md` findings map to final validation evidence.

## Gate Status
- [x] Gate A (Idea -> Design)
- [x] Gate B (Design -> Task)
- [x] Gate C (Task -> Apply)
- [x] Gate D (Apply -> Verify)
- [x] Gate E (Verify -> Archive)
