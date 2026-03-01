#!/usr/bin/env python3
"""
Parse and validate pipeline.yaml

Usage:
    python parse_pipeline.py <pipeline.yaml>
"""

import sys
import yaml
import json
from pathlib import Path


def load_pipeline_config(path: str) -> dict:
    """Load and validate pipeline.yaml"""
    with open(path, 'r') as f:
        config = yaml.safe_load(f)

    required_fields = ['pipeline_name', 'stages']
    for field in required_fields:
        if field not in config:
            raise ValueError(f"Missing required field: {field}")

    # Validate stages
    for stage in config['stages']:
        if 'id' not in stage:
            raise ValueError("Stage missing 'id' field")
        if 'skill' not in stage:
            raise ValueError(f"Stage {stage['id']} missing 'skill' field")

    return config


def find_runnable_stages(config: dict, completed: list) -> list:
    """Find stages that can run (dependencies satisfied)"""
    runnable = []

    for stage in config['stages']:
        stage_id = stage['id']

        # Skip already completed
        if stage_id in completed:
            continue

        # Check dependencies
        depends_on = stage.get('depends_on', [])
        if all(dep in completed for dep in depends_on):
            runnable.append(stage)

    return runnable


def resolve_variables(config: dict, context: dict) -> dict:
    """Resolve {} placeholders in config"""
    config_str = json.dumps(config)

    for key, value in context.items():
        placeholder = f"{{{key}}}"
        config_str = config_str.replace(placeholder, str(value))

    return json.loads(config_str)


def main():
    if len(sys.argv) < 2:
        print("Usage: parse_pipeline.py <pipeline.yaml>")
        sys.exit(1)

    path = sys.argv[1]

    try:
        config = load_pipeline_config(path)
        print(f"✅ Pipeline loaded: {config['pipeline_name']}")
        print(f"   Stages: {len(config['stages'])}")

        # Show stages
        for stage in config['stages']:
            deps = stage.get('depends_on', [])
            print(f"   - {stage['id']}: {stage['skill']} (depends: {deps})")

    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
