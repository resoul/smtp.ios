enum TokenState: String {
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
