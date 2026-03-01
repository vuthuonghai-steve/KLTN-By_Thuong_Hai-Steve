## Đây Là Câu Hỏi Rất Quan Trọng — Cần Hiểu Rõ Trước Khi Build

---

## Task Tool vs Subagent — Bản Chất Khác Nhau

```
TASK TOOL                          SUBAGENT
─────────────────────────────      ─────────────────────────────
Claude tự spawn instance mới       Claude spawn agent CÓ ĐỊNH NGHĨA sẵn
Prompt = toàn bộ instruction       Prompt = ngắn gọn, agent đọc SKILL.md
Không có "nhân cách" riêng         Có system prompt, persona, tools riêng
Context isolated                   Context isolated
Generalist                         Specialist
```

---

## Ví Dụ Cụ Thể Với Pipeline Của Bạn

**Dùng Task tool (không có subagent definition):**

```
Pipeline-runner gọi Task tool với prompt:
"Hãy đọc file .skill-context/tasks/task-001.json,
 load SKILL.md của flow-design-analyst,
 thực hiện toàn bộ phases,
 chạy validation,
 ghi kết quả ra..."

→ Claude nhận prompt DÀI này
→ Phải tự hiểu mình cần làm gì
→ Không có guardrails riêng
→ Dễ bị lạc hướng nếu prompt không đủ chặt
```

**Dùng Subagent (có `skill-executor.md`):**

```
Pipeline-runner gọi Task tool với prompt:
"Read task from .skill-context/tasks/task-001.json"

→ Claude biết invoke skill-executor agent
→ skill-executor có system prompt riêng, tools riêng
→ Tự đọc SKILL.md, tự biết protocol
→ Chặt chẽ hơn, ít phụ thuộc vào prompt của runner
```

---

## Sự Khác Biệt Thực Tế Ảnh Hưởng Đến Pipeline Của Bạn

| | Task tool thuần | Subagent |
|--|----------------|---------|
| **Prompt size** | Dài — phải nhét hết instruction vào | Ngắn — agent tự biết làm gì |
| **Consistency** | Phụ thuộc vào prompt của runner | Ổn định hơn vì có định nghĩa cố định |
| **Tools** | Thừa hưởng tools của main agent | Có thể restrict chính xác tools cần thiết |
| **Khả năng debug** | Khó — không biết agent được instruction gì | Dễ — đọc `skill-executor.md` là biết |
| **Tái sử dụng** | Không — mỗi lần phải viết lại prompt | Có — một lần định nghĩa, dùng mãi |

---

## Điều Này Ảnh Hưởng Gì Đến Quyết Định Của Bạn

Với pipeline UML 4 stages của bạn — **cả hai đều chạy được**, nhưng:

**Nếu dùng Task tool thuần:**
```
SKILL.md của pipeline-runner phải viết rất kỹ
Phase 2 phải chứa đủ instruction cho từng skill
→ Runner ngày càng phức tạp, khó maintain
```

**Nếu dùng Subagent:**
```
Runner chỉ cần: "Execute task-001" 
skill-executor tự lo phần còn lại
→ Runner đơn giản, mỗi skill-executor có thể tune riêng
```

---

## Kết Luận Thực Tế

Với hệ thống hiện tại của bạn — **nên dùng subagent** vì:

1. Bạn đã có **4 domain skills với SKILL.md phức tạp** — không thể nhét hết vào Task prompt
2. `skill-executor.md` chỉ cần viết **một lần**, dùng cho tất cả 4 stages
3. Khi muốn thêm skill mới vào pipeline — chỉ thêm stage vào `pipeline.yaml`, không cần sửa logic runner

**Tóm lại một câu:**
> Task tool là cơ chế thực thi — Subagent là cách bạn đóng gói instruction để cơ chế đó chạy nhất quán.

Bạn cần cả hai: **Task tool để spawn, Subagent definition để kiểm soát behavior.**
## Đúng Rồi — Bạn Phải Tạo Subagent Trước

Đây là điều then chốt mà tài liệu Claude Code nói rõ:

