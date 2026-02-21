# Custom Prompts & Hooks Summary for KLTN

> Quick navigation guide for understanding Claude Code's custom prompts and hooks

**Full Reference:** See `CLAUDE_ADVANCED_GUIDE.md` (comprehensive)

---

## 🎯 Custom Prompts — What & Why

**Custom prompts** = persistent instructions that Claude reads at every session start. They guide Claude's behavior across all conversations.

### Three Key Concepts

| Concept | What | Where | Shareable |
|---------|------|-------|-----------|
| **CLAUDE.md** | Team instructions | `./CLAUDE.md` | ✅ Yes (repo) |
| **CLAUDE.local.md** | Personal preferences | `./CLAUDE.local.md` | ❌ No (gitignored) |
| **Auto Memory** | AI learns patterns | `~/.claude/projects/<>/memory/` | ❌ No (personal) |

### What to Put in CLAUDE.md

✅ **Include:**
- Bash commands specific to YOUR project (`npm run test`, build steps)
- Code style rules that differ from normal (`2 spaces, no semicolons`)
- How to run tests, how to deploy
- Common gotchas ("if tests timeout, increase jest timeout")
- Architecture notes ("API in src/app/api, collections in src/collections")

❌ **Exclude:**
- Generic advice Claude already knows
- Documentation links (just link to docs)
- Info that changes frequently
- Self-evident practices

### Rule of Thumb

**Keep CLAUDE.md under 500 lines.** The shorter and more specific, the better Claude follows it.

---

## 🪝 Hooks — What & Why

**Hooks** = deterministic scripts that ALWAYS execute at specific points (no exceptions).

### When Hooks Fire

| When | Name | Can Block? | Example |
|------|------|-----------|---------|
| Before tool runs | `PreToolUse` | ✅ Yes | Block destructive Bash commands |
| After tool succeeds | `PostToolUse` | ❌ No | Auto-format code |
| Before Claude stops | `Stop` | ✅ Yes | Verify tests pass |
| When session starts | `SessionStart` | ❌ No | Inject project status |
| When config changes | `ConfigChange` | ✅ Yes | Audit changes |

### Key Difference: Hooks vs CLAUDE.md

```
CLAUDE.md:      "You should probably use TypeScript"     ← Claude considers it
Hooks:          "Auto-format after EVERY edit"           ← Always happens, no exceptions
```

### Blocking Hooks (Exit Code 2)

Hooks that can block actions must return:
- `exit 0` — allow action
- `exit 2` — block action (print reason to stderr)

Example: Block `rm -rf` commands
```bash
if echo "$COMMAND" | grep -q 'rm -rf'; then
  echo "Destructive command blocked" >&2
  exit 2
fi
exit 0
```

---

## 📋 How KLTN Uses Custom Prompts

**Current Setup:**

1. **Team CLAUDE.md** — `./CLAUDE.md` (main project instructions)
2. **Project Rules** — `./.claude/rules/*.md` (modular by topic)
   - `ui-stack.md` — Tailwind v4 + Radix UI only
   - `spec-first.md` — Read specs before coding
   - `payload-conventions.md` — Payload CMS patterns
   - `lifecycle.md` — 4-Life phase rules
3. **Project CLAUDE.md** — `./.claude/CLAUDE.md` (alternative, also loads)
4. **Advanced Guide** — `./.claude/CLAUDE_ADVANCED_GUIDE.md` (reference)

**To Add Custom Instructions:**

Edit either:
- `./CLAUDE.md` — for team-wide rules
- `./.claude/CLAUDE.md` — alternative (same effect)
- `./.claude/rules/new-topic.md` — for specific code paths

**To Add Personal Preferences:**

Create `./CLAUDE.local.md` (won't commit to repo):
```markdown
# My Personal Preferences

- I prefer seeing verbose output
- Use my test data in /tmp/test-data/
- My Vercel sandbox URL: ...
```

---

## 🔧 How KLTN Uses Hooks

**Current Setup in `.claude/settings.json`:**

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "command": ".claude/hooks/block-destructive.sh" }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          { "command": ".claude/hooks/verify-tests.sh" }
        ]
      }
    ]
  }
}
```

**Current Hooks:**

1. **block-destructive.sh** (PreToolUse)
   - Prevents: `rm -rf`, `DROP TABLE`, `git reset --hard`
   - Triggered: Before every Bash command

2. **verify-tests.sh** (Stop)
   - Prevents: Claude from stopping if tests fail
   - Triggered: When Claude finishes (before stopping)

3. **session-end.sh** (Stop, async)
   - Logs: Session end timestamp
   - Triggered: When session ends

### Adding New Hooks

**Step 1:** Create script in `.claude/hooks/my-hook.sh`
```bash
#!/bin/bash
INPUT=$(cat)
# Your logic here
exit 0  # or exit 2 to block
```

**Step 2:** Make executable
```bash
chmod +x .claude/hooks/my-hook.sh
```

**Step 3:** Add to `settings.json`
```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "pattern",
        "hooks": [
          { "command": ".claude/hooks/my-hook.sh" }
        ]
      }
    ]
  }
}
```

---

## 📚 Reference Files in This Project

| File | Purpose |
|------|---------|
| `./CLAUDE.md` | Main project memory (team-shared) |
| `./.claude/CLAUDE.md` | Alternative project memory |
| `./.claude/CLAUDE_ADVANCED_GUIDE.md` | Complete reference (this guide) |
| `./.claude/PROMPTS_HOOKS_SUMMARY.md` | Quick navigation (you are here) |
| `./.claude/settings.json` | Permissions, plugins, hooks config |
| `./.claude/settings.local.json` | Your personal overrides (gitignored) |
| `./.claude/rules/*.md` | Modular, path-specific rules |
| `./.claude/hooks/*.sh` | Hook scripts |
| `./.claude/agents/*.md` | Project-specific agents |
| `./.claude/skills/` | 28 skills copied from `.agent/skills/` |

---

## ⚡ Quick Recipes for Common Tasks

### Recipe 1: Add a Team Rule

**Scenario:** "All API routes must validate input"

1. Create `./.claude/rules/api.md`:
```yaml
---
paths:
  - "src/app/api/**/*.ts"
