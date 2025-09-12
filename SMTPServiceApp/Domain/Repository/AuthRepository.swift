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
