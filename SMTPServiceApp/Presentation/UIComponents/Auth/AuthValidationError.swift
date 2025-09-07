import Foundation

enum AuthValidationError: Error, LocalizedError {
    case emptyFirstName
    case emptyLastName
    case emptyEmail
    case invalidEmail
    case emptyPassword
    case passwordTooShort
    case passwordMismatch
    case emptyResetToken
    
    var errorDescription: String? {
        switch self {
        case .emptyFirstName:
            return "First name is required"
        case .emptyLastName:
            return "Last name is required"
        case .emptyEmail:
            return "Email is required"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .emptyPassword:
            return "Password is required"
        case .passwordTooShort:
            return "Password must be at least 10 characters long"
        case .passwordMismatch:
            return "Passwords do not match"
        case .emptyResetToken:
            return "Reset token is required"
        }
    }
}
