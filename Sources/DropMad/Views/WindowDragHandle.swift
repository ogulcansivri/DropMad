import SwiftUI
import AppKit

public struct WindowDragHandle: NSViewRepresentable {
    public init() {}
    
    public func makeNSView(context: Context) -> NSView {
        return WindowDragNSView()
    }
    
    public func updateNSView(_ nsView: NSView, context: Context) {}
}

private final class WindowDragNSView: NSView {
    override func mouseDown(with event: NSEvent) {
        window?.performDrag(with: event)
    }
}