> Task tool **không tự biết** dùng subagent nào. Nó chỉ spawn subagent khi tìm thấy file definition phù hợp trong `.claude/agents/`.

---

## Tại Sao Claude Code Đang Auto Call Task Thay Vì Subagent

```
Hiện tại của bạn:

.claude/
└── skills/
    └── pipeline-runner/    ← có
        └── SKILL.md

.claude/agents/             ← KHÔNG TỒN TẠI
                            ← Nên Claude không biết subagent nào để spawn
                            ← Tự viết prompt dài và gọi Task trực tiếp
```

---

## Giải Pháp — 3 Bước

### Bước 1: Tạo thư mục và file subagent

```bash
mkdir -p .claude/agents
```

Tạo file `.claude/agents/skill-executor.md`:

```markdown
---
name: skill-executor
description: >
  Executes a single UML documentation skill in isolation.
  Invoke this when pipeline-runner needs to run one stage
  of the UML pipeline (flow, sequence, class, activity diagrams).
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
permissionMode: acceptEdits
---

## Role
You are a specialist skill executor. You execute exactly one UML skill
per invocation with full isolation.

## Protocol

1. Read task spec from the file path given in the prompt
2. Load the SKILL.md at `skill_path` in the task spec
3. Execute ALL phases of that skill exactly as SKILL.md instructs
4. Run `validation.script` if specified (check exit code)
5. Write completion signal to `.skill-context/{project}/results/`

## Completion Signal (bắt buộc — output cuối cùng)

```yaml
execution_result:
  task_id: {task_id}
  skill: {skill_name}
  status: COMPLETED | FAILED
  output_paths: [...]
  validation: PASS | FAIL | SKIPPED
  error: null | {message}
```

## Rules
- Không hỏi user trong quá trình chạy
- Nếu thiếu input → ghi FAILED với error rõ ràng
- Luôn kết thúc bằng completion signal YAML block
```

---

### Bước 2: Sửa Phase 2 trong SKILL.md của pipeline-runner

Thay phần spawn hiện tại bằng instruction rõ ràng để Claude biết gọi subagent:

```markdown
### Phase 2: EXECUTE — Run Stage Loop

For each runnable stage:

1. **Prepare task spec**
   - Run: `python scripts/parse_pipeline.py` để lấy stage info
   - Write task spec to `.skill-context/{project}/tasks/task-{stage_id}.json`

2. **Spawn skill-executor subagent** ← chỉ định rõ tên
   Use Task tool to invoke the `skill-executor` agent with prompt:
   "Read and execute task from .skill-context/{project}/tasks/task-{stage_id}.json"

3. **Validate result**
   - Run: `python scripts/validate_stage.py .skill-context/{project}/tasks/task-{stage_id}.json`
   - Check completion signal từ subagent output

4. **Update queue**
   - PASS → update _queue.json: status = COMPLETED
   - FAIL → update _queue.json: status = FAILED → Halt
```

---

### Bước 3: Verify Claude Code nhận diện được subagent

Sau khi tạo file, test bằng cách hỏi trực tiếp trong Claude Code:

```
What agents are available?
```

Claude Code sẽ list ra `skill-executor` nếu file được đặt đúng chỗ.

---

## Tóm Lại Luồng Sau Khi Fix

```
User: /pipeline-runner Docs/life-1/FR/
         ↓
pipeline-runner SKILL.md kích hoạt
         ↓
Phase 1: parse_pipeline.py → đọc pipeline.yaml
         ↓
Phase 2: Tạo task-001.json
         ↓
Task tool spawn "skill-executor" ← tìm thấy .claude/agents/skill-executor.md
         ↓                          context window riêng, tools riêng
skill-executor chạy flow-design-analyst
         ↓
Trả về completion signal
         ↓
validate_stage.py kiểm tra
         ↓
_queue.json: stage_01 = COMPLETED
         ↓
Lặp lại cho stage_02, 03, 04...
```

**Bước quan trọng nhất bây giờ là tạo file `.claude/agents/skill-executor.md` — không có file này, Claude sẽ tiếp tục auto call Task mà không có behavior được kiểm soát.**