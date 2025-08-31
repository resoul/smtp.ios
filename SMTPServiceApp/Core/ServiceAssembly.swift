final class ServiceAssembly {
    private(set) lazy var authService: AuthService = {
        return AuthServiceImpl()
    }()
}