---

# API Development Rules

- All endpoints must validate request body
- Use errorHandler from src/utils/
- Log all errors with req context
- Include OpenAPI documentation
```

2. Done — Claude auto-loads when editing API files

### Recipe 2: Add a Personal Preference

**Scenario:** "I prefer using pnpm instead of npm"

1. Create `./.claude/CLAUDE.local.md`:
```markdown
# My Personal Preferences

- Use `pnpm` instead of `npm` for all commands
- My sandbox URL: https://my-sandbox.local
- Test data location: ~/test-data/
```

2. Done — Won't commit to repo

### Recipe 3: Protect a File from Edits

**Scenario:** "Don't let Claude edit .env files"

1. Create `./.claude/hooks/protect-env.sh`:
```bash
#!/bin/bash
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path')

if [[ "$FILE" == *".env"* ]]; then
  echo ".env files cannot be edited" >&2
  exit 2
fi
exit 0
```

2. Add to `settings.json`:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "command": ".claude/hooks/protect-env.sh" }
        ]
      }
    ]
  }
}
```

3. Done — Hook fires on every Edit/Write to Bash

### Recipe 4: Auto-Test After Edits

**Scenario:** "Run tests automatically after I save code"

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "command": "npm test -- $(jq -r '.tool_input.file_path | sub(\\.ts(?:x)?$; .test.ts)')",
            "async": true
          }
        ]
      }
    ]
  }
}
```

Note: `async: true` means test runs without blocking Claude.

---

## 🎓 Learning Path

1. **Start:** Read this file (you are here)
2. **Understand:** Look at current `./CLAUDE.md` and `./.claude/rules/`
3. **Reference:** See `CLAUDE_ADVANCED_GUIDE.md` for detailed explanations
4. **Experiment:** Add a small rule or hook to the project
5. **Master:** Build specialized agents in `./.claude/agents/`

---

## ❓ Common Questions

**Q: Should I edit `./CLAUDE.md` or `./.claude/CLAUDE.md`?**
A: Either works (they load the same). Convention: use `./CLAUDE.md` in root.

**Q: Do I commit `./.claude/settings.local.json`?**
A: No, it's auto-gitignored. It's for your personal settings.

**Q: Why don't hooks work when I test them?**
A: Hooks need proper exit code (0 or 2) and valid JSON output. Test with:
```bash
echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' | ./your-hook.sh
echo $?
```

**Q: Can hooks modify what Claude does?**
A: Yes, for PreToolUse you can modify the input (`updatedInput`) or block it entirely.

**Q: Is there a length limit for CLAUDE.md?**
A: No hard limit, but keep it under 500 lines. Longer = Claude ignores it more.

**Q: How do I debug hooks?**
A: Turn on verbose mode: `Ctrl+O` in Claude Code, then see hook output.

---

## 📞 When to Use What

| Task | Tool | File |
|------|------|------|
| Add team convention | CLAUDE.md | `./CLAUDE.md` |
| Add personal preference | CLAUDE.local.md | `./CLAUDE.local.md` |
| Add path-specific rule | Rules file | `./.claude/rules/*.md` |
| Auto-run action | Hook | `./.claude/hooks/*.sh` |
| Block bad behavior | PreToolUse hook | `.claude/settings.json` |
| Validate result | PostToolUse hook | `.claude/settings.json` |
| Prevent early stop | Stop hook | `.claude/settings.json` |
| Custom agent | Agent skill | `./.claude/agents/*.md` |

---

## 📖 Where's the Full Docs?

**This Project:**
- Complete guide: `./.claude/CLAUDE_ADVANCED_GUIDE.md`
- Project rules: `./.claude/rules/*.md`
- Hooks config: `./.claude/settings.json`

**Official Claude Code:**
- Check `claude.ai/code` for official documentation
- `/help` command in Claude Code for built-in help
