## ADDED Requirements

### Requirement: Use-case documentation SHALL provide a two-level structure
The use-case documentation SHALL be reorganized into a two-level architecture consisting of a hub index, one system overview diagram document, and module-level decomposition documents.

#### Scenario: Reader starts from global context
- **WHEN** a reader opens the use-case documentation set
- **THEN** the reader MUST find a single overview document that presents system boundary, primary actors, and major functional modules without low-level clutter

#### Scenario: Reader drills down into module details
- **WHEN** a reader needs details for a specific module (M1-M6)
- **THEN** the reader MUST be able to navigate from the hub to a dedicated module file containing that module's detailed use cases

### Requirement: Hub navigation SHALL define canonical reading paths
The hub document SHALL define clear reading paths for overview-first and module-first consumption and SHALL map each module to its corresponding decomposition file.

#### Scenario: Overview-first navigation
- **WHEN** a reader wants a quick understanding of the system
- **THEN** the hub MUST direct the reader to the overview document before module-level files

#### Scenario: Module-first navigation
- **WHEN** a reader needs to review one module directly
- **THEN** the hub MUST provide a direct link from the module identifier (M1-M6) to its module file

### Requirement: Module decomposition SHALL preserve requirement traceability
Each module document SHALL include explicit traceability from use cases to module IDs and FR IDs derived from life-1 sources.

#### Scenario: Verify use-case origin
- **WHEN** a reviewer inspects a use case in a module file
- **THEN** the reviewer MUST find its corresponding FR reference and module mapping in the same file

#### Scenario: Validate completeness against feature map
- **WHEN** the decomposed set is reviewed against `feature-map-and-priority.md`
- **THEN** every use case in scope MUST be traceable to at least one FR and one module identifier

### Requirement: Diagram decomposition SHALL reduce visual complexity while preserving UML semantics
Each module-level diagram SHALL focus on in-module actors/use cases and retain valid UML relationship semantics (`association`, `<<include>>`, `<<extend>>`, `generalization`).

#### Scenario: Cross-module relationship handling
- **WHEN** a relationship spans another module
- **THEN** the module file MUST reference that dependency textually instead of introducing excessive cross-module connectors in the diagram

#### Scenario: UML semantic consistency
- **WHEN** a relationship is represented in overview or module diagrams
- **THEN** the relationship type MUST use consistent UML meaning across all documents
