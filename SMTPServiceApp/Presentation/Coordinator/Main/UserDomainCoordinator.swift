import AsyncDisplayKit

final class UserDomainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController = ASDKNavigationController()
    var container: Container
    
    private lazy var userDomainViewModel: UserDomainViewModel = {
        container.makeUserDomainViewModel()
    }()

    init(container: Container) {
        self.container = container
    }

    func start() {
        let controller = UserDomainController(viewModel: userDomainViewModel)
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
}
