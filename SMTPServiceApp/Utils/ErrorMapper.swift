import Foundation

/// Centralized error mapping utility that converts technical errors into user-friendly messages
///
/// This utility provides consistent error handling across the application by mapping
/// various error types (network, validation, authentication) to localized, user-friendly messages.
///
/// Usage:
/// ```swift
/// do {
///     try await someOperation()
/// } catch {
///     let message = ErrorMapper.mapToUserFriendlyMessage(error)
///     showAlert(message)
/// }
/// ```
final class ErrorMapper {
    
    // MARK: - Public Interface
    
    /// Maps any error to a user-friendly message
    /// - Parameter error: The error to map
    /// - Returns: A localized, user-friendly error message
    static func mapToUserFriendlyMessage(_ error: Error) -> String {
        switch error {
        case let networkError as NetworkError:
            return mapNetworkError(networkError)
        case let validationError as AuthValidationError:
            return validationError.localizedDescription
        default:
            return NSLocalizedString(
                "error.unknown",
                value: "An unexpected error occurred. Please try again.",
                comment: "Generic error message"
            )
        }
    }
    
    /// Checks if an error is recoverable (user can retry)
    /// - Parameter error: The error to check
    /// - Returns: True if the error is recoverable
    static func isRecoverable(_ error: Error) -> Bool {
        switch error {
        case let networkError as NetworkError:
            switch networkError {
            case .tooManyRequests, .serverError, .noData:
                return true
            case .authenticationError, .accountNotActivated:
                return false
            default:
                return true
            }
        default:
            return true
        }
    }
    
    /// Suggests an action for the error
    /// - Parameter error: The error to analyze
    /// - Returns: Suggested action text, if any
    static func suggestedAction(_ error: Error) -> String? {
        switch error {
        case let networkError as NetworkError:
            switch networkError {
            case .tooManyRequests:
                return NSLocalizedString(
                    "error.action.wait",
                    value: "Please wait a few minutes before trying again.",
                    comment: "Rate limit action"
                )
            case .accountNotActivated:
                return NSLocalizedString(
                    "error.action.activate",
                    value: "Please check your email and activate your account.",
                    comment: "Account activation action"
                )
            case .authenticationError:
                return NSLocalizedString(
                    "error.action.login",
                    value: "Please log in again.",
                    comment: "Re-authentication action"
                )
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    // MARK: - Private Helpers
    
    private static func mapNetworkError(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return NSLocalizedString(
                "error.network.invalid_url",
                value: "Service configuration error. Please contact support.",
                comment: "Invalid URL error"
            )
        case .noData:
            return NSLocalizedString(
                "error.network.no_data",
                value: "No response from server. Please check your connection and try again.",
                comment: "No data received error"
            )
        case .tooManyRequests:
            return NSLocalizedString(
                "error.network.rate_limit",
                value: "Too many requests. Please try again later.",
                comment: "Rate limit error"
            )
        case .decodingError:
            return NSLocalizedString(
                "error.network.decoding",
                value: "Server response format error. Please update the app or try again.",
                comment: "JSON decoding error"
            )
        case .validationError(let errors):
            return formatValidationErrors(errors)
        case .authenticationError:
            return NSLocalizedString(
                "error.auth.invalid_credentials",
                value: "Invalid email or password. Please check your credentials.",
                comment: "Authentication failed error"
            )
        case .accountNotActivated:
            return NSLocalizedString(
                "error.auth.not_activated",
                value: "Account not activated. Please check your email for activation link.",
                comment: "Account not activated error"
            )
        case .notFound:
            return NSLocalizedString(
                "error.network.not_found",
                value: "The requested resource was not found.",
                comment: "404 error"
            )
        case .serverError(let code):
            if let codeString = code as? String {
                return String(
                    format: NSLocalizedString(
                        "error.server.with_code",
                        value: "Server error (%@). Please try again later.",
                        comment: "Server error with code"
                    ),
                    codeString
                )
            } else if let codeInt = code as? Int {
                return String(
                    format: NSLocalizedString(
                        "error.server.with_code",
                        value: "Server error (%d). Please try again later.",
                        comment: "Server error with code"
                    ),
                    codeInt
                )
            } else {
                return NSLocalizedString(
                    "error.server.generic",
                    value: "Server error. Please try again later.",
                    comment: "Generic server error"
                )
            }
        case .unknown:
            return NSLocalizedString(
                "error.unknown",
                value: "An unexpected error occurred. Please try again.",
                comment: "Unknown error"
            )
        }
    }
    
    private static func formatValidationErrors(_ errors: [ValidationError]) -> String {
        if errors.isEmpty {
            return NSLocalizedString(
                "error.validation.generic",
                value: "Please check your input and try again.",
                comment: "Generic validation error"
            )
        }
        
        // Format: "Field: Error message"
        let formattedErrors = errors.map { error in
            let fieldName = formatFieldName(error.entity)
            return "\(fieldName): \(error.error)"
        }
        
        return formattedErrors.joined(separator: "\n")
    }
    
    private static func formatFieldName(_ entity: String) -> String {
        // Convert snake_case or camelCase to readable format
        let words = entity.components(separatedBy: CharacterSet(charactersIn: "_"))
        return words.map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined(separator: " ")
    }
}

// MARK: - Error Context

/// Additional context for error reporting and analytics
struct ErrorContext {
    let error: Error
    let timestamp: Date
    let userFriendlyMessage: String
    let isRecoverable: Bool
    let suggestedAction: String?
    let source: String
    
    init(error: Error, source: String) {
        self.error = error
        self.timestamp = Date()
        self.userFriendlyMessage = ErrorMapper.mapToUserFriendlyMessage(error)
        self.isRecoverable = ErrorMapper.isRecoverable(error)
        self.suggestedAction = ErrorMapper.suggestedAction(error)
        self.source = source
    }
    
    /// Returns a dictionary suitable for analytics logging
    var analyticsPayload: [String: Any] {
        var payload: [String: Any] = [
            "error_type": String(describing: type(of: error)),
            "timestamp": timestamp.timeIntervalSince1970,
            "source": source,
            "is_recoverable": isRecoverable
        ]
        
        if let action = suggestedAction {
            payload["suggested_action"] = action
        }
        
        return payload
    }
}
