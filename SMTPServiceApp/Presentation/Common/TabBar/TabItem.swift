import UIKit

struct TabItem: Codable, Hashable {
    let id: String
    let title: String
    let icon: String
    let viewControllerType: String
    var isEnabled: Bool
    var order: Int
    
    static let defaultTabs = [
        TabItem(id: "home", title: "Home", icon: "house", viewControllerType: "HomeViewController", isEnabled: true, order: 0),
        TabItem(id: "search", title: "Search", icon: "magnifyingglass", viewControllerType: "SearchViewController", isEnabled: true, order: 1),
        TabItem(id: "favorites", title: "Favorites", icon: "heart", viewControllerType: "FavoritesViewController", isEnabled: true, order: 2),
        TabItem(id: "profile", title: "Profile", icon: "person", viewControllerType: "ProfileViewController", isEnabled: true, order: 3),
        TabItem(id: "settings", title: "Settings", icon: "gearshape", viewControllerType: "SettingsViewController", isEnabled: false, order: 4),
        TabItem(id: "messages", title: "Messages", icon: "message", viewControllerType: "MessagesViewController", isEnabled: false, order: 5),
    ]
}
