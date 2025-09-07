import Combine

final class RequestResetPasswordViewModel {
    private var cancellables = Set<AnyCancellable>()
    private let resetPasswordUseCase: ResetPasswordUseCase

    @Published var resetToken = ""
    @Published var password = ""
    @Published var passwordConfirmation = ""
    @Published var state: ViewState = .idle
    @Published var isResetEnabled = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    var statePublisher: AnyPublisher<ViewState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    var isResetEnabledPublisher: AnyPublisher<Bool, Never> {
        $isResetEnabled.eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String?, Never> {
        $errorMessage.eraseToAnyPublisher()
    }
    
    var successMessagePublisher: AnyPublisher<String?, Never> {
        $successMessage.eraseToAnyPublisher()
    }
    
    func updatePassword(_ password: String) {
        self.password = password
    }
    
    func updateResetToken(_ resetToken: String) {
        self.resetToken = resetToken
    }
    
    func updatePasswordConfirmation(_ passwordConfirmation: String) {
        self.passwordConfirmation = passwordConfirmation
    }
    
    @MainActor
    func resetPassword() async {
        state = .loading
        errorMessage = nil
        successMessage = nil
        
        do {
            try await resetPasswordUseCase.execute(
                resetToken: resetToken,
                password: password,
                passwordConfirmation: passwordConfirmation
            )
            state = .success
            successMessage = String(localized: "em.smtp.t.auth.validation.msg.success.reset.password")
        } catch {
            let message = error.localizedDescription
            errorMessage = message
            state = .error(message)
        }
    }
    
    private func setupValidation() {
        Publishers.CombineLatest3($resetToken, $password, $passwordConfirmation)
            .map { resetToken, password, passwordConfirmation in
                !password.isEmpty && !passwordConfirmation.isEmpty
            }
            .assign(to: &$isResetEnabled)
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
        resetToken = ""
        password = ""
        passwordConfirmation = ""
        state = .idle
        errorMessage = nil
        successMessage = nil
    }
    
    init(resetPasswordUseCase: ResetPasswordUseCase) {
        self.resetPasswordUseCase = resetPasswordUseCase
        setupValidation()
    }
}
