final class LoginUseCaseImpl: LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String, password: String) async throws -> User {
        // Input validation
        try validateInputs(email: email, password: password)
        
        // Perform login through repository
        do {
            let user = try await authRepository.login(email: email, password: password)
            
            // Additional post-login validation if needed
            try validateLoginResult(user: user)
            
            return user
        } catch {
            // Log error for debugging (in production, use proper logging)
            print("Login failed for email: \(email.isEmpty ? "empty" : "***@***"), error: \(error)")
            
            // Re-throw the error to be handled by the view model
            throw error
        }
    }
    
    // MARK: - Private Validation Methods
    private func validateInputs(email: String, password: String) throws {
        // Validate email
        try validateEmail(email)
        
        // Validate password
        try validatePassword(password)
    }
    
    private func validateEmail(_ email: String) throws {
        // Check if email is empty
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        guard !trimmedEmail.isEmpty else {
            throw AuthValidationError.emptyEmail
        }
        
        guard email.isValidEmail else {
            throw AuthValidationError.invalidEmail
        }

        guard trimmedEmail.count <= 254 else {
            throw AuthValidationError.invalidEmail
        }
    }
    
    private func validatePassword(_ password: String) throws {
        // Check if password is empty
        guard !password.isEmpty else {
            throw AuthValidationError.emptyPassword
        }
        
        // Note: For login, we typically don't enforce password strength rules
        // as the user might have an older password that doesn't meet current standards.
        // Password strength is usually enforced only during registration or password change.
    }
    
    private func validateLoginResult(user: User) throws {
        // Validate that we received a valid user object
        guard !user.uuid.isEmpty else {
            throw NetworkError.decodingError
        }
        
        guard !user.email.isEmpty else {
            throw NetworkError.decodingError
        }
    }
}
