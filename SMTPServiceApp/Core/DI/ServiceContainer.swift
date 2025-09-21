protocol ServiceContainer {
    var networkService: NetworkService { get }
    var authService: AuthenticationService { get }
    var userService: UserService { get }
}

final class Service {
    private let appConfiguration: AppConfiguration
    private let storage: Storage
    
    init(appConfiguration: AppConfiguration, storage: Storage) {
        self.appConfiguration = appConfiguration
        self.storage = storage
    }
    
    // Router that handles auth-related events coming from the network layer
    private lazy var authEventRouter: AuthEventRouter = {
        return AuthEventRouter(
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
