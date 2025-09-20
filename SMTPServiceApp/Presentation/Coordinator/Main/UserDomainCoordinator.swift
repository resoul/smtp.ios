import AsyncDisplayKit

final class UserDomainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = ASDKNavigationController()
    var container: Container

    init(container: Container) {
        self.container = container
    }

    func start() {
        let controller = UserDomainController(viewModel: container.makeUserDomainViewModel())
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
}
