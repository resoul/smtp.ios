import Foundation

struct Response<T: Codable>: Codable {
    let status: ResponseStatus
    let data: T?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(ResponseStatus.self, forKey: .status)
        
        if let value = try? container.decode(T.self, forKey: .data) {
            data = value
        } else {
            data = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case status
        case data
    }
}

struct ResponseStatus: Codable {
    let code: String
    let details: [ValidationError]?
    let request: RequestInfo
}

struct ValidationError: Codable {
    let entity: String
    let error: String
}

struct RequestInfo: Codable {
    let id: String
    let timestamp: String
}

struct ListingResponse<T> {
    let items: [T]
    let pagination: PaginationResponse
}

struct PaginationResponse {
    let page: Int
    let perPage: Int
    let itemsOnCurrentPage: Int
    let totalItems: Int
}

extension ListingResponseDTO {
    func map<U>(_ transform: (T) -> U) -> ListingResponse<U> {
        return ListingResponse<U>(
            items: self.items.map(transform),
            pagination: self.pagination.toDomain()
        )
    }
}
