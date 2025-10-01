import Foundation

final class SuppressionRepositoryImpl: SuppressionRepository {
    private let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }

    func lising(page: Int, perPage: Int) async throws -> ListingResponse<Suppression> {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        
        let calendar = Calendar.current
        let now = Date()
        
        let startDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -7, to: now)!)
        let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now)!
        
        let dateFrom = formatter.string(from: startDate)
        let dateTo = formatter.string(from: endDate)
        
        let request = SuppressionListingRequest(page: page, perPage: perPage, dateFrom: dateFrom, dateTo: dateTo)
        let response = try await network.request(
            endpoint: SuppressionEndpoint.listing(request),
            responseType: ListingResponseDTO<SuppressionDTO>.self
        )
        
        return response.map { $0.toDomain() }
    }
}
