import UIKit

protocol LoginViewModel {}
final class LoginViewModelImpl: LoginViewModel {}

final class LoginController: UIViewController {
    private let viewModel: LoginViewModel
    weak var coordinator: AuthCoordinator?

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
