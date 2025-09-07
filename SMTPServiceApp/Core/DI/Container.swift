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
        self.repository = Repository()
        self.useCase = UseCase()
    }
}

extension Container: UseCaseContainer {}

extension Container: RepositoryContainer {}

extension Container: StorageContainer {
    var cookieStorage: CookieStorage {
        storage.cookieStorage
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
        LoginViewModelImpl()
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
}
