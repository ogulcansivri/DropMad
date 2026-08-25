# 🗂️ DropMad

> **A lightweight, open-source macOS temporary file shelf (Dropover / Yoink alternative) built natively with Swift & SwiftUI.**
> 
> *macOS için Swift & SwiftUI ile yerel olarak geliştirilmiş, hafif ve açık kaynaklı geçici dosya rafı.*

<p align="center">
  <img src="https://img.shields.io/badge/Platform-macOS%2013%2B-blue?style=flat-square&logo=apple" alt="macOS 13+">
  <img src="https://img.shields.io/badge/Swift-5.9%2B-orange?style=flat-square&logo=swift" alt="Swift">
  <img src="https://img.shields.io/badge/Languages-English%20%7C%20T%C3%BCrk%C3%A7e-blueviolet?style=flat-square" alt="Languages">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License">
</p>

---

## 🌐 Language / Dil Seçimi
- [English Documentation](#-english) &bull; [📖 Full User Guide](GUIDE.md#-english-user-guide)
- [Türkçe Dokümantasyon](#-türkçe) &bull; [📖 Kapsamlı Kullanım Kılavuzu](GUIDE.md#-türkçe-kullanım-kılavuzu)

---

<a name="-english"></a>
## 🇬🇧 English

### 💡 The Problem
Moving files between **different full-screen apps, browser tabs, or macOS Spaces** is awkward. You start dragging a file in Finder, need to swipe three desktops over, switch apps with Mission Control, and hope your finger doesn't slip off the trackpad.

**DropMad** solves this with a floating, multi-space temporary shelf that appears when you need it and holds your files until you're ready to drop them elsewhere.

### ✨ Features
- 🛸 **Floats Across All Spaces:** Visible over full-screen apps and across all virtual desktops (`.canJoinAllSpaces`).
- 📥 **Drag-In Anything:** Accepts files, folders, images, documents, and URLs from Finder, browsers, or other apps.
- 📤 **Seamless Drag-Out:** Drag items directly out of the shelf into Slack, Discord, Finder, Mail, or web uploads.
- ⚡ **Instant Global Summon:** Press `⌥ + Space` (Option + Space) to summon the shelf right under your mouse pointer.
- 🖼️ **Quick Previews:** High-resolution asynchronous file thumbnails via macOS `QuickLookThumbnailing`.
- 🗜️ **One-Click "Zip All":** Compress everything currently held in the shelf into a single `.zip` file on a background queue.
- 📋 **Copy All:** Quick button to copy all file paths/objects to the clipboard.
- 📖 **Interactive In-App Guide:** Built-in illustrated guide available in English & Turkish.
- 🪶 **Zero Overhead:** Pure Swift & SwiftUI with AppKit, running as a sleek Menu Bar accessory without Dock clutter.

### ⌨️ Shortcuts & Interactions
| Action | Shortcut / Gesture |
|---|---|
| **Toggle Shelf (Under Cursor)** | `⌥ + Space` (Option + Space) |
| **Open Built-in Guide** | Click `?` in header or Menu Bar → User Guide |
| **Open File** | Double click on item card |
| **Reveal in Finder** | Right click item card → *Reveal in Finder* |
| **Drag Out** | Click & drag any card out to target app |
| **Menu Bar Actions** | Left-click tray icon to toggle, Right-click for menu & language switcher |

### 🚀 Installation & Setup

#### Option 1: One-Line Terminal Install (Recommended)
Paste this in your Terminal to download, install to `/Applications`, and launch DropMad instantly:

```bash
curl -fsSL https://raw.githubusercontent.com/ogulcansivri/DropMad/main/install.sh | bash
```

#### Option 2: Download DMG / ZIP
Download the latest **`DropMad-1.0.0.dmg`** or `.zip` from the [Releases](https://github.com/ogulcansivri/DropMad/releases) page and drag `DropMad.app` to your `/Applications` folder.

#### Option 3: Build From Source
```bash
git clone https://github.com/ogulcansivri/DropMad.git
cd DropMad
./scripts/create_dmg.sh
open build/DropMad-1.0.0.dmg
```

---

<a name="-türkçe"></a>
## 🇹🇷 Türkçe

### 💡 Problem Neydi?
Tam ekran uygulamalar (Xcode, Safari vb.) veya sanal masaüstleri (Spaces) arasında dosya sürükleyip bırakmak macOS'ta oldukça zordur. Finder'da bir dosyayı tutup üç masaüstü yana kaydırmak zorunda kalır veya Mission Control arasında parmağınızı trackpad'den kaçırmamaya çalışırsınız.

**DropMad**, bu sorunu masaüstünün üzerinde yüzen ve dosyalarınızı siz hedef uygulamaya geçene kadar güvenle tutan geçici bir raf ile çözer.

### ✨ Öne Çıkan Özellikler
- 🛸 **Tüm Masaüstlerinde (Spaces) Yüzer:** Tam ekran uygulamaların ve sanal masaüstlerinin üzerinde her zaman görünür kalır.
- 📥 **Her Şeyi Kabul Eder:** Finder'dan dosyalar, klasörler, fotoğraflar veya tarayıcıdan indirilen görselleri sürükleyip bırakabilirsiniz.
- 📤 **Doğrudan Dışarı Sürükleme (Drag-Out):** Raftaki herhangi bir dosyayı tutup doğrudan Slack, Discord, Mail, Finder veya tarayıcı yükleme alanlarına bırakabilirsiniz.
- ⚡ **Hızlı Çağırma:** `⌥ + Space` (Option + Space) kısayolu ile rafı doğrudan farenin bulunduğu noktada açabilirsiniz.
- 🖼️ **Zengin Önizleme:** macOS `QuickLookThumbnailing` sayesinde PDF, resim ve kod dosyalarının yüksek çözünürlüklü minik önizlemeleri oluşturulur.
- 🗜️ **Tek Tıkla "Hepsini Zip Yap":** Raftaki tüm dosyaları arka planda tek bir `.zip` arşivine dönüştürür.
- 📋 **Hepsini Kopyala:** Raftaki dosyaların yollarını tek tıkla panoya kopyalar.
- 📖 **Uygulama İçi Resimli Kılavuz:** Uygulamanın içinde tek tıkla açılabilen Türkçe ve İngilizce kullanım rehberi bulunur.
- 🪶 **Sıfır Yük & Saf Swift:** Dock'u kirletmeden sağ üst menü çubuğunda sessizce çalışır.

### 🚀 Kurulum Seçenekleri

#### Seçenek 1: Tek Satır Terminal Komutu ile Kurulum (Önerilen)
Terminal'e şu komutu yapıştırarak DropMad'i anında indirip `/Applications` klasörüne kurabilir ve başlatabilirsiniz:

```bash
curl -fsSL https://raw.githubusercontent.com/ogulcansivri/DropMad/main/install.sh | bash
```

#### Seçenek 2: DMG veya ZIP ile İndirme
[Releases](https://github.com/ogulcansivri/DropMad/releases) sayfasından en son **`DropMad-1.0.0.dmg`** veya `.zip` dosyasını indirin ve `DropMad.app`'i `/Applications` klasörüne sürükleyin.

#### Seçenek 3: Kaynak Koddan Derleme
```bash
git clone https://github.com/ogulcansivri/DropMad.git
cd DropMad
./scripts/create_dmg.sh
open build/DropMad-1.0.0.dmg
```

---

## 🛠️ Tech Stack / Teknolojiler
- **UI:** SwiftUI + native `NSVisualEffectView` HUD frosted glass background.
- **Windowing:** Non-activating floating `NSPanel` with `.stationary` and `.fullScreenAuxiliary` behavior.
- **Localization:** Dynamic in-app live language switching (English & Turkish).
- **Thumbnails:** `QLThumbnailGenerator` for high-performance preview generation.
- **Data Transfer:** `NSItemProvider` & `Transferable` for cross-application drag-and-drop.

---

## 📄 License / Lisans
Distributed under the MIT License. See `LICENSE` for more information.
