import SwiftUI
import AppKit

public struct ShelfItemCardView: View {
    public let item: ShelfItem
    @State private var isHovering = false
    
    public init(item: ShelfItem) {
        self.item = item
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // Thumbnail / Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(nsColor: .controlBackgroundColor).opacity(0.6))
                    .frame(width: 44, height: 44)
                
                if let thumb = item.thumbnail {
                    Image(nsImage: thumb)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                } else {
                    Image(systemName: item.isDirectory ? "folder.fill" : "doc.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.accentColor)
                }
            }
            
            // File Info
            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .foregroundColor(.primary)
                
                Text(item.formattedSize)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Actions on Hover
            if isHovering {
                Button(action: {
                    DropShelfViewModel.shared.removeItem(withID: item.id)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary.opacity(0.8))
                }
                .buttonStyle(.plain)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isHovering ? Color.primary.opacity(0.08) : Color.primary.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(isHovering ? Color.accentColor.opacity(0.3) : Color.white.opacity(0.1), lineWidth: 1)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        // Native Drag-Out capability to any application (Finder, Slack, Browser, Mail, etc.)
        .onDrag {
            let provider = NSItemProvider(contentsOf: item.url) ?? NSItemProvider()
            provider.suggestedName = item.name
            return provider
        }
        .onTapGesture(count: 2) {
            DropShelfViewModel.shared.openItem(item: item)
        }
        .contextMenu {
            Button("Open") {
                DropShelfViewModel.shared.openItem(item: item)
            }
            Button("Reveal in Finder") {
                DropShelfViewModel.shared.revealInFinder(item: item)
            }
            Divider()
            Button("Remove from Shelf") {
                DropShelfViewModel.shared.removeItem(withID: item.id)
            }
        }
    }
}
