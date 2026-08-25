#!/bin/bash
set -e

echo "🔨 Building DropMad in Release mode..."
swift build -c release

APP_NAME="DropMad"
BUILD_DIR="./build"
APP_BUNDLE="$BUILD_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

echo "📦 Creating .app bundle structure..."
rm -rf "$APP_BUNDLE"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

echo "🚚 Copying binary and Info.plist..."
cp ".build/release/$APP_NAME" "$MACOS_DIR/$APP_NAME"
cp "Info.plist" "$CONTENTS_DIR/Info.plist"

if [ -f "Resources/AppIcon.icns" ]; then
    echo "🎨 Adding AppIcon.icns..."
    cp "Resources/AppIcon.icns" "$RESOURCES_DIR/AppIcon.icns"
fi

echo "✨ DropMad.app successfully built at: $APP_BUNDLE"
echo "👉 You can now run: open \"$APP_BUNDLE\" or move it to /Applications"
