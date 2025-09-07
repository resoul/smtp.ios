import UIKit

protocol AuthViewModel {
    var state: ViewState { get }
    var errorMessage: String? { get }
}

class AuthBaseController: UIViewController, UIGestureRecognizerDelegate {
    weak var coordinator: AuthCoordinator?

    init() {
        super.init(nibName: nil, bundle: nil)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        setupInitialState()
    }
    
    func setupView() {}
    
    func setupInitialState() {}
    
    func setupBindings() {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
