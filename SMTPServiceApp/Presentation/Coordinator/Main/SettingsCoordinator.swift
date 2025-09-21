import AsyncDisplayKit

final class SettingsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = ASDKNavigationController()
    var container: Container

    init(container: Container) {
        self.container = container
    }

    func start() {
        let controller = SettingsController(viewModel: container.makeSettingsViewModel())
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
}
