import Combine
import Foundation

final class UserDomainViewModel {
    private let listingUseCase: UserDomainListingUseCase
    private let deletingUseCase: UserDomainDeletingUseCase
    private var page: Int = 1
    private var perPage: Int = 10
    let totalItems = PassthroughSubject<Int, Never>()
    let items = PassthroughSubject<[UserDomain], Never>()

    init(listingUseCase: UserDomainListingUseCase, deletingUseCase: UserDomainDeletingUseCase) {
        self.listingUseCase = listingUseCase
        self.deletingUseCase = deletingUseCase
    }
    
    func setPage(_ page: Int) {
        self.page = page
    }
    
    @MainActor
    func fetchListings() async throws {
        do {
            let response = try await listingUseCase.execute(page: page, perPage: perPage)
            totalItems.send(response.pagination.totalItems)
            items.send(response.items)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func delete(domainUuid: UUID) async throws {
        do {
            try await deletingUseCase.execute(domainUuid: domainUuid)
        } catch {
            print(error)
        }
    }
}
