import Combine

final class UserDomainViewModel {
    private let listingUseCase: UserDomainListingUseCase
    private var page: Int = 1
    private var perPage: Int = 10
    let totalItems = PassthroughSubject<Int, Never>()
    let items = PassthroughSubject<[UserDomain], Never>()

    init(listingUseCase: UserDomainListingUseCase) {
        self.listingUseCase = listingUseCase
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
}
