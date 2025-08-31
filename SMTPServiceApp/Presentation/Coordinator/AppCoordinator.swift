import UIKit

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var container: Container
    private var lauchCoordinator: LaunchCoordinator?
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let lauchCoordinator = container.makeLauchCoordinator(navigationController: navigationController)
        addChildCoordinator(lauchCoordinator)
        lauchCoordinator.start()
        self.lauchCoordinator = lauchCoordinator
        self.lauchCoordinator?.childCoordinators = self.childCoordinators
    }
}
