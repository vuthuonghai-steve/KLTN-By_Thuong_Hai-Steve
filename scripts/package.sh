#!/bin/bash
# =============================================================================
# Pipeline Package Script
# Purpose: Package Claude Code Pipeline Runner as a portable zip file
# Usage: bash scripts/package.sh [output-dir]
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="${1:-$SCRIPT_DIR}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Packaging Pipeline Runner ===${NC}"

# Create temporary staging directory
STAGING_DIR=$(mktemp -d)
PACKAGE_NAME="claude-pipeline-setup"

echo "Staging directory: $STAGING_DIR"

# Create directory structure in staging
mkdir -p "$STAGING_DIR/$PACKAGE_NAME/.claude/hooks"
mkdir -p "$STAGING_DIR/$PACKAGE_NAME/.claude/agents"
mkdir -p "$STAGING_DIR/$PACKAGE_NAME/.claude/skills"
mkdir -p "$STAGING_DIR/$PACKAGE_NAME/.skill-context/templates"

# Copy hook scripts
echo -e "${YELLOW}Copying hook scripts...${NC}"
cp "$PROJECT_ROOT/.claude/hooks/subagent-start.sh" "$STAGING_DIR/$PACKAGE_NAME/.claude/hooks/"
cp "$PROJECT_ROOT/.claude/hooks/subagent-stop.sh" "$STAGING_DIR/$PACKAGE_NAME/.claude/hooks/"

# Copy pipeline-orchestrator agent
echo -e "${YELLOW}Copying pipeline-orchestrator agent...${NC}"
if [ -f "$PROJECT_ROOT/.claude/agents/pipeline-orchestrator.md" ]; then
    cp "$PROJECT_ROOT/.claude/agents/pipeline-orchestrator.md" "$STAGING_DIR/$PACKAGE_NAME/.claude/agents/"
fi

# Copy templates
echo -e "${YELLOW}Copying templates...${NC}"
cp "$PROJECT_ROOT/.skill-context/templates/pipeline-template.yaml" "$STAGING_DIR/$PACKAGE_NAME/.skill-context/templates/"
cp "$PROJECT_ROOT/.skill-context/templates/_queue-template.json" "$STAGING_DIR/$PACKAGE_NAME/.skill-context/templates/"
cp "$PROJECT_ROOT/.skill-context/templates/task-template.json" "$STAGING_DIR/$PACKAGE_NAME/.skill-context/templates/"

# Copy skills from .claude/skills/ (canonical source)
echo -e "${YELLOW}Copying skills from .claude/skills/...${NC}"
SKILLS_TO_COPY=(
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

for skill in "${SKILLS_TO_COPY[@]}"; do
    if [ -d "$PROJECT_ROOT/.claude/skills/$skill" ]; then
        echo "  - $skill"
        cp -r "$PROJECT_ROOT/.claude/skills/$skill" "$STAGING_DIR/$PACKAGE_NAME/.claude/skills/"
    fi
done

# Copy setup script
echo -e "${YELLOW}Copying setup script...${NC}"
cp "$SCRIPT_DIR/setup.sh" "$STAGING_DIR/$PACKAGE_NAME/"

# Copy README
cp "$SCRIPT_DIR/README.md" "$STAGING_DIR/$PACKAGE_NAME/"

# Make scripts executable
chmod +x "$STAGING_DIR/$PACKAGE_NAME/setup.sh"
chmod +x "$STAGING_DIR/$PACKAGE_NAME/.claude/hooks/subagent-start.sh"
chmod +x "$STAGING_DIR/$PACKAGE_NAME/.claude/hooks/subagent-stop.sh"

# Create zip file
echo -e "${YELLOW}Creating zip archive...${NC}"
cd "$STAGING_DIR"
zip -r "$OUTPUT_DIR/$PACKAGE_NAME.zip" "$PACKAGE_NAME"

# Cleanup
rm -rf "$STAGING_DIR"

echo -e "${GREEN}✓ Package created: $OUTPUT_DIR/$PACKAGE_NAME.zip${NC}"
echo ""
echo "Contents:"
unzip -l "$OUTPUT_DIR/$PACKAGE_NAME.zip" | grep -v "Archive:" | grep -v "Length" | grep -v "^$"

echo ""
echo -e "${GREEN}=== Packaging Complete ===${NC}"
echo ""
echo "To use this package in a new project:"
echo "  1. Extract: unzip claude-pipeline-setup.zip"
echo "  2. Run: bash claude-pipeline-setup/setup.sh"
echo ""
