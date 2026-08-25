import AppKit
import SwiftUI

public final class CustomFloatingPanel: NSPanel {
    public override var canBecomeKey: Bool {
        return false // Non-activating panel so user doesn't lose focus in current active app!
    }
    
    public override var canBecomeMain: Bool {
        return false
    }
}

@MainActor
public final class ShelfWindowManager: NSObject, ObservableObject {
    public static let shared = ShelfWindowManager()
    
    private var panel: CustomFloatingPanel?
    @Published public private(set) var isVisible: Bool = false
    
    private override init() {
        super.init()
    }
    
    public func setup() {
        guard panel == nil else { return }
        
        let initialRect = NSRect(x: 0, y: 0, width: 340, height: 420)
        let panel = CustomFloatingPanel(
            contentRect: initialRect,
            styleMask: [.nonactivatingPanel, .borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false // Eliminates the rectangular window frame box
        panel.isMovableByWindowBackground = false // Prevents window from hijacking file drag-out
        panel.hidesOnDeactivate = false
        panel.isReleasedWhenClosed = false
        
        let contentView = NSHostingView(rootView: ShelfView())
        panel.contentView = contentView
        
        self.panel = panel
        
        // Position on the right side of the main screen by default
        positionAtDefaultLocation()
    }
    
    private func targetScreen(for mouseLocation: NSPoint? = nil) -> NSScreen {
        if let loc = mouseLocation {
            if let screen = NSScreen.screens.first(where: { NSMouseInRect(loc, $0.frame, false) }) {
                return screen
            }
        }
        return NSScreen.main ?? NSScreen.screens.first ?? NSScreen()
    }
    
    public func positionAtDefaultLocation() {
        let mouseLocation = NSEvent.mouseLocation
        let screen = targetScreen(for: mouseLocation)
        guard let panel = panel else { return }
        let visibleFrame = screen.visibleFrame
        let x = visibleFrame.maxX - panel.frame.width - 24
        let y = visibleFrame.midY - (panel.frame.height / 2)
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
    
    public func positionNearMouse() {
        let mouseLocation = NSEvent.mouseLocation
        let screen = targetScreen(for: mouseLocation)
        guard let panel = panel else { return }
        let screenFrame = screen.visibleFrame
        
        var x = mouseLocation.x + 20
        var y = mouseLocation.y - (panel.frame.height / 2)
        
        // Clamp to screen bounds
        if x + panel.frame.width > screenFrame.maxX {
            x = mouseLocation.x - panel.frame.width - 20
        }
        if y < screenFrame.minY {
            y = screenFrame.minY + 20
        }
        if y + panel.frame.height > screenFrame.maxY {
            y = screenFrame.maxY - panel.frame.height - 20
        }
        
        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
    
    public func show(nearMouse: Bool = false) {
        if panel == nil { setup() }
        if nearMouse {
            positionNearMouse()
        }
        panel?.orderFrontRegardless()
        isVisible = true
    }
    
    public func showGuide() {
        show(nearMouse: false)
        // Post notification or sheet trigger
        NotificationCenter.default.post(name: Notification.Name("ShowDropMadGuide"), object: nil)
    }
    
    public func hide() {
        panel?.orderOut(nil)
        isVisible = false
    }
    
    public func toggle(nearMouse: Bool = false) {
        if isVisible {
            hide()
        } else {
            show(nearMouse: nearMouse)
        }
    }
}
