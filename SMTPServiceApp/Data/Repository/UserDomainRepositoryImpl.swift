final class UserDomainRepositoryImpl: UserDomainRepository {
    private let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func lising(page: Int, perPage: Int) async throws -> ListingResponse<UserDomain> {
        let request = UserDomainListingRequest(page: page, perPage: perPage)
        let response = try await network.request(
            endpoint: UserDomainEndpoint.listing(request),
            responseType: ListingResponseDTO<UserDomainDTO>.self
        )
        
        return ListingResponse<UserDomain>(
            items: response.items.map { $0.toDomain() },
            pagination: response.pagination.toDomain()
        )
    }
}
