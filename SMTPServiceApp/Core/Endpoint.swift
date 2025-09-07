import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

struct LoginRequest: Codable {
    let login: String
    let password: String
}

struct RegistrationRequest: Codable {
    let firstname: String
    let lastname: String
    let email: String
    let password: String
    let passwordConfirmation: String
}

struct ForgotPasswordRequest: Codable {
    let email: String
}

struct ResendActivationEmailRequest: Codable {
    let email: String
}

struct ResetPasswordRequest: Codable {
    let resetToken: String
    let password: String
    let passwordConfirmation: String
}

enum Endpoint {
    case login(LoginRequest)
    case logout
    case registration(RegistrationRequest)
    case forgotPassword(ForgotPasswordRequest)
    case resetPassword(ResetPasswordRequest)
    case resendActivationEmail(ResendActivationEmailRequest)
    
    var path: String {
        switch self {
        case .login:
            return "/api/auth/login"
        case .logout:
            return "/api/auth/logout"
        case .registration:
            return "/api/user/registration"
        case .forgotPassword:
            return "/api/auth/forgot_password"
        case .resetPassword:
            return "/api/auth/reset_password"
        case .resendActivationEmail:
            return "/api/user/registration/resend_activation_email"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .registration, .forgotPassword, .resetPassword:
            return .POST
        case .resendActivationEmail:
            return .PUT
        case .logout:
            return .DELETE
        }
    }
    
    var body: Data? {
        switch self {
        case .login(let request):
            return try? JSONEncoder().encode(request)
        case .registration(let request):
            return try? JSONEncoder().encode(request)
        case .forgotPassword(let request):
            return try? JSONEncoder().encode(request)
        case .resetPassword(let request):
            return try? JSONEncoder().encode(request)
        case .resendActivationEmail(let request):
            return try? JSONEncoder().encode(request)
        case .logout:
            return nil
        }
    }
}
