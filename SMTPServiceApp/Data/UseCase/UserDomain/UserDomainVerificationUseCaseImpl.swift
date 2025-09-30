import Foundation

final class UserDomainVerificationUseCaseImpl: UserDomainVerificationUseCase {
    private let userDomainRepository: UserDomainRepository

    init(userDomainRepository: UserDomainRepository) {
        self.userDomainRepository = userDomainRepository
    }
    
    func execute(domainUuid: UUID) async throws -> UserDomain {
        return try await userDomainRepository.verify(domainUuid: domainUuid)
    }
}
