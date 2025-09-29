import UIKit

protocol MainTabBarCoordinatorDelegate: AnyObject {
    func coordinatorDidLogout(_ coordinator: MainTabBarCoordinator)
    func coordinatorDidChangeTab(_ coordinator: MainTabBarCoordinator, to tab: TabType)
}

final class MainTabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var container: Container
    weak var delegate: MainTabBarCoordinatorDelegate?
    
    var tabBarController: MainTabBarController!
    private var tabCoordinators: [TabType: Coordinator] = [:]
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        setupTabBarController()
        setupTabCoordinators()
        navigationController.setViewControllers([tabBarController], animated: false)
    }
    
    private func setupTabBarController() {
        tabBarController = MainTabBarController()
        tabBarController.coordinator = self
        tabBarController.delegate = tabBarController
    }
    
    private func setupTabCoordinators() {
        let tabs = TabType.allCases
        var viewControllers: [UIViewController] = []

        for tab in tabs {
            let coordinator = createCoordinator(for: tab)
            let navController = UINavigationController()

            coordinator.navigationController = navController
            coordinator.start()

            // Setup tab bar item
            navController.tabBarItem = createTabBarItem(for: tab)

            // Store coordinator and add to child coordinators
            tabCoordinators[tab] = coordinator
            addChildCoordinator(coordinator)
            viewControllers.append(navController)
        }

        tabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    private func createCoordinator(for tab: TabType) -> Coordinator {
        switch tab {
        case .dashboard:
            return container.makeDashboardCoordinator()
        case .settings:
            return container.makeTokenCoordinator()
        case .domains:
            return container.makeUserDomainCoordinator()
        case .suppression:
            return container.makeDashboardCoordinator()
        case .reports:
            return container.makeDashboardCoordinator()
        }
    }
    
    private func createTabBarItem(for tab: TabType) -> UITabBarItem {
        let item = UITabBarItem(
            title: tab.title,
            image: UIImage(systemName: tab.icon),
            selectedImage: UIImage(systemName: tab.selectedIcon)
        )

        // Add badge if needed
        switch tab {
        case .suppression:
            // Example: Show pending campaigns count
            item.badgeValue = nil // Set from your data source
        default:
            break
        }

        return item
    }
    
    func selectTab(_ tab: TabType) {
        tabBarController.selectedIndex = tab.rawValue
        delegate?.coordinatorDidChangeTab(self, to: tab)
    }

    func setBadge(for tab: TabType, value: String?) {
        guard let index = TabType.allCases.firstIndex(of: tab) else { return }
        tabBarController.tabBar.items?[index].badgeValue = value
    }

    func getCoordinator(for tab: TabType) -> Coordinator? {
        return tabCoordinators[tab]
    }
    
    func didLogout() {
        delegate?.coordinatorDidLogout(self)
    }
    
    func didSelectTab(_ tab: TabType) {
        delegate?.coordinatorDidChangeTab(self, to: tab)
    }
}
