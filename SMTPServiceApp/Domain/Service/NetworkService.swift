import Foundation

protocol NetworkService {
    func request<T: Codable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T
    
    func requestWithoutResponse(endpoint: Endpoint) async throws
}
