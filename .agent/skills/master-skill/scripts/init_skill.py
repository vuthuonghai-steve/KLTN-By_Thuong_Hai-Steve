#!/usr/bin/env python3
"""Initialize a standalone lifecycle skill skeleton."""

from __future__ import annotations

import argparse
from datetime import date
from pathlib import Path


SKILL_TEMPLATE = """---
name: {skill_name}
description: Orchestrate lifecycle-driven delivery for {skill_name} with standalone intent routing, session tracking, and deterministic verification.
---

# {skill_title}

## Mission
Convert user intent into a controlled standalone lifecycle:
`IDEA -> DESIGN.md -> TASK.md -> IMPLEMENTATION -> VERIFY_REPORT.md -> ARCHIVE`.

## Mandatory Boot Sequence
1. Read `knowledge/architect.md`.
2. Read `knowledge/standards.md`.
3. Read `loop/roadmap.md`.
4. Resolve intent via natural language first, then optional `/ss:*` command hints.

## Standalone Intent Router
- Natural language intent (primary).
- Optional command triggers (secondary):
  - `/ss:explore`
  - `/ss:new-session`
  - `/ss:ff`
  - `/ss:continue`
  - `/ss:apply`
  - `/ss:verify`
  - `/ss:archive`
- External namespace policy: reject unsupported external commands and return migration hint to `/ss:*`.

## Ana-Skill Phase
1. Build `DESIGN.md`.
2. Record risks and open questions.
3. Sync decisions to `loop/roadmap.md`.

## Task-Skill Phase
1. Build `TASK.md`.
2. Break work into phases and checklist items.
3. Sync execution plan to `loop/tasks.md`.

## Moni-Skill Phase
1. Build `VERIFY_REPORT.md`.
2. Classify issues by severity.
3. Sync pass/fail state to `loop/checklist.md`.

## Response Contract
Return exactly eight sections:
1. Mode
2. Using Session
3. Phase Focus
4. Action Taken
5. Files Created/Updated
6. Remaining Gaps
7. Risks / Blockers
8. Next Step

## Done Definition
Mark completion only after required files exist, validation passes, and user confirms final closure.
"""


DESIGN_TEMPLATE = """# DESIGN.md

## 1. Problem Statement

## 2. Goals / Non-Goals
### Goals
- 

### Non-Goals
- 

## 3. User Scenarios
1. 

## 4. Capability Map
- 

## 5. Workflow & Gates
- Gate A:
- Gate B:
- Gate C:
- Gate D:
- Gate E:

## 6. 7-Zone File Plan
1. Core:
2. Knowledge:
3. Scripts:
4. Templates:
5. Data:
6. Loop:
7. Assets:

## 7. Risks & Mitigations
- Risk:
- Mitigation:

## 8. Open Questions
1. 

## 9. Changelog
- {today}: Initialized.
"""


TASK_TEMPLATE = """# TASK.md

## 1. Execution Phases
- Phase 1:
- Phase 2:

## 2. Task Checklist
- [ ] 

## Session Context
- Session Name:
- Session Mode:
- Trigger Strategy:

## 3. Input/Output per Task Group
- Group A Input:
- Group A Output:

## 4. Definition of Done
- 

## 5. Dependency & Blocker Log
- Dependency:
- Blocker:

## 6. Progress Summary
- Total tasks: 0
- Completed: 0
- Remaining: 0
- Status: Draft
- Next Step:
"""


VERIFY_TEMPLATE = """# VERIFY_REPORT.md

## Session Context
- Session Name:
- Session Mode:

## 1. Completeness
Status: PENDING

## 2. Correctness
Status: PENDING

## 3. Coherence
Status: PENDING

## 4. Issues by severity
### CRITICAL
- Pending verification.

### WARNING
- None.

### SUGGESTION
- None.

## 5. Final Assessment
Not Ready for archive.

## Next Step
Define next action.
"""


ARCHITECT_TEMPLATE = """# Architect Notes

Document architecture constraints, zone map, and workflow invariants.
"""


STANDARDS_TEMPLATE = """# Standards

- Use imperative voice.
- Route intent by natural language first, then optional `/ss:*` command hints.
- Maintain lifecycle traceability across design, task, implementation, and verification.
- Block archive while any CRITICAL issue exists in verification output.
- Keep validation deterministic through scripts.
"""


ROADMAP_TEMPLATE = """# Roadmap

## Session Metadata
- Session Name: TODO
- Session Mode: TODO
- Trigger Strategy: natural-language-first + optional /ss:*

## Gate Status
- Gate A: TODO
- Gate B: TODO
- Gate C: TODO
- Gate D: TODO
- Gate E: TODO

## Change Log
- {today}: Initialized roadmap.
"""


CHECKLIST_TEMPLATE = """# Verification Checklist

## Completeness
- [ ] Required files exist

## Correctness
- [ ] Validation script passes
- [ ] Legacy routing residue check is clean

## Coherence
- [ ] Design-task-code links are documented
"""


TASKS_LOOP_TEMPLATE = """# Loop Task State

## Active Session
- Session Name: TODO
- Session Mode: TODO
- Trigger Strategy: natural-language-first + optional /ss:*

## Phase Tracker
- [ ] Phase 1
- [ ] Phase 2
"""


