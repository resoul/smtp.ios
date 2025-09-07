import Combine

final class ForgotPasswordViewModel {
    // MARK: - Published Properties
    @Published var email = ""
    @Published var state: ViewState = .idle
    @Published var isSubmitEnabled = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    // MARK: - Public Publishers
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
    
    private let forgotPasswordUseCase: ForgotPasswordUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(forgotPasswordUseCase: ForgotPasswordUseCase) {
        self.forgotPasswordUseCase = forgotPasswordUseCase
        setupValidation()
    }
    
    private func setupValidation() {
        $email
            .map { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .assign(to: &$isSubmitEnabled)
    }
    
    // MARK: - Public Methods
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    @MainActor
    func sendResetLink() async {
        state = .loading
        errorMessage = nil
        successMessage = nil
        
        do {
            try await forgotPasswordUseCase.execute(email: email)
            state = .success
            successMessage = "Reset link sent to your email address"
        } catch {
            let message = error.localizedDescription
            errorMessage = message
            state = .error(message)
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
        email = ""
        state = .idle
        errorMessage = nil
        successMessage = nil
    }
}
