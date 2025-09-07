import Foundation

protocol ResendActivationEmailUseCase {
    func execute(email: String) async throws
}

final class ResendActivationEmailUseCaseImpl: ResendActivationEmailUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(email: String) async throws {
        try validateEmail(email)
        try await authRepository.resendActivationEmail(email: email)
    }
    
    private func validateEmail(_ email: String) throws {
        guard !email.isEmpty else {
            throw AuthValidationError.emptyEmail
        }
        
        guard !email.isValidEmail else {
            throw AuthValidationError.invalidEmail
        }
    }
}
