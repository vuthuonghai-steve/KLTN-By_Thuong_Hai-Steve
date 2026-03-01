#!/bin/bash
# =============================================================================
# Steve Void Project Package Script v3
# Purpose: Package Steve Void (KLTN) core .claude environment & setup script
# Usage: bash scripts/package.sh [output-dir]
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# In this specific repo, scripts are in workspace/scripts, so KLTN root is two levels up
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
OUTPUT_DIR="${1:-$PROJECT_ROOT}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${GREEN}=== Packaging Steve Void Core Ecosystem ===${NC}"
echo "Root: $PROJECT_ROOT"

# Create temporary staging directory
STAGING_DIR=$(mktemp -d)
PACKAGE_NAME="claude-agent-ecosystem"

echo "Staging directory: $STAGING_DIR"

# Target directories to package
mkdir -p "$STAGING_DIR/$PACKAGE_NAME/.claude"
mkdir -p "$STAGING_DIR/$PACKAGE_NAME/scripts"

# Use defined list of core components
COMPONENTS=(
    "agents"
    "commands"
    "hooks"
    "knowledge"
    "rules"
    "skills"
)

echo -e "${YELLOW}[1/3] Copying .claude directories...${NC}"
for comp in "${COMPONENTS[@]}"; do
    if [ -d "$PROJECT_ROOT/.claude/$comp" ]; then
        cp -r "$PROJECT_ROOT/.claude/$comp" "$STAGING_DIR/$PACKAGE_NAME/.claude/"
        echo "  - .claude/$comp/"
    fi
done

echo -e "${YELLOW}[2/3] Copying configuration files...${NC}"
for file in "settings.json" "settings.local.json"; do
    if [ -f "$PROJECT_ROOT/.claude/$file" ]; then
        cp "$PROJECT_ROOT/.claude/$file" "$STAGING_DIR/$PACKAGE_NAME/.claude/"
        echo "  - .claude/$file"
    fi
done

echo -e "${YELLOW}[3/3] Copying scripts...${NC}"
if [ -f "$PROJECT_ROOT/workspace/scripts/setup.sh" ]; then
    cp "$PROJECT_ROOT/workspace/scripts/setup.sh" "$STAGING_DIR/$PACKAGE_NAME/scripts/"
    echo "  - scripts/setup.sh"
elif [ -f "$SCRIPT_DIR/setup.sh" ]; then
    cp "$SCRIPT_DIR/setup.sh" "$STAGING_DIR/$PACKAGE_NAME/scripts/"
    echo "  - scripts/setup.sh"
fi

# =============================================================================
# Create install.sh
# =============================================================================
echo -e "${YELLOW}Creating install.sh...${NC}"
cat > "$STAGING_DIR/$PACKAGE_NAME/install.sh" << 'INSTALL_SCRIPT'
#!/bin/bash
# =============================================================================
# Steve Void Ecosystem Installer
# Usage: Run this from your new project's root: bash claude-agent-ecosystem/install.sh
# =============================================================================
set -e

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$PWD"

echo -e "\033[0;36m=== Installing Steve Void Core Ecosystem ===\033[0m"
echo -e "Target Project Root: $TARGET_DIR"

if [ ! -d "$SOURCE_DIR/.claude" ]; then
    echo -e "\033[0;31mError: Cannot find .claude directory in $SOURCE_DIR\033[0m"
    exit 1
fi

# Prevent installing into itself
if [ "$SOURCE_DIR" == "$TARGET_DIR" ]; then
    echo -e "\033[0;33mWarning: You are running install.sh inside the extracted folder. Assuming you want to install it here.\033[0m"
    bash "$TARGET_DIR/scripts/setup.sh"
    exit 0
fi

echo -n "Copying .claude and scripts directories... "
cp -r "$SOURCE_DIR/.claude" "$TARGET_DIR/"
cp -r "$SOURCE_DIR/scripts" "$TARGET_DIR/"
echo -e "\033[0;32mDone\033[0m"

echo -e "Configuring ecosystem..."
bash "$TARGET_DIR/scripts/setup.sh"

echo ""
echo -e "\033[0;32m✓ Installation Complete!\033[0m"
echo -e "\033[0;33mYou can safely delete the extracted 'claude-agent-ecosystem' directory now.\033[0m"
INSTALL_SCRIPT
chmod +x "$STAGING_DIR/$PACKAGE_NAME/install.sh"

# =============================================================================
# Make scripts executable
# =============================================================================
chmod +x "$STAGING_DIR/$PACKAGE_NAME/scripts/"*.sh 2>/dev/null || true
chmod +x "$STAGING_DIR/$PACKAGE_NAME/.claude/hooks/"*.sh 2>/dev/null || true

# =============================================================================
# Create tar.gz file
# =============================================================================
echo -e "\n${YELLOW}Creating tar.gz archive...${NC}"
cd "$STAGING_DIR"
tar -czvf "$OUTPUT_DIR/$PACKAGE_NAME.tar.gz" "$PACKAGE_NAME" > /dev/null

# Cleanup
rm -rf "$STAGING_DIR"

echo ""
echo -e "${GREEN}✓ Package created successfully: $OUTPUT_DIR/$PACKAGE_NAME.tar.gz${NC}"
echo ""
echo -e "${CYAN}To use this package in a new project:${NC}"
echo "  1. Move $PACKAGE_NAME.tar.gz to your new project root."
echo "  2. Extract it (this will create a folder named '$PACKAGE_NAME')."
echo "  3. From your new project root, run: bash $PACKAGE_NAME/install.sh"
echo ""
