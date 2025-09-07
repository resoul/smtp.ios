import Combine

protocol RegistrationViewModel: AuthViewModel {
    var email: String { get }
    
    var statePublisher: AnyPublisher<ViewState, Never> { get }
    var isRegistrationEnabledPublisher: AnyPublisher<Bool, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }
    
    func register() async
    func updateEmail(_ email: String)
    func updatePassword(_ password: String)
    func updateFirstName(_ firstName: String)
    func updateLastName(_ lastName: String)
    func updatePasswordConfirmation(_ passwordConfirmation: String)
    func clearError()
    func resetForm()
}

final class RegistrationViewModelImpl: RegistrationViewModel {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var passwordConfirmation = ""
    @Published var state: ViewState = .idle
    @Published var isRegistrationEnabled = false
    @Published var errorMessage: String?
    
    // MARK: - Public Publishers
    var statePublisher: AnyPublisher<ViewState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    var isRegistrationEnabledPublisher: AnyPublisher<Bool, Never> {
        $isRegistrationEnabled.eraseToAnyPublisher()
    }
    
    var errorMessagePublisher: AnyPublisher<String?, Never> {
        $errorMessage.eraseToAnyPublisher()
    }
    
    private let registrationUseCase: RegistrationUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(registrationUseCase: RegistrationUseCase) {
        self.registrationUseCase = registrationUseCase
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest4($firstName, $lastName, $email, $password)
            .combineLatest($passwordConfirmation)
            .map { fields, passwordConfirmation in
                let (firstName, lastName, email, password) = fields
                return !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
                       !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
                       !email.trimmingCharacters(in: .whitespaces).isEmpty &&
                       !password.isEmpty &&
                       !passwordConfirmation.isEmpty
            }
            .assign(to: &$isRegistrationEnabled)
    }
    
    // MARK: - Public Methods
    func updateFirstName(_ firstName: String) {
        self.firstName = firstName
    }
    
    func updateLastName(_ lastName: String) {
        self.lastName = lastName
    }
    
    func updateEmail(_ email: String) {
        self.email = email
    }
    
    func updatePassword(_ password: String) {
        self.password = password
    }
    
    func updatePasswordConfirmation(_ passwordConfirmation: String) {
        self.passwordConfirmation = passwordConfirmation
    }
    
    @MainActor
    func register() async {
        state = .loading
        errorMessage = nil
        
        do {
            let user = try await registrationUseCase.execute(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                passwordConfirmation: passwordConfirmation
            )
            state = .success
            print("Registration successful for user: \(user.email)")
        } catch {
            print(error)
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
    
    func resetForm() {
        firstName = ""
        lastName = ""
        email = ""
        password = ""
        passwordConfirmation = ""
        state = .idle
        errorMessage = nil
    }
}
