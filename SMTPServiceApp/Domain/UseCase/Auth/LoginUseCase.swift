protocol LoginUseCase {
    func execute(email: String, password: String) async throws -> User
}
