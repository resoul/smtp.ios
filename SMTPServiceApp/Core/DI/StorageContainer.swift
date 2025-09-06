protocol StorageContainer {
    var cookieStorage: CookieStorage { get }
}

final class Storage {
    let source: DataSource
    
    init(source: DataSource) {
        self.source = source
    }
    
    private(set) lazy var cookieStorage: CookieStorage = {
        return CookieStorage(dataSource: source)
    }()
}
