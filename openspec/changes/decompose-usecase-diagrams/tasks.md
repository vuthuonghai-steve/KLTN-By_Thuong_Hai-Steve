## 1. Define UseCase Documentation Skeleton

- [x] 1.1 Create `Docs/life-2/diagrams/UseCase/index.md` as navigation hub for overview-first and module-first reading paths
- [x] 1.2 Create `Docs/life-2/diagrams/UseCase/use-case-overview.md` for system boundary, actors, and M1-M6 high-level capabilities
- [x] 1.3 Create module files: `use-case-m1-auth-profile.md`, `use-case-m2-content-engine.md`, `use-case-m3-discovery-feed.md`, `use-case-m4-engagement-connections.md`, `use-case-m5-bookmarking.md`, `use-case-m6-notifications-moderation.md`

## 2. Decompose Existing Monolithic UseCase Content

- [x] 2.1 Extract and move high-level actor/system context from existing `use-case-diagram.md` into `use-case-overview.md`
- [x] 2.2 Distribute detailed use cases into module files by M1-M6 ownership, ensuring each use case appears in exactly one module document
- [x] 2.3 Keep cross-module dependencies as textual references in module files instead of adding high-clutter cross-module connectors

## 3. Enforce UML and Traceability Consistency

- [x] 3.1 Add/verify UML relationship semantics (`association`, `<<include>>`, `<<extend>>`, `generalization`) in each module diagram
- [x] 3.2 Add traceability tables in each module file mapping Use Case -> Module ID -> FR ID
- [x] 3.3 Add a traceability/navigation section in `index.md` mapping FR and modules to the new file structure

## 4. Validate Readability and Completeness

- [x] 4.1 Review all new diagrams for readability (overview stays high-level, module diagrams remain scoped)
- [x] 4.2 Verify every in-scope use case from `feature-map-and-priority.md` is represented and traceable in decomposed files
- [x] 4.3 Update/deprecate legacy monolithic-only sections in `use-case-diagram.md` after decomposition is fully validated
