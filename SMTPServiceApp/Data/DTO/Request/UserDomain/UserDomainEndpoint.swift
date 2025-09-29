import Foundation

enum UserDomainEndpoint {
    case listing(UserDomainListingRequest)
    case delete(UserDomainDeletingRequest)
    case create(UserDomainCreatingRequest)
    case verify(UserDomainVerificationRequest)
}

extension UserDomainEndpoint: Endpoint {
    var path: String {
        switch self {
        case .listing: return "/api/user_domain/listing"
        case .delete: return "/api/user_domain/delete"
        case .create: return "/api/user_domain/create"
        case .verify: return "/api/user_domain/verify"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listing: return .GET
        case .delete: return .DELETE
        case .create: return .POST
        case .verify: return .PUT
        }
    }

    var body: Data? {
        switch self {
        case .delete(let request):
            return try? JSONEncoder().encode(request)
        case .create(let request):
            return try? JSONEncoder().encode(request)
        case .verify(let request):
            return try? JSONEncoder().encode(request)
        case .listing: return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .delete, .create, .verify: return nil
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
