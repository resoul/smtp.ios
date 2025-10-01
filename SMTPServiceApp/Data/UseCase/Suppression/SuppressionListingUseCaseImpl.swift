final class SuppressionListingUseCaseImpl: SuppressionListingUseCase {
    private let suppressionRepository: SuppressionRepository

    init(suppressionRepository: SuppressionRepository) {
        self.suppressionRepository = suppressionRepository
    }

    func execute(page: Int, perPage: Int) async throws -> ListingResponse<Suppression> {
        return try await suppressionRepository.lising(page: page, perPage: perPage)
    }
}
