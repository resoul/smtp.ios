import UIKit

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    weak var coordinator: MainTabBarCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        delegate = self
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        
        // Background color
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        // Shadow (modern way)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.1)
        appearance.shadowImage = nil // Use default shadow
        
        // Tint and item appearance
        let normalItem = appearance.stackedLayoutAppearance.normal
        normalItem.iconColor = .systemGray
        normalItem.titleTextAttributes = [.foregroundColor: UIColor.systemGray]
        
        let selectedItem = appearance.stackedLayoutAppearance.selected
        selectedItem.iconColor = .systemBlue
        selectedItem.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        // Apply to all appearance variants (for scrolling and compact)
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        // For interactive tinting (still respected)
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
    }

    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Handle tab selection
        guard let tabType = TabType(rawValue: tabBarController.selectedIndex) else { return }

        // Notify coordinator about tab change
        handleTabSelection(tabType)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Check if user can access this tab
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController),
              let tabType = TabType(rawValue: index) else { return true }

        return canSelectTab(tabType)
    }

    private func handleTabSelection(_ tabType: TabType) {
        // Handle double tap to scroll to top or refresh
        if selectedIndex == tabType.rawValue {
            handleDoubleTap(for: tabType)
        }

        // Analytics tracking
        trackTabSelection(tabType)
    }

    private func handleDoubleTap(for tabType: TabType) {
        // Get the coordinator for the tab and handle double tap
        coordinator?.getCoordinator(for: tabType)?.handleDoubleTap?()
    }

    private func canSelectTab(_ tabType: TabType) -> Bool {
        // Add permission checks here if needed
        switch tabType {
        case .domains:
            // Check if user has analytics permissions
            return true // container.userPermissions.canViewAnalytics
        default:
            return true
        }
    }

    private func trackTabSelection(_ tabType: TabType) {
        // Analytics tracking
        // AnalyticsManager.shared.track("tab_selected", parameters: ["tab": tabType.title])
    }
}
