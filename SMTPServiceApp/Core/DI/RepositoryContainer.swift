protocol RepositoryContainer {
    var authRepository: AuthRepository { get }
    var userDomainRepository: UserDomainRepository { get }
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
}
