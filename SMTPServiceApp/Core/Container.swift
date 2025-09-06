import UIKit
import PreviewIntro
import AsyncDisplayKit

protocol Container {
    var authService: AuthService { get }
    func makePreviewIntroViewModel() -> PreviewIntroViewModel
    func makeLoginViewModel() -> LoginViewModel
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator
    func makePreviewIntroCoordinator(navigationController: UINavigationController) -> PreviewIntroCoordinator
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator
    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator
}

final class ContainerImpl: Container {
    private let serviceAssembly: ServiceAssembly
    
    init () {
        serviceAssembly = ServiceAssembly()
    }
    
    var authService: AuthService {
        serviceAssembly.authService
    }
    
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
        let navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return AppCoordinator(
            navigationController: navigationController,
            container: self
        )
    }
    
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
    
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        AuthCoordinator(navigationController: navigationController, container: self)
    }
    
    func makePreviewIntroCoordinator(navigationController: UINavigationController) -> PreviewIntroCoordinator {
        PreviewIntroCoordinator(navigationController: navigationController, container: self)
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModelImpl()
    }
    
    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator {
        MainCoordinator(navigationController: navigationController, container: self)
    }
}
