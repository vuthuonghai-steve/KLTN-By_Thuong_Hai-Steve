## Context

The current use-case analysis is concentrated in a single file with one large diagram and a long mixed narrative. This causes high cognitive load for new readers and makes targeted reviews difficult when only one functional module changes.

The project already models functionality by modules M1-M6 in `Docs/life-1/01-vision/FR/feature-map-and-priority.md`. The new documentation structure should align with that module map and preserve UML semantics and FR traceability.

Stakeholders:
- Product/BA reviewers needing a system-wide snapshot
- Developers needing module-level analysis for implementation
- Future AI agents needing stable navigation for downstream schema/API design

## Goals / Non-Goals

**Goals:**
- Provide a two-level use-case documentation architecture: overview + module-level decomposition.
- Make navigation explicit using a hub index file.
- Preserve and standardize traceability from module/use-case to FR references.
- Reduce diagram complexity per document while maintaining UML relationship meaning.

**Non-Goals:**
- No change to product scope (FR-1..FR-10 remain unchanged).
- No change to runtime code, API behavior, or database schema.
- No redesign of unrelated diagrams (ER, sequence, flow, class).

## Decisions

### Decision 1: Hub-and-spoke file architecture
- Choice: Create `UseCase/index.md` as a navigation hub and split diagrams into one overview file plus six module files.
- Rationale: Readers can start from system context then drill into one domain without scanning unrelated use cases.
- Alternative considered: Keep one file with collapsible sections. Rejected because visual complexity remains high and file-level reviews still noisy.

### Decision 2: Stable file naming aligned with module semantics
- Choice: Name module files by capability domains (auth-profile, content-engine, discovery-feed, engagement-connections, bookmarking, notifications-moderation).
- Rationale: Improves discoverability and aligns directly with M1-M6 language already used in life-1.
- Alternative considered: Keep numeric filenames (`m1.md`, `m2.md`, ...). Rejected due to lower readability outside internal context.

### Decision 3: Decomposition rules to cap diagram complexity
- Choice: Each module file focuses only on in-module actors/use cases and in-module `<<include>>` / `<<extend>>`; cross-module links are referenced textually.
- Rationale: Prevents diagram spaghetti while retaining semantic correctness.
- Alternative considered: Draw all cross-module relations in each module diagram. Rejected due to repeated clutter and maintenance overhead.

### Decision 4: Traceability-first layout per file
- Choice: Every module file includes a traceability table mapping Use Case -> Module ID -> FR ID.
- Rationale: Ensures downstream design artifacts can verify requirement origin quickly.
- Alternative considered: Central traceability table only in overview. Rejected because module reviewers need local context.

## Risks / Trade-offs

- [Risk] Cross-module dependencies become less visible when links are textual, not visual.
  -> Mitigation: Add a short "cross-module dependency" section in each module file with references to related module documents.

- [Risk] Naming drift between life-1 module terms and life-2 document filenames.
  -> Mitigation: Define canonical naming in `UseCase/index.md` and keep module IDs (M1-M6) in each file header.

- [Risk] Reviewers may read only module files and miss system context.
  -> Mitigation: Include a required "Start here" note in each module file pointing back to `use-case-overview.md`.

## Migration Plan

1. Create new use-case documentation tree (`index.md`, `use-case-overview.md`, and six module files).
2. Move/refactor current monolithic content into corresponding module files.
3. Keep old monolithic sections only as transitional references (if needed) during review.
4. Validate that every use case from current document appears in exactly one module file.
5. Remove obsolete monolithic-only sections after review sign-off.

Rollback:
- If decomposition causes ambiguity, revert to previous single-file document and keep new files as draft references.

## Open Questions

- Should each module file include a small "test checklist" derived from scenarios, or should that remain only in OpenSpec tasks?
- Do we want one additional cross-cutting diagram file for shared auth/validation includes, or keep cross-cutting links textual only?
