#!/bin/bash
# =============================================================================
# Pipeline Installer Setup Script
# Purpose: Setup Claude Code Pipeline Runner for Life-2 workflow automation
# Usage: bash scripts/setup.sh
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Detect if running from package (skills are in same directory as script)
PACKAGE_SKILLS_DIR="$SCRIPT_DIR/.claude/skills"
PACKAGE_AGENTS_DIR="$SCRIPT_DIR/.claude/agents"

echo -e "${GREEN}=== Pipeline Installer Setup ===${NC}"
echo "Project root: $PROJECT_ROOT"

# =============================================================================
# Step 1: Validate Environment
# =============================================================================
echo -e "\n${YELLOW}[1/7] Validating environment...${NC}"

# Check if running in Claude Code project - create .claude if not exists
if [ ! -d "$PROJECT_ROOT/.claude" ]; then
    echo -e "${YELLOW}! Creating .claude directory (new project)${NC}"
    mkdir -p "$PROJECT_ROOT/.claude"
fi

echo -e "${GREEN}✓ Claude Code directory ready${NC}"

# Check for jq
if ! command -v jq &> /dev/null; then
    echo -e "${RED}ERROR: jq is required but not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ jq installed${NC}"

# =============================================================================
# Step 2: Create .claude/hooks directory structure
# =============================================================================
echo -e "\n${YELLOW}[2/7] Creating hook directory structure...${NC}"

mkdir -p "$PROJECT_ROOT/.claude/hooks"
echo -e "${GREEN}✓ Created .claude/hooks/${NC}"

# =============================================================================
# Step 3: Copy hook scripts
# =============================================================================
echo -e "\n${YELLOW}[3/7] Installing hook scripts...${NC}"

# SubagentStart hook
cat > "$PROJECT_ROOT/.claude/hooks/subagent-start.sh" << 'HOOK_START'
#!/bin/bash
# =============================================================================
# Hook: SubagentStart
# Description: Chạy khi một subagent bắt đầu thực thi
# Purpose: Log stage start, cập nhật _queue.json status = IN_PROGRESS
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# hooks/ -> .claude/ -> project root (3 levels)
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
SKILL_CONTEXT="$PROJECT_DIR/.skill-context"
LOGS_DIR="$SKILL_CONTEXT/logs"
QUEUE_FILE="$SKILL_CONTEXT/_queue.json"

# Đọc JSON input từ stdin
INPUT=$(cat)

# Trích xuất thông tin
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // "unknown"')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Tạo thư mục logs nếu chưa có
mkdir -p "$LOGS_DIR"

# Log vào file
LOG_FILE="$LOGS_DIR/pipeline.log"
echo "[$TIMESTAMP] SUBAGENT_START: agent_id=$AGENT_ID, agent_type=$AGENT_TYPE" >> "$LOG_FILE"

# Kiểm tra nếu đang chạy pipeline (_queue.json tồn tại)
if [ -f "$QUEUE_FILE" ]; then
    echo "[$TIMESTAMP] Pipeline detected, stage starting..." >> "$LOG_FILE"
fi

# Tạo thư mục shared cho progress tracking
mkdir -p "$SKILL_CONTEXT/shared"

# Ghi progress tracking
PROGRESS_FILE="$SKILL_CONTEXT/shared/progress.md"
echo "## Subagent Start - $TIMESTAMP" >> "$PROGRESS_FILE"
echo "- Agent: $AGENT_TYPE ($AGENT_ID)" >> "$PROGRESS_FILE"
echo "- Status: IN_PROGRESS" >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

# Output JSON cho Claude Code hook system
jq -n \
    --arg agent_id "$AGENT_ID" \
    --arg agent_type "$AGENT_TYPE" \
    --arg timestamp "$TIMESTAMP" \
    '{
        "hookSpecificOutput": {
            "hookEventName": "SubagentStart",
            "additionalContext": ("Subagent " + $agent_type + " started at " + $timestamp)
        }
    }'

