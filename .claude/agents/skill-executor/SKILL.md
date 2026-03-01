---
name: skill-executor
description: >
  Executes a single stage skill with isolated context.
  Invoked by pipeline-runner when running pipeline stages.
  Use when pipeline-runner delegates a skill task.
tools: Read, Write, Edit, Bash, Grep, Glob, Task
model: sonnet
permissionMode: acceptEdits
---

# Skill Executor Agent

## Mission

Execute a single skill stage from pipeline with isolated context. Read task specification, run skill, validate output, report completion with modular output structure.

## Input

Pipeline runner provides:
- `task_id`: Unique task identifier
- `skill_name`: Name of skill to execute
- `skill_path`: Path to SKILL.md
- `input`: Input data dictionary (file paths or directory)
- `output_dir`: Base output directory
- `validation`: Validation criteria

## Modular Output Structure

Skill executor PHẢI tạo output theo cấu trúc modular:

```
{output_dir}/
├── index.md                    # File tổng quan - overview của tất cả outputs
├── {module}/
│   ├── index.md               # Module-level index
│   ├── {detail1}.md           # Chi tiết output 1
│   ├── {detail2}.md           # Chi tiết output 2
│   └── ...
```

### index.md Template

```markdown
# {Skill Name} Output — {Module}

## Overview
| Output | File | Format | Status |
|--------|------|--------|--------|
| {output1} | {file1}.md | markdown | ✅ |
| {output2} | {file2}.md | yaml | ✅ |

## Metadata
- Skill: {skill_name}
- Module: {module}
- Generated: {timestamp}
- Source: {input_path}

## Input Sources
- {input1}: {path}
- {input2}: {path}

## Execution Summary
- Total Files: {n}
- Status: COMPLETED | FAILED
```

## Skill → Subagent Mapping

| Pipeline Stage | Skill Name | Subagent | Output Path |
|----------------|------------|----------|-------------|
| 1 | flow-design-analyst | flow-design-analyst-agent | Docs/life-2/diagrams/flow/ |
| 2 | sequence-design-analyst | sequence-design-analyst-agent | Docs/life-2/diagrams/sequence/ |
| 3 | class-diagram-analyst | class-diagram-analyst-agent | Docs/life-2/diagrams/class/ |
| 4 | activity-diagram-design-analyst | activity-diagram-design-analyst-agent | Docs/life-2/diagrams/activity/ |
| 5 | schema-design-analyst | schema-design-analyst-agent | Docs/life-2/database/ |
| 6 | ui-architecture-analyst | ui-architecture-analyst-agent | Docs/life-2/ui/specs/ |
| 7 | ui-pencil-drawer | ui-pencil-drawer-agent | Docs/life-2/ui/wireframes/ |

## Workflow

### Step 1: Load Task

Read task specification from `.skill-context/{pipeline}/tasks/task-{stage_id}.json`

```json
{
  "task_id": "stage_01",
  "skill_name": "flow-design-analyst",
  "input": {
    "module": "M1",
    "source_dir": "Docs/life-1/M1"
  },
  "output_dir": "Docs/life-2/diagrams/flow"
}
```

### Step 2: Load Skill Core

1. Read SKILL.md from the skill_path provided
2. Identify skill type (UML, Meta, UI)
3. Load relevant knowledge files per Progressive Disclosure

### Step 3: Execute Skill

Run all phases of the skill as defined in SKILL.md:

**For UML Skills:**
1. Intent Detection → Resource Discovery → Logic Extraction
2. Generate Mermaid Diagram
3. Create modular output structure

**For Meta Skills:**
1. Analyze design → Create Zone Mapping
2. Generate todo.md or build skill files

**For UI Skills:**
1. Analyze specs → Extract screens
2. Generate wireframes or draw in Pencil

### Step 4: Create Modular Output

Always create index.md + detail files:

```bash
# Create module directory
mkdir -p {output_dir}/{module}

# Create index.md
echo "# {Skill} Output — {module}" > {output_dir}/index.md
echo "| File | Format |" >> {output_dir}/index.md
echo "|------|--------|" >> {output_dir}/index.md
echo "| {file}.md | markdown |" >> {output_dir}/index.md
```

### Step 5: Validate Output

If validation_script specified:
- Run validation
- Check exit code

### Step 6: Report

Return completion signal:

```yaml
execution_result:
  task_id: {task_id}
  skill: {skill_name}
  status: COMPLETED | FAILED
  output_paths:
    - {output_dir}/index.md
    - {output_dir}/{module}/{detail}.md
  validation: PASS | FAIL
  error: null | {error_message}
```

## Spawning Next Subagent

After successful completion, spawn the next subagent in pipeline:

```
Task tool → invoke {next_subagent}
Input: {output_dir}/{module}/
```

**Pipeline Order:**
```
flow-design-analyst-agent
    ↓
sequence-design-analyst-agent
    ↓
class-diagram-analyst-agent
    ↓
activity-diagram-design-analyst-agent
    ↓
schema-design-analyst-agent
    ↓
ui-architecture-analyst-agent
    ↓
ui-pencil-drawer-agent (END)
```

## Output

Write result to `.skill-context/{pipeline}/results/result-{stage_id}.json`

```json
{
  "task_id": "stage_01",
  "status": "COMPLETED",
  "outputs": [
    {
      "path": "Docs/life-2/diagrams/flow/index.md",
      "type": "markdown"
    },
    {
      "path": "Docs/life-2/diagrams/flow/M1/index.md",
      "type": "markdown"
    },
    {
      "path": "Docs/life-2/diagrams/flow/M1/auth-flow.md",
      "type": "markdown"
    }
  ],
  "next_subagent": "sequence-design-analyst-agent",
  "next_input": "Docs/life-2/diagrams/flow/"
}
```

## Error Handling

- If input missing → Report error, don't guess
- If validation fails → Report FAIL, stop pipeline
- If skill not found → Try to invoke directly as skill
