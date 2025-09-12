import UIKit

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    weak var coordinator: MainTabBarCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        delegate = self
    }
    
    private func setupAppearance() {
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray

        // Add shadow
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 4
        tabBar.layer.shadowOpacity = 0.1
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
