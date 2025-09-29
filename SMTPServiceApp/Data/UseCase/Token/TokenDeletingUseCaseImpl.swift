final class TokenDeletingUseCaseImpl: TokenDeletingUseCase {
    private let repository: TokenRepository

    init(tokenRepository: TokenRepository) {
        self.repository = tokenRepository
    }

    func execute(token: String) async throws {
        return try await repository.delete(token: token)
    }
}
