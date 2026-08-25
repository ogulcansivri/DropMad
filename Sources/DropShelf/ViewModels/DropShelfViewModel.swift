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
        var handled = false
        
        for provider in providers {
            // Priority 1: Standard URL (Files, Folders)
            if provider.canLoadObject(ofClass: URL.self) {
                _ = provider.loadObject(ofClass: URL.self) { [weak self] url, _ in
                    guard let url = url else { return }
                    Task { @MainActor in
                        self?.addItems(urls: [url])
                    }
                }
                handled = true
            }
            // Priority 2: File representation (Web downloads, drag from other apps)
            else if provider.hasItemConformingToTypeIdentifier(UTType.item.identifier) {
                provider.loadFileRepresentation(forTypeIdentifier: UTType.item.identifier) { [weak self] tempURL, error in
                    guard let tempURL = tempURL, error == nil else { return }
                    
                    // Copy to a persistent temp location so it doesn't get wiped immediately
                    let cacheDir = FileManager.default.temporaryDirectory.appendingPathComponent("DropShelfCache", isDirectory: true)
                    try? FileManager.default.createDirectory(at: cacheDir, withIntermediateDirectories: true)
                    let destURL = cacheDir.appendingPathComponent(tempURL.lastPathComponent)
                    
                    try? FileManager.default.removeItem(at: destURL)
                    do {
                        try FileManager.default.copyItem(at: tempURL, to: destURL)
                        Task { @MainActor in
                            self?.addItems(urls: [destURL])
                        }
                    } catch {
                        print("Failed to cache dropped item: \(error)")
                    }
                }
                handled = true
            }
        }
        return handled
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
        
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let timestamp = Int(Date().timeIntervalSince1970)
        let stagingDir = tempDir.appendingPathComponent("DropShelf_Archive_\(timestamp)", isDirectory: true)
        let zipURL = tempDir.appendingPathComponent("DropShelf_Archive_\(timestamp).zip")
        
        do {
            // Create temporary staging directory
            try fileManager.createDirectory(at: stagingDir, withIntermediateDirectories: true)
            
            // Copy each item into staging directory
            for item in items {
                let dest = stagingDir.appendingPathComponent(item.url.lastPathComponent)
                try? fileManager.removeItem(at: dest)
                try fileManager.copyItem(at: item.url, to: dest)
            }
            
            // Run ditto on the staging directory to produce the zip
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/ditto")
            process.arguments = ["-c", "-k", "--sequesterRsrc", "--keepParent", stagingDir.path, zipURL.path]
            
            try process.run()
            process.waitUntilExit()
            
            // Clean up staging folder
            try? fileManager.removeItem(at: stagingDir)
            
            // Replace shelf items with the created zip file
            Task { @MainActor in
                self.clearAll()
                self.addItems(urls: [zipURL])
            }
        } catch {
            print("Failed to create zip archive: \(error)")
            try? fileManager.removeItem(at: stagingDir)
        }
    }
}
