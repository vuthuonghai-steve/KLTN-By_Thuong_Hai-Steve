#!/bin/bash
# =============================================================================
# Steve Void Project Installer Setup Script
# Purpose: Setup Steve Void (KLTN) Claude Code environment
# Usage: bash scripts/setup.sh
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Detect if running from package (skills are in same directory as script)
PACKAGE_SKILLS_DIR="$SCRIPT_DIR/.claude/skills"
PACKAGE_HOOKS_DIR="$SCRIPT_DIR/.claude/hooks"
PACKAGE_RULES_DIR="$SCRIPT_DIR/.claude/rules"

echo -e "${GREEN}=== Steve Void Project Setup ===${NC}"
echo -e "${BLUE}Project: NeoSocial - Knowledge Sharing Social Network${NC}"
echo "Project root: $PROJECT_ROOT"
echo ""

# =============================================================================
# Step 1: Validate Environment
# =============================================================================
echo -e "${YELLOW}[1/7] Validating environment...${NC}"

# Check if running in Claude Code project - create .claude if not exists
if [ ! -d "$PROJECT_ROOT/.claude" ]; then
    echo -e "${YELLOW}! Creating .claude directory (new project)${NC}"
    mkdir -p "$PROJECT_ROOT/.claude"
fi

# Note: .agent directory is not needed, skills go to .claude/skills/

echo -e "${GREEN}✓ Claude Code directories ready${NC}"

# Check for jq
if ! command -v jq &> /dev/null; then
    echo -e "${RED}ERROR: jq is required but not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ jq installed${NC}"

# =============================================================================
# Step 2: Create directory structures
# =============================================================================
echo -e "\n${YELLOW}[2/7] Creating directory structures...${NC}"

# .claude directories
mkdir -p "$PROJECT_ROOT/.claude/hooks"
mkdir -p "$PROJECT_ROOT/.claude/rules"
mkdir -p "$PROJECT_ROOT/.claude/agents"
mkdir -p "$PROJECT_ROOT/.claude/skills"
mkdir -p "$PROJECT_ROOT/.claude/knowledge"

echo -e "${GREEN}✓ Created .claude/ directories${NC}"

# =============================================================================
# Step 3: Install Hook Scripts
# =============================================================================
echo -e "\n${YELLOW}[3/7] Installing hook scripts...${NC}"

# Priority: 1) Package hooks, 2) Project hooks, 3) Create default

# pre-write-check.sh
if [ -f "$PACKAGE_HOOKS_DIR/pre-write-check.sh" ]; then
    cp "$PACKAGE_HOOKS_DIR/pre-write-check.sh" "$PROJECT_ROOT/.claude/hooks/"
    echo "  - pre-write-check.sh (from package)"
elif [ -f "$PROJECT_ROOT/.claude/hooks/pre-write-check.sh" ]; then
    echo "  - pre-write-check.sh (existing)"
else
    # Create default
    cat > "$PROJECT_ROOT/.claude/hooks/pre-write-check.sh" << 'HOOK_PREWRITE'
#!/bin/bash
# =============================================================================
# Hook: PreToolUse - Pre-write check
# Purpose: Prevent committing sensitive files
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Files to block
BLOCKED_FILES=(
    ".env"
    ".env.local"
    ".env.production"
    "credentials.json"
    "*.key"
)

# Get input and parse JSON
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || echo "")

if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
    for pattern in "${BLOCKED_FILES[@]}"; do
        if echo "$FILE_PATH" | grep -q "$pattern"; then
            echo -e "${RED}ERROR: Writing to $FILE_PATH is not allowed${NC}"
            echo "This file may contain sensitive data."
            exit 1
        fi
    done
fi

exit 0
HOOK_PREWRITE
    echo "  - pre-write-check.sh (created default)"
fi

# session-end.sh
if [ -f "$PACKAGE_HOOKS_DIR/session-end.sh" ]; then
    cp "$PACKAGE_HOOKS_DIR/session-end.sh" "$PROJECT_ROOT/.claude/hooks/"
    echo "  - session-end.sh (from package)"
elif [ -f "$PROJECT_ROOT/.claude/hooks/session-end.sh" ]; then
    echo "  - session-end.sh (existing)"
else
    cat > "$PROJECT_ROOT/.claude/hooks/session-end.sh" << 'HOOK_SESSION'
