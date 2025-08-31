import UIKit

protocol LaunchCoordinator: Coordinator {
    func handleLauchCompletion()
}

final class LaunchCoordinatorImpl: LaunchCoordinator, AuthCoordinatorDelegate {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var container: Container
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
        self.childCoordinators = []
    }
    
    func start() {
        let controller = LauchController(viewModel: container.makeLauchViewModel())
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func handleLauchCompletion() {
        if container.authService.isAuthenticated {
            startMainFlow()
        } else {
            startAuthFlow()
        }
    }
    
    private func startAuthFlow() {
        let authCoordinator = container.makeAuthCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
        print(childCoordinators)
    }
    
    private func startMainFlow() {
        let authCoordinator = container.makeMainCoordinator(navigationController: navigationController)
        authCoordinator.delegate = self
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
    }
    
    func authCoordinatorDidFinishAuth(_ coordinator: AuthCoordinator) {
        //
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
