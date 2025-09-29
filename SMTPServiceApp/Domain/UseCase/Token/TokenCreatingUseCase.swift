protocol TokenCreatingUseCase {
    func execute(tokenName: String) async throws
}
