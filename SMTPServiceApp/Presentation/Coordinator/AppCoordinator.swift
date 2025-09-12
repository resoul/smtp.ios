import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var container: Container
    
    private var mainTabBarCoordinator: MainTabBarCoordinator?
    private var authCoordinator: AuthCoordinator?
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        startIntroFlow()
    }
    
    private func startIntroFlow() {
        let coordinator = container.makePreviewIntroCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }

    private func startAuthFlow() {
        cleanupCurrentFlow()
        authCoordinator = container.makeAuthCoordinator(navigationController: navigationController)
        authCoordinator?.delegate = self
        addChildCoordinator(authCoordinator!)
        authCoordinator?.start()
    }
    
    private func startMainFlow() {
        cleanupCurrentFlow()
        mainTabBarCoordinator = container.makeMainTabBarCoordinator(navigationController: navigationController)
        mainTabBarCoordinator?.delegate = self
        addChildCoordinator(mainTabBarCoordinator!)
        mainTabBarCoordinator?.start()
    }
    
    private func cleanupCurrentFlow() {
        childCoordinators.forEach { coordinator in
            coordinator.finish()
        }
        childCoordinators.removeAll()
        navigationController.setViewControllers([], animated: false)
    }
    
    // MARK: - State Restoration
    func saveAppState() {
        guard let mainCoordinator = mainTabBarCoordinator else { return }
        let currentTab = mainCoordinator.tabBarController.selectedIndex
        
        guard var storage = container.appStorage.get() else {
            container.appStorage.save(AppSettings(mainCurrentTab: currentTab))
            return
        }
        storage.mainCurrentTab = currentTab
        container.appStorage.save(storage)
    }

    func restoreAppState() {
        guard let mainCoordinator = mainTabBarCoordinator, let storage = container.appStorage.get() else {
            return
        }

        if let tabType = TabType(rawValue: storage.mainCurrentTab) {
            mainCoordinator.selectTab(tabType)
        }
    }
}

extension AppCoordinator: PreviewIntroCoordinatorDelegate {
    func previewIntroCoordinatorDidFinish(_ coordinator: PreviewIntroCoordinator) {
        removeChildCoordinator(coordinator)
        if container.authService.isAuthenticated {
            startMainFlow()
        } else {
            startAuthFlow()
        }
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        removeChildCoordinator(coordinator)
        startMainFlow()
    }
}

extension AppCoordinator: MainTabBarCoordinatorDelegate {
    func coordinatorDidLogout(_ coordinator: MainTabBarCoordinator) {
        removeChildCoordinator(coordinator)
        startAuthFlow()
    }
}
