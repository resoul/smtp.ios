protocol ServiceContainer {
    var networkService: NetworkService { get }
    var authService: AuthenticationService { get }
}

final class Service {
    private let appConfiguration: AppConfiguration
    private let storage: Storage
    
    init(appConfiguration: AppConfiguration, storage: Storage) {
        self.appConfiguration = appConfiguration
        self.storage = storage
    }
    
    private(set) lazy var networkService: NetworkService = {
        return NetworkServiceImpl(
            config: appConfiguration.networkConfig,
            cookieStorage: storage.cookieStorage)
    }()
    
    private(set) lazy var authService: AuthenticationService = {
        return AuthenticationServiceImpl(cookieStorage: storage.cookieStorage)
    }()
}
