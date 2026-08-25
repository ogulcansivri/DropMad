import SwiftUI
import AppKit
import UniformTypeIdentifiers

@MainActor
public final class DropShelfViewModel: ObservableObject {
    public static let shared = DropShelfViewModel()
    
    @Published public var items: [ShelfItem] = []
    @Published public var isTargeted: Bool = false
    @Published public var isHovering: Bool = false
    
    public init() {}
    
    public func addItems(urls: [URL]) {
        for url in urls {
            // Avoid duplicates
            if !items.contains(where: { $0.url.path == url.path }) {
                let newItem = ShelfItem(url: url)
                let itemId = newItem.id
                items.append(newItem)
                
                // Asynchronously generate higher quality thumbnail
                Task {
                    if let thumb = await ThumbnailGenerator.shared.generateThumbnail(for: url) {
                        if let index = self.items.firstIndex(where: { $0.id == itemId }) {
                            self.items[index].thumbnail = thumb
                        }
                    }
                }
            }
        }
        
        // Notify window manager to show shelf if it was hidden
        ShelfWindowManager.shared.show()
    }
    
    public func handleDrop(providers: [NSItemProvider]) -> Bool {
        var foundAny = false
        for provider in providers {
            if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                _ = provider.loadObject(ofClass: URL.self) { [weak self] url, error in
                    guard let url = url, error == nil else { return }
                    Task { @MainActor in
                        self?.addItems(urls: [url])
                    }
                }
                foundAny = true
            }
        }
        return foundAny
    }
    
    public func removeItem(withID id: UUID) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            items.removeAll { $0.id == id }
        }
    }
    
    public func clearAll() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            items.removeAll()
        }
    }
    
    public func copyAllToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let urls = items.map { $0.url as NSURL }
        pasteboard.writeObjects(urls)
    }
    
    public func revealInFinder(item: ShelfItem) {
        NSWorkspace.shared.activateFileViewerSelecting([item.url])
    }
    
    public func openItem(item: ShelfItem) {
        NSWorkspace.shared.open(item.url)
    }
    
    public func zipAllItems() {
        guard !items.isEmpty else { return }
        
        let tempDir = FileManager.default.temporaryDirectory
        let zipName = "DropShelf_Archive_\(Int(Date().timeIntervalSince1970)).zip"
        let zipURL = tempDir.appendingPathComponent(zipName)
        
        let coordinator = NSFileCoordinator()
        var zipError: NSError?
        
        coordinator.coordinate(readingItemAt: items[0].url, options: [], error: &zipError) { _ in
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/ditto")
            
            // Build ditto args to create a zip
            var args = ["-c", "-k", "--sequesterRsrc", "--keepParent"]
            for item in items {
                args.append(item.url.path)
            }
            args.append(zipURL.path)
            
            process.arguments = args
            
            do {
                try process.run()
                process.waitUntilExit()
                
                Task { @MainActor in
                    self.clearAll()
                    self.addItems(urls: [zipURL])
                }
            } catch {
                print("Failed to zip items: \(error)")
            }
        }
    }
}
