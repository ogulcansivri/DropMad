import AppKit
import SwiftUI

@MainActor
public final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        // Run as menu bar accessory (no dock icon clutter by default)
        NSApp.setActivationPolicy(.accessory)
        
        // Setup Floating Window & Hotkeys
        Task { @MainActor in
            ShelfWindowManager.shared.setup()
            HotkeyManager.shared.startMonitoring()
        }
        
        // Setup Status Item in Menu Bar
        setupStatusItem()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        guard let button = statusItem?.button else { return }
        
        button.image = NSImage(systemSymbolName: "tray.and.arrow.down", accessibilityDescription: "DropShelf")
        button.action = #selector(statusItemClicked)
        button.target = self
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    @objc private func statusItemClicked() {
        guard let event = NSApp.currentEvent else { return }
        
        if event.type == .rightMouseUp {
            // Show Context Menu on Right Click
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: "Toggle Shelf (⌥ + Space)", action: #selector(toggleShelf), keyEquivalent: ""))
            
            let count = DropShelfViewModel.shared.items.count
            menu.addItem(NSMenuItem(title: "Items on Shelf: \(count)", action: nil, keyEquivalent: ""))
            
            menu.addItem(NSMenuItem.separator())
            
            if count > 0 {
                menu.addItem(NSMenuItem(title: "Copy All to Clipboard", action: #selector(copyAll), keyEquivalent: ""))
                menu.addItem(NSMenuItem(title: "Clear Shelf", action: #selector(clearShelf), keyEquivalent: ""))
                menu.addItem(NSMenuItem.separator())
            }
            
            menu.addItem(NSMenuItem(title: "Quit DropShelf", action: #selector(quitApp), keyEquivalent: "q"))
            
            statusItem?.menu = menu
            statusItem?.button?.performClick(nil)
            statusItem?.menu = nil // Reset so left click still triggers action
        } else {
            // Left click toggles shelf
            Task { @MainActor in
                ShelfWindowManager.shared.toggle(nearMouse: false)
            }
        }
    }
    
    @objc private func toggleShelf() {
        Task { @MainActor in
            ShelfWindowManager.shared.toggle(nearMouse: false)
        }
    }
    
    @objc private func clearShelf() {
        Task { @MainActor in
            DropShelfViewModel.shared.clearAll()
        }
    }
    
    @objc private func copyAll() {
        Task { @MainActor in
            DropShelfViewModel.shared.copyAllToClipboard()
        }
    }
    
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
