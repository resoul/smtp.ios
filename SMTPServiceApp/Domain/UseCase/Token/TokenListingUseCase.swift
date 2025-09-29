protocol TokenListingUseCase {
    func execute(page: Int, perPage: Int) async throws -> ListingResponse<Token>
}
