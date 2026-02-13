#!/usr/bin/env python3
"""Quick validator for standalone master-skill structure and lifecycle artifacts."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


REQUIRED_FILES = [
    "SKILL.md",
    "DESIGN.md",
    "TASK.md",
    "VERIFY_REPORT.md",
    "knowledge/architect.md",
    "knowledge/standards.md",
    "loop/roadmap.md",
    "loop/checklist.md",
    "loop/tasks.md",
    "scripts/init_skill.py",
    "scripts/quick_validate.py",
    "templates/DESIGN.md.template",
    "templates/TASK.md.template",
    "templates/VERIFY_REPORT.md.template",
]

REQUIRED_SECTIONS = {
    "SKILL.md": [
        "## Mandatory Boot Sequence",
        "## Standalone Intent Router",
        "## Ana-Skill Phase",
        "## Task-Skill Phase",
        "## Moni-Skill Phase",
        "## Phase Gates",
        "## Response Contract",
        "## Done Definition",
        "Using Session",
        "Next Step",
    ],
    "DESIGN.md": [
        "## 1. Problem Statement",
        "## 2. Goals / Non-Goals",
        "## 3. User Scenarios",
        "## 4. Capability Map",
        "## 5. Workflow & Gates",
        "## 6. 7-Zone File Plan",
        "## 7. Risks & Mitigations",
        "## 8. Open Questions",
        "## 9. Changelog",
    ],
    "TASK.md": [
        "## 1. Execution Phases",
        "## 2. Task Checklist",
        "## 3. Input/Output per Task Group",
        "## 4. Definition of Done",
        "## 5. Dependency & Blocker Log",
        "## 6. Progress Summary",
    ],
    "VERIFY_REPORT.md": [
        "## 1. Completeness",
        "## 2. Correctness",
        "## 3. Coherence",
        "## 4. Issues by severity",
        "## 5. Final Assessment",
    ],
}

LEGACY_SCAN_FILES = [
    "SKILL.md",
    "DESIGN.md",
    "TASK.md",
    "VERIFY_REPORT.md",
    "knowledge/standards.md",
    "loop/roadmap.md",
    "loop/tasks.md",
    "loop/checklist.md",
    "scripts/init_skill.py",
]

POLICY_SCAN_FILES = [
    "SKILL.md",
    "DESIGN.md",
    "TASK.md",
    "VERIFY_REPORT.md",
    "knowledge/standards.md",
    "loop/roadmap.md",
    "loop/tasks.md",
]

FORBIDDEN_ARCHIVE_OVERRIDE_TOKENS = [
    "obtain explicit user acceptance",
    "obtain explicit warning acceptance",
    "pending explicit user confirmation to archive",
    "wait for explicit user confirmation",
    "confirm archive decision and close gate e",
    "confirm archive decision with user",
]


def build_legacy_tokens() -> list[str]:
    removed_ns = "op" + "sx"
    removed_cmd_prefix = "/" + "op" + "sx" + ":"
    removed_ss_migration_residue_1 = "/" + "m" + "s" + ":"
    removed_ss_migration_residue_2 = "/" + "m" + "s" + " commands"
    removed_ss_migration_residue_3 = "Use /" + "m" + "s" + ":* commands instead."
    removed_field_1 = "Using " + "Change"
    removed_field_2 = "Next " + "Command"
    return [
        removed_ns,
        removed_cmd_prefix,
        removed_ss_migration_residue_1,
        removed_ss_migration_residue_2,
        removed_ss_migration_residue_3,
        removed_field_1,
        removed_field_2,
    ]


def has_valid_frontmatter(skill_md: str) -> tuple[bool, str]:
    if not skill_md.startswith("---\n"):
        return False, "SKILL.md missing YAML frontmatter"

    match = re.match(r"^---\n(.*?)\n---\n", skill_md, re.DOTALL)
    if not match:
        return False, "SKILL.md has invalid YAML frontmatter format"

    frontmatter = match.group(1)
    if "name:" not in frontmatter:
        return False, "SKILL.md frontmatter missing 'name'"
    if "description:" not in frontmatter:
        return False, "SKILL.md frontmatter missing 'description'"

    return True, "OK"


def check_required_files(root: Path) -> list[str]:
    errors: list[str] = []
    for relative_path in REQUIRED_FILES:
        file_path = root / relative_path
        if not file_path.exists():
            errors.append(f"Missing required file: {relative_path}")
    return errors


def check_required_sections(root: Path) -> list[str]:
    errors: list[str] = []
    for relative_path, headings in REQUIRED_SECTIONS.items():
        file_path = root / relative_path
        if not file_path.exists():
            continue

        content = file_path.read_text(encoding="utf-8")
        for heading in headings:
            if heading not in content:
                errors.append(f"Missing section/content '{heading}' in {relative_path}")
    return errors


def check_legacy_residue(root: Path) -> list[str]:
    errors: list[str] = []
    legacy_tokens = build_legacy_tokens()

    for relative_path in LEGACY_SCAN_FILES:
        file_path = root / relative_path
        if not file_path.exists():
            continue

        content = file_path.read_text(encoding="utf-8")
        for token in legacy_tokens:
            if token in content:
                errors.append(f"Legacy residue detected in {relative_path}: {token}")
    return errors


def check_archive_policy_residue(root: Path) -> list[str]:
    errors: list[str] = []

    for relative_path in POLICY_SCAN_FILES:
        file_path = root / relative_path
        if not file_path.exists():
            continue

        content = file_path.read_text(encoding="utf-8").lower()
        for token in FORBIDDEN_ARCHIVE_OVERRIDE_TOKENS:
            if token in content:
                errors.append(f"Archive override residue detected in {relative_path}: {token}")
    return errors


def validate(root: Path) -> tuple[bool, list[str], list[str]]:
    errors: list[str] = []
    warnings: list[str] = []

    errors.extend(check_required_files(root))
    errors.extend(check_required_sections(root))
    errors.extend(check_legacy_residue(root))
    errors.extend(check_archive_policy_residue(root))

    skill_md_path = root / "SKILL.md"
    if skill_md_path.exists():
        ok, message = has_valid_frontmatter(skill_md_path.read_text(encoding="utf-8"))
        if not ok:
            errors.append(message)

    package_script = root / "scripts/package_skill.py"
    if not package_script.exists():
        warnings.append("Recommended file missing: scripts/package_skill.py")

    return len(errors) == 0, errors, warnings


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Validate standalone master-skill structure and migration rules.")
    parser.add_argument("skill_dir", nargs="?", default=".", help="Path to skill root. Defaults to current directory.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    root = Path(args.skill_dir).expanduser().resolve()

    if not root.exists() or not root.is_dir():
        print(f"FAIL: skill directory not found: {root}")
        return 1

    passed, errors, warnings = validate(root)

    for warning in warnings:
        print(f"WARNING: {warning}")

    if passed:
        print(f"PASS: Validation succeeded for {root}")
        return 0

    print(f"FAIL: Validation failed for {root}")
    for error in errors:
        print(f"  - {error}")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
