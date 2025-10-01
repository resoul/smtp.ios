import UIKit

enum PasswordStrength: Int, CaseIterable {
    case veryWeak = 0
    case weak = 1
    case medium = 2
    case strong = 3
    case veryStrong = 4
    
    var title: String {
        switch self {
        case .veryWeak: return "Very Weak"
        case .weak: return "Weak"
        case .medium: return "Medium"
        case .strong: return "Strong"
        case .veryStrong: return "Very Strong"
        }
    }
    
    var color: UIColor {
        switch self {
        case .veryWeak: return .systemRed
        case .weak: return .systemOrange
        case .medium: return .systemYellow
        case .strong: return .systemBlue
        case .veryStrong: return .systemGreen
        }
    }
    
    var requirements: [String] {
        switch self {
        case .veryWeak, .weak:
            return [
                "At least 8 characters",
                "Mix of letters and numbers",
                "At least one uppercase letter"
            ]
        case .medium:
            return [
                "At least one special character",
                "Mix of uppercase and lowercase"
            ]
        case .strong, .veryStrong:
            return ["Password meets all security requirements"]
        }
    }
}
