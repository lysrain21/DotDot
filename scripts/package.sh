#!/bin/bash
set -e

echo "🎁 TaskAgent Packaging Script"
echo "============================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
FLUTTER_DIR="$PROJECT_DIR/task_agent_flutter"
PKG_DIR="$PROJECT_DIR/package"

# App name
APP_NAME="Task Agent"
APP_BUNDLE="Task Agent.app"
DMG_NAME="TaskAgent.dmg"

echo -e "${YELLOW}📁 Project Directory: $PROJECT_DIR${NC}"

# Create package directory
mkdir -p "$PKG_DIR"

# Build the app
echo -e "${GREEN}🔨 Building application...${NC}"
"$SCRIPT_DIR/build.sh"

# Copy app to package directory
echo "Copying app bundle..."
cp -R "$FLUTTER_DIR/build/macos/Build/Products/Release/$APP_BUNDLE" "$PKG_DIR/"

# Create DMG
echo -e "${GREEN}📦 Creating DMG...${NC}"
cd "$PKG_DIR"

# Create temporary DMG directory
mkdir -p dmg
mv "$APP_BUNDLE" dmg/

# Create DMG
hdiutil create -fs HFS+ -volname "$APP_NAME" -srcfolder dmg "$DMG_NAME"

# Clean up
rm -rf dmg

echo -e "${GREEN}✅ DMG created: $PKG_DIR/$DMG_NAME${NC}"
echo -e "${GREEN}🎉 Packaging complete!${NC}"