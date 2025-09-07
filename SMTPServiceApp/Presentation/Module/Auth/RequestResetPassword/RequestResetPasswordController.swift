import UIKit
import Combine

final class RequestResetPasswordController: AuthBaseController {
    private var cancellables = Set<AnyCancellable>()
    private let viewNode = RequestResetPasswordNode()
    private let viewModel: RequestResetPasswordViewModel
    
    override func setupInitialState() {
        viewNode.setButtonEnabled(false)
    }
    
    override func setupBindings() {
        bindViewNode()
        bindViewModel()
    }
    
    private func bindViewNode() {
        viewNode.events
            .sink { [weak self] event in
                self?.handleNodeEvent(event)
            }
            .store(in: &cancellables)
        
        viewNode.passwordTextPublisher
            .removeDuplicates()
            .sink { [weak self] password in
                self?.viewModel.updatePassword(password)
            }
            .store(in: &cancellables)
        
        viewNode.retypePasswordTextPublisher
            .removeDuplicates()
            .sink { [weak self] password in
                self?.viewModel.updatePasswordConfirmation(password)
            }
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
        
        viewModel.isResetEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.viewNode.setButtonEnabled(isEnabled)
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
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(
            title: String(localized: "em.smtp.t.alert.title.reset_password"),
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: String(localized: "em.smtp.t.alert.ok"), style: .default) { [weak self] _ in
            self?.viewModel.clearError()
        })

        if message.contains("network") || message.contains("connection") {
            alert.addAction(UIAlertAction(title: String(localized: "em.smtp.t.alert.retry"), style: .default) { [weak self] _ in
                self?.viewModel.clearError()
                self?.perfomRequestResetPassword()
            })
        }
        
        present(alert, animated: true)
    }
    
    private func handleNodeEvent(_ event: RequestResetPasswordNodeEvent) {
        switch event {
        case .submit:
            perfomRequestResetPassword()
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
    
    private func perfomRequestResetPassword() {
        guard case .idle = viewModel.state else { return }
        
        Task {
            await viewModel.resetPassword()
            
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
    
    override func setupView() {
        view = viewNode.view
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    init(viewModel: RequestResetPasswordViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
