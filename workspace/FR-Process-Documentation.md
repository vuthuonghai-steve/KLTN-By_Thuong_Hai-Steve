# FR Document Generator Skill - Process Documentation

> **Purpose**: This document captures the complete context, mechanism, and process used in this session to generate FR (Functional Requirements) documents for M1-M6 modules.
> **Created**: 2026-03-01
> **For**: Reproducing the workflow in a new Claude session using skill-architect + skill-planner + skill-builder

---

## 📥 INPUT CONTEXT

### Source Files Used

| File | Path | Purpose |
|------|------|---------|
| feature-map-and-priority.md | `/docs/life-1/01-vision/FR/feature-map-and-priority.md` | Maps modules (M1-M6), features, FR references, sprint priorities |
| user-stories.md | `/docs/life-1/01-vision/user-stories.md` | High-level user stories (Epic format) |
| requirements-srs.md | `/docs/life-1/01-vision/FR/requirements-srs.md` | Basic FR and NFR list |

### Input Structure Analysis

```
INPUT STRUCTURE
================

feature-map-and-priority.md contains:
├── Module mapping (M1-M6)
│   ├── M1: Auth & Profile (FR-1, FR-2)
│   ├── M2: Content Engine (FR-3)
│   ├── M3: Discovery & Feed (FR-4, FR-7)
│   ├── M4: Engagement (FR-5, FR-10)
│   ├── M5: Bookmarking (FR-6)
│   └── M6: Notifications & Moderation (FR-8, FR-9)
├── Feature details (M1.1, M1.2, etc.)
└── Sprint priorities (P1-P4)

user-stories.md contains:
├── Epic 1-10 format
└── High-level user stories

requirements-srs.md contains:
├── FR-1 to FR-10
└── Basic NFR list
```

---

## 📤 OUTPUT GENERATED

### Files Created

| Module | User Stories | Functional Req | Non-Functional Req | Index |
|--------|---------------|----------------|-------------------|-------|
| M1 | m1-user-stories.md | m1-functional-requirements.md | m1-non-functional-requirements.md | ✅ |
| M2 | m2-user-stories.md | m2-functional-requirements.md | m2-non-functional-requirements.md | ✅ |
| M3 | m3-user-stories.md | m3-functional-requirements.md | m3-non-functional-requirements.md | ✅ |
| M4 | m4-user-stories.md | m4-functional-requirements.md | m4-non-functional-requirements.md | ✅ |
| M5 | m5-user-stories.md | m5-functional-requirements.md | m5-non-functional-requirements.md | ✅ |
| M6 | m6-user-stories.md | m6-functional-requirements.md | m6-non-functional-requirements.md | ✅ |

### Output Location

```
/home/steve/Documents/KLTN/Test/docs/life-1/01-vision/FR/
├── index.md                          # Master index
├── m1-user-stories.md               # 13.5 KB
├── m1-functional-requirements.md    # 17 KB
├── m1-non-functional-requirements.md# 8.7 KB
├── m2-user-stories.md               # 8.5 KB
├── m2-functional-requirements.md    # 10 KB
├── m2-non-functional-requirements.md# 6.5 KB
... (and so on for M3-M6)
```

---

## ⚙️ MECHANISM - How Results Were Produced

### Step-by-Step Process

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DOCUMENT GENERATION WORKFLOW                       │
└─────────────────────────────────────────────────────────────────────┘

1. INPUT ANALYSIS
   │
   ├─► Read feature-map-and-priority.md
   │       → Extract modules (M1-M6)
   │       → Extract features per module
   │       → Extract FR references
   │       → Extract sprint priorities
   │
   ├─► Read user-stories.md
   │       → Extract high-level Epic/US format
   │
   └─► Read requirements-srs.md
           → Extract FR-1 to FR-10
           → Extract basic NFRs