exit 0
HOOK_START

# SubagentStop hook
cat > "$PROJECT_ROOT/.claude/hooks/subagent-stop.sh" << 'HOOK_STOP'
#!/bin/bash
# =============================================================================
# Hook: SubagentStop
# Description: Chạy khi một subagent hoàn thành thực thi
# Purpose: Log stage completion, cập nhật _queue.json status = COMPLETED
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# hooks/ -> .claude/ -> project root (3 levels)
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
SKILL_CONTEXT="$PROJECT_DIR/.skill-context"
LOGS_DIR="$SKILL_CONTEXT/logs"
QUEUE_FILE="$SKILL_CONTEXT/_queue.json"

# Đọc JSON input từ stdin
INPUT=$(cat)

# Trích xuất thông tin
AGENT_ID=$(echo "$INPUT" | jq -r '.agent_id // "unknown"')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "unknown"')
LAST_MESSAGE=$(echo "$INPUT" | jq -r '.last_assistant_message // ""')
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Tạo thư mục logs nếu chưa có
mkdir -p "$LOGS_DIR"

# Log vào file
LOG_FILE="$LOGS_DIR/pipeline.log"
echo "[$TIMESTAMP] SUBAGENT_STOP: agent_id=$AGENT_ID, agent_type=$AGENT_TYPE" >> "$LOG_FILE"

# Kiểm tra nếu đang chạy pipeline (_queue.json tồn tại)
if [ -f "$QUEUE_FILE" ]; then
    echo "[$TIMESTAMP] Pipeline detected, stage completed." >> "$LOG_FILE"
    echo "[$TIMESTAMP] Queue updated: COMPLETED" >> "$LOG_FILE"
fi

# Cập nhật progress tracking
PROGRESS_FILE="$SKILL_CONTEXT/shared/progress.md"
echo "## Subagent Stop - $TIMESTAMP" >> "$PROGRESS_FILE"
echo "- Agent: $AGENT_TYPE ($AGENT_ID)" >> "$PROGRESS_FILE"
echo "- Status: COMPLETED" >> "$PROGRESS_FILE"
echo "- Last message: ${LAST_MESSAGE:0:100}..." >> "$PROGRESS_FILE"
echo "" >> "$PROGRESS_FILE"

# Tạo thư mục results nếu chưa có
mkdir -p "$SKILL_CONTEXT/results"

# Lưu kết quả vào file
RESULT_FILE="$SKILL_CONTEXT/results/${AGENT_TYPE}_${AGENT_ID}.json"
echo "$INPUT" > "$RESULT_FILE"

# Output JSON cho Claude Code hook system
jq -n \
    --arg agent_id "$AGENT_ID" \
    --arg agent_type "$AGENT_TYPE" \
    --arg timestamp "$TIMESTAMP" \
    '{
        "hookSpecificOutput": {
            "hookEventName": "SubagentStop",
            "additionalContext": ("Subagent " + $agent_type + " completed at " + $timestamp)
        }
    }'

exit 0
HOOK_STOP

chmod +x "$PROJECT_ROOT/.claude/hooks/subagent-start.sh"
chmod +x "$PROJECT_ROOT/.claude/hooks/subagent-stop.sh"

echo -e "${GREEN}✓ Installed subagent-start.sh and subagent-stop.sh${NC}"

# =============================================================================
# Step 4: Update settings.json with hooks
# =============================================================================
echo -e "\n${YELLOW}[4/7] Updating settings.json...${NC}"

SETTINGS_FILE="$PROJECT_ROOT/.claude/settings.json"

# Backup existing settings
if [ -f "$SETTINGS_FILE" ]; then
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}✓ Backed up existing settings.json${NC}"
fi

# Create settings with hooks
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
        "matcher": "",
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
        "matcher": "",
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
        "matcher": "",
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

