## Why

The current use-case document is a single large diagram that is hard to read and hard to maintain. We need a layered structure so readers can start from a high-level system view and then drill down into specific functional domains.

## What Changes

- Replace the monolithic use-case documentation with a hub-and-subdiagram structure.
- Introduce one overview use-case diagram for system-wide understanding.
- Introduce module-level decomposed diagrams for M1-M6 so each domain is readable and reviewable on its own.
- Add explicit navigation and traceability mapping from FR/module IDs to the corresponding use-case files.
- Keep UML semantics (`association`, `<<include>>`, `<<extend>>`, `generalization`) while reducing visual clutter.

## Capabilities

### New Capabilities
- `usecase-diagram-decomposition`: Define a multi-level use-case documentation structure (overview + module breakdown) with consistent traceability and navigation.

### Modified Capabilities
- None.

## Impact

- Affected docs: `Docs/life-2/diagrams/UseCase/*`
- New documentation files for overview and module-specific diagrams.
- Existing `use-case-diagram.md` content will be redistributed into focused files.
- No runtime code, API contract, or database behavior changes.