2. MODULE PROCESSING (Repeated for each module)
   │
   ├─► A. User Stories Generation
   │       │
   │       ├─► For each feature in module:
   │       │   ├── Identify Actor
   │       │   ├── Define Preconditions
   │       │   ├── Create Main Flow (step-by-step)
   │       │   ├── Create Alternative Flows
   │       │   ├── Define Postconditions
   │       │   └── Extract Business Rules
   │       │
   │       └─► Output: m*-user-stories.md
   │
   ├─► B. Functional Requirements Generation
   │       │
   │       ├─► For each FR:
   │       │   ├── Define Input Specification (table format)
   │       │   ├── Define Output Specification (JSON examples)
   │       │   ├── Create Processing Rules (step-by-step)
   │       │   ├── Define Validation Rules
   │       │   └── Extract Business Rules
   │       │
   │       └─► Output: m*-functional-requirements.md
   │
   └─► C. Non-Functional Requirements Generation
           │
           ├─► For each category:
           │   ├── Performance (response time, throughput)
           │   ├── Security (authentication, authorization)
           │   ├── Scalability (indexing, caching)
           │   ├── Availability (uptime, error handling)
           │   └── Usability (UX requirements)
           │
           └─► Output: m*-non-functional-requirements.md

3. INDEX GENERATION
   │
   └─► Create master index.md
           ├── Module overview tables
           ├── Sprint mapping
           ├── FR references
           └── Collections (Payload CMS)
```

---

## 🎯 DETAILED OUTPUT STRUCTURE

### A. User Stories Document Structure

```markdown
# Module X: [Name] - User Stories Chi Tiết

> **Vị trí file:** ...
> **Module:** M[X]
> **Mục đích:** Chi tiết hóa User Stories...

---

## 1. [Group Name] (Mx.X)

### US-Mx.X.X: [Feature Name]

| Thuộc tính | Chi tiết |
|------------|-----------|
| **Actor** | [Who] |
| **Preconditions** | [What must be true before] |
| **Trigger** | [What starts the flow] |
| **Main Flow** | 1. [Step 1] ... |
| **Alternative Flows** | A1: [Condition] → [Action] |
| **Postconditions** | [What is true after] |
| **Business Rules** | [Constraints] |

---

## 2. Dependencies & References

| US | Module | Feature ID |
|----|--------|------------|
| ... | ... | ... |

---

## 3. Acceptance Criteria

- [ ] Criteria 1
- [ ] Criteria 2
```

### B. Functional Requirements Document Structure

```markdown
# Module X: [Name] - Functional Requirements

## FR-X: [Requirement Name]

### FR-X.Y: [Sub-requirement]

| Thuộc tính | Chi tiết |
|------------|-----------|
| **FR-ID** | FR-X.Y |
| **Tên** | [Name] |
| **Mô tả** | [Description] |
| **Priority** | [P1-P4] |
| **User Story** | [US-Mx.X.X] |

#### X.Y.1 Input Specification

| Field | Type | Required | Validation Rules |
|-------|------|----------|-----------------|
| ... | ... | ... | ... |

#### X.Y.2 Output Specification

| Response | Format | Description |
|----------|--------|-------------|
| ... | ... | ... |

#### X.Y.3 Processing Rules

1. Step 1...
2. Step 2...

---

## Error Codes

| Code | Message | HTTP Status |
|------|---------|-------------|
| ... | ... | ... |

---

## API Endpoints

| FR | Method | Endpoint |
|----|--------|----------|
| ... | ... | ... |
```

### C. Non-Functional Requirements Document Structure

```markdown
# Module X: [Name] - Non-Functional Requirements

## 1. Performance Requirements

### 1.1 Response Time

| Metric | Target | Measurement |
|--------|--------|-------------|
| ... | ... | ... |

### 1.2 Throughput

| Scenario | Target |
|----------|--------|
| ... | ... |

---

## 2. Security Requirements

### 2.1 Authentication

| Requirement | Specification |
|-------------|--------------|
| ... | ... |

---

## 3. Scalability Requirements

...

## 4. Summary Matrix

| Category | Requirement | Priority |
|----------|-------------|----------|
| ... | ... | ... |
```

---

## 🔄 SKILL ARCHITECT + PLANNER + BUILDER INTEGRATION

### How the 3-Skill System Works

```
┌─────────────────────────────────────────────────────────────────────┐
│                    MASTER SKILL SUITE                                 │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│    SKILL     │────▶│    SKILL     │────▶│    SKILL     │
│  ARCHITECT   │     │   PLANNER    │     │   BUILDER    │
└──────────────┘     └──────────────┘     └──────────────┘
        │                    │                    │
        ▼                    ▼                    ▼
   design.md             todo.md             skill files
   (10 sections)        (5 sections)        (ready to use)
