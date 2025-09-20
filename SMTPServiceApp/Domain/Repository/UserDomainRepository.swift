protocol UserDomainRepository {
    func lising(page: Int, perPage: Int) async throws -> ListingResponse<UserDomain>
}