echo -e "${GREEN}✓ Updated settings.json with SubagentStart/SubagentStop hooks${NC}"

# =============================================================================
# Step 5: Create .skill-context directory structure
# =============================================================================
echo -e "\n${YELLOW}[5/7] Creating .skill-context directory...${NC}"

mkdir -p "$PROJECT_ROOT/.skill-context/logs"
mkdir -p "$PROJECT_ROOT/.skill-context/results"
mkdir -p "$PROJECT_ROOT/.skill-context/shared"
mkdir -p "$PROJECT_ROOT/.skill-context/pipelines"
mkdir -p "$PROJECT_ROOT/.skill-context/templates"
mkdir -p "$PROJECT_ROOT/.skill-context/skills"

echo -e "${GREEN}✓ Created .skill-context directories${NC}"

# =============================================================================
# Step 5b: Install Skills (from package or .claude/skills/)
# =============================================================================
echo -e "\n${YELLOW}[5b/7] Installing skills...${NC}"

# List of skills to install
SKILLS=(
    "flow-design-analyst"
    "sequence-design-analyst"
    "class-diagram-analyst"
    "activity-diagram-design-analyst"
    "schema-design-analyst"
    "ui-architecture-analyst"
    "ui-pencil-drawer"
    "skill-architect"
    "skill-builder"
    "skill-planner"
)

# Priority: 1) Package skills, 2) Project .claude/skills
for skill in "${SKILLS[@]}"; do
    # First check package directory
    if [ -d "$PACKAGE_SKILLS_DIR/$skill" ]; then
        echo "  - Copying $skill from package"
        mkdir -p "$PROJECT_ROOT/.claude/skills"
        cp -r "$PACKAGE_SKILLS_DIR/$skill" "$PROJECT_ROOT/.claude/skills/"
    elif [ -d "$PROJECT_ROOT/.claude/skills/$skill" ]; then
        echo "  - Using existing $skill from project .claude/skills/"
    else
        echo "  - Note: $skill not found (will use default)"
    fi
done

# Also install pipeline-orchestrator agent if in package
if [ -f "$PACKAGE_AGENTS_DIR/pipeline-orchestrator.md" ]; then
    echo "  - Installing pipeline-orchestrator agent"
    mkdir -p "$PROJECT_ROOT/.claude/agents"
    cp "$PACKAGE_AGENTS_DIR/pipeline-orchestrator.md" "$PROJECT_ROOT/.claude/agents/"
fi

# Ensure .claude/skills directory exists
if [ -d "$PROJECT_ROOT/.claude/skills" ] && [ "$(ls -A "$PROJECT_ROOT/.claude/skills" 2>/dev/null)" ]; then
    echo -e "${GREEN}✓ Installed skills${NC}"
else
    echo -e "${YELLOW}! No skills installed, using templates only${NC}"
fi

# =============================================================================
# Step 6: Create templates (Note: skills come from .claude/skills/ in the package)
# =============================================================================
echo -e "\n${YELLOW}[6/7] Creating pipeline templates...${NC}"

# Pipeline template
cat > "$PROJECT_ROOT/.skill-context/templates/pipeline-template.yaml" << 'PIPELINE_TEMPLATE'
# Pipeline Configuration Template
# Copy to .skill-context/pipelines/{name}.yaml and customize

name: "{{pipeline_name}}"
version: "1.0"
description: "{{description}}"

# Define stages in execution order
stages:
  - id: stage_01
    skill: flow-design-analyst
    depends_on: []
    input: .skill-context/tasks/stage_01_input.json
    output_path: Docs/life-2/diagrams/flow/

  - id: stage_02
    skill: sequence-design-analyst
    depends_on: [stage_01]
    input: .skill-context/tasks/stage_02_input.json
    output_path: Docs/life-2/diagrams/sequence/

  - id: stage_03
    skill: class-diagram-analyst
    depends_on: [stage_02]
    input: .skill-context/tasks/stage_03_input.json
    output_path: Docs/life-2/diagrams/class/

