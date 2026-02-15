## ADDED Requirements

### Requirement: Build sessions SHALL inventory critical context resources
The builder workflow SHALL enumerate critical context resources in `.skill-context/{skill-name}` before implementation proceeds.

#### Scenario: Critical resource inventory is generated
- **WHEN** builder starts Step PREPARE for a skill context
- **THEN** it SHALL inventory at minimum `design.md`, `todo.md`, all `resources/*`, and all `data/*` files

### Requirement: Build logs SHALL include explicit resource usage matrix
The build log SHALL include mandatory sections `Resource Inventory` and `Resource Usage Matrix` to prove resource consumption.

#### Scenario: Build log structure includes mandatory sections
- **WHEN** build log is finalized for a skill context
- **THEN** the document SHALL contain `## Resource Inventory` and `## Resource Usage Matrix`

#### Scenario: Critical resources are traceable in usage matrix
- **WHEN** a build task is marked complete
- **THEN** the usage matrix SHALL record at least one trace entry from a critical resource file to produced outputs

### Requirement: Strict context validation SHALL fail on missing coverage evidence
Validator strict mode SHALL fail if mandatory sections are missing or any critical resource lacks usage evidence.

#### Scenario: Missing matrix section in strict mode
- **WHEN** validator runs with `--strict-context` and `build-log.md` lacks a mandatory section
- **THEN** validation SHALL return FAIL

#### Scenario: Uncovered critical resource in strict mode
- **WHEN** validator runs with `--strict-context` and a critical context file is not referenced in usage evidence
- **THEN** validation SHALL return FAIL

### Requirement: Non-strict validation SHALL remain backward compatible
Validator non-strict mode SHALL warn on context coverage issues without hard failing legacy builds.

#### Scenario: Coverage issue in non-strict mode
- **WHEN** validator runs without `--strict-context` and detects uncovered critical resources
- **THEN** validation SHALL emit warnings and preserve non-strict compatibility behavior
