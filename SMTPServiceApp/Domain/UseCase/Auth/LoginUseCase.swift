/// Use case for user login authentication
///
/// This use case encapsulates the business logic for authenticating a user.
/// It validates input, calls the repository, and handles any business rules
/// specific to the login process.
///
/// Usage:
/// ```swift
/// let loginUseCase = LoginUseCaseImpl(authRepository: repository)
/// let user = try await loginUseCase.execute(email: "user@example.com", password: "password")
/// ```
protocol LoginUseCase {
    /// Executes the login operation
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authenticated `User` object
    /// - Throws: `NetworkError` for authentication failures or network issues
    func execute(email: String, password: String) async throws -> User
}