```

### Skill Architect (design phase)

**Purpose**: Design the skill architecture

**Input**: User requirements (what they want to automate)

**Output**: `.skill-context/{skill-name}/design.md`

**Key Sections** (§1-§10):
- §1: Problem Statement
- §2: Capability Map (3 Pillars)
- §3: Zone Mapping (files to create)
- §4: Folder Structure (mindmap)
- §5: Execution Flow (sequence diagram)
- §6: Interaction Points (when to ask user)
- §7: Progressive Disclosure Plan (Tier 1/2 files)
- §8: Risks & Blind Spots
- §9: Open Questions
- §10: Metadata

### Skill Planner (planning phase)

**Purpose**: Create implementation plan from design

**Input**: design.md from Architect

**Output**: `.skill-context/{skill-name}/todo.md`

**Key Sections**:
- 1. Pre-requisites (what knowledge needed)
- 2. Phase Breakdown (tasks with trace tags)
- 3. Knowledge & Resources Needed
- 4. Definition of Done
- 5. Notes

### Skill Builder (implementation phase)

**Purpose**: Build the actual skill files

**Input**: design.md + todo.md from Architect and Planner

**Output**: Complete skill files in `.agent/skills/{skill-name}/`

**Key Outputs**:
- SKILL.md (core persona + workflow)
- knowledge/*.md (domain knowledge)
- templates/*.template (output formats)
- scripts/*.py (automation)
- loop/*.md (checklists)
- data/*.yaml (config)

---

## 📋 CREATING FR DOCUMENT GENERATOR SKILL

### Proposed Design for FR Generator Skill

Based on this session, here's how to create the skill:

#### 1. Skill Metadata

```
Name: fr-document-generator
Description: Tự động sinh tài liệu FR (User Stories, Functional Req, Non-Functional Req) từ input documents
Trigger: "generate FR", "tao tai lieu FR", "xay dung tai lieu chuc nang"
```

#### 2. Input Files (Expected)

| File | Purpose |
|------|---------|
| feature-map-and-priority.md | Module mapping, features, priorities |
| user-stories.md | High-level user stories |
| requirements-srs.md | Basic FR/NFR list |

#### 3. Output Files (Generated)

For each module (M1-M6):
- `{module}-user-stories.md`
- `{module}-functional-requirements.md`
- `{module}-non-functional-requirements.md`
- index.md (master)

#### 4. Processing Logic

```
INPUT PARSING
├── Extract modules from feature-map
├── Extract features per module
├── Extract FR references
└── Extract sprint priorities

