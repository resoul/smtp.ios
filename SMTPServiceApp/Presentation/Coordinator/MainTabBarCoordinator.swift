import UIKit

final class MainTabBarCoordinator: Coordinator {
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
        navigationController.setViewControllers([MainTabBarController()], animated: false)
    }
}
