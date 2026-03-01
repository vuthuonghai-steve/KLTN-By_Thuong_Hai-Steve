---
name: pipeline-runner
description: Orchestrates multi-stage skill pipelines by spawning sub-agents sequentially. Use when you need to run multiple skills automatically with dependency management, validation gates, and checkpoint support.
trigger_patterns:
  - "/pipeline-runner <path>"
  - "/uml-pipeline <path>"
  - "chạy pipeline"
  - "run pipeline"
  - "generate uml"
---

# Pipeline Runner — Orchestrator Skill

## Mission

**Persona:** Pipeline Orchestrator. Automatically chain and execute multiple skills in sequence, managing dependencies, validation, and state persistence.

## Boot Sequence

1. Read this `SKILL.md` (Core orchestration logic).
2. Read `knowledge/pipeline-config.md` — Pipeline YAML schema.
3. Read `.skill-context/{pipeline_name}/pipeline.yaml` — User's pipeline definition.
4. Read `.skill-context/{pipeline_name}/_queue.json` — Runtime state (if resuming).

*Additional files load per-step below (Progressive Disclosure).*

---

## Workflow Phases

### Phase 1: INIT — Initialize Pipeline

1. Read pipeline.yaml to get stages, dependencies, checkpoints.
2. Validate all skills referenced exist in skills.yaml.
3. Create or resume _queue.json with status tracking.
4. Notify user: pipeline start, stage count, first stage.

### Phase 2: EXECUTE — Run Stage Loop

For each stage (in dependency order):

1. **Find Runnable**: Check if all dependencies are COMPLETED.
2. **Prepare Task**: Create task-input.json in .skill-context/{pipeline}/tasks/
3. **Spawn Sub-agent**: Use Task tool to invoke skill-executor agent with task spec.
4. **Execute**: skill-executor runs the skill with isolated context.
5. **Validate**: Run validation_script, check exit code = 0.
6. **Update Queue**: Write _queue.json with COMPLETED or FAILED.
7. **Checkpoint**: If checkpoint=true, pause and ask user to continue.

### Phase 3: COMPLETE — Finalize

1. Generate summary.md with all outputs.
2. Report completion to user.

---

## Interaction Points (Gates)

| Gate | When | Action |
|------|------|--------|
| **Pipeline Start** | Before INIT | Show: pipeline name, stages, input |
| **Checkpoint** | After stage with checkpoint=true | Ask: "Continue / Stop / View Details" |
| **Validation Failed** | After stage fails | Ask: "Retry / Skip / Stop" |
| **Skill Not Found** | During validation | Ask: "Select alternative / Stop" |
| **Pipeline Complete** | After all stages | Show: summary path, all outputs |

---

## Guardrails

| ID | Rule | Mechanism |
|----|------|----------|
| G1 | Dependency Enforcement | Only run stage when all depends_on are COMPLETED |
| G2 | Validation Gate | Hard stop if exit code != 0 |
| G3 | Checkpoint Pause | Pause at checkpoint=true stages |
| G4 | Atomic State | Write _queue.tmp first, then rename to _queue.json |
| G5 | Source Citation | Require each skill cite input from previous stage |

---

## Progressive Disclosure

### Tier 1: Always Load
- SKILL.md (this file)
- knowledge/pipeline-config.md

### Tier 2: Per-Stage
- Current skill's SKILL.md (when spawning sub-agent)
- knowledge/error-codes.md (when error occurs)

### Tier 3: Debug
- loop/checklist.md (when verifying quality)
- scripts/resume_pipeline.py (when resuming failed pipeline)

---

## Quick Trigger

### Command Patterns

```
/pipeline-runner <input-path>     # Run pipeline with input path
/uml-pipeline <input-path>       # Quick UML generation shortcut
```

### Example Usage

```bash
# Generate UML from FR docs
/pipeline-runner Docs/life-1/01-vision/FR/

# Resume failed pipeline
/pipeline-runner --resume

# Check status
/pipeline-runner --status
```

---

## Reference

See TRIGGER.md for full trigger documentation.
See templates/pipeline-uml-generation.yaml for example pipeline config.
