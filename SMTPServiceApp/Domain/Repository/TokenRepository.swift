protocol TokenRepository {
    func lising(page: Int, perPage: Int) async throws -> ListingResponse<Token>
    func delete(token: String) async throws
    func create(tokenName: String) async throws
    func update(token: String, tokenName: String, state: String) async throws
}
