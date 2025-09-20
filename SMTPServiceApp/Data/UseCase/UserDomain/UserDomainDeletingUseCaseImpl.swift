import Foundation

final class UserDomainDeletingUseCaseImpl: UserDomainDeletingUseCase {
    private let userDomainRepository: UserDomainRepository

    init(userDomainRepository: UserDomainRepository) {
        self.userDomainRepository = userDomainRepository
    }
    
    func execute(domainUuid: UUID) async throws {
        return try await userDomainRepository.delete(domainUuid: domainUuid)
    }
}
