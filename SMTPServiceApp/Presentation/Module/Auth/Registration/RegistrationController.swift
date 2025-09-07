import UIKit
import Combine

final class RegistrationController: AuthBaseController {
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: RegistrationViewModel
    private let nodeView = RegistrationNode()
    
    override func setupInitialState() {
        nodeView.setRegistrationButtonEnabled(false)
    }
    
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
        
        nodeView.firstNameTextPublisher
            .removeDuplicates()
            .sink { [weak self] firstName in
                self?.viewModel.updateFirstName(firstName)
            }
            .store(in: &cancellables)
        
        nodeView.lastNameTextPublisher
            .removeDuplicates()
            .sink { [weak self] lastName in
                self?.viewModel.updateLastName(lastName)
            }
            .store(in: &cancellables)
        
        nodeView.passwordTextPublisher
            .removeDuplicates()
            .sink { [weak self] password in
                self?.viewModel.updatePassword(password)
            }
            .store(in: &cancellables)
        
        nodeView.retypePasswordTextPublisher
            .removeDuplicates()
            .sink { [weak self] password in
                self?.viewModel.updatePasswordConfirmation(password)
            }
            .store(in: &cancellables)
        
        // Bind view model state to UI
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
        
        viewModel.isRegistrationEnabledPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.nodeView.setRegistrationButtonEnabled(isEnabled)
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
            title: "Registration Failed",
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
                self?.performRegistration()
            })
        }
        
        present(alert, animated: true)
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
    
    private func handleNodeEvent(_ event: RegistrationNodeEvent) {
        switch event {
        case .submit:
            self.performRegistration()
        case .login:
            coordinator?.showLogin()
        }
    }
    
    private func performRegistration() {
        guard case .idle = viewModel.state else { return }
        
        Task {
            await viewModel.register()
            
            await MainActor.run {
                if case .success = self.viewModel.state {
                    self.handleRegistrationSuccess()
                }
            }
        }
    }
    
    private func handleRegistrationSuccess() {
        let email = viewModel.email
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.coordinator?.showAccountActive(email: email)
        }
    }
    
    deinit {
        cancellables.removeAll()
    }

    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
