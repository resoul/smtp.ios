import AsyncDisplayKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var container: Container { get }
    
    func start()
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func finish() {
        childCoordinators.removeAll()
    }
    
    var handleDoubleTap: (() -> Void)? {
        return nil
    }
}

class TabCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let container: Container
    
    init(
        container: Container,
        navigationControllerType: UINavigationController.Type = ASDKNavigationController.self
    ) {
        self.container = container
        self.navigationController = navigationControllerType.init()
    }
    
    func start() {
        fatalError("start() must be overridden in subclass")
    }
}

class FlowCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let container: Container
    
    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        fatalError("start() must be overridden in subclass")
    }
}
