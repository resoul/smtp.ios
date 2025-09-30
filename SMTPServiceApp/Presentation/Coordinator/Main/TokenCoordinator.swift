import AsyncDisplayKit

final class TokenCoordinator: TabCoordinator {
    private lazy var tokenViewModel: TokenViewModel = {
        self.container.makeTokenViewModel()
    }()
    
    override func start() {
        let controller = TokenController(viewModel: tokenViewModel)
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
    
    func showCreateToken(from viewController: UIViewController) {
        let controller = CreateTokenController(viewModel: tokenViewModel)
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        viewController.present(controller, animated: true)
    }
    
    func showUpdateToken(from viewController: UIViewController) {
        let controller = UpdateTokenController(viewModel: tokenViewModel)
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        viewController.present(controller, animated: true)
    }
    
    func showDetails(from viewController: UIViewController) {
        guard let token = tokenViewModel.getToken() else { return }
        
        let controller = DetailTokenController(token: token)
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve

        viewController.present(controller, animated: true)
    }
}
