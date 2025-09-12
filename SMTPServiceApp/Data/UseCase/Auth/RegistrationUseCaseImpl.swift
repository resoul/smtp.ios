final class RegistrationUseCaseImpl: RegistrationUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) async throws -> User {
        // Input validation
        try validateFirstName(firstName)
        try validateLastName(lastName)
        try validateEmail(email)
        try validatePassword(password)
        try validatePasswordConfirmation(password, passwordConfirmation)
        
        return try await authRepository.register(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation
        )
    }
    
    private func validateFirstName(_ firstName: String) throws {
        guard !firstName.isEmpty else {
            throw AuthValidationError.emptyFirstName
        }
    }
    
    private func validateLastName(_ lastName: String) throws {
        guard !lastName.isEmpty else {
            throw AuthValidationError.emptyLastName
        }
    }
    
    private func validateEmail(_ email: String) throws {
        guard !email.isEmpty else {
            throw AuthValidationError.emptyEmail
        }
        
        guard email.isValidEmail else {
            throw AuthValidationError.invalidEmail
        }
    }
    
    private func validatePassword(_ password: String) throws {
        guard !password.isEmpty else {
            throw AuthValidationError.emptyPassword
        }
        
        guard password.count >= 10 else {
            throw AuthValidationError.passwordTooShort
        }
    }
    
    private func validatePasswordConfirmation(
        _ password: String,
        _ passwordConfirmation: String
    ) throws {
        guard password == passwordConfirmation else {
            throw AuthValidationError.passwordMismatch
        }
    }
}
