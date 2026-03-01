# Kiến trúc pipeline-runner với Claude Code: toàn bộ kỹ thuật sub-agent và context isolation

**Claude Code cung cấp đầy đủ primitives để xây dựng pipeline-runner**: sub-agent với context window cách ly, file system tools cho shared memory, và nhiều orchestration pattern từ sequential chaining đến parallel background execution. Điểm then chốt cho thiết kế của bạn là mỗi sub-agent chạy trong **context window riêng biệt** (~200K tokens), giao tiếp với main agent qua kết quả trả về và qua file system — chính xác mô hình bạn cần cho `.skill-context/` shared memory. Bài phân tích này tổng hợp toàn bộ tài liệu chính thức từ `docs.anthropic.com`, `platform.claude.com`, và `code.claude.com`.

---

## Sub-agent: spawn, truyền context, nhận kết quả, và lifecycle

### Cơ chế hoạt động cốt lõi

Sub-agent trong Claude Code là các AI assistant chuyên biệt, mỗi agent chạy trong **context window riêng**, với system prompt riêng và tool access riêng. Claude Code spawn sub-agent thông qua **Task tool** — đây là tool nội bộ duy nhất để tạo sub-agent. Khi main agent gặp task phù hợp với description của sub-agent, nó tự động delegate qua Task tool.

**Cách spawn sub-agent** có 3 phương thức:

1. **File-based** (khuyến nghị cho pipeline-runner): tạo markdown file với YAML frontmatter trong `.claude/agents/`:

```yaml
---
name: skill-executor
description: Execute a specific skill with isolated context. Use when pipeline-runner delegates a skill task.
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
permissionMode: acceptEdits
---
You are a skill executor agent. Read your task specification from the file path
provided in the prompt. Execute the skill, write results to the designated
output path in .skill-context/, and report completion status.
```

2. **Programmatic qua SDK** (TypeScript/Python):

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Execute the data-extraction skill on input.json",
  options: {
    allowedTools: ["Read", "Write", "Edit", "Bash", "Grep", "Glob", "Task"],
    agents: {
      "skill-executor": {
        description: "Executes a skill with isolated context",
        prompt: "You are a skill executor. Read task from .skill-context/current-task.json...",
        tools: ["Read", "Write", "Edit", "Bash", "Grep", "Glob"],
        model: "sonnet",
      }
    }
  }
})) {
  if (message.type === "result") console.log(message.result);
}
```

3. **CLI headless mode** — spawn Claude Code instances riêng biệt:

```bash
claude -p "Execute skill: read .skill-context/task-001.json and process" \
  --allowedTools "Read,Write,Edit,Bash,Grep,Glob" \
  --output-format json > .skill-context/result-001.json
```

### Truyền context/input vào sub-agent

Sub-agent **không nhận full context** của main agent. Nó chỉ nhận: (1) system prompt từ file definition, (2) prompt/description khi được invoke qua Task tool, và (3) thông tin môi trường cơ bản (working directory). Do đó, **truyền input qua file là pattern chính thức và hiệu quả nhất** — hoàn toàn phù hợp với `.skill-context/` design:

```
Main agent → Write task spec to .skill-context/task-{id}.json
           → Invoke sub-agent via Task tool with prompt pointing to file
Sub-agent  → Read .skill-context/task-{id}.json
           → Execute skill
           → Write result to .skill-context/result-{id}.json
           → Return completion summary to main agent
