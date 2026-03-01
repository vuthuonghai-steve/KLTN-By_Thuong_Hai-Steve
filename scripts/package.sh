#!/bin/bash
# =============================================================================
# Steve Void Project Package Script
# Purpose: Package Steve Void (KLTN) setup files as a portable zip
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
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}=== Packaging Steve Void Project ===${NC}"
echo -e "${BLUE}Project: NeoSocial - Knowledge Sharing Social Network${NC}"
echo "Root: $PROJECT_ROOT"

# Create temporary staging directory
STAGING_DIR=$(mktemp -d)
PACKAGE_NAME="steve-void-setup"

echo "Staging directory: $STAGING_DIR"

# Create directory structure in staging
mkdir -p "$STAGING_DIR/$PACKAGE_NAME/.claude/hooks"
mkdir -p "$STAGING_DIR/$PACKAGE_NAME/.claude/rules"
mkdir -p "$STAGING_DIR/$PACKAGE_NAME/.agent/skills"

# =============================================================================
# Copy Hook Scripts
# =============================================================================
echo -e "${YELLOW}[1/4] Copying hook scripts...${NC}"

HOOKS=(
    "pre-write-check.sh"
    "session-end.sh"
    "subagent-start.sh"
    "subagent-stop.sh"
)

for hook in "${HOOKS[@]}"; do
    if [ -f "$PROJECT_ROOT/.claude/hooks/$hook" ]; then
        cp "$PROJECT_ROOT/.claude/hooks/$hook" "$STAGING_DIR/$PACKAGE_NAME/.claude/hooks/"
        echo "  - $hook"
    fi
done

# =============================================================================
# Copy Claude Rules
# =============================================================================
echo -e "${YELLOW}[2/4] Copying Claude rules...${NC}"

if [ -d "$PROJECT_ROOT/.claude/rules" ]; then
    cp -r "$PROJECT_ROOT/.claude/rules" "$STAGING_DIR/$PACKAGE_NAME/.claude/"
    echo "  - rules/"
fi

# =============================================================================
# Copy Skills from .claude/skills/ (canonical source)
# =============================================================================
echo -e "${YELLOW}[3/4] Copying skills from .claude/skills/...${NC}"

# Copy all skills from .claude/skills/ (canonical source)
if [ -d "$PROJECT_ROOT/.claude/skills" ]; then
    for dir in "$PROJECT_ROOT/.claude/skills"/*/; do
        if [ -d "$dir" ]; then
            skill_name=$(basename "$dir")
            # Skip files like skills.yaml
            if [ "$skill_name" != "skills.yaml" ] && [ -f "$dir/SKILL.md" ]; then
                echo "  - $skill_name"
                cp -r "$dir" "$STAGING_DIR/$PACKAGE_NAME/.claude/skills/"
            fi
        fi
    done
fi

# =============================================================================
# Copy Setup Script
# =============================================================================
echo -e "${YELLOW}[4/4] Copying setup script...${NC}"

cp "$SCRIPT_DIR/setup.sh" "$STAGING_DIR/$PACKAGE_NAME/"

# Make scripts executable
chmod +x "$STAGING_DIR/$PACKAGE_NAME/setup.sh"
chmod +x "$STAGING_DIR/$PACKAGE_NAME/.claude/hooks/"*.sh

# =============================================================================
# Create zip file
# =============================================================================
echo -e "${YELLOW}Creating zip archive...${NC}"
cd "$STAGING_DIR"
zip -r "$OUTPUT_DIR/$PACKAGE_NAME.zip" "$PACKAGE_NAME"

# Cleanup
rm -rf "$STAGING_DIR"

echo -e "${GREEN}✓ Package created: $OUTPUT_DIR/$PACKAGE_NAME.zip${NC}"
echo ""
echo "Contents:"
unzip -l "$OUTPUT_DIR/$PACKAGE_NAME.zip" | grep -v "Archive:" | grep -v "Length" | grep -v "^$" | head -30

echo ""
if [ $(unzip -l "$OUTPUT_DIR/$PACKAGE_NAME.zip" | grep -c "skills/") -gt 30 ]; then
    SKILL_COUNT=$(unzip -l "$OUTPUT_DIR/$PACKAGE_NAME.zip" | grep "\.agent/skills/.*SKILL\.md" | wc -l)
    echo -e "${GREEN}✓ Packaged $SKILL_COUNT skills${NC}"
fi

echo ""
echo -e "${GREEN}=== Packaging Complete ===${NC}"
echo ""
echo "To use this package in a new project:"
echo "  1. Extract: unzip steve-void-setup.zip"
echo "  2. Run: bash steve-void-setup/setup.sh"
echo ""
