import UIKit

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator)
}

final class AuthCoordinator: Coordinator {
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
        startLogin()
    }
    
    func showLogin() {
        pushController(
            LoginController(viewModel: container.makeLoginViewModel())
        )
    }
    
    func showRegistration() {
        pushController(
            RegistrationController(viewModel: container.makeRegistrationViewModel())
        )
    }
    
    func showForgotPassword() {
        pushController(
            ForgotPasswordController(viewModel: container.makeForgotPasswordViewModel())
        )
    }
    
    func showAccountActive(email: String) {
        pushController(
            ActivateAccountController(
                email: "test@email.com",
                viewModel: container.makeActivateAccountViewModel()
            )
        )
    }
    
    func showRequestResetPassword() {
        pushController(
            RequestResetPasswordController(
                viewModel: container.makeRequestResetPasswordViewModel()
            )
        )
    }
    
    func didCompleteAuthentication() {
        delegate?.authCoordinatorDidFinish(self)
    }
    
    private func pushController(_ controller: AuthBaseController) {
        controller.coordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
}

extension AuthCoordinator {
    private func startRegistration() {
        let controller = RegistrationController(viewModel: container.makeRegistrationViewModel())
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
    
    private func startLogin() {
        let controller = LoginController(viewModel: container.makeLoginViewModel())
        controller.coordinator = self
        navigationController.setViewControllers([controller], animated: false)
    }
}
