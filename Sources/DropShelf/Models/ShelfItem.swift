import Foundation
import AppKit
import UniformTypeIdentifiers
import SwiftUI

public struct ShelfItem: Identifiable, Hashable {
    public let id: UUID
    public let url: URL
    public let name: String
    public let isDirectory: Bool
    public let fileSize: Int64
    public var thumbnail: NSImage?
    public let dateAdded: Date
    
    public init(url: URL) {
        self.id = UUID()
        self.url = url
        self.name = url.lastPathComponent
        self.dateAdded = Date()
        
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        self.isDirectory = isDir.boolValue
        
        if let attrs = try? FileManager.default.attributesOfItem(atPath: url.path),
           let size = attrs[.size] as? Int64 {
            self.fileSize = size
        } else {
            self.fileSize = 0
        }
        
        self.thumbnail = NSWorkspace.shared.icon(forFile: url.path)
    }
    
    private static let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        return formatter
    }()
    
    public var formattedSize: String {
        if isDirectory {
            return "Folder"
        }
        return Self.byteFormatter.string(fromByteCount: fileSize)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(url)
    }
    
    public static func == (lhs: ShelfItem, rhs: ShelfItem) -> Bool {
        lhs.id == rhs.id
    }
}

// Support for dragging out of the shelf to Finder, apps, etc.
extension ShelfItem: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .data) { item in
            SentTransferredFile(item.url)
        }
    }
}
