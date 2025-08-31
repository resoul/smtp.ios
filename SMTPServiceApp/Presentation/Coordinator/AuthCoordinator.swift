import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinishAuth(_ coordinator: AuthCoordinator)
}

final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var container: Container
    weak var delegate: AuthCoordinatorDelegate?
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
        self.childCoordinators = []
    }
    
    func start() {
        let controller = LoginController(viewModel: container.makeLoginViewModel())
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func handleLauchCompletion() {
        print(childCoordinators)
    }
}
