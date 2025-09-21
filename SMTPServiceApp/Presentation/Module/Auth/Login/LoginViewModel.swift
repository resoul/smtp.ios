import Combine
import Foundation

protocol LoginViewModel: AuthViewModel {
    var email: String { get set }
    var password: String { get set }
    var currentUser: User? { get }
    
    var statePublisher: AnyPublisher<ViewState, Never> { get }
    var isLoginEnabledPublisher: AnyPublisher<Bool, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }
    var emailValidationError: AnyPublisher<String?, Never> { get }
    var passwordValidationError: AnyPublisher<String?, Never> { get }
    var userPublisher: AnyPublisher<User?, Never> { get }
    
    func login() async
    func updateEmail(_ email: String)
    func updatePassword(_ password: String)
    func clearError()
    func resetForm()
}

final class LoginViewModelImpl: LoginViewModel {
    @Published var email = ""
    @Published var password = ""
    @Published var state: ViewState = .idle
    @Published var isLoginEnabled = false
    @Published var errorMessage: String?
    @Published private(set) var currentUser: User?
    
    private let loginUseCase: LoginUseCase
    private let userStorage: UserStorage
    private var cancellables = Set<AnyCancellable>()
    
    var emailValidationError: AnyPublisher<String?, Never> {
        $email
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map { [weak self] email in
                self?.validateEmailInput(email)
            }
            .eraseToAnyPublisher()
    }
    
    var passwordValidationError: AnyPublisher<String?, Never> {
        $password
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map { [weak self] password in
                self?.validatePasswordInput(password)
            }
            .eraseToAnyPublisher()
    }
    
    var statePublisher: AnyPublisher<ViewState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    var isLoginEnabledPublisher: AnyPublisher<Bool, Never> {
        $isLoginEnabled.eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String?, Never> {
        $errorMessage.eraseToAnyPublisher()
    }
    
    var userPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }

    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((Error) -> Void)?
    
    init(loginUseCase: LoginUseCase, userStorage: UserStorage) {
        self.loginUseCase = loginUseCase
        self.userStorage = userStorage
        setupValidation()
        loadCurrentUser()
    }
    
    @MainActor
    func login() async {
        guard canPerformLogin() else { return }
        
        state = .loading
        errorMessage = nil
        
        do {
            currentUser = try await loginUseCase.execute(email: email, password: password)
            state = .success
            onLoginSuccess?()
        } catch {
            let message = mapErrorToUserFriendlyMessage(error)
            errorMessage = message
            state = .error(message)
            onLoginError?(error)
            print("Login failed: \(error.localizedDescription)")
        }
    }
    
    func updateEmail(_ email: String) {
        self.email = email
        clearErrorIfNeeded()
    }
    
    func updatePassword(_ password: String) {
        self.password = password
        clearErrorIfNeeded()
    }
    
    func clearError() {
        errorMessage = nil
        if case .error = state {
            state = .idle
        }
    }
    
    func resetForm() {
        email = ""
        password = ""
        state = .idle
        errorMessage = nil
    }
    
    private func loadCurrentUser() {
        // Load user from storage if available
        if let userDTO = userStorage.getUser() {
            currentUser = userDTO.toDomain()
        }
    }
    
    // MARK: - Private Methods
    private func setupValidation() {
        // Combine email and password to determine if login should be enabled
        Publishers.CombineLatest3($email, $password, $state)
            .map { [weak self] email, password, state in
                guard let self = self else { return false }
                guard !state.isLoading else { return false }
                
                // Check if inputs are valid
                let emailValid = self.validateEmailInput(email) == nil && !email.trimmingCharacters(in: .whitespaces).isEmpty
                let passwordValid = self.validatePasswordInput(password) == nil && !password.isEmpty
                
                return emailValid && passwordValid
            }
            .assign(to: &$isLoginEnabled)
    }
    
    private func validateEmailInput(_ email: String) -> String? {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        if trimmedEmail.isEmpty {
            return nil // Don't show error for empty field initially
        }
        
        if !trimmedEmail.isValidEmail {
            return "Please enter a valid email address"
        }

        return nil
    }
    
    private func validatePasswordInput(_ password: String) -> String? {
        if password.isEmpty {
            return nil // Don't show error for empty field initially
        }
        
        if password.count < 2 {
            return "Password is too short"
        }
        
        return nil
    }
    
    private func canPerformLogin() -> Bool {
        switch state {
        case .loading:
            return false
        default:
            return isLoginEnabled
        }
    }
    
    private func clearErrorIfNeeded() {
        if case .error = state {
            clearError()
        }
    }
    
    private func mapErrorToUserFriendlyMessage(_ error: Error) -> String {
        switch error {
        case let networkError as NetworkError:
            return mapNetworkError(networkError)
        case let validationError as AuthValidationError:
            return validationError.localizedDescription
        default:
            return "An unexpected error occurred. Please try again."
        }
    }
    
    private func mapNetworkError(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "Service configuration error. Please contact support."
        case .noData:
            return "No response from server. Please try again."
        case .tooManyRequests:
            return "Too many requests. Try later."
        case .decodingError:
            return "Server response format error. Please try again."
        case .validationError(let errors):
            if errors.isEmpty {
                return "Please check your login credentials."
            }
            return errors.map { "\($0.entity): \($0.error)" }.joined(separator: "\n")
        case .authenticationError:
            return "Invalid email or password. Please check your credentials."
        case .accountNotActivated:
            return "Your account is not activated. Please check your email for activation instructions."
        case .notFound:
            return "Account not found. Please check your email address."
        case .serverError(let message):
            return "Server error: \(message). Please try again later."
        case .unknown:
            return "Network connection error. Please check your internet connection and try again."
        }
    }
}

extension ViewState {
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var isError: Bool {
        if case .error = self {
            return true
        }
        return false
    }
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}
