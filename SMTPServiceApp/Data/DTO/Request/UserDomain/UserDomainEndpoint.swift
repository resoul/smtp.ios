import Foundation

enum UserDomainEndpoint {
    case listing(UserDomainListingRequest)
}

extension UserDomainEndpoint: Endpoint {
    var path: String {
        switch self {
        case .listing: return "/api/user_domain/listing"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listing: return .GET
        }
    }

    var body: Data? {
        switch self {
        case .listing: return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
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
