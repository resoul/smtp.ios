import AsyncDisplayKit

final class DashboardCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = ASDKNavigationController()
    var container: Container

    init(container: Container) {
        self.container = container
    }

    func start() {
        let controller = DashboardController()
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
}
