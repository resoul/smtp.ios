import UIKit
import PreviewIntro

final class Container {
    private let appConfiguration: AppConfiguration
    private let service: Service
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
        self.service = Service()
    }
}

extension Container: ServiceContainer {
    var authService: AuthenticationService {
        service.authService
    }
}

extension Container: ViewModelContainer {
    func makePreviewIntroViewModel() -> PreviewIntroViewModel {
        //MARK: TODO - make data source for preview intro
        let items = [
            PreviewIntro(
                headline: "Send Messages Based On Website & Email Events",
                description: "Unlock the key to super-responsive real-time personalization. Set up customer tracking & custom events today.",
                image: UIImage(named: "splash"),
                backgroundColor: UIColor.hex("343248"),
                headlineColor: .white,
                descriptionColor: .white
            ),
            PreviewIntro(
                headline: "Build Highly-Customizable email Journeys!",
                description: "Take our drag-and-drop email automation builder, design the ideal customer journey and let our platform convert leads for You On Autopilot.",
                image: UIImage(named: "splash-1"),
                backgroundColor: UIColor.hex("343248"),
                headlineColor: .white,
                descriptionColor: .white
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
