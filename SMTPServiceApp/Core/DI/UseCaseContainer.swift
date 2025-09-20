protocol UseCaseContainer {
    var resetPasswordUseCase: ResetPasswordUseCase { get }
    var resendActivationEmailUseCase: ResendActivationEmailUseCase { get }
    var forgotPasswordUseCase: ForgotPasswordUseCase { get }
    var registrationUseCase: RegistrationUseCase { get }
    var loginUseCase: LoginUseCase { get }
    var logoutUseCase: LogoutUseCase { get }
}

final class UseCase {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    private(set) lazy var resendActivationEmailUseCase: ResendActivationEmailUseCase = {
        return ResendActivationEmailUseCaseImpl(authRepository: repository.authRepository)
    }()
    
    private(set) lazy var resetPasswordUseCase: ResetPasswordUseCase = {
        return ResetPasswordUseCaseImpl(authRepository: repository.authRepository)
    }()
    
    private(set) lazy var forgotPasswordUseCase: ForgotPasswordUseCase = {
        return ForgotPasswordUseCaseImpl(authRepository: repository.authRepository)
    }()
    
    private(set) lazy var registrationUseCase: RegistrationUseCase = {
        return RegistrationUseCaseImpl(authRepository: repository.authRepository)
    }()
    
    private(set) lazy var loginUseCase: LoginUseCase = {
        return LoginUseCaseImpl(authRepository: repository.authRepository)
    }()
    
    private(set) lazy var logoutUseCase: LogoutUseCase = {
        return LogoutUseCaseImpl(authRepository: repository.authRepository)
    }()
    
    private(set) lazy var userDomainListingUseCase: UserDomainListingUseCase = {
        return UserDomainListingUseCaseImpl(userDomainRepository: repository.userDomainRepository)
    }()
}
