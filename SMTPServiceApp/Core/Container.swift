import UIKit
import PreviewIntro

protocol RepositoryContainer {
    var authRepository: AuthRepository { get }
    var userDomainRepository: UserDomainRepository { get }
}

protocol StorageContainer {
    var cookieStorage: CookieStorage { get }
    var userStorage: UserStorage { get }
    var appStorage: AppStorage { get }
}

//MARK: -- Main Container
final class Container {
    private let appConfiguration: AppConfiguration
    private let themeManager: ThemeManager
    private let service: Service
    private let storage: Storage
    private let repository: Repository
    
    init(appConfiguration: AppConfiguration, source: DataSource, themeManager: ThemeManager) {
        self.appConfiguration = appConfiguration
        self.themeManager = themeManager
        self.storage = Storage(source: source)
        self.service = Service(appConfiguration: appConfiguration, storage: storage)
        self.repository = Repository(service: service, storage: storage)
    }
}

final class Storage {
    private let source: DataSource
    
    init(source: DataSource) {
        self.source = source
    }
    
    private(set) lazy var cookieStorage: CookieStorage = {
        return CookieStorage(dataSource: source)
    }()
    
    private(set) lazy var userStorage: UserStorage = {
        return UserStorage(dataSource: source)
    }()
    
    private(set) lazy var appStorage: AppStorage = {
        return AppStorage(dataSource: source)
    }()
}

final class Service {
    private let appConfiguration: AppConfiguration
    private let storage: Storage
    
    init(appConfiguration: AppConfiguration, storage: Storage) {
        self.appConfiguration = appConfiguration
        self.storage = storage
    }
    
    // Router that handles auth-related events coming from the network layer
    private lazy var authEventRouter: AuthEventRouter = {
        return AuthEventRouter(
            cookieStorage: storage.cookieStorage,
            userStorage: storage.userStorage
        )
    }()
    
    private(set) lazy var networkService: NetworkService = {
        return NetworkServiceImpl(
            config: appConfiguration.networkConfig,
            cookieStorage: storage.cookieStorage,
            authEventHandler: authEventRouter
        )
    }()
    
    private(set) lazy var authService: AuthenticationService = {
        return AuthenticationServiceImpl(cookieStorage: storage.cookieStorage)
    }()
    
    private(set) lazy var userService: UserService = {
        return UserServiceImpl(userStorage: storage.userStorage)
    }()
}

final class Repository {
    private let service: Service
    private let storage: Storage
    
    init(service: Service, storage: Storage) {
        self.service = service
        self.storage = storage
    }
    
    private(set) lazy var authRepository: AuthRepository = {
        return AuthRepositoryImpl(
            network: service.networkService,
            cookieStorage: storage.cookieStorage,
            userStorage: storage.userStorage
        )
    }()
    
    private(set) lazy var userDomainRepository: UserDomainRepository = {
        return UserDomainRepositoryImpl(network: service.networkService)
    }()
}

//MARK: -- Container App Configuration
extension Container {
    var showPreviewIntro: Bool {
        appConfiguration.previewIntoEnabled
    }
}

//MARK: -- Container Repository
extension Container: RepositoryContainer {
    var authRepository: AuthRepository {
        repository.authRepository
    }
    
    var userDomainRepository: UserDomainRepository {
        repository.userDomainRepository
    }
}

//MARK: -- Container Storage
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

//MARK: -- Container Service
extension Container {
    var authService: AuthenticationService {
        service.authService
    }
    
    var networkService: NetworkService {
        service.networkService
    }
    
    var userService: UserService {
        service.userService
    }
}

//MARK: -- Container ViewModel
extension Container {
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
        LoginViewModelImpl(
            loginUseCase: LoginUseCaseImpl(authRepository: repository.authRepository),
            userStorage: storage.userStorage
        )
    }
    
    func makeRequestResetPasswordViewModel() -> RequestResetPasswordViewModel {
        RequestResetPasswordViewModel(
            resetPasswordUseCase: ResetPasswordUseCaseImpl(authRepository: repository.authRepository)
        )
    }
    
    func makeActivateAccountViewModel() -> ActivateAccountViewModel {
        ActivateAccountViewModel(
            resendActivationEmailUseCase: ResendActivationEmailUseCaseImpl(authRepository: repository.authRepository)
        )
    }
    
    func makeForgotPasswordViewModel() -> ForgotPasswordViewModel {
        ForgotPasswordViewModel(
            forgotPasswordUseCase: ForgotPasswordUseCaseImpl(authRepository: repository.authRepository)
        )
    }
    
    func makeRegistrationViewModel() -> RegistrationViewModel {
        RegistrationViewModelImpl(
            registrationUseCase: RegistrationUseCaseImpl(authRepository: repository.authRepository)
        )
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(userService: userService)
    }
    
    func makeUserDomainViewModel() -> UserDomainViewModel {
        UserDomainViewModel(
            userService: userService,
            listingUseCase: UserDomainListingUseCaseImpl(userDomainRepository: repository.userDomainRepository),
            deletingUseCase: UserDomainDeletingUseCaseImpl(userDomainRepository: repository.userDomainRepository)
        )
    }
}

//MARK: -- Container Coordinator
extension Container {
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
    
    func makeSettingsCoordinator() -> SettingsCoordinator {
        SettingsCoordinator(container: self)
    }
    
    func makeUserDomainCoordinator() -> UserDomainCoordinator {
        UserDomainCoordinator(container: self)
    }
}
