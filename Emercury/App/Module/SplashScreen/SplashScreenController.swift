import AsyncDisplayKit

final class SplashScreenController: ASDKViewController<SplashScreenNode> {
    
    private let items: [SplashScreenItem] = [
        SplashScreenItem(
            title: "Send Messages Based On Website & Email Events",
            image: "tracking",
            description: "Unlock the key to super-responsive real-time personalization. Set up customer tracking & custom events today."
        ),
        SplashScreenItem(
            title: "Build Highly-Customizable email Journeys!",
            image: "illustration",
            description: "Take our drag-and-drop email automation builder, design the ideal customer journey and let our platform convert leads for You On Autopilot."
        )
    ]

    override init() {
        super.init(node: SplashScreenNode(item: items.randomElement() ?? items[0]))
        view.backgroundColor = UIColor.hex("343248")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.proceed()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func proceed() {
        let onboard = UserDefaults.standard.integer(forKey: "onboard")

        let nextController: UIViewController = (onboard == 1)
            ? MainController()
            : AuthLoginController()

        if let nav = self.navigationController as? ASDKNavigationController {
            nav.setViewControllers([nextController], animated: true)
        }
    }
}
