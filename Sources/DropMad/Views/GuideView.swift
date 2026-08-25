import SwiftUI

public struct GuideView: View {
    @ObservedObject var locManager = LocalizationManager.shared
    var onDismiss: () -> Void
    
    public init(onDismiss: @escaping () -> Void = {}) {
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 8) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.accentColor)
                
                Text(L10n.guideTitle)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Language Switcher Picker
                Picker("", selection: $locManager.currentLanguage) {
                    ForEach(AppLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 140)
                
                Button(action: {
                    onDismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                        .frame(width: 22, height: 22)
                        .background(Circle().fill(Color.primary.opacity(0.08)))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.top, 14)
            .padding(.bottom, 10)
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Subtitle
            Text(L10n.guideSubtitle)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14)
                .padding(.top, 8)
            
            // Steps ScrollView
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 10) {
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
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            
            Divider()
                .background(Color.white.opacity(0.1))
            
            // Footer
            HStack {
                Text("⌥ + Space")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.primary.opacity(0.08)))
                    .foregroundColor(.secondary)
                
                Text(locManager.currentLanguage == .turkish ? "ile çağır" : "to summon")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    onDismiss()
                }) {
                    Text(L10n.close)
                        .font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
    }
    
    @ViewBuilder
    private func guideCard(icon: String, color: Color, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(1.5)
            }
            
            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.primary.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }
}
