import Foundation

protocol UserDomainVerificationUseCase {
    func execute(domainUuid: UUID) async throws -> UserDomain
}
