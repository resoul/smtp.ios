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
