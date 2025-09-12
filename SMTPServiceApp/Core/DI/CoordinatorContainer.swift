import UIKit

protocol CoordinatorContainer {
    func makeAppCoordinator(window: UIWindow) -> AppCoordinator
    func makePreviewIntroCoordinator(navigationController: UINavigationController) -> PreviewIntroCoordinator
    func makeAuthCoordinator(navigationController: UINavigationController) -> AuthCoordinator
    func makeMainTabBarCoordinator(navigationController: UINavigationController) -> MainTabBarCoordinator
    
    func makeDashboardCoordinator() -> DashboardCoordinator
}
