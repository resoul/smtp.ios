import Foundation

enum AuthEndpoint {
    case login(LoginRequest)
    case logout
    case registration(RegistrationRequest)
    case forgotPassword(ForgotPasswordRequest)
    case resetPassword(ResetPasswordRequest)
    case resendActivationEmail(ResendActivationEmailRequest)
}

extension AuthEndpoint: Endpoint {
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
