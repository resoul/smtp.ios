import Foundation

protocol UserDomainDeletingUseCase {
    func execute(domainUuid: UUID) async throws
}
