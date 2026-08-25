import AppKit
import SwiftUI

@MainActor
public final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        // Run as menu bar accessory (no dock icon clutter by default)
        NSApp.setActivationPolicy(.accessory)
        
        // Setup Floating Window & Hotkeys
        ShelfWindowManager.shared.setup()
        HotkeyManager.shared.startMonitoring()
        
        // Setup Status Item in Menu Bar
        setupStatusItem()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let button = statusItem?.button else { return }
        
        button.image = NSImage(systemSymbolName: "tray.and.arrow.down", accessibilityDescription: "DropMad")
        button.action = #selector(statusItemClicked)
        button.target = self
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    @objc private func statusItemClicked() {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            // Show Context Menu on Right Click
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: L10n.toggleShelf, action: #selector(toggleShelf), keyEquivalent: ""))
            
            let count = DropMadViewModel.shared.items.count
            menu.addItem(NSMenuItem(title: L10n.itemsCount(count), action: nil, keyEquivalent: ""))
            
            menu.addItem(NSMenuItem.separator())
            
            if count > 0 {
                menu.addItem(NSMenuItem(title: L10n.copyAll, action: #selector(copyAll), keyEquivalent: ""))
                menu.addItem(NSMenuItem(title: L10n.clearAll, action: #selector(clearShelf), keyEquivalent: ""))
                menu.addItem(NSMenuItem.separator())
            }
            
            // Guide / Help
            menu.addItem(NSMenuItem(title: L10n.guideTitle, action: #selector(openGuide), keyEquivalent: ""))
            
            // Language Submenu
            let langMenu = NSMenu()
            for lang in AppLanguage.allCases {
                let item = NSMenuItem(title: lang.displayName, action: #selector(changeLanguage(_:)), keyEquivalent: "")
                item.representedObject = lang
                if lang == LocalizationManager.shared.currentLanguage {
                    item.state = .on
                }
                langMenu.addItem(item)
            }
            let langSubItem = NSMenuItem(title: L10n.language, action: nil, keyEquivalent: "")
            langSubItem.submenu = langMenu
            menu.addItem(langSubItem)
            
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: L10n.quit, action: #selector(quitApp), keyEquivalent: "q"))
            
            statusItem?.menu = menu
            statusItem?.button?.performClick(nil)
            statusItem?.menu = nil // Reset so left click still triggers action
        } else {
            // Left click toggles shelf
            ShelfWindowManager.shared.toggle(nearMouse: false)
        }
    }
    
    @objc private func openGuide() {
        ShelfWindowManager.shared.showGuide()
    }
    
    @objc private func changeLanguage(_ sender: NSMenuItem) {
        if let lang = sender.representedObject as? AppLanguage {
            LocalizationManager.shared.setLanguage(lang)
        }
    }
    
    @objc private func toggleShelf() {
        ShelfWindowManager.shared.toggle(nearMouse: false)
    }
    
    @objc private func clearShelf() {
        DropMadViewModel.shared.clearAll()
    }
    
    @objc private func copyAll() {
        DropMadViewModel.shared.copyAllToClipboard()
    }
    
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