#!/bin/bash
# =============================================================================
# Hook: Stop - Session End
# Purpose: Log session end for tracking
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
LOGS_DIR="$PROJECT_DIR/.claude/logs"

mkdir -p "$LOGS_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LOG_FILE="$LOGS_DIR/session.log"

echo "[$TIMESTAMP] Session ended" >> "$LOG_FILE"

exit 0
HOOK_SESSION
    echo "  - session-end.sh (created default)"
fi

# subagent-start.sh
if [ -f "$PACKAGE_HOOKS_DIR/subagent-start.sh" ]; then
    cp "$PACKAGE_HOOKS_DIR/subagent-start.sh" "$PROJECT_ROOT/.claude/hooks/"
    echo "  - subagent-start.sh (from package)"
elif [ -f "$PROJECT_ROOT/.claude/hooks/subagent-start.sh" ]; then
    echo "  - subagent-start.sh (existing)"
else
    cat > "$PROJECT_ROOT/.claude/hooks/subagent-start.sh" << 'HOOK_START'
#!/bin/bash
# =============================================================================
# Hook: SubagentStart
# Description: Chạy khi một subagent bắt đầu thực thi
# Purpose: Log stage start, cập nhật _queue.json status = IN_PROGRESS
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
SKILL_CONTEXT="$PROJECT_DIR/.skill-context"
LOGS_DIR="$SKILL_CONTEXT/logs"

INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // "unknown"')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

mkdir -p "$LOGS_DIR"
LOG_FILE="$LOGS_DIR/pipeline.log"
echo "[$TIMESTAMP] SUBAGENT_START: agent_id=$AGENT_ID, agent_type=$AGENT_TYPE" >> "$LOG_FILE"

mkdir -p "$SKILL_CONTEXT/shared"
PROGRESS_FILE="$SKILL_CONTEXT/shared/progress.md"
echo "## Subagent Start - $TIMESTAMP" >> "$PROGRESS_FILE"
echo "- Agent: $AGENT_TYPE ($AGENT_ID)" >> "$PROGRESS_FILE"
echo "- Status: IN_PROGRESS" >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

jq -n \
    --arg agent_id "$AGENT_ID" \
    --arg agent_type "$AGENT_TYPE" \
    --arg timestamp "$TIMESTAMP" \
    '{"hookSpecificOutput": {"hookEventName": "SubagentStart", "additionalContext": ("Subagent " + $agent_type + " started at " + $timestamp)}}'

exit 0
HOOK_START
    echo "  - subagent-start.sh (created default)"
fi

# subagent-stop.sh
if [ -f "$PACKAGE_HOOKS_DIR/subagent-stop.sh" ]; then
    cp "$PACKAGE_HOOKS_DIR/subagent-stop.sh" "$PROJECT_ROOT/.claude/hooks/"
    echo "  - subagent-stop.sh (from package)"
elif [ -f "$PROJECT_ROOT/.claude/hooks/subagent-stop.sh" ]; then
    echo "  - subagent-stop.sh (existing)"
else
    cat > "$PROJECT_ROOT/.claude/hooks/subagent-stop.sh" << 'HOOK_STOP'
#!/bin/bash
# =============================================================================
# Hook: SubagentStop
# Description: Chạy khi một subagent hoàn thành thực thi
# Purpose: Log stage completion
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
SKILL_CONTEXT="$PROJECT_DIR/.skill-context"
LOGS_DIR="$SKILL_CONTEXT/logs"

INPUT=$(cat)
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // "unknown"')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
LAST_MESSAGE=$(echo "$INPUT" | jq -r '.last_assistant_message // ""')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

mkdir -p "$LOGS_DIR"
LOG_FILE="$LOGS_DIR/pipeline.log"
echo "[$TIMESTAMP] SUBAGENT_STOP: agent_id=$AGENT_ID, agent_type=$AGENT_TYPE" >> "$LOG_FILE"

mkdir -p "$SKILL_CONTEXT/results"
RESULT_FILE="$SKILL_CONTEXT/results/${AGENT_TYPE}_${AGENT_ID}.json"
echo "$INPUT" > "$RESULT_FILE"

jq -n \
    --arg agent_id "$AGENT_ID" \
    --arg agent_type "$AGENT_TYPE" \
    --arg timestamp "$TIMESTAMP" \
    '{"hookSpecificOutput": {"hookEventName": "SubagentStop", "additionalContext": ("Subagent " + $agent_type + " completed at " + $timestamp)}}'

