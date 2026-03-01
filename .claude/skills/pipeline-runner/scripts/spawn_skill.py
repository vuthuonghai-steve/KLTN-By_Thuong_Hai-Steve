#!/usr/bin/env python3
"""
Task Preparation Helper for Pipeline Runner

NOTE: This script prepares task spec for Claude Code's Task tool.
      Actual spawning is done by Claude Code (not Python).

Usage:
    python spawn_skill.py <task-input.json>
"""

import sys
import json
import subprocess
from pathlib import Path


def spawn_subagent(task_input: dict) -> dict:
    """Spawn sub-agent to execute skill"""

    skill_name = task_input['skill_name']
    skill_path = task_input.get('skill_path')
    input_data = task_input.get('input', {})
    output_dir = task_input.get('output', {}).get('target_dir')

    # Build prompt for sub-agent
    prompt = f"""Execute skill: {skill_name}

Task Input:
{json.dumps(input_data, indent=2)}

Output Directory: {output_dir}

Read the skill definition from: {skill_path}
Execute the skill and write results to the designated output directory.
"""

    # NOTE: This returns the prompt for Claude Code's Task tool to use.
    # Claude Code will invoke skill-executor agent via Task tool automatically.
    return {
        'status': 'PREPARED_FOR_TASK_TOOL',
        'skill': skill_name,
        'prompt': prompt,
        'agent': 'skill-executor'
    }


def find_skill_path(skill_name: str) -> str:
    """Find skill SKILL.md path"""

    search_paths = [
        f'.claude/skills/{skill_name}/SKILL.md',
        f'.agent/skills/{skill_name}/SKILL.md',
        f'.codex/skills/{skill_name}/SKILL.md',
    ]

    for path in search_paths:
        if Path(path).exists():
            return path

    return None


def main():
    if len(sys.argv) < 2:
        print("Usage: spawn_skill.py <task-input.json>")
        sys.exit(1)

    path = sys.argv[1]

    with open(path, 'r') as f:
        task_input = json.load(f)

    # Find skill path
    skill_path = task_input.get('skill_path')
    if not skill_path:
        skill_path = find_skill_path(task_input['skill_name'])

    if not skill_path:
        print(f"❌ Skill not found: {task_input['skill_name']}")
        sys.exit(1)

    task_input['skill_path'] = skill_path

    # Spawn sub-agent
    result = spawn_subagent(task_input)

    print(f"✅ Spawned: {result['skill']}")
    print(f"   Prompt length: {len(result['prompt'])} chars")


if __name__ == "__main__":
    main()
