import SwiftUI

public struct GuideView: View {
    @ObservedObject var locManager = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isTestTargeted = false
    @State private var testDroppedCount = 0
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.accentColor)
                    
                    Text(L10n.guideTitle)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Language Switcher Picker
                Picker("", selection: $locManager.currentLanguage) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 160)
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                        .frame(width: 22, height: 22)
                        .background(Circle().fill(Color.primary.opacity(0.08)))
                }
                .buttonStyle(.plain)
                .padding(.leading, 8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Subtitle
            Text(L10n.guideSubtitle)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 10)
            
            // Steps Carousel / ScrollView
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 12) {
                    guideCard(
                        icon: "arrow.down.doc.fill",
                        color: .blue,
                        title: L10n.step1Title,
                        description: L10n.step1Desc
                    )
                    
                    guideCard(
                        icon: "macwindow.on.rectangle",
                        color: .purple,
                        title: L10n.step2Title,
                        description: L10n.step2Desc
                    )
                    
                    guideCard(
                        icon: "arrow.up.right.and.arrow.down.left.rectangle.fill",
                        color: .green,
                        title: L10n.step3Title,
                        description: L10n.step3Desc
                    )
                    
                    guideCard(
                        icon: "bolt.fill",
                        color: .orange,
                        title: L10n.step4Title,
                        description: L10n.step4Desc
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Footer
            HStack {
                Text("⌥ + Space")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.primary.opacity(0.08)))
                    .foregroundColor(.secondary)
                
                Text(locManager.currentLanguage == .turkish ? "ile istediğin zaman çağır" : "to summon anywhere")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text(L10n.close)
                        .font(.system(size: 12, weight: .semibold))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .frame(width: 480, height: 460)
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
        )
    }
    
    @ViewBuilder
    private func guideCard(icon: String, color: Color, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(color.opacity(0.15))
                    .frame(width: 38, height: 38)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.primary.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