exit 0
HOOK_STOP
    echo "  - subagent-stop.sh (created default)"
fi

chmod +x "$PROJECT_ROOT/.claude/hooks/"*.sh
echo -e "${GREEN}✓ Installed hook scripts${NC}"

# =============================================================================
# Step 4: Install Claude Rules
# =============================================================================
echo -e "\n${YELLOW}[4/7] Installing Claude rules...${NC}"

if [ -d "$PACKAGE_RULES_DIR" ]; then
    cp -r "$PACKAGE_RULES_DIR" "$PROJECT_ROOT/.claude/"
    echo "  - rules/ (from package)"
elif [ -d "$PROJECT_ROOT/.claude/rules" ]; then
    echo "  - rules/ (existing)"
else
    # Create default rules
    mkdir -p "$PROJECT_ROOT/.claude/rules"

    # lifecycle.md
    cat > "$PROJECT_ROOT/.claude/rules/lifecycle.md" << 'RULES_LIFECYCLE'
# Rule: 4-Life Lifecycle System
# Applies to: All tasks in this project

## Phase Overview
| Phase | Status |
|-------|--------|
| Life-1 | Done |
| Life-2 | In Progress |
| Life-3 | Not started |
| Life-4 | Not started |

## Current: Life-2
Specs in Docs/life-2/specs/
RULES_LIFECYCLE
    echo "  - lifecycle.md (created default)"
fi

echo -e "${GREEN}✓ Installed Claude rules${NC}"

# =============================================================================
# Step 5: Install Skills
# =============================================================================
echo -e "\n${YELLOW}[5/7] Installing skills...${NC}"

# All skills to install
SKILLS=(
    # Design & Specification (Life-2)
    "flow-design-analyst"
    "sequence-design-analyst"
    "class-diagram-analyst"
    "activity-diagram-design-analyst"
    "schema-design-analyst"
    "ui-architecture-analyst"
    "ui-pencil-drawer"

    # Skill Development
    "skill-architect"
    "skill-builder"
    "skill-planner"
    "skill-creator"

    # OpenSpec Workflow
    "openspec-new-change"
    "openspec-apply-change"
    "openspec-verify-change"
    "openspec-archive-change"
    "openspec-sync-specs"
    "openspec-continue-change"
    "openspec-explore"
    "openspec-ff-change"
    "openspec-onboard"
    "openspec-bulk-archive-change"

    # Implementation (Life-3)
    "build-crud-admin-page"
    "error-response-system"
    "api-from-ui"
    "api-integration"
    "screen-structure-checker"

    # Utilities
    "task-planner"
    "prompt-improver"
    "typescript-error-explainer"
    "latex-report-specialist"

    # Master
    "master-skill"
)

SKILL_COUNT=0
for skill in "${SKILLS[@]}"; do
    # Priority: 1) Package (.claude/skills), 2) Project .claude/skills
    INSTALLED=false
    if [ -d "$PACKAGE_SKILLS_DIR/$skill" ]; then
        mkdir -p "$PROJECT_ROOT/.claude/skills"
        cp -r "$PACKAGE_SKILLS_DIR/$skill" "$PROJECT_ROOT/.claude/skills/"
        echo "  - $skill (from package)"
        INSTALLED=true
    elif [ -d "$PROJECT_ROOT/.claude/skills/$skill" ]; then
        echo "  - $skill (existing)"
        INSTALLED=true
    fi
    if [ "$INSTALLED" = true ]; then
        SKILL_COUNT=$((SKILL_COUNT + 1))
    fi
done

echo -e "${GREEN}✓ Installed $SKILL_COUNT skills${NC}"

# =============================================================================
# Step 5b: Install Agents
# =============================================================================
echo -e "\n${YELLOW}[5b/8] Installing agents...${NC}"

# All agents to install
AGENTS=(
    "pipeline-orchestrator"
    "skill-executor"
    "spec-reviewer"
    "payload-expert"
    "ui-architect"
)

PACKAGE_AGENTS_DIR="$SCRIPT_DIR/.claude/agents"

