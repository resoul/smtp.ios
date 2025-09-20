protocol UserDomainListingUseCase {
    func execute(page: Int, perPage: Int) async throws -> ListingResponse<UserDomain>
}
