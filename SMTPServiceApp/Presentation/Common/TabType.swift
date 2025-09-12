enum TabType: Int, CaseIterable {
    case dashboard = 0
    case settings = 1
    case domains = 2
    case suppression = 3
    case reports = 4

    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .settings: return "Settings"
        case .domains: return "Domains"
        case .suppression: return "Suppression"
        case .reports: return "Reports"
        }
    }

    var icon: String {
        switch self {
        case .dashboard: return "chart.bar"
        case .settings: return "gearshape"
        case .domains: return "at"
        case .suppression: return "nosign"
        case .reports: return "link"
        }
    }

    var selectedIcon: String {
        switch self {
        case .dashboard: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        case .domains: return "at.fill"
        case .suppression: return "nosign.fill"
        case .reports: return "link.fill"
        }
    }
}
