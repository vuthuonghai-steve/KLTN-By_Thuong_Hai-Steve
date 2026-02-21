#!/usr/bin/env python3
"""Package a skill directory into a zip archive after validation."""

from __future__ import annotations

import sys
import zipfile
from pathlib import Path

from quick_validate import validate


def package_skill(skill_path: Path, output_dir: Path | None = None) -> Path:
    skill_path = skill_path.resolve()
    if not skill_path.exists() or not skill_path.is_dir():
        raise FileNotFoundError(f"Skill directory not found: {skill_path}")

    passed, errors, warnings = validate(skill_path)
    for warning in warnings:
        print(f"WARNING: {warning}")

    if not passed:
        details = "\n".join(f"- {err}" for err in errors)
        raise ValueError(f"Validation failed:\n{details}")

    output_root = output_dir.resolve() if output_dir else Path.cwd().resolve()
    output_root.mkdir(parents=True, exist_ok=True)

    archive = output_root / f"{skill_path.name}.zip"
    with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as zipf:
        for file_path in skill_path.rglob("*"):
            if file_path.is_file():
                arcname = file_path.relative_to(skill_path.parent)
                zipf.write(file_path, arcname)

    return archive


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: package_skill.py <path/to/skill-folder> [output-directory]")
        return 1

    skill_dir = Path(sys.argv[1]).expanduser()
    output_dir = Path(sys.argv[2]).expanduser() if len(sys.argv) > 2 else None

    try:
        archive = package_skill(skill_dir, output_dir)
    except Exception as exc:
        print(f"FAIL: {exc}")
        return 1

    print(f"PASS: Packaged skill at {archive}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