DOCUMENT GENERATION
├── For each module:
│   ├── Generate detailed user stories
│   │   ├── Actor identification
│   │   ├── Preconditions
│   │   ├── Main/Alternative flows
│   │   ├── Postconditions
│   │   └── Business rules
│   │
│   ├── Generate functional requirements
│   │   ├── Input specifications
│   │   ├── Output specifications
│   │   ├── Processing rules
│   │   └── Validation rules
│   │
│   └── Generate non-functional requirements
│       ├── Performance
│       ├── Security
│       ├── Scalability
│       └── Usability
│
└── Generate master index
```

#### 5. Zone Mapping

| Zone | Files to Create | Content |
|------|-----------------|----------|
| Core (SKILL.md) | SKILL.md | Persona, workflow, triggers |
| Knowledge | knowledge/structure.md | Input/output formats |
| Templates | templates/user-stories.template | US template |
| Templates | templates/functional-req.template | FR template |
| Templates | templates/non-functional-req.template | NFR template |
| Loop | loop/verify-checklist.md | Quality checks |

---

## 🔗 INTEGRATION WITH EXISTING SKILLS

### Skills Connected to FR Generator

| Skill | Integration Point | Purpose |
|-------|-------------------|---------|
| class-diagram-analyst | Input: schema-design.md | Generate DB schema |
| flow-design-analyst | Input: user stories | Create process flows |
| sequence-design-analyst | Input: FR | Create API sequences |
| activity-diagram-design-analyst | Input: flows | Create activity diagrams |
| ui-architecture-analyst | Input: specs | Generate UI specs |
| ui-pencil-drawer | Input: UI specs | Draw wireframes |
| schema-design-analyst | Input: FR | Design database |

### Pipeline Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DOCUMENT PIPELINE                                   │
└─────────────────────────────────────────────────────────────────────┘

INPUT DOCUMENTS
       │
       ▼
┌──────────────────────────────────────────────────────────────────┐
│                    FR DOCUMENT GENERATOR                            │
│  (skill: fr-document-generator)                                  │
│                                                                   │
│  Input: feature-map, user-stories, requirements-srs              │
│  Output: m*-user-stories.md, m*-functional-requirements.md,      │
│          m*-non-functional-requirements.md, index.md             │
└──────────────────────────────────────────────────────────────────┘
       │
       ├──────────────────┬──────────────────┬──────────────────┐
       ▼                  ▼                  ▼                  ▼
┌─────────────┐   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│    CLASS    │   │    FLOW     │   │   SEQUENCE  │   │    UI       │
│   DIAGRAM   │   │   ANALYST   │   │   ANALYST   │   │  ANALYST    │
│             │   │             │   │             │   │             │
│ Input:      │   │ Input:      │   │ Input:      │   │ Input:      │
│ schema-     │   │ user-       │   │ functional  │   │ specs       │
│ design.md   │   │ stories.md  │   │ requirements│   │             │
└─────────────┘   └─────────────┘   └─────────────┘   └─────────────┘
       │                  │                  │                  │
       └──────────────────┴──────────────────┴──────────────────┘
                              ▼
                    ┌─────────────┐
                    │    UI       │
                    │  PENCIL     │
                    │  DRAWER     │
                    │             │
                    │ Input:      │
                    │ UI specs    │
                    └─────────────┘
```

---

## 📝 REPRODUCING IN A NEW SESSION

### Steps to Recreate

1. **Provide Input Files**
   - Upload feature-map-and-priority.md
   - Upload user-stories.md
   - Upload requirements-srs.md

2. **Define Scope**
   - Specify which modules to process (M1-M6 or subset)
   - Specify output types (US, FR, NFR, or all)

3. **For Each Module**:

   **A. User Stories Generation**
   - Read module features from feature-map
   - Read high-level US from user-stories
   - Expand each into detailed format:
     - Actor, Preconditions, Trigger
     - Main Flow (numbered steps)
     - Alternative Flows (A1, A2...)
     - Postconditions
     - Business Rules

   **B. Functional Requirements Generation**
   - Map FR references from feature-map
   - Create detailed specs:
     - Input fields with validation
     - Output formats with examples
     - Step-by-step processing rules
     - Error codes table

   **C. Non-Functional Requirements Generation**
   - Define metrics:
     - Performance (response time, throughput)
     - Security (authentication, rate limiting)
     - Scalability (indexing, caching)
     - Availability (uptime, error handling)
     - Usability (UX requirements)

4. **Generate Index**
   - Create master index with all modules
   - Include sprint mapping
   - Include FR references

---

## ✅ QUALITY CHECKLIST

When generating FR documents, ensure:

- [ ] All features from feature-map are covered
- [ ] User stories have complete flow (Actor → Pre → Main → Alt → Post)
- [ ] Functional requirements have Input/Output/Processing sections
- [ ] Error codes are defined with HTTP status
- [ ] API endpoints are documented
- [ ] Non-functional requirements are measurable
- [ ] Index links to all files correctly

---

## 📚 REFERENCE

### Skills for Complete Pipeline

```
.skills/
├── fr-document-generator       # THIS SKILL (to be created)
├── class-diagram-analyst       # Schema from FR
├── flow-design-analyst         # Process flows from US
├── sequence-design-analyst     # API sequences from FR
├── activity-diagram-design-analyst # Activities from flows
├── schema-design-analyst       # DB design from FR
├── ui-architecture-analyst      # UI specs from specs
├── ui-pencil-drawer            # Wireframes from UI specs
├── skill-architect             # Design skill architecture
├── skill-planner               # Plan implementation
└── skill-builder               # Build the skill
```

---

*Document created to capture the complete process for reproducing FR document generation in any future session.*
