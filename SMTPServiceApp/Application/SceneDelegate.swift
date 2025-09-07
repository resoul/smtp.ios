import UIKit
import FontManager

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        FontManager.registerFonts(fontFamily: Fonts.Poppins.self)
        AppThemeSetup.setupCustomThemes()

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let config = AppConfigurationBuilder()
            .withNetworkConfig(.development)
            .withAnalytics(enabled: false)
            .withDebugMode(enabled: true)
            .withOfflineMode(enabled: false)
            .build()
        
        let container = Container(
            appConfiguration: config,
            source: UserDefaultsDataSource(),
            themeManager: ThemeManager.shared
        )
        
        appCoordinator = container.makeAppCoordinator(window: window!)
        appCoordinator?.start()
    }
    
    func windowScene(
        _ windowScene: UIWindowScene,
        didUpdate previousCoordinateSpace: any UICoordinateSpace,
        interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation,
        traitCollection previousTraitCollection: UITraitCollection
    ) {
        if windowScene.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            switch windowScene.traitCollection.userInterfaceStyle {
            case .dark:
                ThemeManager.shared.setTheme(.dark)
            case .light:
                ThemeManager.shared.setTheme(.light)
            case .unspecified:
                ThemeManager.shared.setCustomTheme(key: "em.smtp")
            @unknown default:
                fatalError("Unknown user interface style")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
