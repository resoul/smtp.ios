import Combine

final class ActivateAccountViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let resendActivationEmailUseCase: ResendActivationEmailUseCase
    private var email: String = ""
    
    @Published var state: ViewState = .idle
    @Published var isSubmitEnabled = true
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    var statePublisher: AnyPublisher<ViewState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    var isSubmitEnabledPublisher: AnyPublisher<Bool, Never> {
        $isSubmitEnabled.eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String?, Never> {
        $errorMessage.eraseToAnyPublisher()
    }
    
    var successMessagePublisher: AnyPublisher<String?, Never> {
        $successMessage.eraseToAnyPublisher()
    }
    
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    @MainActor
    func sendResetLink() async {
        state = .loading
        errorMessage = nil
        successMessage = nil
        
        do {
            try await resendActivationEmailUseCase.execute(email: email)
            state = .success
            successMessage = String(localized: "em.smtp.t.auth.validation.msg.success.resend_activation_link")
            //successMessage = "Reset link sent to your email address"
        } catch {
            let message = error.localizedDescription
            errorMessage = message
            state = .error(message)
        }
    }
    
    private func canPerformResend() -> Bool {
        switch state {
        case .loading:
            return false
        default:
            return isSubmitEnabled
        }
    }
    
    func clearError() {
        errorMessage = nil
        if case .error = state {
            state = .idle
        }
    }
    
    func clearSuccess() {
        successMessage = nil
        if case .success = state {
            state = .idle
        }
    }
    
    func resetForm() {
        state = .idle
        errorMessage = nil
        successMessage = nil
    }
    
    init(resendActivationEmailUseCase: ResendActivationEmailUseCase) {
        self.resendActivationEmailUseCase = resendActivationEmailUseCase
    }
}
