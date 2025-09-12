final class LogoutUseCaseImpl: LogoutUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() async throws {
        do {
            try await authRepository.logout()
        } catch {
            print("Logout failed, error: \(error)")
            
            // Re-throw the error to be handled by the view model
            throw error
        }
    }
}
