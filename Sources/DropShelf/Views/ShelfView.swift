import SwiftUI
import UniformTypeIdentifiers

public struct ShelfView: View {
    @StateObject private var viewModel = DropShelfViewModel.shared
    @State private var isTargeted: Bool = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Frosted Acrylic / Glass Background
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(isTargeted ? Color.accentColor : Color.white.opacity(0.15), lineWidth: isTargeted ? 2 : 1)
                )
                .shadow(color: Color.black.opacity(0.35), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 0) {
                // Header (Draggable Area)
                headerView
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // Content Body
                if viewModel.items.isEmpty {
                    emptyStateView
                } else {
                    itemsListView
                }
                
                // Footer / Action Bar (if items exist)
                if !viewModel.items.isEmpty {
                    Divider()
                        .background(Color.white.opacity(0.1))
                    footerView
                }
            }
        }
        .frame(width: 320, height: viewModel.items.isEmpty ? 260 : 420)
        .padding(10)
        // Accept drops anywhere on the panel!
        .onDrop(of: [UTType.fileURL.identifier], isTargeted: $isTargeted) { providers in
            viewModel.handleDrop(providers: providers)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.items.count)
        .animation(.easeInOut(duration: 0.2), value: isTargeted)
    }
    
    // MARK: - Header
    private var headerView: some View {
        HStack {
            Image(systemName: "tray.and.arrow.down.fill")
                .foregroundColor(.accentColor)
                .font(.system(size: 14, weight: .semibold))
            
            Text("DropShelf")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.primary)
            
            if !viewModel.items.isEmpty {
                Text("\(viewModel.items.count)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color.accentColor))
            }
            
            Spacer()
            
            Button(action: {
                ShelfWindowManager.shared.hide()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: 20)
                    .background(Circle().fill(Color.primary.opacity(0.06)))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
    
    // MARK: - Empty State / Drop Target
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isTargeted ? Color.accentColor.opacity(0.2) : Color.primary.opacity(0.04))
                    .frame(width: 68, height: 68)
                
                Image(systemName: isTargeted ? "arrow.down.circle.fill" : "plus.square.dashed")
                    .font(.system(size: 32))
                    .foregroundColor(isTargeted ? .accentColor : .secondary)
                    .scaleEffect(isTargeted ? 1.15 : 1.0)
            }
            
            VStack(spacing: 4) {
                Text(isTargeted ? "Drop to Hold Here" : "Drag & Drop Files Here")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Hold files temporarily while switching spaces or full-screen apps")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    // MARK: - Items List
    private var itemsListView: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 8) {
                ForEach(viewModel.items) { item in
                    ShelfItemCardView(item: item)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
    }
    
    // MARK: - Footer Actions
    private var footerView: some View {
        HStack(spacing: 10) {
            // Zip All Button
            Button(action: {
                viewModel.zipAllItems()
            }) {
                Label("Zip All", systemImage: "doc.zipper")
                    .font(.system(size: 11, weight: .medium))
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            
            // Copy All Button
            Button(action: {
                viewModel.copyAllToClipboard()
            }) {
                Label("Copy All", systemImage: "doc.on.doc")
                    .font(.system(size: 11, weight: .medium))
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            
            Spacer()
            
            // Clear All Button
            Button(action: {
                viewModel.clearAll()
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 12))
                    .foregroundColor(.red.opacity(0.8))
            }
            .buttonStyle(.plain)
            .help("Clear all items")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}
