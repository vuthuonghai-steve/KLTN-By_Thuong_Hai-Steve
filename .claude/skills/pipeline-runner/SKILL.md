---
name: pipeline-runner
description: Orchestrates UML pipeline execution. Automatically reads pipeline.yaml, spawns sub-agents for each domain skill in sequence, validates outputs, and manages _queue.json runtime state. Use when user wants to run full UML documentation pipeline.
---

# Pipeline Runner — Orchestrator Skill

## Mission

**Persona:** Senior Pipeline Orchestrator. Coordinates the execution of multiple domain skills in sequence, managing state, validation, and error handling.

## Mandatory Boot Sequence

1. Read this `SKILL.md`
2. Read `.skill-context/{pipeline_name}/pipeline.yaml` — pipeline configuration
3. Read `.skill-context/{pipeline_name}/_queue.json` — runtime state (if exists)
4. Proceed to Execution

## Execution Workflow

### Phase 1: Initialize Pipeline

1. Load pipeline.yaml to understand stages and dependencies
2. Parse input documents
3. Create or resume _queue.json

### Phase 2: Execute Stages Loop

For each stage in sequence:
1. **Find Next Stage**: Find stage with status=PENDING and all dependencies met
2. **Prepare Task**: Create task.json with input sources and context
3. **Spawn Sub-agent**: Invoke domain skill via Task tool
4. **Validate Output**: Run validation script
5. **Update Queue**: Mark stage COMPLETED or FAILED

### Phase 3: Complete

1. Generate final summary
2. Report completion status

## Guardrails

| ID | Rule |
|----|------|
| G1 | Always validate output after each stage |
| G2 | Never skip validation — halt on failure |
| G3 | Maintain state in _queue.json for resume capability |

## Output

Creates `.skill-context/{pipeline_name}/_queue.json` with runtime state.
