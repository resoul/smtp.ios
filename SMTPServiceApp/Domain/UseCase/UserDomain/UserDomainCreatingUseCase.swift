protocol UserDomainCreatingUseCase {
    func execute(domainName: String) async throws -> ListingResponse<UserDomain>
}