# Execution settings
execution:
  mode: sequential
  max_retries: 2
  continue_on_error: false
  timeout_per_stage: 1800
PIPELINE_TEMPLATE

# Queue template
cat > "$PROJECT_ROOT/.skill-context/templates/_queue-template.json" << 'QUEUE_TEMPLATE'
{
  "pipeline_id": "{{pipeline_id}}",
  "pipeline_name": "{{pipeline_name}}",
  "version": "1.0",
  "description": "{{description}}",
  "started_at": "{{started_at}}",
  "status": "PENDING",
  "current_stage": null,
  "stages": {},
  "execution": {
    "mode": "sequential",
    "max_retries": 2,
    "continue_on_error": false
  },
  "context": {
    "total_stages": 0,
    "completed_stages": 0,
    "failed_stages": 0,
    "current_errors": []
  },
  "history": []
}
QUEUE_TEMPLATE

# Task template
cat > "$PROJECT_ROOT/.skill-context/templates/task-template.json" << 'TASK_TEMPLATE'
{
  "task_id": "{{task_id}}",
  "skill": "{{skill_name}}",
  "description": "{{description}}",
  "input_files": [],
  "expected_outputs": [],
  "params": {}
}
TASK_TEMPLATE

echo -e "${GREEN}✓ Created pipeline templates${NC}"

# =============================================================================
# Step 7: Verify installation
# =============================================================================
echo -e "\n${YELLOW}[7/7] Verifying installation...${NC}"

# Check hook scripts are executable
if [ -x "$PROJECT_ROOT/.claude/hooks/subagent-start.sh" ]; then
    echo -e "${GREEN}✓ subagent-start.sh is executable${NC}"
else
    echo -e "${RED}✗ subagent-start.sh is NOT executable${NC}"
fi

if [ -x "$PROJECT_ROOT/.claude/hooks/subagent-stop.sh" ]; then
    echo -e "${GREEN}✓ subagent-stop.sh is executable${NC}"
else
    echo -e "${RED}✗ subagent-stop.sh is NOT executable${NC}"
fi

# Verify settings.json is valid JSON
if jq . "$SETTINGS_FILE" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ settings.json is valid JSON${NC}"
else
    echo -e "${RED}✗ settings.json is NOT valid JSON${NC}"
fi

# Test hook scripts
echo -e "\n${YELLOW}Testing hook scripts...${NC}"
echo '{"agent_id":"test-123","agent_type":"test-agent"}' | bash "$PROJECT_ROOT/.claude/hooks/subagent-start.sh" > /dev/null && echo -e "${GREEN}✓ subagent-start.sh test passed${NC}" || echo -e "${RED}✗ subagent-start.sh test failed${NC}"

echo '{"agent_id":"test-123","agent_type":"test-agent","last_assistant_message":"Completed"}' | bash "$PROJECT_ROOT/.claude/hooks/subagent-stop.sh" > /dev/null && echo -e "${GREEN}✓ subagent-stop.sh test passed${NC}" || echo -e "${RED}✗ subagent-stop.sh test failed${NC}"

# =============================================================================
# Summary
# =============================================================================
echo -e "\n${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "Pipeline Runner has been installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code to load new hooks"
echo "  2. Create a pipeline: cp .skill-context/templates/pipeline-template.yaml .skill-context/pipelines/my-pipeline.yaml"
echo "  3. Run the pipeline using Claude Code"
echo ""
echo "Directory structure created:"
echo "  .claude/hooks/subagent-start.sh"
echo "  .claude/hooks/subagent-stop.sh"
echo "  .skill-context/logs/"
echo "  .skill-context/results/"
echo "  .skill-context/shared/"
echo "  .skill-context/pipelines/"
echo "  .skill-context/templates/"
echo ""
