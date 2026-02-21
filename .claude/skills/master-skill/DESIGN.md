# DESIGN.md

## 1. Problem Statement
`master-skill` contained external routing semantics and command dependencies that conflicted with standalone execution goals. The skill must run independently with natural language intent and optional internal commands.

## 2. Goals / Non-Goals
### Goals
- Keep lifecycle `IDEA -> DESIGN -> TASK -> IMPLEMENTATION -> VERIFY -> ARCHIVE`.
- Remove all external router dependencies and adopt standalone routing.
- Use natural-language-first intent resolution with optional `/ss:*` command triggers.
- Replace legacy change runtime model with session runtime model.
- Preserve deterministic validation and traceable loop state.

### Non-Goals
- Keep backward compatibility for removed external command namespace.
- Modify 7-zone folder architecture.
- Introduce new external dependencies.

## 3. User Scenarios
1. User requests analysis in plain language and skill enters explore flow without any command prefix.
2. User provides `/ss:apply` and skill executes implementation checklist within active session context.
3. User provides an unsupported external command and skill rejects it with migration hint.
4. User requests verification and receives coherence report tied to session state.

## 4. Capability Map
- `Ana-skill`: Analyze intent and build design decisions.
- `Task-skill`: Convert design into executable checklist and DoD.
- `Moni-skill`: Verify completeness/correctness/coherence.
- `Standalone Intent Router`: Resolve natural language intent first, then `/ss:*` command hints.

## 5. Workflow & Gates
- Gate A (Idea -> Design): Confirm scope and capability map.
- Gate B (Design -> Task): Freeze design decisions in `DESIGN.md`.
- Gate C (Task -> Apply): Ensure `TASK.md` has executable checklist + DoD.
- Gate D (Apply -> Verify): Complete implementation tasks and validation scripts.
- Gate E (Verify -> Archive): Block archive while any CRITICAL issue exists.

## 6. 7-Zone File Plan
1. Core: `SKILL.md`, `DESIGN.md`, `TASK.md`, `VERIFY_REPORT.md`.
2. Knowledge: `knowledge/architect.md`, `knowledge/standards.md`.
3. Scripts: `scripts/init_skill.py`, `scripts/quick_validate.py`, `scripts/package_skill.py`.
4. Templates: `templates/DESIGN.md.template`, `templates/TASK.md.template`, `templates/VERIFY_REPORT.md.template`.
5. Data: `data/` reserved for static config snapshots.
6. Loop: `loop/roadmap.md`, `loop/tasks.md`, `loop/checklist.md`.
7. Assets: `assets/` reserved for reusable payloads.

## 7. Risks & Mitigations
- Risk: Intent ambiguity from natural language triggers wrong phase.
- Mitigation: Use precedence order `explore -> plan -> apply -> verify -> archive` and ask up to three short clarifying questions.

- Risk: Mixed terminology creates tracking drift.
- Mitigation: Enforce session vocabulary in docs, loop files, templates, and validation rules.

- Risk: Partial migration leaves hidden legacy keywords.
- Mitigation: Enforce dedicated legacy residue checks in validator.

## 8. Open Questions
1. Decide if session identifiers should be UUID-like or human-readable slugs.
2. Decide if archive packaging should run automatically after Gate E passes with zero CRITICAL issues.

## 9. Changelog
- 2026-02-11: Refactored design to standalone routing with NL-first and `/ss:*` commands.
- 2026-02-11: Adopted session-based runtime model and hard-cut legacy routing.
- 2026-02-11: Switched Gate E to hard archive block when CRITICAL issues exist.