```

### Kết quả trả về và lifecycle

Khi sub-agent hoàn thành, **một message duy nhất** (kết quả cuối cùng) trả về main agent's context. Sub-agent **không thể giao tiếp qua lại** với main agent trong quá trình chạy — nó hoạt động hoàn toàn autonomous cho đến khi xong. Lifecycle gồm 4 giai đoạn: (1) **Spawn** — Task tool tạo sub-agent với isolated context, (2) **Execute** — sub-agent chạy độc lập với tools được cấp, (3) **Return** — kết quả trả về main context dưới dạng text summary, (4) **Cleanup** — context window của sub-agent bị hủy, transcript lưu trong `agent-{agentId}.jsonl` (tự động cleanup sau **30 ngày**).

**Ràng buộc quan trọng**: sub-agent **không thể spawn sub-agent khác** — không có nested delegation. Đây là constraint cố định để ngăn infinite nesting.

---

## Context window management: giữ sạch, compact, và isolate

### Commands và auto-compaction

Claude Code có hệ thống quản lý context gồm 3 lớp. **`/clear`** xóa hoàn toàn conversation history nhưng giữ lại CLAUDE.md — dùng khi chuyển sang task không liên quan. **`/compact [instructions]`** nén conversation thành summary ngắn gọn, giảm **50–70%** token usage (70K tokens có thể nén còn ~4K) — dùng optional instructions để chỉ định cần giữ gì. **Auto-compaction** tự trigger khi context đạt ~95% capacity, tạo summary rồi thay thế old messages.

### Subagent là cơ chế context isolation chính

Đây là điểm then chốt cho pipeline-runner design: **mỗi sub-agent hoạt động trong context window riêng biệt** (~200K tokens mỗi agent). Verbose output, file contents, command results — tất cả nằm trong context của sub-agent. Chỉ summary ngắn gọn trả về main agent. Anthropic documentation nói rõ: *"Agents help preserve main context, enabling longer overall sessions"*.

### Server-side compaction API

Cho programmatic pipeline, API beta (`compact-2026-01-12`) cho phép control compaction:

```python
response = client.beta.messages.create(
    betas=["compact-2026-01-12"],
    model="claude-opus-4-6",
    max_tokens=4096,
    messages=messages,
    context_management={
        "edits": [{
            "type": "compact_20260112",
            "trigger": {"type": "input_tokens", "value": 100000},
            "pause_after_compaction": True,
        }]
    },
)
```

### CLAUDE.md cho persistent context qua sessions

CLAUDE.md files (project: `./CLAUDE.md`, user: `~/.claude/CLAUDE.md`) load vào system prompt mỗi session, **survive qua /clear và compaction**. Đây là nơi đặt pipeline-runner instructions, routing rules, và conventions mà mọi agent cần biết. Giữ dưới **200 dòng** — beyond đó signal-to-noise giảm.

---

## Orchestration patterns: sequential, parallel, và coordinator

### Sequential chaining qua main agent

Main agent invoke sub-agents tuần tự, mỗi agent hoàn thành trước khi agent tiếp theo bắt đầu. Results từ agent trước có thể được pass (qua file hoặc qua prompt) cho agent sau:

```
User: "First use skill-analyzer to assess input, then use skill-transformer to process"
→ Main agent invoke skill-analyzer (foreground, blocking)
→ skill-analyzer writes to .skill-context/analysis.json, returns summary
→ Main agent invoke skill-transformer with reference to analysis.json
→ skill-transformer reads analysis, processes, writes result
```

### Parallel execution qua background sub-agents

Multiple sub-agents chạy đồng thời — **lên đến 10 concurrent tasks**. Background sub-agents không block main conversation. Permissions được cấp upfront trước khi launch.

```yaml
# .claude/agents/parallel-skill.md
---
name: parallel-skill
description: Execute skill in background for parallel pipeline stages
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
---
Execute the skill specified in the prompt. Write all results to .skill-context/.
Work independently without requiring user interaction.
```

### Coordinator pattern với Task tool restriction

Main agent (coordinator) có thể **giới hạn** những sub-agent nào được phép spawn:

```yaml
---
name: pipeline-runner
description: Orchestrates skill execution pipeline
tools: Task(skill-analyzer, skill-transformer, skill-validator), Read, Write, Bash
---
You are a pipeline orchestrator. For each skill in the pipeline:
1. Read pipeline spec from .skill-context/pipeline.json
2. Spawn appropriate sub-agent for each stage
3. Monitor results via .skill-context/ files
4. Proceed to next stage when current completes
```

Cú pháp `Task(agent1, agent2)` là **allowlist** — chỉ những agent được liệt kê mới có thể spawn. Omit `Task` entirely = không được spawn agent nào.

### Worktree isolation cho parallel file safety

Khi nhiều sub-agents cần modify files đồng thời, **worktree isolation** ngăn conflict:

```yaml
---
name: feature-skill
isolation: worktree
---
```

Mỗi sub-agent nhận git worktree riêng, tự động cleanup khi hoàn thành.

---

## File system tools và shared memory qua .skill-context/

### Tools có sẵn cho file operations

Claude Code cung cấp **6 file tools chính** mà sub-agents sử dụng trực tiếp:

- **Read** — đọc file, hỗ trợ `offset` và `limit` (line range) để tiết kiệm tokens
- **Write** — tạo mới hoặc overwrite file hoàn toàn
- **Edit** — exact string replacement trong file (cho partial updates)
- **Glob** — pattern matching tìm files (`**/*.json`, `.skill-context/*.json`)
- **Grep** — regex search nội dung file (ripgrep-based)
- **Bash** — execute shell commands (persistent session, state maintained between commands)

### Thiết kế .skill-context/ shared memory

Dựa trên patterns chính thức từ Anthropic docs, kiến trúc `.skill-context/` nên gồm:

```
.skill-context/
├── pipeline.json          # Pipeline definition & current state
├── _queue.json            # Task queue with status tracking
├── tasks/
│   ├── task-001.json      # Input spec for skill-001
│   ├── task-002.json      # Input spec for skill-002
│   └── ...
├── results/
│   ├── result-001.json    # Output from skill-001
│   ├── result-002.json    # Output from skill-002
│   └── ...
├── shared/
│   ├── context.json       # Shared state across skills
│   └── errors.json        # Error log
└── handoff/
    └── notes.md           # Handoff notes between stages
```

### Queue-based coordination pattern

Anthropic docs mô tả pattern dùng queue file cho multi-agent pipeline:

```json
// .skill-context/_queue.json
{
  "pipeline_id": "pipe-20260228-001",
  "stages": [
    {"skill": "data-extraction", "status": "COMPLETED", "agent_id": "abc123"},
    {"skill": "data-transform", "status": "IN_PROGRESS", "agent_id": "def456"},
    {"skill": "validation", "status": "PENDING", "agent_id": null},
    {"skill": "output-format", "status": "BLOCKED_BY:validation", "agent_id": null}
  ]
}
```

Sub-agents đọc/ghi queue file này. **SubagentStop hook** có thể trigger logic chuyển sang stage tiếp theo.

---

## Hooks, Agent Teams, và advanced pipeline features

### Hook system cho pipeline lifecycle control

Claude Code hooks cho phép inject logic tại các lifecycle events quan trọng. Cho pipeline-runner, **3 hooks critical nhất**:

```json
{
  "hooks": {
    "SubagentStart": [{
      "hooks": [{"type": "command", "command": ".claude/hooks/on-skill-start.sh", "timeout": 30}]
    }],
    "SubagentStop": [{
      "hooks": [{"type": "command", "command": ".claude/hooks/on-skill-complete.sh", "timeout": 60}]
    }],
    "PreCompact": [{
      "hooks": [{"type": "command", "command": ".claude/hooks/save-pipeline-state.sh", "timeout": 30}]
    }]
  }
}
```

**SubagentStop** hook input bao gồm `last_assistant_message` — cho phép extract kết quả cuối cùng của sub-agent và update queue file. **PreCompact** hook cho phép lưu pipeline state trước khi context bị nén.

### Agent Teams — multi-session orchestration (experimental)

Agent Teams là feature **research preview** (cần `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`), cho phép **multiple Claude Code instances** coordinate across separate sessions. Khác biệt với subagents: teammates có thể communicate peer-to-peer qua inbox messaging, và user có thể interact trực tiếp với từng teammate.

Tuy nhiên, **subagents đủ mạnh cho pipeline-runner use case** và production-ready hơn Agent Teams. Agent Teams phù hợp hơn cho sustained parallel work cần cross-agent communication liên tục — pipeline-runner thường không cần điều này vì các skill stages giao tiếp qua file.

### SDK pipeline pattern hoàn chỉnh

Pattern production-ready cho pipeline-runner sử dụng Agent SDK:

```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";
import { readFileSync, writeFileSync } from "fs";

// Define pipeline stages as agents
const pipelineAgents = {
  "data-extractor": {
    description: "Extract and normalize data from raw inputs",
    prompt: "Read task from .skill-context/tasks/current.json. Extract data. Write to .skill-context/results/extraction.json",
    tools: ["Read", "Write", "Bash", "Grep", "Glob"],
    model: "sonnet" as const,
  },
  "transformer": {
    description: "Transform extracted data according to schema",
    prompt: "Read .skill-context/results/extraction.json. Transform per schema in .skill-context/shared/schema.json. Write to .skill-context/results/transformed.json",
    tools: ["Read", "Write", "Bash"],
    model: "sonnet" as const,
  },
  "validator": {
    description: "Validate transformed output against rules",
    prompt: "Read .skill-context/results/transformed.json. Validate. Write report to .skill-context/results/validation.json",
    tools: ["Read", "Write", "Bash", "Grep"],
    model: "haiku" as const,
  }
};

// Execute pipeline
for await (const message of query({
  prompt: `Execute pipeline: first data-extractor, then transformer, then validator. 
           Read pipeline config from .skill-context/pipeline.json.
           Update .skill-context/_queue.json status after each stage.`,
  options: {
    allowedTools: ["Read", "Write", "Task", "Bash"],
    agents: pipelineAgents,
    maxTurns: 50,
    cwd: "/path/to/project",
  }
})) {
  if (message.type === "result" && message.subtype === "success") {
    console.log(`Pipeline complete. Cost: $${message.total_cost_usd}`);
  }
}
```

### Headless CLI pipeline chaining

Cho trường hợp cần maximum isolation (mỗi skill là process riêng):

```bash
#!/bin/bash
# pipeline-runner.sh

CONTEXT_DIR=".skill-context"

# Stage 1: Extract (isolated process)
claude -p "Read $CONTEXT_DIR/tasks/task-001.json. Execute data extraction. \
  Write results to $CONTEXT_DIR/results/stage1.json" \
  --allowedTools "Read,Write,Bash,Grep,Glob" \
  --output-format json > "$CONTEXT_DIR/logs/stage1.json"

# Check success
if [ $(jq -r '.is_error' "$CONTEXT_DIR/logs/stage1.json") = "true" ]; then
  echo "Stage 1 failed"; exit 1
fi

# Stage 2: Transform (completely fresh context)
claude -p "Read $CONTEXT_DIR/results/stage1.json. Transform data. \
  Write to $CONTEXT_DIR/results/stage2.json" \
  --allowedTools "Read,Write,Bash" \
  --output-format json > "$CONTEXT_DIR/logs/stage2.json"

# Stage 3: Validate
claude -p "Read $CONTEXT_DIR/results/stage2.json. Validate output. \
  Write report to $CONTEXT_DIR/results/final.json" \
  --allowedTools "Read,Write,Bash,Grep" \
  --output-format json > "$CONTEXT_DIR/logs/stage3.json"
```

---

## Kết luận: blueprint cho pipeline-runner architecture

Kiến trúc pipeline-runner tối ưu kết hợp **3 layers** từ Claude Code primitives. Layer 1: **Main orchestrator** là một Claude Code agent (hoặc SDK query) với `Task` tool và `Read`/`Write` access, chịu trách nhiệm đọc pipeline spec, spawn sub-agents, và monitor `.skill-context/_queue.json`. Layer 2: **Skill sub-agents** được define trong `.claude/agents/`, mỗi agent có tools tối thiểu cần thiết, model routing phù hợp (haiku cho tasks đơn giản, sonnet cho tasks phức tạp), và system prompt chỉ định đọc input từ / ghi output ra `.skill-context/`. Layer 3: **`.skill-context/` shared memory** sử dụng cấu trúc directory chuẩn với queue file, task specs, results, và shared state.

Insight quan trọng nhất: **không nên truyền data lớn qua prompt/context giữa agents** — luôn dùng file system. Sub-agent chỉ nhận prompt ngắn gọn (pointer đến file), đọc full data từ disk, xử lý trong isolated context, và ghi kết quả ra disk. Main agent chỉ cần đọc summary/status. Pattern này scale tốt vì main agent's context chỉ chứa pipeline logic và status updates, không bị polluted bởi intermediate data. Với **SubagentStop hooks** để auto-advance pipeline stages và **worktree isolation** cho parallel skill execution, đây là kiến trúc production-grade đã được Anthropic validate qua chính hệ thống research multi-agent nội bộ của họ.