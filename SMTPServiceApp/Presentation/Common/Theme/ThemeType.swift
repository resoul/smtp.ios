enum ThemeType: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case custom = "custom"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .custom: return "Custom"
        }
    }
}
