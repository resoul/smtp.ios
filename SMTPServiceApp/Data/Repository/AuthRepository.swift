protocol AuthRepository {
    func resetPassword(resetToken: String, password: String, passwordConfirmation: String) async throws
    func resendActivationEmail(email: String) async throws
    func forgotPassword(email: String) async throws
    func register(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) async throws -> User
    func login(email: String, password: String) async throws -> User
    func logout() async throws
}

final class AuthRepositoryImpl: AuthRepository {
    private let network: NetworkService
    private let userStorage: UserStorage
    private let cookieStorage: CookieStorage
    
    init(network: NetworkService, cookieStorage: CookieStorage, userStorage: UserStorage) {
        self.network = network
        self.userStorage = userStorage
        self.cookieStorage = cookieStorage
    }
    
    func forgotPassword(email: String) async throws {
        let request = ForgotPasswordRequest(email: email)
        let endpoint = Endpoint.forgotPassword(request)
        
        try await network.requestWithoutResponse(endpoint: endpoint)
    }
    
    func resendActivationEmail(email: String) async throws {
        let request = ResendActivationEmailRequest(email: email)
        try await network.requestWithoutResponse(endpoint: Endpoint.resendActivationEmail(request))
    }
    
    func login(email: String, password: String) async throws -> User {
        let response: AuthResponse = try await network.request(
            endpoint: Endpoint.login(LoginRequest(login: email, password: password)),
            responseType: AuthResponse.self
        )
        
        let user = response.user
        userStorage.saveUser(user)
        
        return user.toDomain()
    }
    
    func logout() async throws {
        try await network.requestWithoutResponse(endpoint: Endpoint.logout)
        
        cookieStorage.remove()
        userStorage.removeUser()
    }

    func resetPassword(
        resetToken: String,
        password: String,
        passwordConfirmation: String
    ) async throws {
        let request = ResetPasswordRequest(
            resetToken: resetToken,
            password: password,
            passwordConfirmation: passwordConfirmation
        )
        
        try await network.requestWithoutResponse(endpoint: Endpoint.resetPassword(request))
    }
    
    func register(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) async throws -> User {
        let request = RegistrationRequest(
            firstname: firstName,
            lastname: lastName,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation
        )
        let endpoint = Endpoint.registration(request)
        
        let response: AuthResponse = try await network.request(
            endpoint: endpoint,
            responseType: AuthResponse.self
        )
        
        let user = response.user
        userStorage.saveUser(user)

        return user.toDomain()
    }
}
