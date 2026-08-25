#!/bin/bash
set -e

echo "🔨 Building DropMad..."
./scripts/build_app.sh

APP_NAME="DropMad"
VERSION="1.0.0"
BUILD_DIR="./build"
DMG_FINAL="${BUILD_DIR}/${APP_NAME}-${VERSION}.dmg"
DMG_TEMP="${BUILD_DIR}/temp.dmg"
STAGING_DIR="${BUILD_DIR}/dmg_staging"
VOL_NAME="${APP_NAME}"

echo "📦 Preparing DMG staging..."
rm -rf "$STAGING_DIR" "$DMG_FINAL" "$DMG_TEMP"
mkdir -p "$STAGING_DIR"

# Copy App and Applications link
cp -R "${BUILD_DIR}/${APP_NAME}.app" "$STAGING_DIR/"
ln -s /Applications "$STAGING_DIR/Applications"

# Add background image and make it invisible
if [ -f "Resources/dmg_background.png" ]; then
    mkdir -p "$STAGING_DIR/.background"
    cp "Resources/dmg_background.png" "$STAGING_DIR/.background/background.png"
    SetFile -a V "$STAGING_DIR/.background" "$STAGING_DIR/.background/background.png" 2>/dev/null || true
    chflags hidden "$STAGING_DIR/.background" "$STAGING_DIR/.background/background.png" 2>/dev/null || true
fi

chmod -R 755 "$STAGING_DIR"

echo "💿 Creating temporary writable DMG..."
hdiutil create -srcfolder "$STAGING_DIR" -volname "$VOL_NAME" -fs HFS+ -fsargs "-c c=64,a=16,e=16" -format UDRW -size 120M "$DMG_TEMP"

echo "🎨 Styling DMG window layout..."
DEVICE=$(hdiutil attach -readwrite -noverify "$DMG_TEMP" | egrep '^/dev/' | sed 1q | awk '{print $1}')
MOUNT_POINT="/Volumes/$VOL_NAME"

sleep 2

# Clean volume noise
rm -rf "$MOUNT_POINT/.fseventsd" "$MOUNT_POINT/.Trashes" 2>/dev/null || true

# AppleScript with proper POSIX file alias for background
osascript <<EOF
tell application "Finder"
    tell disk "$VOL_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {300, 200, 960, 600}
        set theViewOptions to the icon view options of container window
        set icon size of theViewOptions to 100
        set arrangement of theViewOptions to not arranged
        try
            set background picture of theViewOptions to (POSIX file "$MOUNT_POINT/.background/background.png" as alias)
        end try
        set position of item "$APP_NAME.app" of container window to {160, 240}
        set position of item "Applications" of container window to {500, 240}
        close
        open
        update without registering applications
        delay 2
    end tell
end tell
EOF

# Sync & unmount
sync
hdiutil detach "$DEVICE" || hdiutil detach "$MOUNT_POINT" -force

echo "🗜️ Compressing final DMG..."
hdiutil convert "$DMG_TEMP" -format UDZO -imagekey zlib-level=9 -o "$DMG_FINAL"
rm -rf "$DMG_TEMP" "$STAGING_DIR"

echo ""
echo "🎉 Styled DMG successfully created at: ${DMG_FINAL}"
