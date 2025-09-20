final class UserDomainListingUseCaseImpl: UserDomainListingUseCase {
    private let userDomainRepository: UserDomainRepository

    init(userDomainRepository: UserDomainRepository) {
        self.userDomainRepository = userDomainRepository
    }

    func execute(page: Int, perPage: Int) async throws -> ListingResponse<UserDomain> {
        return try await userDomainRepository.lising(page: page, perPage: perPage)
    }
}
