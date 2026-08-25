import AppKit

public final class HotkeyManager {
    public static let shared = HotkeyManager()
    
    private var globalMonitor: Any?
    private var localMonitor: Any?
    
    private init() {}
    
    public func startMonitoring() {
        // Monitor global key down (Option + Space to toggle DropMad)
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
        }
        
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if self?.handleKeyEvent(event) == true {
                return nil
            }
            return event
        }
    }
    
    @discardableResult
    private func handleKeyEvent(_ event: NSEvent) -> Bool {
        // Check for Option + Space (Keycode 49 = Space, flags contain .option)
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        if flags == .option && event.keyCode == 49 {
            Task { @MainActor in
                ShelfWindowManager.shared.toggle(nearMouse: true)
            }
            return true
        }
        return false
    }
    
    deinit {
        if let gm = globalMonitor {
            NSEvent.removeMonitor(gm)
        }
        if let lm = localMonitor {
            NSEvent.removeMonitor(lm)
        }
    }
}
