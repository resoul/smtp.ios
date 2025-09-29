protocol TokenUpdatingUseCase {
    func execute(token: String, tokenName: String, state: String) async throws
}
