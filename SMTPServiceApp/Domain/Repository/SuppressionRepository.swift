protocol SuppressionRepository {
    func lising(page: Int, perPage: Int) async throws -> ListingResponse<Suppression>
}
