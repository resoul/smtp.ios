import Foundation

final class UserDomainRepositoryImpl: UserDomainRepository {
    private let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func delete(domainUuid: UUID) async throws {
        try await network.requestWithoutResponse(
            endpoint: UserDomainEndpoint.delete(UserDomainDeletingRequest(domainUuid: domainUuid))
        )
    }
    
    func lising(page: Int, perPage: Int) async throws -> ListingResponse<UserDomain> {
        let request = UserDomainListingRequest(page: page, perPage: perPage)
        let response = try await network.request(
            endpoint: UserDomainEndpoint.listing(request),
            responseType: ListingResponseDTO<UserDomainDTO>.self
        )
        
        return response.map { $0.toDomain() }
    }
    
    func create(domainName: String) async throws -> ListingResponse<UserDomain> {
        let request = UserDomainCreatingRequest(domainName: domainName)
        let response = try await network.request(
            endpoint: UserDomainEndpoint.create(request),
            responseType: ListingResponseDTO<UserDomainDTO>.self
        )
        
        return response.map { $0.toDomain() }
    }
    
    func verify(domainUuid: UUID) async throws -> ListingResponse<UserDomain> {
        let request = UserDomainVerificationRequest(domainUuid: domainUuid)
        let response = try await network.request(
            endpoint: UserDomainEndpoint.verify(request),
            responseType: ListingResponseDTO<UserDomainDTO>.self
        )
        
        return response.map { $0.toDomain() }
    }
}
