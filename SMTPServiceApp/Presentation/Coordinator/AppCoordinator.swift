import UIKit

final class AppCoordinator: Coordinator, PreviewIntroCoordinatorDelegate {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var container: Container
    
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
    
    func previewIntroCoordinatorDidFinish(_ coordinator: PreviewIntroCoordinator) {
        if container.authService.isAuthenticated {
            startMainFlow()
        } else {
            startAuthFlow()
        }
    }

    private func startAuthFlow() {
        authCoordinator = container.makeAuthCoordinator(navigationController: navigationController)
        guard let coordinator = authCoordinator else {
            return
        }
        
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    private func startMainFlow() {
        let coordinator = container.makeMainTabBarCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    private func switchToMainFlow() {
        childCoordinators = childCoordinators.filter { !($0 is AuthCoordinator) }
        navigationController.setViewControllers([], animated: false)
        startMainFlow()
    }
    
    private func switchToAuthFlow() {
        childCoordinators = childCoordinators.filter { !($0 is MainTabBarCoordinator) }
        navigationController.setViewControllers([], animated: false)
        startAuthFlow()
    }
}
