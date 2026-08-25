#!/bin/bash
set -e

echo "🔨 Building DropMad..."
./scripts/build_app.sh

APP_NAME="DropMad"
VERSION="1.0.0"
BUILD_DIR="./build"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
DMG_PATH="${BUILD_DIR}/${DMG_NAME}"
STAGING_DIR="${BUILD_DIR}/dmg_staging"

echo "📦 Preparing DMG staging directory..."
rm -rf "$STAGING_DIR" "$DMG_PATH"
mkdir -p "$STAGING_DIR"

# Copy App to staging
cp -R "${BUILD_DIR}/${APP_NAME}.app" "$STAGING_DIR/"

# Create symlink to /Applications
ln -s /Applications "$STAGING_DIR/Applications"

echo "💿 Creating DMG image..."
hdiutil create -volname "${APP_NAME}" -srcfolder "$STAGING_DIR" -ov -format UDZO "$DMG_PATH"

# Cleanup staging
rm -rf "$STAGING_DIR"

echo ""
echo "🎉 DMG successfully created at: ${DMG_PATH}"
echo "👉 Users can double-click this DMG and drag DropMad directly into Applications!"
