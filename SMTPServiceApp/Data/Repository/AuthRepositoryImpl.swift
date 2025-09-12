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

        try await network.requestWithoutResponse(endpoint: AuthEndpoint.forgotPassword(request))
    }
    
    func resendActivationEmail(email: String) async throws {
        let request = ResendActivationEmailRequest(email: email)
        try await network.requestWithoutResponse(
            endpoint: AuthEndpoint.resendActivationEmail(request)
        )
    }
    
    func login(email: String, password: String) async throws -> User {
        let response: AuthResponse = try await network.request(
            endpoint: AuthEndpoint.login(LoginRequest(login: email, password: password)),
            responseType: AuthResponse.self
        )
        
        let user = response.user
        userStorage.saveUser(user)
        
        return user.toDomain()
    }
    
    func logout() async throws {
        try await network.requestWithoutResponse(endpoint: AuthEndpoint.logout)
        
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
        
        try await network.requestWithoutResponse(endpoint: AuthEndpoint.resetPassword(request))
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
        let response: AuthResponse = try await network.request(
            endpoint: AuthEndpoint.registration(request),
            responseType: AuthResponse.self
        )
        
        let user = response.user
        userStorage.saveUser(user)

        return user.toDomain()
    }
}
