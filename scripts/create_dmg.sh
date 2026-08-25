#!/bin/bash
set -e

echo "🔨 Building DropMad..."
./scripts/build_app.sh

APP_NAME="DropMad"
VERSION="1.0.0"
BUILD_DIR="./build"
DMG_FINAL="${BUILD_DIR}/${APP_NAME}-${VERSION}.dmg"
STAGING_DIR="${BUILD_DIR}/dmg_staging"

echo "📦 Preparing clean DMG staging..."
rm -rf "$STAGING_DIR" "$DMG_FINAL"
mkdir -p "$STAGING_DIR"

# Copy ONLY DropMad.app and Applications symlink
cp -R "${BUILD_DIR}/${APP_NAME}.app" "$STAGING_DIR/"
ln -s /Applications "$STAGING_DIR/Applications"

echo "💿 Creating clean minimal DMG..."
hdiutil create -volname "${APP_NAME}" -srcfolder "$STAGING_DIR" -ov -format UDZO "$DMG_FINAL"

# Cleanup staging
rm -rf "$STAGING_DIR"

echo ""
echo "🎉 Clean minimalist DMG created at: ${DMG_FINAL}"
