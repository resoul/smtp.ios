/// Repository protocol for authentication operations
///
/// This protocol defines all authentication-related data operations including
/// login, registration, password management, and account activation.
/// All methods are async and may throw network or validation errors.
protocol AuthRepository {
    /// Resets user password using a reset token
    /// - Parameters:
    ///   - resetToken: The password reset token from email
    ///   - password: New password
    ///   - passwordConfirmation: Password confirmation (must match password)
    /// - Throws: `NetworkError` if request fails or validation errors
    func resetPassword(resetToken: String, password: String, passwordConfirmation: String) async throws
    
    /// Resends account activation email
    /// - Parameter email: User's email address
    /// - Throws: `NetworkError` if request fails
    func resendActivationEmail(email: String) async throws
    
    /// Initiates password reset flow by sending reset email
    /// - Parameter email: User's email address
    /// - Throws: `NetworkError` if request fails
    func forgotPassword(email: String) async throws
    
    /// Registers a new user account
    /// - Parameters:
    ///   - firstName: User's first name
    ///   - lastName: User's last name
    ///   - email: User's email address
    ///   - password: Desired password
    ///   - passwordConfirmation: Password confirmation (must match password)
    /// - Returns: The newly created `User` object
    /// - Throws: `NetworkError.validationError` for invalid input or `NetworkError` for other failures
    func register(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) async throws -> User
    
    /// Authenticates a user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authenticated `User` object
    /// - Throws: `NetworkError.authenticationError` for invalid credentials
    func login(email: String, password: String) async throws -> User
    
    /// Logs out the current user and clears session
    /// - Throws: `NetworkError` if logout request fails
    func logout() async throws
}
