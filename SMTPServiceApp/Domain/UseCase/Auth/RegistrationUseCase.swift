protocol RegistrationUseCase {
    func execute(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) async throws -> User
}
