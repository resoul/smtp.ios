import UIKit
import PreviewIntro

final class Container {
    private let appConfiguration: AppConfiguration
    private let themeManager: ThemeManager
    private let service: Service
    private let storage: Storage
    private let useCase: UseCase
    private let repository: Repository
    
    init(appConfiguration: AppConfiguration, source: DataSource, themeManager: ThemeManager) {
        self.appConfiguration = appConfiguration
        self.themeManager = themeManager
        self.storage = Storage(source: source)
        self.service = Service(appConfiguration: appConfiguration, storage: storage)
        self.repository = Repository(service: service, storage: storage)
        self.useCase = UseCase(repository: repository)
    }
}

extension Container: UseCaseContainer {
    var resetPasswordUseCase: ResetPasswordUseCase {
        useCase.resetPasswordUseCase
    }
    
    var resendActivationEmailUseCase: ResendActivationEmailUseCase {
        useCase.resendActivationEmailUseCase
    }
    
    var forgotPasswordUseCase: ForgotPasswordUseCase {
        useCase.forgotPasswordUseCase
    }
    
    var registrationUseCase: RegistrationUseCase {
        useCase.registrationUseCase
    }
    
    var loginUseCase: LoginUseCase {
        useCase.loginUseCase
    }
    
    var logoutUseCase: LogoutUseCase {
        useCase.logoutUseCase
    }
}

extension Container: RepositoryContainer {
    var authRepository: AuthRepository {
        repository.authRepository
    }
}

extension Container: StorageContainer {
    var cookieStorage: CookieStorage {
        storage.cookieStorage
    }
    
    var userStorage: UserStorage {
        storage.userStorage
    }
    
    var appStorage: AppStorage {
        storage.appStorage
    }
}

extension Container: ServiceContainer {
    var authService: AuthenticationService {
        service.authService
    }
    
    var networkService: NetworkService {
        service.networkService
    }
}

extension Container: ViewModelContainer {
    func makePreviewIntroViewModel() -> PreviewIntroViewModel {
        //MARK: TODO - make data source for preview intro
        let theme = themeManager.currentTheme.previewIntroPresentationData
        let items = [
            PreviewIntro(
                headline: "Send Messages Based On Website & Email Events",
                description: "Unlock the key to super-responsive real-time personalization. Set up customer tracking & custom events today.",
                image: UIImage(named: "splash"),
                backgroundColor: theme.backgroundColor,
                headlineColor: theme.textColor,
                descriptionColor: theme.textColor
            ),
            PreviewIntro(
                headline: "Build Highly-Customizable email Journeys!",
                description: "Take our drag-and-drop email automation builder, design the ideal customer journey and let our platform convert leads for You On Autopilot.",
                image: UIImage(named: "splash-1"),
                backgroundColor: theme.backgroundColor,
                headlineColor: theme.textColor,
                descriptionColor: theme.textColor
            )
        ]
        
        return PreviewIntroViewModelImpl(items: items)
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModelImpl(loginUseCase: useCase.loginUseCase)
    }
    
    func makeRequestResetPasswordViewModel() -> RequestResetPasswordViewModel {
        RequestResetPasswordViewModel(resetPasswordUseCase: useCase.resetPasswordUseCase)
    }
    
    func makeActivateAccountViewModel() -> ActivateAccountViewModel {
        ActivateAccountViewModel(resendActivationEmailUseCase: useCase.resendActivationEmailUseCase)
    }
    
    func makeForgotPasswordViewModel() -> ForgotPasswordViewModel {
        ForgotPasswordViewModel(forgotPasswordUseCase: useCase.forgotPasswordUseCase)
    }
    
    func makeRegistrationViewModel() -> RegistrationViewModel {
        RegistrationViewModelImpl(registrationUseCase: useCase.registrationUseCase)
    }
}

extension Container: CoordinatorContainer {
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
        let navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return AppCoordinator(
            navigationController: navigationController,
            container: self
        )
    }
    
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        AuthCoordinator(navigationController: navigationController, container: self)
    }
    
    func makePreviewIntroCoordinator(navigationController: UINavigationController) -> PreviewIntroCoordinator {
        PreviewIntroCoordinator(navigationController: navigationController, container: self)
    }
    
    func makeMainTabBarCoordinator(navigationController: UINavigationController) -> MainTabBarCoordinator {
        MainTabBarCoordinator(navigationController: navigationController, container: self)
    }
    
    func makeDashboardCoordinator() -> DashboardCoordinator {
        DashboardCoordinator(container: self)
    }
}
