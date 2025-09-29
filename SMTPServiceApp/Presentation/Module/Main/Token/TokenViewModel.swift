import Combine
import Foundation

final class TokenViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    private let userService: UserService
    private let listingUseCase: TokenListingUseCase
    private let deletingUseCase: TokenDeletingUseCase
    private let creatingUseCase: TokenCreatingUseCase
    private let updatingUseCase: TokenUpdatingUseCase

    private var page: Int = 1
    private var perPage: Int = 10
    
    private var currentToken: Token?
    
    let totalItems = PassthroughSubject<Int, Never>()
    let items = PassthroughSubject<[Token], Never>()
    let needsReload = PassthroughSubject<Void, Never>()
    
    enum SettingsTab: Int, CaseIterable {
       case smtp = 0
       case apiDetails = 1

       var title: String {
           switch self {
           case .smtp: return "SMTP"
           case .apiDetails: return "API details"
           }
       }
    }
    
    enum Section: Int, CaseIterable {
        case tabs = 0
        case content = 1
        case tokensHeader = 2
        case tokens = 3

        var numberOfRows: Int {
            switch self {
            case .tabs, .content, .tokensHeader: return 1
            case .tokens: return 0
            }
        }
    }
    
    init(
        userService: UserService,
        listingUseCase: TokenListingUseCase,
        deletingUseCase: TokenDeletingUseCase,
        creatingUseCase: TokenCreatingUseCase,
        updatingUseCase: TokenUpdatingUseCase
    ) {
        self.listingUseCase = listingUseCase
        self.deletingUseCase = deletingUseCase
        self.creatingUseCase = creatingUseCase
        self.updatingUseCase = updatingUseCase
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
    func delete(token: String) async throws {
        do {
            try await deletingUseCase.execute(token: token)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func create(tokenName: String) async throws {
        do {
            try await creatingUseCase.execute(tokenName: tokenName)
            page = 1
            needsReload.send()
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func update(tokenName: String, token: String, state: TokenState) async throws {
        do {
            try await updatingUseCase.execute(
                token: token,
                tokenName: tokenName,
                state: state.rawValue.uppercased()
            )
        } catch {
            print(error)
        }
    }
    
    func getCurrentUser() -> User? {
        userService.getCurrentUser()
    }
    
    func getToken() -> Token? {
        currentToken
    }
    
    func setToken(_ token: Token) {
        self.currentToken = token
    }
}
