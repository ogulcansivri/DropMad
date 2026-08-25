#!/bin/bash
set -e

echo "🚀 Installing DropMad for macOS..."

REPO="ogulcansivri/DropMad"
APP_NAME="DropMad.app"
DEST_DIR="/Applications"

# Fetch latest release download URL
LATEST_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep "browser_download_url.*\.zip" | cut -d '"' -f 4 || true)

TEMP_DIR=$(mktemp -d)

if [ -n "$LATEST_URL" ]; then
    echo "📥 Downloading latest release from GitHub..."
    curl -L "$LATEST_URL" -o "${TEMP_DIR}/DropMad.zip"
    echo "📦 Extracting..."
    unzip -q "${TEMP_DIR}/DropMad.zip" -d "$TEMP_DIR"
else
    echo "⚙️ Building directly from source..."
    git clone --depth 1 "https://github.com/${REPO}.git" "${TEMP_DIR}/DropMad_src"
    cd "${TEMP_DIR}/DropMad_src"
    ./scripts/build_app.sh
    cp -R "./build/${APP_NAME}" "$TEMP_DIR/"
fi

echo "🚚 Moving to /Applications..."
rm -rf "${DEST_DIR}/${APP_NAME}"
cp -R "${TEMP_DIR}/${APP_NAME}" "${DEST_DIR}/"

# Clean quarantine attribute so macOS doesn't block it
xattr -rd com.apple.quarantine "${DEST_DIR}/${APP_NAME}" 2>/dev/null || true

# Cleanup temp
rm -rf "$TEMP_DIR"

echo "✨ DropMad has been successfully installed in /Applications!"
echo "🚀 Launching DropMad..."
open "${DEST_DIR}/${APP_NAME}"
