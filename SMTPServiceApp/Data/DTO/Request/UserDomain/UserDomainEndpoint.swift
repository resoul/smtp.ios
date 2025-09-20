import Foundation

enum UserDomainEndpoint {
    case listing(UserDomainListingRequest)
    case delete(UserDomainDeletingRequest)
}

extension UserDomainEndpoint: Endpoint {
    var path: String {
        switch self {
        case .listing: return "/api/user_domain/listing"
        case .delete: return "/api/user_domain/delete"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listing: return .GET
        case .delete: return .DELETE
        }
    }

    var body: Data? {
        switch self {
        case .delete(let request):
            return try? JSONEncoder().encode(request)
        case .listing: return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .delete: return nil
        case .listing(let request):
            return [
                URLQueryItem(name: "page", value: String(request.page)),
                URLQueryItem(name: "perPage", value: String(request.perPage)),
                URLQueryItem(name: "orderBy", value: request.orderBy),
                URLQueryItem(name: "orderDirection", value: request.orderDirection)
            ].compactMap { $0 }
        }
    }
}
