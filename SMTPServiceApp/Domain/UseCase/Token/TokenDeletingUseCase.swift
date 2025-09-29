protocol TokenDeletingUseCase {
    func execute(token: String) async throws
}
