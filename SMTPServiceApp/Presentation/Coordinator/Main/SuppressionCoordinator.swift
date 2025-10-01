import AsyncDisplayKit

final class SuppressionCoordinator: TabCoordinator {
    private lazy var suppressionViewModel: SuppressionViewModel = {
        self.container.makeSuppressionViewModel()
    }()
    
    override func start() {
        let controller = SuppressionController(viewModel: suppressionViewModel)
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func showSuppressionFilter(from viewController: UIViewController) {
        viewController.present(SuppressionFilterController(), animated: true)
    }
}
