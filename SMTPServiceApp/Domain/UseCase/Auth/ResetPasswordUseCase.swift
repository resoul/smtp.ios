protocol ResetPasswordUseCase {
    func execute(resetToken: String, password: String, passwordConfirmation: String) async throws
}