AGENT_COUNT=0
for agent in "${AGENTS[@]}"; do
    # Priority: 1) Package (.claude/agents), 2) Project .claude/agents
    INSTALLED=false
    if [ -d "$PACKAGE_AGENTS_DIR/$agent" ]; then
        mkdir -p "$PROJECT_ROOT/.claude/agents"
        cp -r "$PACKAGE_AGENTS_DIR/$agent" "$PROJECT_ROOT/.claude/agents/"
        echo "  - $agent (from package)"
        INSTALLED=true
    elif [ -d "$PROJECT_ROOT/.claude/agents/$agent" ]; then
        echo "  - $agent (existing)"
        INSTALLED=true
    fi
    if [ "$INSTALLED" = true ]; then
        AGENT_COUNT=$((AGENT_COUNT + 1))
    fi
done

echo -e "${GREEN}✓ Installed $AGENT_COUNT agents${NC}"

# =============================================================================
# Step 6: Copy knowledge directory
# =============================================================================
echo -e "\n${YELLOW}[6/8] Copying knowledge directory...${NC}"

PACKAGE_KNOWLEDGE_DIR="$SCRIPT_DIR/.claude/knowledge"
if [ -d "$PACKAGE_KNOWLEDGE_DIR" ]; then
    cp -r "$PACKAGE_KNOWLEDGE_DIR" "$PROJECT_ROOT/.claude/"
    echo "  - knowledge/ (from package)"
elif [ -d "$PROJECT_ROOT/.claude/knowledge" ]; then
    echo "  - knowledge/ (existing)"
fi

echo -e "${GREEN}✓ Knowledge directory ready${NC}"

# =============================================================================
# Step 7: Update settings.json with hooks
# =============================================================================
echo -e "\n${YELLOW}[7/8] Updating settings.json...${NC}"

SETTINGS_FILE="$PROJECT_ROOT/.claude/settings.json"

# Backup existing settings
if [ -f "$SETTINGS_FILE" ]; then
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✓ Backed up existing settings.json${NC}"
fi

# Create settings with hooks (Steve Void specific)
cat > "$SETTINGS_FILE" << 'SETTINGS_JSON'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash {project_root}/.claude/hooks/pre-write-check.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash {project_root}/.claude/hooks/session-end.sh",
            "timeout": 100,
            "async": true
          }
        ]
      }
    ],
    "SubagentStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash {project_root}/.claude/hooks/subagent-start.sh",
            "timeout": 30
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash {project_root}/.claude/hooks/subagent-stop.sh",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
SETTINGS_JSON

# Replace {project_root} with actual path
sed -i "s|{project_root}|$PROJECT_ROOT|g" "$SETTINGS_FILE"

echo -e "${GREEN}✓ Updated settings.json with hooks${NC}"

# =============================================================================
# Step 7: Verify installation
# =============================================================================
echo -e "\n${YELLOW}[8/8] Verifying installation...${NC}"

# Check hook scripts are executable
HOOK_OK=true
for hook in "$PROJECT_ROOT/.claude/hooks"/*.sh; do
    if [ -f "$hook" ] && [ ! -x "$hook" ]; then
        echo -e "${RED}✗ $(basename $hook) is NOT executable${NC}"
        HOOK_OK=false
    fi
done

if [ "$HOOK_OK" = true ]; then
    echo -e "${GREEN}✓ All hook scripts are executable${NC}"
fi

# Verify settings.json is valid JSON
if jq . "$SETTINGS_FILE" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ settings.json is valid JSON${NC}"
else
    echo -e "${RED}✗ settings.json is NOT valid JSON${NC}"
fi

# Count installed skills
INSTALLED_SKILLS=$(ls -d "$PROJECT_ROOT/.claude/skills"/*/ 2>/dev/null | wc -l)
echo -e "${GREEN}✓ Installed $INSTALLED_SKILLS skills${NC}"

# =============================================================================
# Summary
# =============================================================================
echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo -e "${CYAN}Steve Void Project has been configured successfully!${NC}"
echo ""
echo "Project: NeoSocial - Knowledge Sharing Social Network"
echo "Phase: Life-2 (Design & Specification)"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code to load new hooks"
echo "  2. Read Docs/life-2/specs/ for module specifications"
echo "  3. Use skills: /skill-architect, /flow-design-analyst, etc."
echo ""
echo "Directory structure:"
echo "  .claude/hooks/     - Hook scripts"
echo "  .claude/rules/    - Claude Code rules"
echo "  .claude/settings.json"
echo "  .claude/skills/  - All installed skills ($INSTALLED_SKILLS)"
echo ""
