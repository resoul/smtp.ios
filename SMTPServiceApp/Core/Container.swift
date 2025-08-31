import UIKit

protocol Container {
    var authService: AuthService { get }
    func makeLauchViewModel() -> LauchViewModel
    func makeLoginViewModel() -> LoginViewModel
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator
    func makeLauchCoordinator(navigationController: UINavigationController) -> LaunchCoordinator
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
    
    func makeLauchCoordinator(navigationController: UINavigationController) -> LaunchCoordinator {
        LaunchCoordinatorImpl(navigationController: navigationController, container: self)
    }
    
    func makeLauchViewModel() -> LauchViewModel {
        LauchViewModelImpl()
    }
    
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator {
        AuthCoordinator(navigationController: navigationController, container: self)
    }
    
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModelImpl()
    }
    
    func makeMainCoordinator(navigationController: UINavigationController) -> MainCoordinator {
        MainCoordinator(navigationController: navigationController, container: self)
    }
}
