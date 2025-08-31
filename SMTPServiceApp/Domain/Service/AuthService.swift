protocol AuthService {
    var isAuthenticated: Bool { get }
}

class AuthServiceImpl: AuthService {
    var isAuthenticated: Bool {
        return false
    }
}
