import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinishAuth(_ coordinator: AuthCoordinator)
}

final class MainCoordinator: Coordinator {
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
        let controller = TabBarController()
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func handleLauchCompletion() {
        print(childCoordinators)
    }
}
