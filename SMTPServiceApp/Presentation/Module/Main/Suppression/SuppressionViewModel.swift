import Combine
import Foundation

final class SuppressionViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    private let listingUseCase: SuppressionListingUseCase

    private var page: Int = 1
    private var perPage: Int = 10

    let totalItems = PassthroughSubject<Int, Never>()
    let items = PassthroughSubject<[Suppression], Never>()
    
    enum Section: Int, CaseIterable {
        case suppressionHeader = 0
        case suppression = 1

        var numberOfRows: Int {
            switch self {
            case .suppressionHeader: return 1
            case .suppression: return 0
            }
        }
    }

    init(listingUseCase: SuppressionListingUseCase) {
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
