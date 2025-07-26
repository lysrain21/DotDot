#!/bin/bash
set -e

echo "🦄 TaskAgent Build Script"
echo "========================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKEND_DIR="$PROJECT_DIR/backend"
FLUTTER_DIR="$PROJECT_DIR/task_agent_flutter"
BUILD_DIR="$PROJECT_DIR/build"

echo -e "${YELLOW}📁 Project Directory: $PROJECT_DIR${NC}"

# Create build directory
mkdir -p "$BUILD_DIR"

# Build Backend
echo -e "${GREEN}🔧 Building Python backend...${NC}"
cd "$BACKEND_DIR"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Install PyInstaller
pip install pyinstaller

# Build executable
echo "Building executable..."
pyinstaller --onefile \
    --name taskagentd \
    --add-data "requirements.txt:./" \
    --hidden-import="sqlmodel" \
    --hidden-import="openai" \
    main.py

# Copy executable to build directory
cp dist/taskagentd "$BUILD_DIR/"
echo -e "${GREEN}✅ Backend built successfully${NC}"

# Build Flutter App
echo -e "${GREEN}📱 Building Flutter app...${NC}"
cd "$FLUTTER_DIR"

# Clean previous builds
flutter clean

# Build macOS app
flutter build macos --release

# Copy backend executable to Flutter app
echo "Copying backend executable to Flutter app..."
cp "$BUILD_DIR/taskagentd" "build/macos/Build/Products/Release/Task Agent.app/Contents/MacOS/"

echo -e "${GREEN}✅ Flutter app built successfully${NC}"
echo -e "${GREEN}📦 Build complete! App available at: $FLUTTER_DIR/build/macos/Build/Products/Release/Task Agent.app${NC}"