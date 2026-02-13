## ADDED Requirements

### Requirement: AI SHALL read project context before any action
The AI agent SHALL read `00-project-context.md` to understand the project purpose, scope, and core reference document (`architect.md`) before performing any task.

#### Scenario: AI starts a new task
- **WHEN** AI receives a new task request from user
- **THEN** AI reads `.agent/rules/00-project-context.md` first
- **THEN** AI understands this is an Agent Skill Framework project
- **THEN** AI references `architect.md` as the source of truth

---

### Requirement: AI SHALL comply with architecture zones
The AI agent SHALL only create files/directories within zones defined in `architect.md`: SKILL.md, knowledge/, scripts/, templates/, data/, loop/, assets/.

#### Scenario: AI creates new file within valid zone
- **WHEN** AI needs to create a new file for a skill
- **THEN** AI places the file in one of the valid zones
- **THEN** file is created successfully

#### Scenario: AI attempts to create file outside valid zones
- **WHEN** AI identifies need for a file outside valid zones
- **THEN** AI MUST stop and ask user for confirmation before proceeding

---

### Requirement: AI SHALL follow 5-step workflow
The AI agent SHALL follow the 5-step workflow from `architect.md`: Khảo sát → Thiết kế → Xây dựng → Kiểm định → Bảo trì.

#### Scenario: AI completes phase with verify
- **WHEN** AI finishes a phase (e.g., Thiết kế)
- **THEN** AI runs verify checkpoint for that phase
- **THEN** AI proceeds to next phase only if verify passes

#### Scenario: AI detects verify failure
- **WHEN** verify checkpoint fails
- **THEN** AI reports the failure to user
- **THEN** AI performs rollback or fix as per architect.md

---

### Requirement: AI SHALL ask clarifying questions only in early phases
The AI agent SHALL ask clarifying questions during Khảo sát and Thiết kế phases when there are multiple interpretations or unclear requirements.

#### Scenario: Ambiguity in early phase
- **WHEN** AI encounters ambiguous requirement during Khảo sát or Thiết kế
- **THEN** AI stops and asks user for clarification
- **THEN** AI proceeds after receiving clear answer

#### Scenario: Executing in build phase
- **WHEN** AI is in Xây dựng or Kiểm định phase (after design is approved)
- **THEN** AI proceeds with implementation without additional questions
- **THEN** AI provides verify/confirmation only after completion

---

### Requirement: AI SHALL NOT execute forbidden patterns
The AI agent SHALL NOT violate forbidden patterns listed in `04-forbidden-patterns.md`.

#### Scenario: AI attempts to deviate from architect.md
- **WHEN** AI considers proposing architecture different from architect.md
- **THEN** AI MUST explicitly state the deviation and wait for user approval

#### Scenario: AI attempts to switch scope
- **WHEN** user requests skill design but AI considers writing product code
- **THEN** AI MUST stop and confirm scope with user before proceeding

---

### Requirement: AI SHALL provide implementation checklist
The AI agent SHALL provide visible checklist items during each phase so user can track progress.

#### Scenario: User monitors AI progress
- **WHEN** AI works through a phase
- **THEN** AI shows checklist with completed and remaining items
- **THEN** user can verify AI is following correct steps

---

### Requirement: Rule files SHALL have English and Vietnamese versions
Rule files SHALL be written in English (primary, for AI consumption) with Vietnamese translations in `_vi/` subdirectory (temporary, for user review).

#### Scenario: User reviews rule content
- **WHEN** user wants to understand rule content
- **THEN** user reads Vietnamese version in `.agent/rules/_vi/`
- **THEN** Vietnamese version matches English version semantically

#### Scenario: Vietnamese versions cleanup
- **WHEN** user is comfortable with English rules
- **THEN** `_vi/` directory can be deleted without affecting AI behavior
