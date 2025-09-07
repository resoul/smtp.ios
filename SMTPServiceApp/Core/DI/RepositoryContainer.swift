protocol RepositoryContainer {
    var authRepository: AuthRepository { get }
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
}