DESIGN_MD_TEMPLATE = """# DESIGN.md

## 1. Problem Statement
{{problem_statement}}

## 2. Goals / Non-Goals
### Goals
- {{goal_1}}

### Non-Goals
- {{non_goal_1}}

## 3. User Scenarios
1. {{scenario_1}}

## 4. Capability Map
- {{capability_1}}

## 5. Workflow & Gates
- Gate A: {{gate_a}}
- Gate B: {{gate_b}}
- Gate C: {{gate_c}}
- Gate D: {{gate_d}}
- Gate E: {{gate_e}}

## 6. 7-Zone File Plan
1. Core: {{core_files}}
2. Knowledge: {{knowledge_files}}
3. Scripts: {{script_files}}
4. Templates: {{template_files}}
5. Data: {{data_files}}
6. Loop: {{loop_files}}
7. Assets: {{asset_files}}

## 7. Risks & Mitigations
- Risk: {{risk_1}}
- Mitigation: {{mitigation_1}}

## 8. Open Questions
1. {{question_1}}

## 9. Changelog
- {{date}}: {{change_note}}
"""


TASK_MD_TEMPLATE = """# TASK.md

## 1. Execution Phases
- Phase 1: {{phase_1}}
- Phase 2: {{phase_2}}

## 2. Task Checklist
- [ ] {{task_1}}
- [ ] {{task_2}}

## Session Context
- Session Name: {{session_name}}
- Session Mode: {{session_mode}}
- Trigger Strategy: {{trigger_strategy}}

## 3. Input/Output per Task Group
- Group A Input: {{group_a_input}}
- Group A Output: {{group_a_output}}

## 4. Definition of Done
- {{dod_1}}
- {{dod_2}}

## 5. Dependency & Blocker Log
- Dependency: {{dependency_1}}
- Blocker: {{blocker_1}}

## 6. Progress Summary
- Total tasks: {{total_tasks}}
- Completed: {{completed_tasks}}
- Remaining: {{remaining_tasks}}
- Status: {{status}}
- Next Step: {{next_step}}
"""


VERIFY_MD_TEMPLATE = """# VERIFY_REPORT.md

## Session Context
- Session Name: {{session_name}}
- Session Mode: {{session_mode}}

## 1. Completeness
Status: {{completeness_status}}
- {{completeness_evidence_1}}

## 2. Correctness
Status: {{correctness_status}}
- {{correctness_evidence_1}}

## 3. Coherence
Status: {{coherence_status}}
- {{coherence_evidence_1}}

## 4. Issues by severity
### CRITICAL
- {{critical_issue_or_none}}

### WARNING
- {{warning_issue_or_none}}

### SUGGESTION
- {{suggestion_issue_or_none}}

## 5. Final Assessment
{{final_assessment}}

## Next Step
{{next_step}}
"""


VALIDATOR_STUB = """#!/usr/bin/env python3
\"\"\"Run quick structure validation for this skill.\"\"\"

import sys
from pathlib import Path


def main() -> int:
    target = Path(sys.argv[1]).resolve() if len(sys.argv) > 1 else Path.cwd()
    skill_md = target / 'SKILL.md'
    if not skill_md.exists():
        print('FAIL: SKILL.md not found')
        return 1
    print('PASS: SKILL.md exists')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
"""


INIT_STUB = """#!/usr/bin/env python3
\"\"\"Local initializer placeholder. Replace with project-specific logic if needed.\"\"\"

print('Use root scripts/init_skill.py to scaffold new standalone skills.')
"""


PACKAGE_STUB = """#!/usr/bin/env python3
\"\"\"Package placeholder script.\"\"\"

print('Implement packaging workflow for this skill as needed.')
"""


def title_case(skill_name: str) -> str:
    return " ".join(part.capitalize() for part in skill_name.split("-"))


def write_file(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.rstrip() + "\n", encoding="utf-8")


def initialize_skill(skill_name: str, output_path: Path) -> Path:
    skill_dir = output_path / skill_name
    if skill_dir.exists():
        raise FileExistsError(f"Skill directory already exists: {skill_dir}")

    today = date.today().isoformat()
    files = {
        "SKILL.md": SKILL_TEMPLATE.format(skill_name=skill_name, skill_title=title_case(skill_name)),
        "DESIGN.md": DESIGN_TEMPLATE.format(today=today),
        "TASK.md": TASK_TEMPLATE,
        "VERIFY_REPORT.md": VERIFY_TEMPLATE,
        "knowledge/architect.md": ARCHITECT_TEMPLATE,
        "knowledge/standards.md": STANDARDS_TEMPLATE,
        "loop/roadmap.md": ROADMAP_TEMPLATE.format(today=today),
        "loop/checklist.md": CHECKLIST_TEMPLATE,
        "loop/tasks.md": TASKS_LOOP_TEMPLATE,
        "templates/DESIGN.md.template": DESIGN_MD_TEMPLATE,
        "templates/TASK.md.template": TASK_MD_TEMPLATE,
        "templates/VERIFY_REPORT.md.template": VERIFY_MD_TEMPLATE,
        "scripts/quick_validate.py": VALIDATOR_STUB,
        "scripts/init_skill.py": INIT_STUB,
        "scripts/package_skill.py": PACKAGE_STUB,
    }

    for relative_path, content in files.items():
        write_file(skill_dir / relative_path, content)

    for script_name in ("scripts/quick_validate.py", "scripts/init_skill.py", "scripts/package_skill.py"):
        (skill_dir / script_name).chmod(0o755)

    for directory in ("data", "assets"):
        (skill_dir / directory).mkdir(parents=True, exist_ok=True)

    return skill_dir


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Initialize a standalone master-skill compliant skeleton.")
    parser.add_argument("skill_name", help="Skill directory name (hyphen-case recommended).")
    parser.add_argument("--path", default=".", help="Base output directory. Defaults to current working directory.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    base_path = Path(args.path).expanduser().resolve()
    base_path.mkdir(parents=True, exist_ok=True)

    try:
        skill_dir = initialize_skill(args.skill_name, base_path)
    except FileExistsError as exc:
        print(f"FAIL: {exc}")
        return 1

    print(f"PASS: Initialized skill at {skill_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
