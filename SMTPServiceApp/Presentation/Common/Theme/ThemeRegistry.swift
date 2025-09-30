class ThemeRegistry {
    private static var customThemes: [String: Theme] = [:]
    
    public static func register(theme: Theme, forKey key: String) {
        customThemes[key] = theme
    }
    
    public static func theme(forKey key: String) -> Theme? {
        return customThemes[key]
    }
    
    public static var allCustomThemes: [String: Theme] {
        return customThemes
    }
    
    public static var allCustomThemeKeys: [String] {
        return Array(customThemes.keys)
    }
}
