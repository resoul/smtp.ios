final class TokenRepositoryImpl: TokenRepository {
    private let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func delete(token: String) async throws {
        try await network.requestWithoutResponse(
            endpoint: TokenEndpoint.delete(TokenDeletingRequest(token: token))
        )
    }
    
    func create(tokenName: String) async throws {
        try await network.requestWithoutResponse(
            endpoint: TokenEndpoint.create(TokenCreationRequest(tokenName: tokenName))
        )
    }
    
    func update(token: String, tokenName: String, state: String) async throws {
        try await network.requestWithoutResponse(
            endpoint: TokenEndpoint.update(TokenUpdatingRequest(
                token: token,
                tokenName: tokenName,
                state: state
            ))
        )
    }
    
    func lising(page: Int, perPage: Int) async throws -> ListingResponse<Token> {
        let request = TokenListingRequest(page: page, perPage: perPage)
        let response = try await network.request(
            endpoint: TokenEndpoint.listing(request),
            responseType: ListingResponseDTO<TokenDTO>.self
        )

        return response.map { $0.toDomain() }
    }
}
