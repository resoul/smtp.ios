import UIKit
import Combine

final class LoginController: AuthBaseController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: LoginViewModel
    private let nodeView = LoginNode()
    
    override func setupView() {
        view = nodeView.view
    }
    
    override func setupBindings() {
        nodeView.events
            .sink { [weak self] event in
                self?.handleNodeEvent(event)
            }
            .store(in: &cancellables)
        
        nodeView.emailTextPublisher
            .removeDuplicates()
            .sink { [weak self] email in
                self?.viewModel.updateEmail(email)
            }
            .store(in: &cancellables)
        
        nodeView.passwordTextPublisher
            .removeDuplicates()
            .sink { [weak self] password in
                self?.viewModel.updatePassword(password)
            }
            .store(in: &cancellables)
        
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
        
        viewModel.isLoginEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.nodeView.setLoginButtonEnabled(isEnabled)
            }
            .store(in: &cancellables)
        
        viewModel.errorMessagePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(errorMessage)
            }
            .store(in: &cancellables)
    }
    
    private func handleNodeEvent(_ event: LoginNodeEvent) {
        switch event {
        case .registration:
            coordinator?.showRegistration()
        case .login:
            performLogin()
        case .forgotPassword:
            coordinator?.showForgotPassword()
        }
    }

    private func performLogin() {
        guard case .idle = viewModel.state else { return }
        
        Task {
            await viewModel.login()
            
            await MainActor.run {
                if case .success = self.viewModel.state {
                    self.handleLoginSuccess()
                }
            }
        }
    }
    
    private func handleLoginSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.coordinator?.didCompleteAuthentication()
        }
    }
    
    private func handleStateChange(_ state: ViewState) {
        switch state {
        case .idle:
            nodeView.setLoading(false)
            
        case .loading:
            nodeView.setLoading(true)
            view.endEditing(true) // Dismiss keyboard during loading
            
        case .success:
            nodeView.setLoading(false)
            
        case .error(let message):
            nodeView.setLoading(false)
            print(message)
            // Error message is handled separately through errorMessagePublisher
        }
    }
    
    override func setupInitialState() {
        nodeView.setLoginButtonEnabled(false)
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Login Failed",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.viewModel.clearError()
        })
        
        // Add retry action for certain error types
        if message.contains("network") || message.contains("connection") {
            alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                self?.viewModel.clearError()
                self?.performLogin()
            })
        }
        
        present(alert, animated: true)
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
