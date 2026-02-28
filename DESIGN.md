# FR-to-Deliverables Pipeline Design

> **Project:** Steve Void - Knowledge Sharing Social Network
> **Purpose:** Tự động hóa hoàn toàn việc tạo Life-2 deliverables từ Functional Requirements
> **Version:** 1.0
> **Date:** 2026-02-28

---

## MỤC LỤC

1. [Tổng Quan Hệ Thống](#1-tổng-quan-hệ-thống)
2. [Vấn Đề Cần Giải Quyết](#2-vấn-đề-cần-giải-quyết)
3. [Kiến Trúc Pipeline](#3-kiến-trúc-pipeline)
4. [Dynamic Variables {}](#4-dynamic-variables-)
5. [Input → Output Flow](#5-input--output-flow)
6. [Cơ Chế Chống Hallucination](#6-cơ-chế-chống-hallucination)
7. [Validation & Quality Gates](#7-validation--quality-gates)
8. [Human-in-the-Loop](#8-human-in-the-loop)
9. [Execution Steps](#9-execution-steps)
10. [Folder Structure](#10-folder-structure)

---

## 1. Tổng Quan Hệ Thống

### Mục tiêu

```
┌─────────────────────────────────────────────────────────────────┐
│                    MỤC TIÊU HỆ THỐNG                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   INPUT ĐẦU VÀO                                               │
│   ├── {input_fr_1}                                             │
│   ├── {input_fr_2}                                             │
│   └── {input_fr_n}                                               │
│                    │                                            │
│                    ▼                                            │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   {pipeline_name} PIPELINE                             │   │
│   │   (Single Input → Fully Automated → Complete Output)   │   │
│   └─────────────────────────┬───────────────────────────────┘   │
│                             │                                    │
│                             ▼                                    │
│   OUTPUT ĐẦU RA                                                │
│   ├── {output_diagrams_dir}/er-diagram.md                     │
│   ├── {output_diagrams_dir}/use-case-diagram.md               │
│   ├── {output_diagrams_dir}/sequence-diagram.md               │
│   ├── {output_diagrams_dir}/flow-diagram.md                   │
│   ├── {output_diagrams_dir}/class-diagram.md                  │
│   ├── {output_database_dir}/schema-design.md                  │
│   └── {output_ui_dir}/wireframes/                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Yêu cầu đầu vào duy nhất

```
User chỉ cần cung cấp:
"{pipeline_command} cho {module_name}"

HOẶC

"Generate all {lifecycle_phase} deliverables từ {input_documents}"
```

---

## 2. Vấn Đề Cần Giải Quyết

### 2.1 Các Nhược Điểm Của AI Agent

```
┌─────────────────────────────────────────────────────────────────┐
│              NHƯỢC ĐIỂM CỦA AI AGENT                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. HALLUCINATION (Ảo giác)                                   │
│     ├── Bịa đặt thông tin không có trong source                │
│     ├── Tạo field/schema không được define                     │
│     └── Vẽ diagram không đúng với logic nghiệp vụ             │
│                                                                 │
│  2. SOURCE CITATION THIẾU                                      │
│     ├── Không trích dẫn nguồn cho thông tin                   │
│     ├── Không verify thông tin với tài liệu gốc              │
│     └── "Tôi nghĩ" thay vì "Theo tài liệu X..."             │
│                                                                 │
│  3. CONTENT FOCUS LỖI                                          │
│     ├── Bỏ qua input, chạy theo ý muốn                        │
│     ├── Không đọc đủ context trước khi làm                   │
│     └── Đưa ra giải pháp không match với requirement          │
│                                                                 │
│  4. NO VERIFICATION                                             │
│     ├── Không tự kiểm tra output có đúng không                │
│     ├── Không có cơ chế phát hiện lỗi                        │
│     └── Tiến tới sai mà không biết                            │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Giải Pháp Thiết Kế

```
┌─────────────────────────────────────────────────────────────────┐
│              GIẢI PHÁP THIẾT KẾ                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. SOURCE-TRUSTED PIPELINE                                    │
│     └── Mọi thông tin phải có source citation                 │
│     └── Không có source = Không được tạo output               │
│                                                                 │
│  2. INPUT-BOUND WORKFLOW                                       │
│     └── Pipeline CHỈ chạy khi đã parse đủ input              │
│     └── Mỗi bước phải trace về source requirement            │
│                                                                 │
│  3. MULTI-LAYER VALIDATION                                     │
│     └── Structural validation ({validate_structure})             │
│     └── Contract validation ({validate_contract})               │
│     └── Quality gates ({validate_quality})                      │
│     └── Source verification ({validate_source})                  │
│                                                                 │
│  4. CHECKPOINT & HUMAN OVERRIDE                                │
│     └── Pause at {checkpoint_stages}                           │
│     └── Allow human to {human_actions}                         │
│     └── {rollback_capability}                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Kiến Trúc Pipeline

### 3.1 Three-Layer Architecture (Modular)

```
┌─────────────────────────────────────────────────────────────────┐
│                    THREE-LAYER ARCHITECTURE                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  LAYER 1: ORCHESTRATOR                                    │ │
│  │  ├── {orchestrator_skill}                               │ │
│  │  ├── Đọc {pipeline_config}                             │ │
│  │  ├── Quản lý {state_file}                               │ │
│  │  ├── Điều phối {skills} theo {execution_mode}          │ │
│  │  ├── Validate sau mỗi {stage_type}                      │ │
│  │  └── {checkpoint_handler}                               │ │
│  └───────────────────────────┬───────────────────────────────┘ │
│                              │                                    │
│  ┌───────────────────────────▼───────────────────────────────┐ │
│  │  LAYER 2: SKILLS REGISTRY                                 │ │
│  │  ├── Load skills từ {skills_dir}                       │ │
│  │  ├── Dynamically resolve {skill_dependencies}          │ │
│  │  └── Instantiate {skill_instances}                      │ │
│  │                                                           │ │
│  │  Available Skills:                                        │ │
│  │  ├── {domain_skill_1} → {skill_handler_1}              │ │
│  │  ├── {domain_skill_2} → {skill_handler_2}              │ │
│  │  └── ... → ...                                          │ │
│  └───────────────────────────┬───────────────────────────────┘ │
│                              │                                    │
│  ┌───────────────────────────▼───────────────────────────────┐ │
│  │  LAYER 3: VALIDATION PLUGIN                              │ │
│  │  ├── {validator_registry}                                │ │
│  │  ├── {validation_strategy} = {multi_layer}              │ │
│  │  └── Extensible validators:                              │ │
│  │       ├── {struct_validator}                             │ │
│  │       ├── {contract_validator}                          │ │
│  │       ├── {source_validator}                            │ │
│  │       └── {quality_validator}                           │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 3.2 Data Flow (Dynamic)

```
┌─────────────────────────────────────────────────────────────────┐
│                        DATA FLOW                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  │ {input}  │───▶│ {parser} │───▶│{orchestr}│───▶│ {skill}  │
│  │  SOURCE  │    │          │    │          │    │   #1     │
│  └──────────┘    └──────────┘    └──────────┘    └────┬─────┘
│                                                          │
│                                                          ▼
│                                                    ┌──────────┐
│                                                    │{validatr} │
│                                                    │  LAYER   │
│                                                    └────┬─────┘
│                                                          │
│    ┌─────────────────────────────────────────────────┼────────┤
│    │                                                 │        │
│    ▼                                                 ▼        ▼
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  │ {skill}  │───▶│ {skill}  │───▶│ {skill}  │───▶│ {output} │
│  │    #2    │    │    #3    │    │    #n    │    │  FILES   │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. Dynamic Variables {}

### 4.1 System Variables

```
┌─────────────────────────────────────────────────────────────────┐
│                    DYNAMIC VARIABLES {}                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ╔═══════════════════════════════════════════════════════════╗ │
│  ║ SYSTEM VARIABLES (Pre-defined)                           ║ │
│  ╠═══════════════════════════════════════════════════════════╣ │
│  ║ {project_root}     = Root directory của project           ║ │
│  ║ {skill_context}   = .skill-context/ path                 ║ │
│  ║ {skills_dir}      = .agent/skills/ path                  ║ │
│  ║ {agents_dir}      = .claude/agents/ path                 ║ │
│  ║ {hooks_dir}       = .claude/hooks/ path                   ║ │
│  ║ {workspace_dir}   = workspace/ path                       ║ │
│  ╚═══════════════════════════════════════════════════════════╝ │
│                                                                 │
│  ╔═══════════════════════════════════════════════════════════╗ │
│  ║ PIPELINE VARIABLES (Configurable)                         ║ │
│  ╠═══════════════════════════════════════════════════════════╣ │
│  ║ {pipeline_name}   = Tên pipeline (vd: fr-to-life2)       ║ │
│  ║ {pipeline_id}    = Unique ID (vd: pipe-20260228-001)      ║ │
│  ║ {pipeline_config}= pipeline.yaml path                     ║ │
│  ║ {state_file}     = _queue.json path                       ║ │
│  ║ {stages}        = Array of stage definitions              ║ │
│  ║ {checkpoint_stages}= Stages cần human review              ║ │
│  ╚═══════════════════════════════════════════════════════════╝ │
│                                                                 │
│  ╔═══════════════════════════════════════════════════════════╗ │
│  ║ INPUT/OUTPUT VARIABLES (Dynamic)                         ║ │
│  ╠═══════════════════════════════════════════════════════════╣ │
│  ║ {input_sources}  = Array of input document paths         ║ │
│  ║ {input_1}        = First input file                       ║ │
│  ║ {output_dir}     = Base output directory                  ║ │
│  ║ {output_diagrams}= {output_dir}/diagrams/                 ║ │
│  ║ {output_database}= {output_dir}/database/                 ║ │
│  ║ {output_ui}      = {output_dir}/ui/                       ║ │
│  ╚═══════════════════════════════════════════════════════════╝ │
│                                                                 │
│  ╔═══════════════════════════════════════════════════════════╗ │
│  ║ SKILL VARIABLES (Resolved at runtime)                     ║ │
│  ╠═══════════════════════════════════════════════════════════╣ │
│  ║ {skill_name}     = Current skill name                     ║ │
│  ║ {skill_path}     = Path to SKILL.md                        ║ │
│  ║ {skill_handler}  = Execution handler                      ║ │
│  ║ {input_contracts}= Required inputs (từ SKILL.md)          ║ │
│  ║ {output_contracts}= Output artifacts (từ SKILL.md)        ║ │
│  ║ {validation_rules}= Validation config (từ SKILL.md)      ║ │
│  ╚═══════════════════════════════════════════════════════════╝ │
│                                                                 │
│  ╔═══════════════════════════════════════════════════════════╗ │
│  ║ VALIDATION VARIABLES (Plugin-based)                       ║ │
│  ╠═══════════════════════════════════════════════════════════╣ │
│  ║ {validator_registry}= Map of available validators        ║ │
│  ║ {struct_validator} = Structural validation function         ║ │
│  ║ {contract_validator}= Contract validation function         ║ │
│  ║ {source_validator} = Source citation validator             ║ │
│  ║ {quality_validator}= Quality gate validator                ║ │
│  ║ {validation_result}= Result object                        ║ │
│  ╚═══════════════════════════════════════════════════════════╝ │
│                                                                 │
│  ╔═══════════════════════════════════════════════════════════╗ │
│  ║ EXECUTION VARIABLES (Runtime state)                       ║ │
│  ╠═══════════════════════════════════════════════════════════╣ │
│  ║ {current_stage}   = Stage đang chạy                        ║ │
│  ║ {stage_status}   = COMPLETED|IN_PROGRESS|FAILED|BLOCKED   ║ │
│  ║ {attempt_count}  = Số lần retry                           ║ │
│  ║ {elapsed_time}   = Thời gian chạy (seconds)               ║ │
│  ║ {predecessor_output}= Output từ stage trước              ║ │
│  ║ {successor_needs}= Requirements cho stage tiếp             ║ │
│  ║ {handoff_note}  = Note từ stage trước                   ║ │
│  ╚═══════════════════════════════════════════════════════════╝ │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Variable Resolution

```python
# VariableResolver - Core module for resolving {} variables

class VariableResolver:
    """
    Resolve {} variables at runtime based on context
    """

    RESOLVERS = {
        # System
        "project_root": lambda ctx: ctx["project_root"],
        "skill_context": lambda ctx: f"{ctx['project_root']}/.skill-context",
        "skills_dir": lambda ctx: f"{ctx['project_root']}/.agent/skills",

        # Pipeline
        "pipeline_config": lambda ctx: f"{ctx['skill_context']}/{ctx['pipeline_name']}/pipeline.yaml",
        "state_file": lambda ctx: f"{ctx['skill_context']}/{ctx['pipeline_name']}/_queue.json",

        # Input/Output
        "output_dir": lambda ctx: f"{ctx['project_root']}/{ctx.get('output_base', 'Docs/life-2')}",
        "output_diagrams": lambda ctx: f"{ctx['output_dir']}/diagrams",
        "output_database": lambda ctx: f"{ctx['output_dir']}/database",
        "output_ui": lambda ctx: f"{ctx['output_dir']}/ui",

        # Skills
        "skill_path": lambda ctx: f"{ctx['skills_dir']}/{ctx['skill_name']}",
        "input_contracts": lambda ctx: parse_yaml_frontmatter(f"{ctx['skill_path']}/SKILL.md")["input_contract"],
        "output_contracts": lambda ctx: parse_yaml_frontmatter(f"{ctx['skill_path']}/SKILL.md")["output_contract"],
        "validation_rules": lambda ctx: parse_yaml_frontmatter(f"{ctx['skill_path']}/SKILL.md")["validation"],

        # Execution
        "current_stage": lambda ctx: ctx["queue"]["current_stage"],
        "stage_status": lambda ctx: ctx["queue"]["stages"][ctx["current_stage"]]["status"],
        "predecessor_output": lambda ctx: get_stage_output(ctx, ctx["current_stage"]),
    }

    def resolve(self, template: str, context: dict) -> str:
        """Resolve all {variables} in template string"""
        import re

        def replacer(match):
            var_name = match.group(1)
            if var_name in self.RESOLVERS:
                return str(self.RESOLVERS[var_name](context))
            return match.group(0)

        return re.sub(r'\{(\w+)\}', replacer, template)
```

### 4.3 Example Variable Resolution

```
┌─────────────────────────────────────────────────────────────────┐
│              VARIABLE RESOLUTION EXAMPLE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INPUT TEMPLATE:                                                │
│  ─────────────────                                              │
│  {pipeline_name}: {current_stage}                               │
│  Output: {output_diagrams}/{stage_output_file}                 │
│  Depends on: {predecessor_stage}                               │
│                                                                 │
│  CONTEXT:                                                      │
│  ────────                                                      │
│  {                                                              │
│    "pipeline_name": "fr-to-life2",                            │
│    "current_stage": "stage_03_sequence",                       │
│    "stage_output_file": "sequence-diagram.md",                 │
│    "predecessor_stage": "stage_02_usecase"                    │
│  }                                                              │
│                                                                 │
│  RESOLVED OUTPUT:                                               │
│  ────────────────                                              │
│  fr-to-life2: stage_03_sequence                                │
│  Output: Docs/life-2/diagrams/sequence-diagram.md             │
│  Depends on: stage_02_usecase                                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 5. Input → Output Flow

### 5.1 User Command Format (Dynamic)

```
┌─────────────────────────────────────────────────────────────────┐
│                 USER COMMAND EXAMPLES                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  # Format: {pipeline_command} {target} {options}               │
│                                                                 │
│  "Chạy pipeline {pipeline_name}"                               │
│  "Run {pipeline_name} for {module_name}"                       │
│  "Execute {pipeline_name} --module={module} --stages={1,2,3}" │
│  "Resume {pipeline_name} from {checkpoint_stage}"             │
│                                                                 │
│  Variables:                                                     │
│  ├── {pipeline_name}  = fr-to-life2, design-to-code, etc.    │
│  ├── {module_name}    = M1, M2, M3 (từ feature map)           │
│  ├── {checkpoint_stage} = stage_03, stage_05, etc.             │
│  └── {options}       = --resume, --skip-validations, etc.      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 5.2 Pipeline Configuration (pipeline.yaml) - Fully Dynamic

```yaml
# {skill_context}/{pipeline_name}/pipeline.yaml
pipeline:
  name: "{pipeline_name}"
  version: "{version}"
  description: "{pipeline_description}"

  # Dynamic inputs - resolved at runtime
  inputs:
    - name: "{input_name_1}"
      path: "{input_path_1}"
      type: "{input_type_1}"
      parser: "{parser_plugin_1}"      # markdown, json, yaml
      required: {input_required_1}
    - name: "{input_name_2}"
      path: "{input_path_2}"
      type: "{input_type_2}"

  # Dynamic stages - generated from {todo_source}
  stages:
    - id: "{stage_id_1}"
      skill: "{skill_name_1}"
      depends_on: {depends_on_1}
      input_sources: {input_sources_1}
      output_path: "{output_path_1}"
      checkpoint: {checkpoint_1}
      auto_advance: {auto_advance_1}
      validation: {validation_config_1}

    - id: "{stage_id_2}"
      skill: "{skill_name_2}"
      depends_on: {depends_on_2}
      input_sources: {input_sources_2}
      output_path: "{output_path_2}"
      checkpoint: {checkpoint_2}
      auto_advance: {auto_advance_2}

  # Dynamic settings
  settings:
    timeout_per_stage: {timeout_seconds}
    max_retries: {max_retry_count}
    checkpoint_on_error: {checkpoint_on_error}
    human_pause_enabled: {human_pause_enabled}
    parallel_execution: {parallel_enabled}
```

### 5.3 Queue State (_queue.json) - Dynamic

```json
{
  "pipeline_id": "{pipeline_id}",
  "pipeline_name": "{pipeline_name}",
  "started_at": "{started_at}",
  "status": "{status}",
  "current_stage": "{current_stage}",

  "stages": {
    "{stage_id_1}": {
      "skill": "{skill_name}",
      "status": "{stage_status}",
      "completed_at": "{completed_at}",
      "output": "{output_path}",
      "validation_passed": {validation_passed},
      "duration_seconds": {duration},
      "source_citations": {citations}
    },
    "{stage_id_2}": {
      "skill": "{skill_name}",
      "status": "{stage_status}",
      "started_at": "{started_at}",
      "input_sources": {input_sources}
    }
  },

  "history": [
    {
      "stage": "{stage_id}",
      "attempt": {attempt_count},
      "started": "{started_time}",
      "completed": "{completed_time}",
      "result": "{result_status}"
    }
  ]
}
```

---

## 6. Cơ Chế Chống Hallucination

### 6.1 Source Citation System (Dynamic)

```
┌─────────────────────────────────────────────────────────────────┐
│              SOURCE CITATION SYSTEM                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  MỌI THÔNG TIN TRONG OUTPUT PHẢI CÓ:                          │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  1. SOURCE FILE REFERENCE                                 │  │
│  │     └── "The {entity} is defined in:                      │  │
│  │         - {input_1}:{section}:{item}                      │  │
│  │         - {input_2}:{section}:{item}                      │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  2. LINE NUMBER (nếu có thể)                            │  │
│  │     └── "According to line {line_start}-{line_end}..."    │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  3. TRACEABILITY CHAIN                                   │  │
│  │     └── {requirement_id} → {usecase_id} → {flow_id}     │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  4. DYNAMIC SOURCE PATTERNS                               │  │
│  │     └── Citation format: {citation_template}            │  │
│  │     └── Source registry: {source_registry}               │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 6.2 Citation Validation Rule (Dynamic)

```python
# {skill_context}/validators/source_citation.py

def validate_source_citations({output_file}, {input_sources}) -> {ValidationResult}:
    """
    Kiểm tra mọi claim trong output đều có source citation
    """
    {result} = {ValidationResult}()

    {content} = {output_file}.read_text()

    # Dynamic patterns from {validation_config}
    {claim_patterns} = {validation_config}["claim_patterns"]

    # Extract claims
    {claims} = extract_claims({content}, {claim_patterns})

    for {claim} in {claims}:
        # Check citation
        {has_citation} = check_citation({claim}, {input_sources}, {source_registry})

        if not {has_citation}:
            {result}.add_error(
                f"Claim '{claim}' không có source citation. "
                f"Thêm reference đến {input_sources}."
            )

    return {result}
```

### 6.3 Input-Bound Workflow Enforcement

```
┌─────────────────────────────────────────────────────────────────┐
│           INPUT-BOUND WORKFLOW ENFORCEMENT                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  TRƯỚC KHI SKILL CHẠY:                                         │
│  ─────────────────────                                          │
│  1. Parse {input_documents}                                    │
│  2. Extract {key_requirements} từ {input_sources}           │
│  3. Build {requirement_index}                                 │
│  4. Verify {input_completeness} trước khi chạy              │
│                                                                 │
│  TRONG KHI SKILL CHẠY:                                          │
│  ──────────────────────                                          │
│  1. Mỗi claim phải trace về {requirement_index}             │
│  2. Nếu không tìm thấy trong index → {action_on_missing}     │
│  3. Nếu contradict requirement → {action_on_contradict}      │
│                                                                 │
│  SAU KHI SKILL XONG:                                            │
│  ────────────────────                                           │
│  1. Validate output vs {requirement_index}                     │
│  2. Generate {source_citation_section}                        │
│  3. Verify {requirement_coverage}                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 7. Validation & Quality Gates

### 7.1 Three-Layer Validation (Dynamic)

```
┌─────────────────────────────────────────────────────────────────┐
│              THREE-LAYER VALIDATION                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  LAYER 1: STRUCTURAL VALIDATION                                │
│  ├── Output file exists? ({file_exists_check})                 │
│  ├── Format correct? ({format_check})                          │
│  ├── Required sections present? ({section_check})             │
│  └── Syntax valid? ({syntax_check})                           │
│                                                                 │
│  LAYER 2: CONTRACT VALIDATION                                  │
│  ├── Meets {successor_needs}?                                 │
│  ├── Has {artifacts} as declared?                            │
│  └── Passes {quality_gates}?                                 │
│                                                                 │
│  LAYER 3: SOURCE CITATION VALIDATION                           │
│  ├── Every claim has {source}?                               │
│  ├── Source references valid?                                │
│  └── No contradictions with {inputs}?                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 7.2 Quality Gates (Configurable per Skill)

```yaml
# In {skill_path}/SKILL.md
validation:
  contract_version: "{validation_version}"

  output_contract:
    artifacts:
      - id: "{artifact_id}"
        type: "{artifact_type}"
        path_pattern: "{path_pattern}"
        format: "{format}"
        required: {required}
        content_schema:
          required_sections: {required_sections}
          must_contain: {must_contain_patterns}
          must_not_contain: {forbidden_patterns}

  quality_gates:
    min_requirements:
      - metric: "{metric_name}"
        min: {min_value}
max_value}
        description: "{description        max: {}"
        fail_on_violation: {fail_on_violation}

    completeness:
      - requirement: "{requirement_name}"
        check: "{check_function}"
        error_message: "{error_message}"

    format:
      - requirement: "{format_requirement}"
        check: "{validation_function}"

  source_citation:
    required: {citation_required}
    format: "{citation_format}"
    registry: "{source_registry}"
```

---

## 8. Human-in-the-Loop

### 8.1 Checkpoint Points (Dynamic)

```
┌─────────────────────────────────────────────────────────────────┐
│              CHECKPOINT DECISION POINTS                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  PIPELINE SẼ PAUSE TẠI:                                        │
│                                                                 │
│  Configurable checkpoints:                                       │
│  ├── checkpoint: {checkpoint_stages}  (từ pipeline.yaml)       │
│  ├── on_validation_fail: {on_validation_fail_action}          │
│  ├── on_timeout: {on_timeout_action}                          │
│  └── on_ambiguous_input: {on_ambiguous_action}                │
│                                                                 │
│  Human Actions:                                                 │
│  ├── {human_approve_action}   = [APPROVE]                      │
│  ├── {human_reject_action}   = [REJECT with reason]           │
│  ├── {human_modify_action}   = [MODIFY + input]              │
│  └── {human_skip_action}     = [SKIP this stage]             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 8.2 Dashboard Interface (Auto-generated)

```markdown
# 📊 {pipeline_name} Dashboard

## Progress
[{progress_bar}] {completed_count}/{total_count} completed ({percentage}%)

## Stages
{% for stage in stages %}
{status_icon} {stage_id}: {stage_name} - {stage_status} @{timestamp} ({duration})
{% endfor %}

## Current Stage
- {current_metric_1}: {value_1}/{target_1}
- {current_metric_2}: {value_2}/{target_2}
- Source citations: {verified_count}/{total_count}

## Checkpoint Reached
⚠️ **{checkpoint_message}**

{available_actions}
```

---

## 9. Execution Steps

### 9.1 Step-by-Step Pipeline Flow

```
┌─────────────────────────────────────────────────────────────────┐
│              PIPELINE EXECUTION STEPS                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  BƯỚC 1: KHỞI TẠO PIPELINE                                    │
│  ─────────────────────────                                      │
│  1. Parse {user_command}                                        │
│  2. Resolve {pipeline_name} from command                        │
│  3. Load {pipeline_config} = {pipeline_config_path}            │
│  4. Resolve {dynamic_variables}                                 │
│  5. Parse {input_documents} into {requirement_index}           │
│  6. Initialize {state_file}                                      │
│                                                                 │
│  BƯỚC 2: RESOLVE & EXECUTE STAGE                               │
│  ─────────────────────────────────                              │
│  1. Find {next_executable_stage} where:                         │
│     ├── status = PENDING                                      │
│     └── all({depends_on}) = COMPLETED                          │
│                                                                 │
│  2. Resolve {stage_input} from:                                │
│     ├── {predecessor_outputs}                                  │
│     └── {input_sources}                                       │
│                                                                 │
│  3. Inject {pipeline_awareness} into {task_context}            │
│                                                                 │
│  4. Execute {skill} with {task_context}                       │
│                                                                 │
│  5. Run {validation_layers}:                                   │
│     ├── {structural_validation}                                │
│     ├── {contract_validation}                                 │
│     └── {source_citation_validation}                           │
│                                                                 │
│  BƯỚC 3: HANDLE RESULT                                        │
│  ────────────────────                                           │
│  IF {validation_passed}:                                        │
│     ├── Generate {handoff_note}                                │
│     ├── Update {state_file}: COMPLETED                         │
│     └── IF {is_checkpoint}: PAUSE + await {human_action}     │
│                                                                 │
│  ELSE IF {validation_failed}:                                   │
│     ├── Increment {attempt_count}                              │
│     ├── IF {attempt_count} < {max_retries}:                   │
│     │    └── Retry stage                                       │
│     └── ELSE: HALT + notify {human}                           │
│                                                                 │
│  BƯỚC 4: LOOP                                                 │
│  ──────────────                                                │
│  IF there are more stages:                                      │
│     └── GOTO BƯỚC 2                                           │
│  ELSE:                                                          │
│     └── GOTO BƯỚC 5                                            │
│                                                                 │
│  BƯỚC 5: COMPLETE                                              │
│  ─────────────                                                  │
│  1. Generate {final_summary}                                   │
│  2. Update {state_file}: COMPLETED                             │
│  3. Notify {user} with {output_paths}                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 10. Folder Structure (Dynamic)

```
{skill_context}/
├── {pipeline_name}/
│   ├── pipeline.yaml              # Pipeline definition
│   ├── _queue.json               # Runtime state
│   │
│   ├── inputs/                   # Parsed FR inputs
│   │   ├── {input_1}.json
│   │   ├── {input_2}.json
│   │   └── requirement_index.json
│   │
│   ├── stages/                   # Each stage work dir
│   │   ├── {stage_id_1}/
│   │   │   ├── task.json              # Task input
│   │   │   ├── output.{output_format} # Output
│   │   │   ├── handoff.md            # Note for next
│   │   │   ├── validation.json       # Validation result
│   │   │   └── source_citations.json # Source tracking
│   │   │
│   │   └── {stage_id_n}/
│   │
│   ├── validators/               # Validation plugins
│   │   ├── {validator_1}.py
│   │   ├── {validator_2}.py
│   │   └── {validator_n}.py
│   │
│   ├── logs/
│   │   ├── pipeline.log
│   │   └── stages/
│   │       └── {stage_id}.log
│   │
│   └── dashboard/
│       └── pipeline-dashboard.md
│
└── templates/                   # Reusable templates
    ├── pipeline_template.yaml
    ├── task_template.json
    └── validation_template.yaml
```

---

## 11. Anti-Hallucination Summary

```
┌─────────────────────────────────────────────────────────────────┐
│              ANTI-HALLUCINATION MEASURES                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ✅ MỌI OUTPUT PHẢI CÓ SOURCE CITATION                         │
│     └── {source_validator} checks every claim                  │
│                                                                 │
│  ✅ INPUT-BOUND WORKFLOW                                        │
│     └── {input_parser} builds {requirement_index}             │
│     └── {skill} only uses {verified_content}                  │
│                                                                 │
│  ✅ MULTI-LAYER VALIDATION                                     │
│     └── Layer 1: {structural_validation}                       │
│     └── Layer 2: {contract_validation}                         │
│     └── Layer 3: {source_citation_validation}                 │
│                                                                 │
│  ✅ CHECKPOINT & HUMAN OVERRIDE                                │
│     └── Pause at {checkpoint_stages}                          │
│     └── Human: {human_approve_reject_modify}                  │
│     └── {rollback_capability}                                  │
│                                                                 │
│  ✅ CHECKPOINT RESUME                                          │
│     └── {state_file} saves after each stage                   │
│     └── Resume from {checkpoint_stage}                        │
│     └── Debug with {versioned_outputs}                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 12. Configuration Examples

### 12.1 Life-2 Pipeline (FR → Diagrams)

```yaml
pipeline_name: "fr-to-life2-deliverables"
version: "1.0"

inputs:
  - name: feature_map
    path: "Docs/life-1/01-vision/FR/{module}-feature-map.md"
  - name: product_vision
    path: "Docs/life-1/01-vision/product-vision.md"
  - name: technical_decisions
    path: "Docs/life-1/02-decisions/technical-decisions.md"

stages:
  - id: stage_01_er
    skill: schema-design-analyst
    depends_on: []
    output_path: "Docs/life-2/diagrams/er-diagram.md"

  - id: stage_02_usecase
    skill: flow-design-analyst
    depends_on: [stage_01_er]
    output_path: "Docs/life-2/diagrams/use-case-diagram.md"

  # ... more stages
```

### 12.2 Custom Pipeline (New Project)

```yaml
pipeline_name: "design-to-code"
version: "1.0"

inputs:
  - name: design_doc
    path: "Design/{project}/spec.md"

stages:
  - id: analyze
    skill: {custom_skill_1}
    depends_on: []
    output_path: "Output/analysis.json"

  - id: implement
    skill: {custom_skill_2}
    depends_on: [analyze]
    output_path: "Output/implementation/"
```

---

## 13. Next Steps

1. **{create_pipeline_yaml}** cho {target_pipeline}
2. **{build_orchestrator}** - skill điều phối chính
3. **{implement_variable_resolver}** - resolve {} variables
4. **{create_validator_plugins}** - validation layer
5. **{test_minimal_pipeline}** - chạy 1 stage đầu
6. **{add_checkpoint_system}** - human pause points
7. **{run_full_pipeline}** - end-to-end test

---

## Appendix: Related Documents

- `.skill-context/claude-pipline.md` - Pipeline concept
- `workspace/Designing Pipeline Runner.md` - Runner design
- `workspace/Automating Skill Pipeline Execution.md` - Automation approach
- `.claude/CLAUDE_ADVANCED_GUIDE.md` - Claude Code features
- `.claude/PROMPTS_HOOKS_SUMMARY.md` - Hooks & prompts summary
