import AsyncDisplayKit

class MainController: ASTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeController = UINavigationController(rootViewController: ViewController())
        homeController.tabBarItem.title = "Home"
        
        let contactsController = UINavigationController(rootViewController: ViewController())
        contactsController.tabBarItem.title = "Contacts"
        
        let campaignsController = UINavigationController(rootViewController: ViewController())
        campaignsController.tabBarItem.title = "Campaigns"
        
        let reportsController = UINavigationController(rootViewController: ViewController())
        reportsController.tabBarItem.title = "Reports"
        
        viewControllers = [
            homeController,
            contactsController,
            campaignsController,
            reportsController
        ]
        
        selectedIndex = 1
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundImage = UIImage()
        tabAppearance.backgroundColor = UIColor.hex("343248")
        
        if let customFont = UIFont(name: "Poppins-Regular", size: 11) {
            tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .font: customFont,
                .foregroundColor: UIColor.white
            ]
            tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .font: customFont,
                .foregroundColor: UIColor.white.withAlphaComponent(0.8)
            ]
        }

        tabAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white.withAlphaComponent(0.8)
        tabAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white
        
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        
        setNeedsStatusBarAppearanceUpdate()
        
        tabBar.tintColor = .white
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
    }
}
