# Claude Code Advanced Guide — Custom Prompts & Hooks

> **Complete reference for custom prompts and hooks in Claude Code**
>
> Created: 2026-02-21
> Based on official Claude Code documentation

---

## TABLE OF CONTENTS

1. [Part 1: Custom Prompts](#part-1-custom-prompts)
2. [Part 2: Hooks](#part-2-hooks)
3. [Quick Reference](#quick-reference)
4. [Examples for KLTN Project](#examples-for-kltn-project)

---

## PART 1: CUSTOM PROMPTS

### Storage Hierarchy (Precedence Order)

```
1. Managed Policy        ← Organization-wide (IT control)
2. Command-line Args    ← Current session only
3. Project Local Memory  ← ./CLAUDE.local.md (gitignored)
4. Project Memory       ← ./CLAUDE.md (shared)
5. User Memory          ← ~/.claude/CLAUDE.md (personal)
6. Auto Memory          ← ~/.claude/projects/<hash>/memory/ (auto-learned)
```

### File Types

| File | Scope | Shareable | Purpose |
|------|-------|-----------|---------|
| `CLAUDE.md` | Project | ✅ Yes (repo) | Team guidelines, coding standards |
| `CLAUDE.local.md` | Project | ❌ No (gitignored) | Personal preferences, private notes |
| `~/.claude/CLAUDE.md` | User | ❌ No (personal) | Your global conventions across projects |
| `.claude/rules/*.md` | Project | ✅ Yes (repo) | Modular, path-specific rules |
| `MEMORY.md` | Auto | ❌ No (personal) | AI learns patterns over time (200 lines loaded) |

### How Claude Loads Prompts at Session Start

1. **Immediate Load** (~2000-5000 tokens):
   - All CLAUDE.md files from directory hierarchy above cwd
   - First 200 lines of auto memory (MEMORY.md)
   - Settings from `.claude/settings.json`

2. **On-Demand Load**:
   - Child directory CLAUDE.md when Claude reads files there
   - Topic files from auto memory when relevant
   - Keeps startup context lean

3. **Persistence**:
   - All loaded context remains until `/clear` or session end
   - Survives across multiple user turns

### Writing Effective Custom Prompts

**✅ DO Include:**
- Bash commands specific to project (`npm run test`, build commands)
- Code style rules that differ from defaults
- Repository etiquette (branch naming, PR format)
- Architectural decisions specific to project
- Developer environment quirks (required env vars)
- Common gotchas or non-obvious behaviors

**❌ DON'T Include:**
- Anything Claude can figure out by reading code
- Standard language conventions Claude already knows
- Detailed API documentation (link to docs instead)
- Information that changes frequently
- Long explanations or tutorials
- Self-evident practices like "write clean code"

### @import Syntax — Composing Prompts

Link other files in your CLAUDE.md:

```markdown
# Project Overview
See @README for installation and @package.json for available scripts.

# Architecture
Review @docs/architecture.md for system design decisions.

# Development Workflow
Git instructions: @docs/git-instructions.md
Personal overrides: @~/.claude/my-overrides.md
```

**Rules:**
- Both relative and absolute paths allowed
- Relative paths resolve from the file's directory
- Imports NOT evaluated inside code blocks (backticks)
- Max 5 levels of recursive imports
- First import shows approval dialog

### Path-Specific Rules (.claude/rules/)

Scope rules to specific files using YAML frontmatter:

```yaml
---
paths:
  - "src/**/*.ts"
  - "src/api/**/*.ts"
---

# These rules apply only to TypeScript files under src/

- All API endpoints must have input validation
- Use standard error response format from error-response-system
- Log all errors with full context
- Include OpenAPI comment documentation
```

**Glob Patterns:**
- `**/*.ts` - All TypeScript files
- `src/**/*.{ts,tsx}` - Both .ts and .tsx
- `{src,lib}/**/*` - Multiple directories
- `*.md` - Only in root directory

### Length and Adherence

**Critical Rule:** Length = Adherence Inverse

- Keep CLAUDE.md under 500 lines
- If Claude ignores rules, the file is too long
- Review and prune regularly (like code reviews)
- Use emphasis (`IMPORTANT`, `YOU MUST`, `CRITICAL`) to highlight key rules
- Test: "Would removing this cause mistakes?" If not, cut it.

### Auto Memory for Learning

Claude learns and records:
- Project patterns (build commands, test structure, code styles)
- Debugging insights (solutions to errors, root causes)
- Architecture notes (key files, module relationships)
- Recurring issues and fixes

**Location:** `~/.claude/projects/<project-hash>/memory/`
- `MEMORY.md` — index file (first 200 lines auto-loaded)
- Topic files like `debugging.md`, `patterns.md` — load on demand

---

## PART 2: HOOKS

### What Are Hooks? (Deterministic Control)

Hooks are scripts/prompts that execute automatically at specific lifecycle points.

**Key Difference from CLAUDE.md:**
- **CLAUDE.md:** Advisory (Claude may ignore)
- **Hooks:** Deterministic (always execute, zero exceptions)

**When to Use Hooks:**

✅ **Use for:**
- Auto-format code after every edit (no exceptions)
- Block edits to protected files
- Validate commands before execution
- Run tests automatically
- Send notifications
- Enforce security policies
- Audit configuration changes

❌ **Don't Use for:**
- Advisory instructions (use CLAUDE.md)
- Context that changes per-task
- Logic requiring human judgment
- Anything that should sometimes be skipped

### All Supported Hook Events (14 types)

```
┌─────────────────────────────────────────────────────────┐
│ PREflight HOOKS (can block actions)                      │
├─────────────────────────────────────────────────────────┤
│ • SessionStart — Before session context loads            │
│ • UserPromptSubmit — Before Claude processes prompt      │
│ • PreToolUse — Before tool executes ⭐ (can block)       │
│ • PermissionRequest — Before permission dialog           │
│ • PreCompact — Before context compaction                 │
├─────────────────────────────────────────────────────────┤
│ DECISION-MAKING HOOKS (can block later actions)          │
├─────────────────────────────────────────────────────────┤
│ • Stop — After Claude finishes ⭐ (can block)            │
│ • SubagentStop — Subagent finishes ⭐ (can block)        │
│ • TeammateIdle — Teammate about to go idle (can block)   │
│ • TaskCompleted — Task marked complete (can block)       │
│ • ConfigChange — Config file changed (can block)         │
├─────────────────────────────────────────────────────────┤
│ POSTFLIGHT HOOKS (cannot block, log/notify)              │
├─────────────────────────────────────────────────────────┤
│ • PostToolUse — Tool succeeds                            │
│ • PostToolUseFailure — Tool fails                        │
│ • SubagentStart — Subagent spawned                       │
│ • Notification — Notification sent                       │
│ • SessionEnd — Session terminates                        │
└─────────────────────────────────────────────────────────┘
```

### Hook Configuration in settings.json

**Structure (3 levels):**

```json
{
  "hooks": {
    "EventName": [                    // Level 1: Event
      {
        "matcher": "regex_pattern",   // Level 2: Filter/Matcher
        "hooks": [
          {
            "type": "command",        // Level 3: Handler
            "command": "script.sh",
            "timeout": 600,
            "async": false
          }
        ]
      }
    ]
  }
}
```

### Matchers (Event-Specific Filtering)

**Tool Events** (PreToolUse, PostToolUse, etc.):
- Match on tool name: `Bash`, `Edit|Write`, `Read`, `Glob`, `mcp__.*`

**SessionStart:**
- Values: `startup`, `resume`, `clear`, `compact`

**SessionEnd:**
- Values: `clear`, `logout`, `prompt_input_exit`, `bypass_permissions_disabled`

**Notification:**
- Values: `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`

**PreCompact:**
- Values: `manual`, `auto`

**ConfigChange:**
- Values: `user_settings`, `project_settings`, `local_settings`, `policy_settings`, `skills`

**MCP Tools:**
- `mcp__<server>__<tool>` (e.g., `mcp__github__search_repositories`)

**No Matcher (fires on all):**
- `UserPromptSubmit`, `Stop`, `TeammateIdle`, `TaskCompleted`

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | ✅ Success. Parse stdout for JSON if present. For SessionStart/UserPromptSubmit, text added as context. |
| `2` | 🛑 Blocking error. stderr shown as feedback. Action blocked. |
| `1`, `3+` | ⚠️ Non-blocking error. Shown in verbose mode. Action proceeds. |

### Structured JSON Output (exit 0)

Standard fields available on all events:

```json
{
  "continue": true,                    // false to stop entirely
  "stopReason": "string",              // Message if continue = false
  "suppressOutput": false,             // Hide from verbose mode
  "systemMessage": "Warning text",     // Show to user
  "hookSpecificOutput": {
    "hookEventName": "EventName",
    "additionalContext": "Added to Claude context"
  }
}
```

**Event-Specific Decisions:**

**PreToolUse:**
```json
{
  "hookSpecificOutput": {
    "permissionDecision": "allow|deny|ask",
    "permissionDecisionReason": "Reason",
    "updatedInput": { "command": "modified" }
  }
}
```

**PermissionRequest:**
```json
{
  "hookSpecificOutput": {
    "decision": {
      "behavior": "allow|deny",
      "message": "Reason if deny"
    }
  }
}
```

**Stop, PostToolUse, SubagentStop:**
```json
{
  "decision": "block",
  "reason": "Why block"
}
```

### Input/Output Examples

**PreToolUse Input (Bash):**
```json
{
  "hook_event_name": "PreToolUse",
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm test",
    "description": "Run tests",
    "timeout": 120000
  },
  "tool_use_id": "toolu_01ABC..."
}
```

**PreToolUse Output (Block with reason):**
```bash
#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

if echo "$COMMAND" | grep -qE '^rm -rf'; then
  jq -n '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "deny",
      "permissionDecisionReason": "Destructive command blocked"
    }
  }'
  exit 0
else
  exit 0
fi
```

**PostToolUse Input (Edit):**
```json
{
  "hook_event_name": "PostToolUse",
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/path/to/file.ts",
    "old_string": "...",
    "new_string": "..."
  }
}
```

**Stop Hook (Prevent Stop Until Tests Pass):**
```bash
#!/bin/bash
INPUT=$(cat)

# Prevent infinite loop
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0
fi

# Run tests
if npm test 2>&1; then
  exit 0  # Allow stop
else
  # Block stop
  jq -n '{
    "decision": "block",
    "reason": "Tests failing. Fix them before stopping."
  }'
fi
```

### Performance Optimization

**Default Timeouts:**
- Command hooks: 600s (10 min)
- Prompt hooks: 30s
- Agent hooks: 60s
- Async hooks: 600s

**Custom timeout:**
```json
{
  "type": "command",
  "command": "prettier --write",
  "timeout": 30
}
```

**Async Hooks** (don't block Claude):
```json
{
  "type": "command",
  "command": "npm test",
  "async": true,
  "timeout": 300
}
```

Results delivered on next turn.

---

## QUICK REFERENCE

### Custom Prompts Checklist

- [ ] Create `.claude/CLAUDE.md` with team conventions
- [ ] Keep under 500 lines
- [ ] Use @imports to reference external files
- [ ] Create `.claude/rules/` for path-specific guidelines
- [ ] Include only what Claude can't discover
- [ ] Use emphasis for critical rules
- [ ] Avoid generic best practices

### Hooks Checklist

- [ ] Identify what MUST happen every time (deterministic)
- [ ] Choose right event (PreToolUse, PostToolUse, Stop, etc.)
- [ ] Write script with proper error handling
- [ ] Test exit codes (0, 2, etc.)
- [ ] Add matcher pattern if needed
- [ ] Configure in `.claude/settings.json`
- [ ] Test hook behavior manually
- [ ] Document in README

### Common Hook Patterns

**Block destructive commands:**
```json
{ "matcher": "Bash", "hooks": [{ "type": "command", "command": ".claude/hooks/block-destructive.sh" }] }
```

**Auto-format on edit:**
```json
{ "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": "prettier --write $(jq -r '.tool_input.file_path')" }] }
```

**Protect sensitive files:**
```json
{ "matcher": "Edit|Write", "hooks": [{ "type": "command", "command": ".claude/hooks/protect-files.sh" }] }
```

**Verify tests pass before stop:**
```json
{ "hooks": [{ "type": "command", "command": ".claude/hooks/verify-tests.sh" }] }
```

---

## EXAMPLES FOR KLTN PROJECT

### 1. Project CLAUDE.md for Steve Void

```markdown
# Steve Void — Claude Code Configuration

## Tech Stack
- Next.js 15 + React 19 (App Router)
- Payload CMS 3.x + MongoDB Atlas
- Tailwind CSS v4 + Radix UI (NO shadcn/antd/mui/chakra)
- TypeScript, Redux Toolkit, SSE, Vercel

## Build & Dev
- `npm run dev` — Start dev server (port 3000)
- `npm run build` — Production build
- `npm run lint` — Run ESLint
- `npm run lint:fix` — Auto-fix linting issues
- `npm test` — Run test suite
- `npm test -- path/to/test` — Single test file

## Payload CMS
- Collections live in `src/collections/`
- Always use Local API for server-side operations (never REST)
- Register collections in `payload.config.ts`
- Schema fields from `Docs/life-2/database/schema-design.md`
- Access control: validate `req.user`, use hooks for business logic

## Code Style
- **UI:** Tailwind v4 + Radix UI primitives ONLY
- **React:** Hooks-based, functional components, TypeScript interfaces
- **Indentation:** 2 spaces
- **Naming:** camelCase for variables/functions, PascalCase for components/classes
- **Imports:** Use ES modules (import/export)

## Critical Rules (MUST FOLLOW)
1. **Spec-First:** Always read `Docs/life-2/specs/<module>-spec.md` before coding
2. **No Shadcn:** Use Radix UI + Tailwind directly, never import shadcn/ui
3. **Field Names:** Must match `Docs/life-2/database/schema-design.md` exactly
4. **Local API:** Server-side Payload calls use Local API, not REST

## Workflow
- Feature branch: `git checkout -b feat/description`
- Before push: `npm run lint:fix && npm test`
- PR format: Reference issue #, describe what changed and why
- Commits must pass CI before merge to main

## Environment
- `.env.example` in repo, `.env` in .gitignore
- Required vars: `MONGODB_URI`, `PAYLOAD_SECRET`, `NEXT_PUBLIC_SERVER_URL`
- Load from `Docs/life-3/setup/env-setup.md`

## Architecture References
- Project vision: `Docs/life-1/01-vision/product-vision.md`
- Database schema: `Docs/life-2/database/schema-design.md`
- Module specs: `Docs/life-2/specs/`
- Folder structure: `Docs/life-3/architecture/folder-structure.md`

## Debugging
- TypeScript errors: `/typescript-error-explainer`
- Design patterns: `/sequence-design-analyst`, `/activity-diagram-design-analyst`
- Payload issues: `payload-expert` agent
- UI reviews: `ui-architect` agent

## Common Issues
- **Tests timeout:** Check jest.config.js timeout setting
- **MongoDB connection fails:** Verify `MONGODB_URI` in .env, check Atlas IP whitelist
- **Build fails TypeScript:** Run `npm run build:check` for details
- **Permissions denied on Payload:** Verify user roles and access control in collection
```

### 2. Hook: Block Destructive Commands

```bash
#!/bin/bash
# .claude/hooks/block-destructive.sh

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

# Patterns to block
BLOCKED_PATTERNS=(
  '^rm -rf'
  'DROP TABLE'
  'truncate'
  '^git reset --hard'
  '^git clean -f'
  'mongodrop'
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    jq -n '{
      "hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": "Destructive command blocked: '"$COMMAND"'"
      }
    }'
    exit 0
  fi
done

exit 0
```

**Configuration in settings.json:**
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash /home/steve/Documents/KLTN/.claude/hooks/block-destructive.sh"
          }
        ]
      }
    ]
  }
}
```

### 3. Hook: Auto-format TypeScript on Edit

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs -I {} bash -c 'if [[ {} == *.ts || {} == *.tsx ]]; then npx prettier --write {}; fi'"
          }
        ]
      }
    ]
  }
}
```

### 4. Hook: Verify Tests Pass Before Stopping

```bash
#!/bin/bash
# .claude/hooks/verify-tests.sh

INPUT=$(cat)

# Prevent infinite loop
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active')" = "true" ]; then
  exit 0
fi

# Run tests
if npm test 2>&1 | tail -5; then
  exit 0  # Allow stop
else
  # Block stop
  jq -n '{
    "decision": "block",
    "reason": "Tests are failing. Run npm test locally and fix before stopping."
  }'
fi
```

**Configuration:**
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash /home/steve/Documents/KLTN/.claude/hooks/verify-tests.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Resources

- Official Claude Code Docs: Check `claude.ai/code` docs
- Project CLAUDE.md: `./CLAUDE.md`
- Project Rules: `./.claude/rules/*.md`
- Hooks Config: `./.claude/settings.json`
- Memory: `~/.claude/projects/*/memory/`
