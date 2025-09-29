import Foundation

protocol UserDomainRepository {
    func lising(page: Int, perPage: Int) async throws -> ListingResponse<UserDomain>
    func create(domainName: String) async throws -> ListingResponse<UserDomain>
    func verify(domainUuid: UUID) async throws -> ListingResponse<UserDomain>
    func delete(domainUuid: UUID) async throws
}
