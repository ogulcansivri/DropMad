# 🗂️ DropShelf

> **A lightweight, open-source macOS temporary file shelf (Dropover / Yoink alternative) built natively with Swift & SwiftUI.**

<p align="center">
  <img src="https://img.shields.io/badge/Platform-macOS%2013%2B-blue?style=flat-square&logo=apple" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-5.9%2B-orange?style=flat-square&logo=swift" alt="Swift">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License">
</p>

---

## 💡 The Problem

Moving files between **different full-screen apps, browser tabs, or macOS Spaces** is awkward. You start dragging a file in Finder, need to swipe three desktops over, switch apps with Mission Control, and hope your finger doesn't slip off the trackpad.

**DropShelf** solves this with a floating, multi-space temporary shelf that appears when you need it and holds your files until you're ready to drop them elsewhere.

---

## ✨ Features

- 🛸 **Floats Across All Spaces:** Visible over full-screen apps and across all virtual desktops (`.canJoinAllSpaces`).
- 📥 **Drag-In Anything:** Accepts files, folders, images, documents, and URLs from Finder, browsers, or other apps.
- 📤 **Seamless Drag-Out:** Drag items directly out of the shelf into Slack, Discord, Finder, Mail, or web uploads.
- ⚡ **Instant Global Summon:** Press `⌥ + Space` (Option + Space) to summon the shelf right under your mouse pointer.
- 🖼️ **Quick Previews:** High-resolution asynchronous file thumbnails via macOS `QuickLookThumbnailing`.
- 🗜️ **One-Click "Zip All":** Compress everything currently held in the shelf into a single `.zip` file ready to share.
- 📋 **Copy All:** Quick button to copy all file paths/objects to the clipboard.
- 🪶 **Zero Overhead:** Pure Swift & SwiftUI with AppKit, running as a sleek Menu Bar accessory without Dock clutter.

---

## ⌨️ Shortcuts & Interactions

| Action | Shortcut / Gesture |
|---|---|
| **Toggle Shelf (Under Cursor)** | `⌥ + Space` (Option + Space) |
| **Open File** | Double click on item card |
| **Reveal in Finder** | Right click item card → *Reveal in Finder* |
| **Drag Out** | Click & drag any card out to target app |
| **Menu Bar Actions** | Left-click tray icon to toggle, Right-click for menu |

---

## 🚀 Installation & Building

### Prerequisites
- macOS 13.0 (Ventura) or later
- Xcode or Swift Command Line Tools (`swift --version`)

### Quick Build (.app Bundle)
Clone the repository and run the build script:

```bash
git clone https://github.com/YOUR_USERNAME/DropShelf.git
cd DropShelf
./scripts/build_app.sh
```

The compiled `DropShelf.app` will be created inside `./build/DropShelf.app`. You can double click it or move it to your `/Applications` folder:

```bash
cp -R ./build/DropShelf.app /Applications/
open /Applications/DropShelf.app
```

---

## 🛠️ Tech Stack & Architecture

- **UI:** SwiftUI + native `NSVisualEffectView` HUD frosted glass background.
- **Windowing:** Non-activating floating `NSPanel` with `.stationary` and `.fullScreenAuxiliary` behavior.
- **Thumbnails:** `QLThumbnailGenerator` for high-performance preview generation.
- **Data Transfer:** `NSItemProvider` & `Transferable` for cross-application drag-and-drop.

---

## 🤝 Contributing

Contributions, feature requests, and pull requests are welcome!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
