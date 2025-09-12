final class ResetPasswordUseCaseImpl: ResetPasswordUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(resetToken: String, password: String, passwordConfirmation: String) async throws {
        try validateResetToken(resetToken)
        try validatePassword(password)
        try validatePasswordConfirmation(password, passwordConfirmation)
        
        try await authRepository.resetPassword(
            resetToken: resetToken,
            password: password,
            passwordConfirmation: passwordConfirmation
        )
    }
    
    private func validateResetToken(_ resetToken: String) throws {
        guard !resetToken.isEmpty else {
            throw AuthValidationError.emptyResetToken
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
