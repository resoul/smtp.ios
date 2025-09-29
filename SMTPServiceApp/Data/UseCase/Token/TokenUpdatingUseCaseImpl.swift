final class TokenUpdatingUseCaseImpl: TokenUpdatingUseCase {
    private let repository: TokenRepository

    init(tokenRepository: TokenRepository) {
        self.repository = tokenRepository
    }

    func execute(token: String, tokenName: String, state: String) async throws {
        return try await repository.update(token: token, tokenName: tokenName, state: state)
    }
}
