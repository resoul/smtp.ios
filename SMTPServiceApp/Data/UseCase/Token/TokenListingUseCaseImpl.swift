final class TokenListingUseCaseImpl: TokenListingUseCase {
    private let repository: TokenRepository

    init(tokenRepository: TokenRepository) {
        self.repository = tokenRepository
    }

    func execute(page: Int, perPage: Int) async throws -> ListingResponse<Token> {
        return try await repository.lising(page: page, perPage: perPage)
    }
}
