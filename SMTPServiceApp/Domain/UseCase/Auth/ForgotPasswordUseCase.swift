protocol ForgotPasswordUseCase {
    func execute(email: String) async throws
}
