protocol ServiceContainer {
    var authService: AuthenticationService { get }
}

final class Service {
    private(set) lazy var authService: AuthenticationService = {
        return AuthenticationServiceImpl()
    }()
}
