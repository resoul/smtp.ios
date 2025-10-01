import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var container: Container
    
    private var mainTabBarCoordinator: MainTabBarCoordinator?
    private var authCoordinator: AuthCoordinator?
    private var reauthObserver: NSObjectProtocol?
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    deinit {
        if let reauthObserver {
            NotificationCenter.default.removeObserver(reauthObserver)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func start() {
        reauthObserver = NotificationCenter.default.addObserver(
            forName: .didReceiveAuthenticationError,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleAuthenticationError()
        }
        
        if container.showPreviewIntro {
            startIntroFlow()
        } else {
            if container.authService.isAuthenticated {
                startMainFlow()
            } else {
                startAuthFlow()
            }
        }
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
        guard let mainCoordinator = mainTabBarCoordinator else {
            print("⚠️ AppState: Not in main flow, skipping save")
            return
        }
        
        let currentTab = mainCoordinator.tabBarController.selectedIndex
        var settings = container.appStorage.get() ?? AppSettings(mainCurrentTab: 0)
        settings.mainCurrentTab = currentTab
        
        container.appStorage.save(settings)
        print("✅ AppState saved: tab index = \(currentTab)")
    }

    func restoreAppState() {
        guard let mainCoordinator = mainTabBarCoordinator else {
            print("⚠️ AppState: Not in main flow, skipping restore")
            return
        }
        
        guard let storage = container.appStorage.get() else {
            print("⚠️ AppState: No saved state found")
            return
        }
        
        guard let tabType = TabType(rawValue: storage.mainCurrentTab) else {
            print("⚠️ AppState: Invalid tab index \(storage.mainCurrentTab)")
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            mainCoordinator.selectTab(tabType)
            print("✅ AppState restored: selected tab = \(tabType.title)")
        }
    }
    
    func clearAppState() {
        container.appStorage.remove()
        print("🗑️ AppState cleared")
    }
    
    // MARK: - Auth Event Handling
    @objc private func handleAuthenticationError() {
        clearAppState()
        if let mainCoordinator = mainTabBarCoordinator {
            removeChildCoordinator(mainCoordinator)
            mainTabBarCoordinator = nil
        }
        startAuthFlow()
    }
}

extension AppCoordinator: PreviewIntroCoordinatorDelegate {
    func previewIntroCoordinatorDidFinish(_ coordinator: PreviewIntroCoordinator) {
        removeChildCoordinator(coordinator)
        if container.authService.isAuthenticated {
            startMainFlow()
            restoreAppState()
        } else {
            startAuthFlow()
        }
    }
}

extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        removeChildCoordinator(coordinator)
        startMainFlow()
        restoreAppState()
    }
}

extension AppCoordinator: MainTabBarCoordinatorDelegate {
    func coordinatorDidLogout(_ coordinator: MainTabBarCoordinator) {
        clearAppState()
        removeChildCoordinator(coordinator)
        startAuthFlow()
    }
    
    func coordinatorDidChangeTab(_ coordinator: MainTabBarCoordinator, to tab: TabType) {
        saveAppState()
        print("📱 Tab changed to: \(tab.title)")
    }
}
