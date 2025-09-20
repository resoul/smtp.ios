import Foundation

protocol UserDomainRepository {
    func lising(page: Int, perPage: Int) async throws -> ListingResponse<UserDomain>
    func delete(domainUuid: UUID) async throws
}
