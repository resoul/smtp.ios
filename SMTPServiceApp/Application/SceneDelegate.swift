import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private let themeManager: ThemeManager = .shared

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

        let config = AppConfigurationBuilder()
            .withNetworkConfig(.development)
            .withOfflineMode(enabled: false)
            .withPreviewInto(enabled: true)
            .build()
        
        let container = Container(
            windowScene: windowScene,
            appConfiguration: config,
            source: UserDefaultsDataSource(),
            themeManager: ThemeManager.shared
        )
        
        window = container.makeMainWindow()
        appCoordinator = container.makeAppCoordinator()
        appCoordinator?.start()
        appCoordinator?.restoreAppState()
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
                ThemeManager.shared.setCustomTheme(key: "em.smtp.theme.emercury")
            @unknown default:
                fatalError("Unknown user interface style")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        appCoordinator?.saveAppState()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        appCoordinator?.saveAppState()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        appCoordinator?.saveAppState()
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
