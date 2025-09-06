import UIKit
import PreviewIntro

final class PreviewIntroControllerImpl: PreviewIntroController {
    weak var coordinator: PreviewIntroCoordinator?
}

protocol PreviewIntroCoordinatorDelegate: AnyObject {
    func previewIntroCoordinatorDidFinish(_ coordinator: PreviewIntroCoordinator)
}

final class PreviewIntroCoordinator: Coordinator, PreviewIntroDelegate {
    var childCoordinators: [Coordinator]
    var navigationController: UINavigationController
    var container: Container
    weak var delegate: PreviewIntroCoordinatorDelegate?
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
        self.childCoordinators = []
    }
    
    func start() {
        let controller = PreviewIntroControllerImpl(
            viewModel: container.makePreviewIntroViewModel(),
            viewNode: PreviewIntroNode()
        )
        
        controller.coordinator = self
        controller.delegate = self
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func handlePreviewCompletion(isLoading: Bool) {
        if isLoading == false {
            delegate?.previewIntroCoordinatorDidFinish(self)
        }
    }
}
