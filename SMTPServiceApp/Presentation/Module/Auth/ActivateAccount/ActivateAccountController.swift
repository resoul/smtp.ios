import UIKit
import Combine

final class ActivateAccountController: AuthBaseController {
    private var cancellables = Set<AnyCancellable>()
    private let viewNode = ActivateAccountNode()
    private let viewModel: ActivateAccountViewModel
    private var task: Task<Void, Never>?
    
    override func setupView() {
        view = viewNode.view
    }
    
    override func setupBindings() {
        viewNode.events
            .sink { [weak self] event in
                self?.handleNodeEvent(event)
            }
            .store(in: &cancellables)
        
        viewModel.errorMessagePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message)
            }
            .store(in: &cancellables)
        
        viewModel.successMessagePublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showErrorAlert(message)
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(
            title: String(localized: "em.smtp.t.alert.title.activate_account"),
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: String(localized: "em.smtp.t.alert.ok"), style: .default) { [weak self] _ in
            self?.viewModel.clearError()
        })

        if message.contains("network") || message.contains("connection") {
            alert.addAction(UIAlertAction(title: String(localized: "em.smtp.t.alert.retry"), style: .default) { [weak self] _ in
                self?.viewModel.clearError()
                self?.performResendEmail()
            })
        }
        
        present(alert, animated: true)
    }
    
    private func handleNodeEvent(_ event: ActivateAccountEvent) {
        switch event {
        case .resend:
            performResendEmail()
        }
    }
    
    private func performResendEmail() {
        guard case .idle = viewModel.state else { return }
        task?.cancel()
        
        task = Task {
            await viewModel.sendResetLink()
            guard !Task.isCancelled else { return }
            await MainActor.run {
                if case .success = self.viewModel.state {
                    self.viewModel.clearSuccess()
                    self.handleSuccess()
                }
            }
        }
    }
    
    private func handleSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            print("ok")
        }
    }
    
    deinit {
        task?.cancel()
        cancellables.removeAll()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        task?.cancel()
    }
    
    init(email: String, viewModel: ActivateAccountViewModel) {
        self.viewModel = viewModel
        self.viewModel.updateEmail(email)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
