import UIKit
import Combine

final class ThemeManager {
    static let shared = ThemeManager()
    private let themeSubject = CurrentValueSubject<Theme, Never>(ThemeImpl.light)
    
    var themePublisher: AnyPublisher<Theme, Never> {
        themeSubject.eraseToAnyPublisher()
    }
    
    var currentTheme: Theme {
        themeSubject.value
    }
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "em.smtp.theme.selected"
    private let customThemeKey = "em.smtp.theme.custom"
    
    private init() {
        loadTheme()
    }
    
    func setTheme(_ themeType: ThemeType) {
        let newTheme: Theme
        
        switch themeType {
        case .light:
            newTheme = ThemeImpl.light
            setInterfaceStyle(.light)
        case .dark:
            newTheme = ThemeImpl.dark
            setInterfaceStyle(.dark)
        case .custom:
            if let customKey = userDefaults.string(forKey: customThemeKey),
               let customTheme = ThemeRegistry.theme(forKey: customKey) {
                newTheme = customTheme
            } else {
                newTheme = ThemeImpl.dark // Fallback
            }
            setInterfaceStyle(.dark)
        }
        
        themeSubject.send(newTheme)
        saveTheme(themeType)
        applyTheme(newTheme)
    }
    
    func setCustomTheme(key: String) {
        guard let customTheme = ThemeRegistry.theme(forKey: key) else {
            print("Theme with key '\(key)' not found")
            return
        }
        
        themeSubject.send(customTheme)
        saveTheme(.custom)
        saveCustomThemeKey(key)
        applyTheme(customTheme)
        
        let interfaceStyle: UIUserInterfaceStyle = determineInterfaceStyle(for: customTheme)
        setInterfaceStyle(interfaceStyle)
    }
    
    var availableCustomThemes: [String] {
        return ThemeRegistry.allCustomThemeKeys
    }
    
    private func determineInterfaceStyle(for theme: Theme) -> UIUserInterfaceStyle {
        let backgroundColor = theme.previewIntroPresentationData.backgroundColor
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        backgroundColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let brightness = (red * 299 + green * 587 + blue * 114) / 1000
        return brightness > 0.5 ? .light : .dark
    }
    
    private func setInterfaceStyle(_ style: UIUserInterfaceStyle) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = style
        }
    }
    
    private func loadTheme() {
        if let savedThemeRawValue = userDefaults.string(forKey: themeKey) {
            let savedTheme = ThemeType(rawValue: savedThemeRawValue) ?? .light
            
            if savedTheme == .custom {
                if let customKey = userDefaults.string(forKey: customThemeKey),
                   ThemeRegistry.theme(forKey: customKey) != nil {
                    setCustomTheme(key: customKey)
                } else {
                    setTheme(.light)
                }
            } else {
                setTheme(savedTheme)
            }
        } else {
            setTheme(.custom)
            setCustomTheme(key: "em.smtp")
        }
    }
    
    private func saveTheme(_ themeType: ThemeType) {
        userDefaults.set(themeType.rawValue, forKey: themeKey)
    }
    
    private func saveCustomThemeKey(_ key: String) {
        userDefaults.set(key, forKey: customThemeKey)
    }
    
    private func applyTheme(_ theme: Theme) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            for window in windowScene.windows {
                // window.tintColor = theme.authPresentationData.textColor
                
                // let navigationBarAppearance = UINavigationBarAppearance()
                // navigationBarAppearance.configureWithOpaqueBackground()
                // navigationBarAppearance.backgroundColor = theme.authPresentationData.backgroundColor
                // navigationBarAppearance.titleTextAttributes = [.foregroundColor: theme.authPresentationData.textColor]
                
                // UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                
                // window.subviews.forEach { $0.setNeedsDisplay() }
            }
        }
    }
}

