import UIKit

class TabBarController: UITabBarController {
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarManager()
        setupTabBarAppearance()
    }
    
    private func setupTabBarManager() {
        TabBarManager.shared.tabBarController = self
        
        // Инициальная настройка табов
        let enabledTabs = TabBarManager.shared.enabledTabs
        let viewControllers = enabledTabs.compactMap { tab in
            createViewController(for: tab)
        }
        
        setViewControllers(viewControllers, animated: false)
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func createViewController(for tab: TabItem) -> UIViewController {
        let viewController: UIViewController
        
        switch tab.viewControllerType {
        case "HomeViewController":
            viewController = UIViewController()
        case "SearchViewController":
            viewController = UIViewController()
        case "FavoritesViewController":
            viewController = UIViewController()
        case "ProfileViewController":
            viewController = UIViewController()
        case "SettingsViewController":
            viewController = UIViewController()
        case "MessagesViewController":
            viewController = UIViewController()
        default:
            viewController = UIViewController()
        }
        
        viewController.tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(systemName: tab.icon),
            selectedImage: UIImage(systemName: tab.icon + ".fill")
        )
        
        return UINavigationController(rootViewController: viewController)
    }
}
