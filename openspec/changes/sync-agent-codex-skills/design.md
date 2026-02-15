## Context

Two parallel skill trees are being maintained in this repository: `.agent/skills/` and `.codex/skills/`. The same skill names can diverge over time, which creates uncertainty during build and review sessions.  
For this change, stakeholder direction is explicit:
- `skill-architect` canonical source: `.agent`
- `skill-builder` canonical source: `.codex`
- Documentation style priority: Vietnamese-first

Current state already includes improvements in `.codex/skills/skill-builder` (context coverage, strict validation), but there is no formal contract that ensures these improvements are synchronized and preserved across both trees.

## Goals / Non-Goals

**Goals:**
- Define deterministic sync governance so each skill has one canonical source.
- Make synchronization reproducible and verifiable (not ad hoc copy-paste).
- Ensure `skill-builder` consumes critical sub-skill context resources and records evidence.
- Encode behavior through spec requirements so future updates do not regress.

**Non-Goals:**
- Implementing all future skill content changes.
- Standardizing every skill in the repository; this change targets `skill-architect` and `skill-builder`.
- Re-architecting OpenSpec schemas or CLI behavior.

## Decisions

### Decision 1: Per-skill canonical source mapping
- Choice: use per-skill canonical mapping rather than one global canonical directory.
- Mapping:
  - `skill-architect` -> `.agent` canonical
  - `skill-builder` -> `.codex` canonical
- Rationale: this matches the current validated workstream and stakeholder preference.
- Alternative considered: single canonical root (all `.codex` or all `.agent`) was rejected because it would overwrite accepted updates in one tree.

### Decision 2: Verification-first synchronization
- Choice: synchronization is only considered complete after deterministic diff checks pass.
- Rationale: a copy operation alone can silently fail or partially sync.
- Alternative considered: manual visual review only; rejected as too error-prone.

### Decision 3: Resource coverage must be explicit in build logs
- Choice: `skill-builder` workflow requires `Resource Inventory` + `Resource Usage Matrix` sections in `.skill-context/{skill-name}/build-log.md`.
- Rationale: this proves critical resources were used, reduces “implicit usage” assumptions, and improves auditability.
- Alternative considered: rely on narrative notes in logs; rejected because coverage cannot be validated reliably.

### Decision 4: Strict context coverage validation is opt-in but required in builder workflow
- Choice: add strict mode to validator and require it in build step documentation.
- Rationale: preserves compatibility for legacy checks while enabling hard gating for modern builds.
- Alternative considered: always-on strict failure; rejected due to disruption for existing historical builds.

## Risks / Trade-offs

- [Risk] Canonical mapping may be forgotten for new sessions  
  -> Mitigation: encode mapping in specs/tasks and sync runbook.
- [Risk] Legacy build logs fail strict checks  
  -> Mitigation: keep non-strict mode for backward compatibility; require strict mode for new builds.
- [Risk] Validator may report false positives if context layout differs  
  -> Mitigation: define critical files contract explicitly and document fallback behavior.
- [Risk] Vietnamese-first wording could drift between trees  
  -> Mitigation: include language preference in sync review checklist and validate metadata consistency.

## Migration Plan

1. Confirm canonical mapping and target scope (`skill-architect`, `skill-builder`).
2. Execute one-way sync per skill based on canonical source.
3. Run `diff -qr` for each skill pair to verify parity.
4. Run `skill-builder` validator in:
   - non-strict mode (compatibility signal)
   - strict mode (coverage gate for new builds)
5. Update `.skill-context/{skill-name}/build-log.md` template/practice with mandatory matrix sections.
6. Keep rollback path by preserving pre-sync git state and reverting file set if verification fails.

## Open Questions

- Should canonical mapping be documented in a shared repository-level policy file for future skills?
- Should strict context coverage become default once legacy transitions finish?
- Should `skill-architect` description be standardized in Vietnamese-only or bilingual format?
