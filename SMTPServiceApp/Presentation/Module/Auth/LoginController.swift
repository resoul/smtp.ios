import UIKit

final class LoginController: UIViewController {
    private lazy var loginView = LoginView()
    private let viewModel: LoginViewModel
    weak var coordinator: AuthCoordinator?
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = loginView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
