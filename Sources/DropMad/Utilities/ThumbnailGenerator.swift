import AppKit
import QuickLookThumbnailing

public final class ThumbnailGenerator {
    public static let shared = ThumbnailGenerator()
    
    private init() {}
    
    public func generateThumbnail(for url: URL, size: CGSize = CGSize(width: 120, height: 120)) async -> NSImage? {
        let scale = NSScreen.main?.backingScaleFactor ?? 2.0
        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: size,
            scale: scale,
            representationTypes: .thumbnail
        )
        
        do {
            let thumbnail = try await QLThumbnailGenerator.shared.generateBestRepresentation(for: request)
            return thumbnail.nsImage
        } catch {
            return NSWorkspace.shared.icon(forFile: url.path)
        }
    }
}
