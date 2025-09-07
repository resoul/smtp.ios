protocol StorageContainer {
    var cookieStorage: CookieStorage { get }
    var userStorage: UserStorage { get }
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
}
