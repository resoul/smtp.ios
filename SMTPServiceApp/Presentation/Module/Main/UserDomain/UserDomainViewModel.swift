import Combine
import Foundation

final class UserDomainViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    private let userService: UserService
    private let listingUseCase: UserDomainListingUseCase
    private let deletingUseCase: UserDomainDeletingUseCase
    private let creatingUseCase: UserDomainCreatingUseCase
    private let verificationUseCase: UserDomainVerificationUseCase
    
    private var page: Int = 1
    private var perPage: Int = 10
    
    let totalItems = PassthroughSubject<Int, Never>()
    let items = PassthroughSubject<[UserDomain], Never>()

    init(
        userService: UserService,
        listingUseCase: UserDomainListingUseCase,
        deletingUseCase: UserDomainDeletingUseCase,
        creatingUseCase: UserDomainCreatingUseCase,
        verificationUseCase: UserDomainVerificationUseCase
    ) {
        self.listingUseCase = listingUseCase
        self.deletingUseCase = deletingUseCase
        self.creatingUseCase = creatingUseCase
        self.verificationUseCase = verificationUseCase
        self.userService = userService
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
    
    @MainActor
    func verify(userDomain: UserDomain) async throws -> UserDomain {
        do {
            return try await verificationUseCase.execute(domainUuid: userDomain.uuid)
        } catch {
            print(error)
        }
        
        return userDomain
    }
    
    func getCurrentUser() -> User? {
        userService.getCurrentUser()
    }
}
