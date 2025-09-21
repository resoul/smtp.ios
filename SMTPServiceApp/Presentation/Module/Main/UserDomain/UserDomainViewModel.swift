import Combine
import Foundation

final class UserDomainViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    private let userService: UserService
    private let listingUseCase: UserDomainListingUseCase
    private let deletingUseCase: UserDomainDeletingUseCase
    
    private var page: Int = 1
    private var perPage: Int = 10
    
    let totalItems = PassthroughSubject<Int, Never>()
    let items = PassthroughSubject<[UserDomain], Never>()
    let currentUser = PassthroughSubject<User?, Never>()
    
    private(set) var user: User?

    init(
        userService: UserService,
        listingUseCase: UserDomainListingUseCase,
        deletingUseCase: UserDomainDeletingUseCase
    ) {
        self.listingUseCase = listingUseCase
        self.deletingUseCase = deletingUseCase
        self.userService = userService
        
        userService.userPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.updateUser(with: user)
            }
            .store(in: &cancellables)
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
    
    private func updateUser(with user: User?) {
        self.user = user
        currentUser.send(user)
    }
}
