## ADDED Requirements

### Requirement: Canonical source mapping SHALL be defined per target skill
The system SHALL define an explicit canonical source directory for each synchronized skill so updates are applied deterministically.

#### Scenario: Canonical mapping is declared for both target skills
- **WHEN** the sync policy is evaluated for `skill-architect` and `skill-builder`
- **THEN** the policy SHALL map `skill-architect` to `.agent/skills/skill-architect` and `skill-builder` to `.codex/skills/skill-builder`

### Requirement: Synchronization SHALL be one-way from canonical source
The sync workflow SHALL copy files only from canonical source to target mirror for each skill mapping.

#### Scenario: One-way sync executes for skill-architect
- **WHEN** sync is run for `skill-architect`
- **THEN** files SHALL be copied from `.agent/skills/skill-architect` to `.codex/skills/skill-architect`

#### Scenario: One-way sync executes for skill-builder
- **WHEN** sync is run for `skill-builder`
- **THEN** files SHALL be copied from `.codex/skills/skill-builder` to `.agent/skills/skill-builder`

### Requirement: Sync completion SHALL require parity verification
The sync workflow SHALL require an explicit parity check between source and mirror directories before marking completion.

#### Scenario: Diff check passes after synchronization
- **WHEN** `diff -qr` is executed on both synchronized skill directory pairs
- **THEN** the workflow SHALL mark synchronization as complete only if no differences remain

### Requirement: Sync review SHALL preserve language preference constraints
The sync review process SHALL preserve Vietnamese-first documentation preference for synchronized skill metadata and guidance content.

#### Scenario: Language preference check during sync review
- **WHEN** synchronized `SKILL.md` metadata and guidance are reviewed
- **THEN** the review SHALL confirm Vietnamese-first wording is preserved according to team policy
