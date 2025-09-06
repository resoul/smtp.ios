import UIKit

final class AppCoordinator: Coordinator, PreviewIntroCoordinatorDelegate {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var container: Container
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
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
        let coordinator = container.makeAuthCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    private func startMainFlow() {
        let coordinator = container.makeMainCoordinator(navigationController: navigationController)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    private func switchToMainFlow() {
        childCoordinators = childCoordinators.filter { !($0 is AuthCoordinator) }
        navigationController.setViewControllers([], animated: false)
        startMainFlow()
    }
    
    private func switchToAuthFlow() {
        childCoordinators = childCoordinators.filter { !($0 is MainCoordinator) }
        navigationController.setViewControllers([], animated: false)
        startAuthFlow()
    }
}
