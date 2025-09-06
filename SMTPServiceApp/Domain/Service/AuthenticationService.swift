protocol AuthenticationService {
    var isAuthenticated: Bool { get }
}

final class AuthenticationServiceImpl: AuthenticationService {
    private let storage: CookieStorage
    
    init(cookieStorage: CookieStorage) {
        self.storage = cookieStorage
    }
    
    var isAuthenticated: Bool {
        return storage.exists()
    }
    
    func login(cookie: String) {
        storage.save(cookie)
    }
    
    func logout() {
        storage.remove()
    }
    
    func getAuthCookie() -> String? {
        return storage.get()
    }
}
