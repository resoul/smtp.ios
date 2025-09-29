import Foundation

enum TokenEndpoint {
    case listing(TokenListingRequest)
    case delete(TokenDeletingRequest)
    case create(TokenCreationRequest)
    case update(TokenUpdatingRequest)
}

extension TokenEndpoint: Endpoint {
    var path: String {
        switch self {
        case .listing: return "/api/token/listing"
        case .delete: return "/api/token/delete"
        case .create: return "/api/token/create"
        case .update: return "/api/token/update"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listing: return .GET
        case .delete: return .DELETE
        case .create: return .POST
        case .update: return .PUT
        }
    }

    var body: Data? {
        switch self {
        case .delete(let request):
            return try? JSONEncoder().encode(request)
        case .create(let request):
            return try? JSONEncoder().encode(request)
        case .update(let request):
            return try? JSONEncoder().encode(request)
        case .listing: return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .delete, .create, .update: return nil
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
