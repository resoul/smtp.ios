final class TokenCreatingUseCaseImpl: TokenCreatingUseCase {
    private let repository: TokenRepository

    init(tokenRepository: TokenRepository) {
        self.repository = tokenRepository
    }

    func execute(tokenName: String) async throws {
        return try await repository.create(tokenName: tokenName)
    }
}
