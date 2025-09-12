protocol ResendActivationEmailUseCase {
    func execute(email: String) async throws
}
