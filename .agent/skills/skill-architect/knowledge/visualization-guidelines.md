# Visualization & Diagram Guidelines

This guide defines how to create effective, concrete, and unambiguous architecture diagrams for Agent Skills. Use these when designing a new skill to ensure clarity for both humans and AI.

## Principle: "Show, then explain"

For each major concept, FIRST draw a diagram, THEN add a table or text that explains details the diagram cannot convey. Never replace a diagram with a table.

## Diagram Types & When to Use

| #  | Diagram Type       | Mermaid Syntax  | Use When                                          |
| -- | ------------------ | --------------- | ------------------------------------------------- |
| D1 | **Folder Structure** | `mindmap`     | ALWAYS — show the skill's directory tree           |
| D2 | **Execution Flow**   | `sequenceDiagram` | ALWAYS — show runtime interaction between participants |
| D3 | **Workflow Phases**  | `flowchart LR` | Skill has multi-phase workflow with clear stages   |
| D4 | **Relationship**     | `flowchart TD` | Skill connects to external systems or other skills |
| D5 | **Data Flow**        | `flowchart LR` | Skill transforms data through multiple stages      |

## Mermaid Skeletons

Use these as starting points. Adapt them to the specific skill being designed.

### D1 — Folder Structure (Mindmap)
```mermaid
mindmap
  root((skill-name))
    SKILL.md
      Persona
      Phases
      Guardrails
    knowledge
      domain-ref.md
    scripts
      tool.py
    templates
      output.md.template
    loop
      checklist.md
```

### D2 — Execution Flow (Sequence)
```mermaid
sequenceDiagram
    participant U as User
    participant S as Skill
    participant K as Knowledge
    participant L as Loop

    U->>S: Input
    S->>K: Read references
    S->>S: Process
    S->>L: Self-verify
    alt Pass
        S->>U: Output
    else Fail
        L-->>S: Retry
    end
```

### D3 — Workflow Phases (Flowchart)
```mermaid
flowchart LR
    P1[Phase 1] -->|gate| P2[Phase 2] -->|gate| P3[Phase 3]
    P1 -.-> I1[Interaction Point]
    P2 -.-> I2[Interaction Point]
    P3 -.-> I3[Output Gate]
```

### D4 — Relationship (Flowchart)
```mermaid
flowchart TD
    User -->|input| SkillA
    SkillA -->|output| ContextDir
    ContextDir -->|input| SkillB
    SkillB -->|output| FinalProduct
```

## Quality Checklist for Diagrams

- [ ] Each diagram has a clear title or is placed under a descriptive heading.
- [ ] Participants/nodes use short, readable labels.
- [ ] Decision points (alt/else, diamond nodes) are visible where logic branches.
- [ ] Interaction points with user are explicitly marked.
- [ ] Diagram renders correctly in standard Mermaid (no unsupported syntax).
