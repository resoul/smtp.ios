final class UserDomainCreatingUseCaseImpl: UserDomainCreatingUseCase {
    private let userDomainRepository: UserDomainRepository

    init(userDomainRepository: UserDomainRepository) {
        self.userDomainRepository = userDomainRepository
    }
    
    func execute(domainName: String) async throws -> ListingResponse<UserDomain> {
        return try await userDomainRepository.create(domainName: domainName)
    }
}
