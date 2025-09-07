import UIKit
import Combine

class ForgotPasswordController: AuthBaseController {
    private var cancellables = Set<AnyCancellable>()
    private let viewNode = ForgotPasswordNode()
    private let viewModel: ForgotPasswordViewModel

    override func setupInitialState() {
        viewNode.setLoginButtonEnabled(false)
    }
    
    override func setupView() {
        view = viewNode.view
    }
    
    override func setupBindings() {
        viewNode.events
            .sink { [weak self] event in
                self?.handleNodeEvent(event)
            }
            .store(in: &cancellables)
        
        viewNode.emailTextPublisher
            .removeDuplicates()
            .sink { [weak self] email in
                self?.viewModel.updateEmail(email)
            }
            .store(in: &cancellables)
        
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
        
        viewModel.isSubmitEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.viewNode.setLoginButtonEnabled(isEnabled)
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
    
    private func handleNodeEvent(_ event: ForgotPasswordNodeEvent) {
        switch event {
        case .registration:
            coordinator?.showRegistration()
        case .login:
            coordinator?.showLogin()
        case .submit:
            perfomForgotPassword()
        }
    }
    
    private func handleStateChange(_ state: ViewState) {
        switch state {
        case .idle:
            viewNode.setLoading(false)
            
        case .loading:
            viewNode.setLoading(true)
            view.endEditing(true) // Dismiss keyboard during loading
            
        case .success:
            viewNode.setLoading(false)
            
        case .error(let message):
            viewNode.setLoading(false)
            print(message)
            // Error message is handled separately through errorMessagePublisher
        }
    }
    
    private func perfomForgotPassword() {
        guard case .idle = viewModel.state else { return }
        
        Task {
            await viewModel.sendResetLink()
            
            await MainActor.run {
                if case .success = self.viewModel.state {
                    self.handleSuccess()
                }
            }
        }
    }
    
    private func handleSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.coordinator?.showLogin()
        }
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(
            title: "Forgot Password Failed",
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
                self?.perfomForgotPassword()
            })
        }
        
        present(alert, animated: true)
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    init(viewModel: ForgotPasswordViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
