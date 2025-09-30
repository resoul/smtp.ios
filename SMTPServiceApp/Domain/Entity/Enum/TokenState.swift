import UIKit

enum TokenState: String, CaseIterable {
    case active
    case inactive
    case expired
    case suspended

    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "active": self = .active
        case "suspended": self = .suspended
        case "expired": self = .expired
        default: self = .inactive
        }
    }
}

extension TokenState: SelectableItem {
    var id: String { rawValue }
    
    var title: String {
        rawValue.capitalized
    }
    
    var color: UIColor? {
        switch self {
        case .active: return .systemGreen
        case .inactive: return .systemGray
        case .expired: return .systemRed
        case .suspended: return .systemOrange
        }
    }
}
