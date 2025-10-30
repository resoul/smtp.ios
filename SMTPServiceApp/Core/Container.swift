import UIKit

/// Protocol defining access to all repositories in the app
///
/// Repositories are responsible for data operations and API communication.
protocol RepositoryContainer {
    var authRepository: AuthRepository { get }
    var userDomainRepository: UserDomainRepository { get }
    var tokenRepository: TokenRepository { get }
    var suppressionRepository: SuppressionRepository { get }
}

/// Protocol defining access to all storage mechanisms
///
/// Storage implementations handle local data persistence.
protocol StorageContainer {
    var cookieStorage: CookieStorage { get }
    var userStorage: UserStorage { get }
    var appStorage: AppStorage { get }
}

// MARK: - Main Container

/// Main dependency injection container for the application
///
/// This container manages the lifecycle of all major app dependencies including
/// repositories, services, storage, and coordinators. It follows the Dependency
/// Injection pattern to provide loose coupling between components.
///
/// The Container is composed of feature-specific protocols:
/// - `AuthContainer`: Authentication-related dependencies
/// - `MainContainer`: Main feature dependencies (Token, UserDomain, etc.)
/// - `RepositoryContainer`: Data layer repositories
/// - `StorageContainer`: Storage implementations
///
/// Usage:
/// ```swift
/// let container = Container(
///     windowScene: windowScene,
///     appConfiguration: config,
///     source: UserDefaultsDataSource(),
///     themeManager: ThemeManager.shared
/// )
/// let appCoordinator = container.makeAppCoordinator()
/// ```
final class Container {
    private let windowScene: UIWindowScene
    private let window: UIWindow
    private let appConfiguration: AppConfiguration
    private let service: Service
    private let storage: Storage
    private let repository: Repository
    let themeManager: ThemeManager
    
    init(
        windowScene:  UIWindowScene,
        appConfiguration: AppConfiguration,
        source: DataSource,
        themeManager: ThemeManager
    ) {
        self.windowScene = windowScene
        self.appConfiguration = appConfiguration
        self.themeManager = themeManager
        self.storage = Storage(source: source)
        self.service = Service(appConfiguration: appConfiguration, storage: storage)
        self.repository = Repository(service: service, storage: storage)
        
        self.window = UIWindow(windowScene: windowScene)
    }
    
    func makeMainWindow() -> UIWindow {
        window.frame = windowScene.coordinateSpace.bounds
        
        return window
    }
}

//MARK: -- Container App Configuration
extension Container {
    var showPreviewIntro: Bool {
        appConfiguration.previewIntoEnabled
    }
}

//MARK: -- Container Repository
extension Container: RepositoryContainer {
    var authRepository: AuthRepository {
        repository.authRepository
    }
    
    var userDomainRepository: UserDomainRepository {
        repository.userDomainRepository
    }
    
    var tokenRepository: TokenRepository {
        repository.tokenRepository
    }
    
    var suppressionRepository: SuppressionRepository {
        repository.suppressionRepository
    }
}

//MARK: -- Container Storage
extension Container: StorageContainer {
    var cookieStorage: CookieStorage {
        storage.cookieStorage
    }
    
    var userStorage: UserStorage {
        storage.userStorage
    }
    
    var appStorage: AppStorage {
        storage.appStorage
    }
}

//MARK: -- Container Service
extension Container {
    var authService: AuthenticationService {
        service.authService
    }
    
    var networkService: NetworkService {
        service.networkService
    }
    
    var userService: UserService {
        service.userService
    }
}

//MARK: -- Container Coordinator
extension Container {
    func makeAppCoordinator() -> AppCoordinator {
        let navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return AppCoordinator(
            navigationController: navigationController,
            container: self
        )
    }
}

final class Storage {
    private let source: DataSource
    
    init(source: DataSource) {
        self.source = source
    }
    
    private(set) lazy var cookieStorage: CookieStorage = {
        return CookieStorage(dataSource: source)
    }()
    
    private(set) lazy var userStorage: UserStorage = {
        return UserStorage(dataSource: source)
    }()
    
    private(set) lazy var appStorage: AppStorage = {
        return AppStorage(dataSource: source)
    }()
}

final class Service {
    private let appConfiguration: AppConfiguration
    private let storage: Storage
    
    init(appConfiguration: AppConfiguration, storage: Storage) {
        self.appConfiguration = appConfiguration
        self.storage = storage
    }
    
    // Router that handles auth-related events coming from the network layer
    private lazy var authEventRouter: AuthenticationEvent = {
        return AuthenticationEvent(
            cookieStorage: storage.cookieStorage,
            userStorage: storage.userStorage
        )
    }()
    
    private(set) lazy var networkService: NetworkService = {
        return NetworkServiceImpl(
            config: appConfiguration.networkConfig,
            cookieStorage: storage.cookieStorage,
            authEventHandler: authEventRouter
        )
    }()
    
    private(set) lazy var authService: AuthenticationService = {
        return AuthenticationServiceImpl(cookieStorage: storage.cookieStorage)
    }()
    
    private(set) lazy var userService: UserService = {
        return UserServiceImpl(userStorage: storage.userStorage)
    }()
}

final class Repository {
    private let service: Service
    private let storage: Storage
    
    init(service: Service, storage: Storage) {
        self.service = service
        self.storage = storage
    }
    
    private(set) lazy var authRepository: AuthRepository = {
        return AuthRepositoryImpl(
            network: service.networkService,
            cookieStorage: storage.cookieStorage,
            userStorage: storage.userStorage
        )
    }()
    
    private(set) lazy var userDomainRepository: UserDomainRepository = {
        return UserDomainRepositoryImpl(network: service.networkService)
    }()
    
    private(set) lazy var tokenRepository: TokenRepository = {
        return TokenRepositoryImpl(network: service.networkService)
    }()
    
    private(set) lazy var suppressionRepository: SuppressionRepository = {
        return SuppressionRepositoryImpl(network: service.networkService)
    }()
}
