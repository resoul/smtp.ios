import Foundation

// MARK: - Error Types
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case validationError([ValidationError])
    case authenticationError
    case accountNotActivated
    case notFound
    case tooManyRequests
    case serverError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .validationError(let errors):
            return errors.map { "\($0.entity): \($0.error)" }.joined(separator: "\n")
        case .authenticationError:
            return "Authentication failed"
        case .accountNotActivated:
            return "Account is not activated"
        case .tooManyRequests:
            return "Too Many Requests"
        case .notFound:
            return "Resource not found"
        case .serverError(let message):
            return "Server error: \(message)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

// MARK: - API Status Codes
struct StatusCodes {
    static let ok = "ok"
    static let validationNotValid = "ems.validation.not_valid"
    static let accountNotActivated = "ems.auth.account_not_activated"
    static let notFound = "ems.common.not_found"
}

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

struct AuthResponse: Codable {
    let user: UserDTO
}
