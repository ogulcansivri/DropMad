import SwiftUI
import AppKit

public enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case turkish = "tr"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .english: return "English 🇬🇧"
        case .turkish: return "Türkçe 🇹🇷"
        }
    }
}

@MainActor
public final class LocalizationManager: ObservableObject {
    public static let shared = LocalizationManager()
    
    @AppStorage("selectedLanguage") public var currentLanguage: AppLanguage = {
        let preferred = Locale.preferredLanguages.first?.lowercased() ?? "en"
        return preferred.starts(with: "tr") ? .turkish : .english
    }()
    
    private init() {}
    
    public func setLanguage(_ lang: AppLanguage) {
        currentLanguage = lang
    }
}

@MainActor
public struct L10n {
    private static var isTurkish: Bool {
        LocalizationManager.shared.currentLanguage == .turkish
    }
    
    // Header & Actions
    public static var appName: String { "DropMad" }
    public static var guide: String { isTurkish ? "Kılavuz" : "Guide" }
    public static var emptyTitle: String { isTurkish ? "Dosyaları Buraya Sürükleyin" : "Drag & Drop Files Here" }
    public static var emptySubtitle: String {
        isTurkish ? "Alanlar (Spaces) veya tam ekran pencereler arasında taşırken dosyaları geçici olarak burada tutun"
                  : "Hold files temporarily while switching spaces or full-screen apps"
    }
    public static var dropTargetPrompt: String { isTurkish ? "Bırak ve Rafa Ekle" : "Drop to Hold Here" }
    public static var zipAll: String { isTurkish ? "Hepsini Zip Yap" : "Zip All" }
    public static var copyAll: String { isTurkish ? "Hepsini Kopyala" : "Copy All" }
    public static var clearAll: String { isTurkish ? "Rafı Temizle" : "Clear Shelf" }
    public static var open: String { isTurkish ? "Aç" : "Open" }
    public static var revealInFinder: String { isTurkish ? "Finder'da Göster" : "Reveal in Finder" }
    public static var remove: String { isTurkish ? "Raftan Kaldır" : "Remove from Shelf" }
    public static var folder: String { isTurkish ? "Klasör" : "Folder" }
    
    // Menu Bar
    public static var toggleShelf: String { isTurkish ? "Rafı Aç/Kapat (⌥ + Space)" : "Toggle Shelf (⌥ + Space)" }
    public static var itemsCount: (Int) -> String = { count in
        isTurkish ? "Raftaki Dosya Sayısı: \(count)" : "Items on Shelf: \(count)"
    }
    public static var language: String { isTurkish ? "Dil / Language" : "Language / Dil" }
    public static var quit: String { isTurkish ? "DropMad'den Çık" : "Quit DropMad" }
    
    // Guide Content
    public static var guideTitle: String { isTurkish ? "DropMad Kullanım Rehberi" : "DropMad User Guide" }
    public static var guideSubtitle: String {
        isTurkish ? "Mac'inizde dosya taşımayı çocuk oyuncağı haline getirin."
                  : "Effortless drag-and-drop file shelf for macOS."
    }
    public static var close: String { isTurkish ? "Kapat" : "Close" }
    
    // Guide Steps
    public static var step1Title: String { isTurkish ? "1. Dosyaları Rafa Bırakın" : "1. Drop Files to Shelf" }
    public static var step1Desc: String {
        isTurkish ? "Finder'dan, tarayıcıdan veya herhangi bir uygulamadan dosyaları, resimleri veya linkleri rafa sürükleyin."
                  : "Drag files, images, links, or folders from Finder, web browsers, or any app onto DropMad."
    }
    
    public static var step2Title: String { isTurkish ? "2. İstediğiniz Uygulamaya Geçin" : "2. Switch Spaces or Apps" }
    public static var step2Desc: String {
        isTurkish ? "DropMad tüm masaüstü alanlarında (Spaces) ve tam ekran uygulamalarda yüzer; eliniz yorulmadan hedef ekrana geçin."
                  : "DropMad stays visible across all virtual desktops and full-screen apps without losing your files."
    }
    
    public static var step3Title: String { isTurkish ? "3. Hedefe Sürükleyip Bırakın" : "3. Drag Out to Target" }
    public static var step3Desc: String {
        isTurkish ? "Raftaki dosyaları doğrudan Slack, Discord, Mail, Finder veya yükleme alanlarına sürükleyip bırakın."
                  : "Drag files out directly into Slack, Mail, Discord, Finder folders, or browser upload fields."
    }
    
    public static var step4Title: String { isTurkish ? "⚡ Kısayol & Süper Güçler" : "⚡ Shortcuts & Superpowers" }
    public static var step4Desc: String {
        isTurkish ? "• ⌥ + Space: Rafı anında imlecin altına çağırır.\n• Hepsini Zip Yap: Dosyaları tek tıkla arşivler.\n• Hepsini Kopyala: Dosya yollarını panoya alır."
                  : "• ⌥ + Space: Summon the shelf instantly under cursor.\n• Zip All: Compress all buffered files into a .zip file.\n• Copy All: Copy all file paths to your clipboard."
    }
}
