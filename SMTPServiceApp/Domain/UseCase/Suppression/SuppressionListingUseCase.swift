protocol SuppressionListingUseCase {
    func execute(page: Int, perPage: Int) async throws -> ListingResponse<Suppression>
}
